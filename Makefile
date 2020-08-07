NAME = ft_turing

SOURCES = src/except.ml src/turing_types.ml src/print.ml src/turing.ml src/main.ml
DEP = -thread -package core -package yojson -package base -package core_kernel

CAMLC = ocamlc
CAMLOPT = ocamlopt
CAMLDEP = ocamldep
CAMLFIND = ocamlfind

CFLAGS =

all: depend $(NAME)

$(NAME): lib opt byt
ifeq (,$(wildcard $(NAME)))
	ln -s $(NAME).byt $(NAME)
endif

opt: $(NAME).opt
byt: $(NAME).byt

OBJS = $(SOURCES:.ml=.cmo)
OPTOBJS = $(SOURCES:.ml=.cmx)

lib:
ifeq (,$(wildcard $(NAME)))
	opam switch 4.07.0
	opam install -y ocamlfind ocamlbuild core base yojson
endif

$(NAME).byt: $(OBJS)
				$(CAMLFIND) $(CAMLC) -o $(NAME).byt -linkpkg $(DEP) $(OBJS)

$(NAME).opt: $(OPTOBJS)
				$(CAMLFIND) $(CAMLOPT) -o $(NAME).opt -linkpkg $(DEP) $(OPTOBJS)

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(CAMLFIND) $(CAMLC) -I src $(DEP) $(CFLAGS) -c $<

.mli.cmi:
	$(CAMLFIND) $(CAMLC) -I src $(DEP) $(CFLAGS) -c $<

.ml.cmx:
	$(CAMLFIND) $(CAMLOPT) -I src $(DEP) $(CFLAGS) -c $<

clean:
	rm -f .depend
	rm -f src/*.cm[iox] src/*.opt src/*.o
	rm -f src/$(NAME).o

fclean: clean
	rm -f $(NAME)
	rm -f $(NAME).opt
	rm -f $(NAME).byt

depend: .depend

.depend:
	$(CAMLDEP) -I src $(SOURCES) > .depend

re: fclean all

-include .depend
