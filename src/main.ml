open Core
open Turing
open Print
open Except

let usage () =
  Printf.printf "usage: %s [-h] jsonfile input\n" Sys.argv.(0);
  Printf.printf "\n";
  Printf.printf "positional arguments:\n";
  Printf.printf "  jsonfile                  json description of the machine\n";
  Printf.printf "  input                     input of the machine\n";
  Printf.printf "\n";
  Printf.printf "optional arguments:\n";
  Printf.printf "  -h, --help                show this help message and exit\n"

let () =
  for i = 1 to Array.length Sys.argv - 1 do
    if Sys.argv.(i) = "-h" || Sys.argv.(i) = "--help" then begin
      usage (); exit 1
    end
  done;
  if Array.length Sys.argv <> 3 then begin
    usage (); exit 1
  end;
  let jsonf = Sys.argv.(1)
  and input = Sys.argv.(2) in
  let machine = Turing.parse_json jsonf in
  try
    Turing.check_machine machine;
    Print.print_machine machine
  with e -> Except.print_exception e
  (*  Turing.execute machine input*)
