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
    transitions : (transition_record list) TransitionsMap.t;
  }

let parse_json json_filename =
  let json = Yojson.Basic.from_file json_filename in
  let machine =
    let set_transitions json_transitions states =
      let transitions = TransitionsMap.empty in
      let set_transition_record json_transition_record =
        {
          read = member "read" json_transition_record |> to_string;
          to_state = member "to_state" json_transition_record |> to_string;
          scanright = member "scanright" json_transition_record |> to_string;
          write = member "write" json_transition_record |> to_string;
          action = member "action" json_transition_record |> to_string;
        } in
      let set_transitions_list state =
        let json_transitions_list = member state json_transitions |> to_list in
        List.map ~f:set_transition_record json_transitions_list in
      let set_transitions_map state =
        TransitionsMap.add state (set_transitions_list state) transitions in
      List.iter ~f:set_transitions_map states in
    {
      name = member "name" json |> to_string;
      alphabet = member "alphabet" json |> to_list |> filter_string;
      blank = member "blank" json |> to_string;
      states = member "states" json |> to_list |> filter_string;
      initial = member "initial" json |> to_string;
      finals = member "finals" json |> to_list |> filter_string;
      transitions = set_transitions (member "transitions" json) (member "states" json |> to_list |> filter_string)
    } in
  machine

let () =
  let json_filename = "machines/unary_sub.json" in
  let machine =
    try parse_json json_filename
    with e -> Printf.eprintf "Error while parsing json file %s: %s\nBacktrace:\n%s" json_filename (Exn.to_string e) (Printexc.get_backtrace ()); exit 1 in
  printf "%s" machine.name
