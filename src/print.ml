open Core
open Turing_types

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
  List.iter ~f:print_transition_list (List.filter ~f:(fun x -> not(List.exists ~f:(String.equal x) machine.finals)) machine.states);
  Core.Printf.printf "*****************************************************************************\n"

let print_machine_step tape i state r =
  Core.Printf.printf "[";
  let rec print_tape tape_i =
    if tape_i = i
    then Core.Printf.printf "<%c>" (String.get tape tape_i)
    else Core.Printf.printf "%c" (String.get tape tape_i);
    if tape_i < (String.length tape) - 1 then print_tape (tape_i + 1) in
  print_tape 0;
  Core.Printf.printf "] -> ";
  print_transition state r
