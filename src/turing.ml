open Core
open Base
open Yojson
open Yojson.Basic.Util
open Turing_types
open Except
open Print

let check_machine machine =
  if (String.length machine.name) = 0
  then Except.Invalid_Machine "Name must not be empty" |> raise;

  let check_character_size_1 str =
    if (String.length str) <> 1
    then Except.Invalid_Machine (Printf.sprintf "Character of the alphabet must be a string of length strictly equal to 1: [%s]" str) |> raise in
  List.iter ~f:check_character_size_1 machine.alphabet;
  if List.exists ~f:(String.equal "<") machine.alphabet
  then Except.Invalid_Machine "Character of the alphabet can't be [<]" |> raise;
  if List.exists ~f:(String.equal ">") machine.alphabet
  then Except.Invalid_Machine "Character of the alphabet can't be [>]" |> raise;

  if not(List.exists ~f:(String.equal machine.blank) machine.alphabet)
  then Except.Invalid_Machine (Printf.sprintf "The blank character must be part of the alphabet: [%s]" machine.blank) |> raise;

  let check_state_not_empty str =
    if String.is_empty str
    then Except.Invalid_Machine "State can't be empty" |> raise in
  List.iter ~f:check_state_not_empty machine.states;

  if not(List.exists ~f:(String.equal machine.initial) machine.states)
  then Except.Invalid_Machine (Printf.sprintf "The initial state must be part of the states list: [%s]" machine.initial) |> raise;

  let check_final_state_in_states final_state =
    if not(List.exists ~f:(String.equal final_state) machine.states)
    then Except.Invalid_Machine (Printf.sprintf "The final states must be part of the states list: [%s]" final_state) |> raise in
  List.iter ~f:check_final_state_in_states machine.finals;

  let check_transition machine_transition =
    if not(List.exists ~f:(String.equal machine_transition.read) machine.alphabet)
    then Except.Invalid_Machine (Printf.sprintf "Transition read must be part of the alphabet: [%s]" machine_transition.read) |> raise;
    if not(List.exists ~f:(String.equal machine_transition.to_state) machine.states)
    then Except.Invalid_Machine (Printf.sprintf "Transition to_state must be part of the states list: [%s]" machine_transition.to_state) |> raise;
    if not(List.exists ~f:(String.equal machine_transition.write) machine.alphabet)
    then Except.Invalid_Machine (Printf.sprintf "Transition write must be part of the alphabet: [%s]" machine_transition.write) |> raise;
    if not(String.equal machine_transition.action "LEFT") && not(String.equal machine_transition.action "RIGHT")
    then Except.Invalid_Machine (Printf.sprintf "Transition action must be either [LEFT] or [RIGHT]: [%s]" machine_transition.action) |> raise in
  let check_transition_list state =
    List.iter ~f:(check_transition) (Map.find_exn machine.transitions state) in
  List.iter ~f:check_transition_list (List.filter ~f:(fun x -> not(List.exists ~f:(String.equal x) machine.finals)) machine.states)

let check_input input machine =
  if String.is_empty input
  then Except.Invalid_Input "Input must not be empty" |> raise;
  if String.contains input (String.get machine.blank 0)
  then Except.Invalid_Input (Printf.sprintf "The blank character must not be part of the input: [%s]" machine.blank) |> raise;
  let rec loop i =
    if not(List.exists ~f:(fun c -> (String.get c 0 |> Char.to_int) = (String.get input i |> Char.to_int)) machine.alphabet)
    then Except.Invalid_Input (Printf.sprintf "Input characters must be part of the alphabet: [%c]" (String.get input i))|> raise;
    if i < (String.length input) - 1 then loop (i + 1) in
  loop 0

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
      else Map.add_exn ~key:state ~data:(set_transitions_list state) (Map.empty (module Turing_types.TransitionsMap)) in
    set_transitions_map 0 in
  {
    name = member "name" json |> to_string;
    alphabet = member "alphabet" json |> to_list |> filter_string;
    blank = member "blank" json |> to_string;
    states = member "states" json |> to_list |> filter_string;
    initial = member "initial" json |> to_string;
    finals = member "finals" json |> to_list |> filter_string;
    transitions = set_transitions (member "transitions" json) (member "states" json |> to_list |> filter_string |> List.filter ~f:(fun x -> not(List.exists ~f:(String.equal x) (member "finals" json |> to_list |> filter_string))))
  }

let parse_json jsonf =
  let machine =
    try create_machine jsonf
    with e -> Except.print_exception e in
  machine

let execute machine tape =
  let rec solve state_history state tape i =
    if List.exists ~f:(String.equal state) machine.finals
    then begin
        Core.Printf.printf "[%s]\n" tape;
        Core.exit 0
      end
    else begin
      let trs_record = Map.find_exn machine.transitions state
      and c = String.get tape i in
      let tr_record = List.fold_left ~init:None ~f:(fun acc e ->
        if Char.to_int (String.get e.read 0) = Char.to_int c
        then Some e else acc
      ) trs_record in
      match tr_record with
      | None -> Except.Invalid_Machine (Printf.sprintf "Can't find character `%c' in `state': `%s'" c state) |> raise
      | Some r -> begin
        Print.print_machine_step tape i state r;
        match Hashtbl.add state_history ~key:(String.concat ~sep:"-" [ state; Int.to_string i; tape ]) ~data:"" with
        | `Duplicate -> Except.Invalid_Machine "Detect infinite loop. Stopping .." |> raise
        | `Ok -> begin
          let state = r.to_state
          and tape = Bytes.of_string tape in
          Base.Bytes.set tape i (String.get r.write 0);
          let (tape, i) = match r.action with
          | "LEFT"  -> if i = 0
            then (String.concat [ machine.blank; (Base.Bytes.to_string tape) ], 0)
            else (Base.Bytes.to_string tape, i-1)
          | "RIGHT" -> if i = (Base.Bytes.length tape)
            then (String.concat [ Base.Bytes.to_string tape; machine.blank ], i+1)
            else (Base.Bytes.to_string tape, i+1)
          | _ -> Except.Invalid_Machine (Printf.sprintf "Unknown `action': `%s'" r.action) |> raise in
          solve state_history state tape i
        end
      end
    end
  in solve (Hashtbl.create (module String)) machine.initial tape 0
