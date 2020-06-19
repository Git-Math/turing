open Core

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

let () =
  for i = 1 to Array.length Sys.argv - 1 do
    if Sys.argv.(i) = "-h" || Sys.argv.(i) = "--help" then
      usage ()
  done;
  if Array.length Sys.argv <> 3 then
    usage ();

  let jsonf = Sys.argv.(1)
  and input = Sys.argv.(2) in
  Printf.printf "jsonf=%s" jsonf;
  Printf.printf "input=%s" input;;
