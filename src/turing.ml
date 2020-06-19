open Core
open Base
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

module TransitionsMap = struct
  module T = struct
    type t = string
    let compare x y = String.compare x y
    let sexp_of_t = String.sexp_of_t
  end
  include T
  include Comparable.Make(T)
end

type machine_record =
  {
    name : string;
    alphabet : string list;
    blank : string;
    states : string list;
    initial : string;
    finals : string list;
    transitions : TransitionsMap.t;
  }

let create_machine json_filename =
  let json = Yojson.Basic.from_file json_filename in
  let set_transitions json_transitions states =
    let set_transition_record json_transition_record = {
        read = member "read" json_transition_record |> to_string;
        to_state = member "to_state" json_transition_record |> to_string;
        scanright = member "scanright" json_transition_record |> to_string;
        write = member "write" json_transition_record |> to_string;
        action = member "action" json_transition_record |> to_string;
    } in
    let set_transitions_list state =
      List.map ~f:set_transition_record (member state json_transitions |> to_list) in
    let m = Map.empty (module TransitionsMap) in
    List.iter ~f:(fun s -> Map.add ~key:s ~data:(set_transitions_list s) m; ()) states; m in
  {
    name = member "name" json |> to_string;
    alphabet = member "alphabet" json |> to_list |> filter_string;
    blank = member "blank" json |> to_string;
    states = member "states" json |> to_list |> filter_string;
    initial = member "initial" json |> to_string;
    finals = member "finals" json |> to_list |> filter_string;
    transitions = set_transitions (member "transitions" json) (member "states" json |> to_list |> filter_string)
  }

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
