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

module RecordMap = Map.Make(String)

type machine_record =
  {
    name : string;
    alphabet : string list;
    blank : string;
    states : string list;
    initial : string;
    finals : string list;
    (*    transitions : (transition_record list) RecordMap.t;*)
  }

let parse_json json_filename =
  let json =
    Yojson.Basic.from_file json_filename
  in
  let machine =
    {
      name = member "name" json |> to_string;
      alphabet = member "tags" json |> to_list |> filter_string;
      blank = member "blank" json |> to_string;
      states = member "states" json |> to_list |> filter_string;
      initial = member "initial" json |> to_string;
      finals = member "finals" json |> to_list |> filter_string;
    }
  in
  printf "%s" machine.name

let () =
  let json_filename = "machines/unary_sub.json" in
  try parse_json json_filename
  with e -> Printf.eprintf "Error while parsing json file %s: %s\nBacktrace:\n%s" json_filename (Exn.to_string e) (Exn.get); exit 1
