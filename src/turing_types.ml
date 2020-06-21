open Core
open Base

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

type trs_record =
  {
    name : string;
    alphabet : string list;
    blank : string;
    states : string list;
    initial : string;
    finals : string list;
    transitions : (TransitionsMap.t, transition_record Base.List.t, TransitionsMap.comparator_witness) Base.Map.t
  }
