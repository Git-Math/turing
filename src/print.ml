open Core
open Turing

let print_transition transition_name machine_transition =
  Core.Printf.printf "(%s, %s) -> (%s, %s, %s)\n" transition_name machine_transition.read machine_transition.to_state machine_transition.write machine_transition.action

let print_machine machine =
  Core.Printf.printf "*****************************************************************************\n";
  Core.Printf.printf "Name : %s\n" machine.name;
  Core.Printf.printf "Alphabet : [ %s ]\n" (String.concat ~sep:", " machine.alphabet);
  Core.Printf.printf "Blank : %s\n" machine.blank;
  Core.Printf.printf "States : [ %s ]\n" (String.concat ~sep:", " machine.states);
  Core.Printf.printf "Initial : %s\n" machine.initial;
  Core.Printf.printf "Finals : [ %s ]\n" (String.concat ~sep:", " machine.finals);
  let print_transition_list state =
    List.iter ~f:(print_transition state) (Map.find_exn machine.transitions state) in
  List.iter ~f:print_transition_list (List.filter ~f:(fun x -> not(List.exists ~f:(fun y -> String.equal x y) machine.finals)) machine.states);
  Core.Printf.printf "*****************************************************************************\n"
