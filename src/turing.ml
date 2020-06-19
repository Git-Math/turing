open Core
open Yojson
open Yojson.Basic.Util

type transition_record =
  {
    read : string;
    to_state : string;
    scanright : string;
    write : string;
    action : string;
  }

module TransitionsMap = Map.Make(String)

type machine_record =
  {
    name : string;
    alphabet : string list;
    blank : string;
    states : string list;
    initial : string;
    finals : string list;
    (*    transitions : (transition_record list) TransitionsMap.t;*)
  }

let create_machine json_filename =
  let json = Yojson.Basic.from_file json_filename in
  let machine =
    {
      name = member "name" json |> to_string;
      alphabet = member "alphabet" json |> to_list |> filter_string;
      blank = member "blank" json |> to_string;
      states = member "states" json |> to_list |> filter_string;
      initial = member "initial" json |> to_string;
      finals = member "finals" json |> to_list |> filter_string;
    } in
  machine

let parse_json jsonf =
  let machine =
    try create_machine jsonf
    with e -> Printf.eprintf "Error while parsing json file %s: %s\nBacktrace:\n%s" jsonf (Exn.to_string e) (Printexc.get_backtrace ()); exit 1 in
  machine

let execute machine input =
  let state = machine.initial
  and i = 0 in
  let rec loop i =
    let trs = TransitionsMap.find state machine.transitions
    and c = String.get input i in
    let tr = List.fold ~f:(fun ret tr -> if tr.read = c then tr else ret) 0 trs in
    Printf.printf "(%s, %c) -> (%s, %s, %s)" state c tr.name tr.write tr.action;
    String.set input i tr.write;
    if tr.action = "LEFT" then
      loop (i-1)
    else if tr.action = "RIGHT" then
      loop (i+1)
  in loop i
