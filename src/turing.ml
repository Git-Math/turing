open Core
open Base
open Yojson
open Yojson.Basic.Util
open Except

type transition_record =
  {
    read : string;
    to_state : string;
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
    transitions : (TransitionsMap.t, transition_record Base.List.t, TransitionsMap.comparator_witness) Base.Map.t
  }

let create_machine json_filename =
  let json = Yojson.Basic.from_file json_filename in
  let set_transitions json_transitions states =
    let set_transition_record json_transition_record = {
        read = member "read" json_transition_record |> to_string;
        to_state = member "to_state" json_transition_record |> to_string;
        write = member "write" json_transition_record |> to_string;
        action = member "action" json_transition_record |> to_string;
    } in
    let set_transitions_list state =
      List.map ~f:set_transition_record (member state json_transitions |> to_list) in
    let rec set_transitions_map i =
      let state = (List.nth_exn states i) in
      if i < ((List.length states) - 1)
      then Map.add_exn ~key:state ~data:(set_transitions_list state) (set_transitions_map (i + 1))
      else Map.add_exn ~key:state ~data:(set_transitions_list state) (Map.empty (module TransitionsMap)) in
    set_transitions_map 0 in
  {
    name = member "name" json |> to_string;
    alphabet = member "alphabet" json |> to_list |> filter_string;
    blank = member "blank" json |> to_string;
    states = member "states" json |> to_list |> filter_string;
    initial = member "initial" json |> to_string;
    finals = member "finals" json |> to_list |> filter_string;
    transitions = set_transitions (member "transitions" json) (member "states" json |> to_list |> filter_string |> List.filter ~f:(fun x -> not(List.exists ~f:(fun y -> String.equal x y) (member "finals" json |> to_list |> filter_string))))
  }

let parse_json jsonf =
  let machine =
    try create_machine jsonf
    with e -> Except.print_exception e in
  machine

(*let execute machine input =
  let state = machine.initial
  and i = 0 in
  let rec loop i =
    let trs = Map.find_exn machine.transitions state
    and c = String.get input i in
    let tr = List.fold ~f:(fun ret tr -> if tr.read = c then tr else ret) 0 trs in
    Printf.printf "(%s, %c) -> (%s, %s, %s)" state c tr.name tr.write tr.action;
    String.set input i tr.write;
    if tr.action = "LEFT" then
      loop (i-1)
    else if tr.action = "RIGHT" then
      loop (i+1)
  in loop i
 *)
