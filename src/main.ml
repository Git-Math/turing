open Core
open Getopt

let usage () =
    Printf.printf "usage: %s [-h] jsonfile input\n" Sys.argv.(0);
    Printf.printf "\n";
    Printf.printf "positional arguments:\n";
    Printf.printf "  jsonfile                  json description of the machine\n";
    Printf.printf "  input                     input of the machine\n";
    Printf.printf "\n";
    Printf.printf "optional arguments:\n";
    Printf.printf "  -h, --help                show this help message and exit\n";
    exit 0

let specs = [
    ( 'h', "help", Some usage, None )
]

let json = ref ""
and input = ref ""

let () =
    parse_cmdline specs print_endline;;
 (* if Array.length Sys.argv <> 2 then usage
    else json = Sys.argv.(1);

    Printf.printf "json %s\n" Sys.argv.(1);
    Printf.printf "input %s\n" Sys.argv.(2);;
*)

(* let () =
   (* Read JSON file into an OCaml string *)
   let buf = In_channel.read_all "machines/unary_sub.json" in
   (* Use the string JSON constructor *)
   let json1 = Yojson.Basic.from_string buf in
   (* Use the file JSON constructor *)
   let json2 = Yojson.Basic.from_file "machines/unary_sub.json" in
   (* Test that the two values are the same *)
   print_endline (if json1 = json2 then "OK" else "FAIL")
   *)
