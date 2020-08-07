open Core

exception Invalid_Machine of string
exception Invalid_Input of string

let print_exception e =
  Core.Printf.eprintf "Error: %s\n" (Exn.to_string e);
  exit 1
