open Core

exception Invalid_Machine of string
exception Invalid_Input of string

let print_exception e =
  Core.Printf.eprintf "Error: %s\nBacktrace:\n%s" (Exn.to_string e) (Printexc.get_backtrace ());
  exit 1
