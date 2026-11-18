open Formule_Syllogisme
open Proposition.Formule

module Predicate_set = Set.Make (String)
(** Module des ensembles de prédicats représentés par des chaines de caractères
*)

module Diag = Map.Make (Predicate_set)
(** Module des Maps dont les clés sont des ensembles de chaines de caractères *)

(** Type des remplissages possibles d'un diagramme de Venn *)
type fill = Vide | NonVide

type diagramme = fill Diag.t
(** Type des diagrammes de Venn *)

(** string_of_key : conversion d'une clé en une chaine de caractères *)
let string_of_key k = Predicate_set.elements k |> String.concat ", "

(** string_of_fill : conversion d'une valeur en une chaine de caractères*)
let string_of_fill = function Vide -> "Vide" | NonVide -> "Non-Vide"

(** string_of_diag d : conversion d'un diagramme d en une chaine de caractères
*)
let string_of_diag (d : diagramme) : string =
  Diag.fold
    (fun key value acc ->
      acc ^ "  {" ^ string_of_key key ^ "}  : " ^ string_of_fill value ^ "   ==")
    d ""

let print_diag d = print_endline (string_of_diag d)

(** diag_from_formule alpha f : construit le diagramme de Venn associé à la
    formule f sur les prédicats issus de f ou de alpha *)
let diag_from_formule (alpha : string list) (f : formule_syllogisme) :
    diagramme list =
  let phi = match f with PourTout phi | IlExiste phi -> phi in
  let all_preds = List.sort_uniq String.compare (alpha @ atomes phi) in

  let zones_list = all_sublists all_preds in
  let zones =
    List.map
      (fun l ->
        List.fold_left
          (fun acc p -> Predicate_set.add p acc)
          Predicate_set.empty l)
      zones_list
  in
  match f with
  | PourTout phi ->
      let diag =
        List.fold_left
          (fun acc zone ->
            let i_zone s = Predicate_set.mem s zone in
            if eval i_zone (Non phi) then Diag.add zone Vide acc else acc)
          Diag.empty zones
      in
      [ diag ]
  | IlExiste phi ->
      let diag_list =
        List.fold_left
          (fun acc zone ->
            let i_zone s = Predicate_set.mem s zone in
            if eval i_zone phi then Diag.singleton zone NonVide :: acc else acc)
          [] zones
      in
      List.sort_uniq Stdlib.compare diag_list

(** est_compatible_diag_diag dp dc : teste si le diagramme dp d'une prémisse est
    compatible avec le diagramme dc d'une conclusion *)
let est_compatible_diag_diag (d1 : diagramme) (d2 : diagramme) : bool =
  Diag.for_all
    (fun ats v2 ->
      match Diag.find_opt ats d1 with None -> true | Some v1 -> v1 = v2)
    d2

(** est_compatible_diag_list dp dcs : teste si un diagramme dp d'une prémisse
    est compatible avec un des diagrammes de la liste dcs, diagrammes issus
    d'une conclusion *)
let est_compatible_diag_list (d1 : diagramme) (d2 : diagramme list) : bool =
  List.exists (est_compatible_diag_diag d1) d2

(** est_compatible_list_list dps dcs : teste si chacun des diagrammes de dps,
    diagrammes issus de prémisses, est compatible avec au moins un des
    diagrammes de dcs, diagrammes issus d'une conclusion *)
let est_compatible_list_list (dps : diagramme list) (dcs : diagramme list) :
    bool =
  List.for_all
    (fun dp -> List.exists (fun dc -> est_compatible_diag_diag dp dc) dcs)
    dps

(** est_compatible_premisses_conc ps c : teste si une liste de prémisses ps est
    compatible avec une conclusion c *)
let est_compatible_premisses_conc (ps : formule_syllogisme list)
    (c : formule_syllogisme) : bool =
  let add_unique acc lst =
    List.fold_left (fun a x -> if List.mem x a then a else x :: a) acc lst
  in
  let univers =
    let acc1 =
      List.fold_left
        (fun a p ->
          let phi = match p with PourTout q | IlExiste q -> q in
          add_unique a (atomes phi))
        [] ps
    in
    let phi_c = match c with PourTout q | IlExiste q -> q in
    add_unique acc1 (atomes phi_c)
  in
  let dc = diag_from_formule univers c in
  List.for_all
    (fun p ->
      let dps = diag_from_formule univers p in
      List.exists (fun d -> est_compatible_diag_list d dc) dps)
    ps

(** incompatibles_premisses_conc ps c : Renvoie la liste des diagrammes issus
    des prémisses ps qui sont incompatibles avec le diagramme associé à la
    conclusion c.*)
let incompatibles_premisses_conc (ps : formule_syllogisme list)
    (c : formule_syllogisme) : diagramme list =
  let add_unique acc lst =
    List.fold_left (fun a x -> if List.mem x a then a else x :: a) acc lst
  in
  let univers =
    let acc1 =
      List.fold_left
        (fun a p ->
          let phi = match p with PourTout q | IlExiste q -> q in
          add_unique a (atomes phi))
        [] ps
    in
    let phi_c = match c with PourTout q | IlExiste q -> q in
    add_unique acc1 (atomes phi_c)
  in
  let dc = diag_from_formule univers c in
  let all_diags =
    List.flatten (List.map (fun p -> diag_from_formule univers p) ps)
  in
  List.filter (fun d -> not (est_compatible_diag_list d dc)) all_diags

(** temoin_incompatibilite_premisses_conc_opt ps c : renvoie un diagramme de la
    combinaison des prémisses ps incompatible avec la conclusion c s'il existe,
    None sinon *)
let temoin_incompatibilite_premisses_conc_opt (ps : formule_syllogisme list)
    (c : formule_syllogisme) : diagramme option =
  let add_unique acc lst =
    List.fold_left (fun a x -> if List.mem x a then a else x :: a) acc lst
  in
  let univers =
    let acc1 =
      List.fold_left
        (fun a p ->
          let phi = match p with PourTout q | IlExiste q -> q in
          add_unique a (atomes phi))
        [] ps
    in
    let phi_c = match c with PourTout q | IlExiste q -> q in
    add_unique acc1 (atomes phi_c)
  in
  let dc = diag_from_formule univers c in
  let all_diags =
    List.flatten (List.map (fun p -> diag_from_formule univers p) ps)
  in
  List.find_opt (fun d -> not (est_compatible_diag_list d dc)) all_diags

(** temoins_incompatibilite_premisses_conc ps c : renvoie les diagrammes de la
    combinaison des prémisses ps incompatibles avec la conclusion c *)
let temoins_incompatibilite_premisses_conc (ps : formule_syllogisme list)
    (c : formule_syllogisme) : diagramme list =
  let add_unique acc lst =
    List.fold_left (fun a x -> if List.mem x a then a else x :: a) acc lst
  in
  let univers =
    let acc1 =
      List.fold_left
        (fun a p ->
          let phi = match p with PourTout q | IlExiste q -> q in
          add_unique a (atomes phi))
        [] ps
    in
    let phi_c = match c with PourTout q | IlExiste q -> q in
    add_unique acc1 (atomes phi_c)
  in
  let dc = diag_from_formule univers c in
  let all_diags =
    List.flatten (List.map (fun p -> diag_from_formule univers p) ps)
  in
  List.filter (fun d -> not (est_compatible_diag_list d dc)) all_diags

(** conj_diag d1 d2 : Calcule la combinaison/conjonction de deux diagrammes,
    renvoyant None si incompatibilité *)
let conj_diag (d1 : diagramme) (d2 : diagramme) : diagramme option =
  Diag.fold
    (fun key v1 acc ->
      match acc with
      | None -> None
      | Some d -> (
          match Diag.find_opt key d with
          | None -> Some (Diag.add key v1 d)
          | Some v2 -> if v1 = v2 then acc else None))
    d1 (Some d2)

(** conj_diag_list ds1 ds2 renvoie la conjonction de deux listes de diagrammes
    ds1 et ds2 *)
let conj_diag_list (ds1 : diagramme list) (ds2 : diagramme list) :
    diagramme list =
  List.concat_map
    (fun d1 -> List.filter_map (fun d2 -> conj_diag d1 d2) ds2)
    ds1

(** negate_diag d renvoie la négation du diagramme d*)
let negate_diag (diag : diagramme) : diagramme list =
  List.map
    (fun (zone, fill) ->
      let fill_inverse = match fill with Vide -> NonVide | NonVide -> Vide in
      Diag.singleton zone fill_inverse)
    (Diag.bindings diag)

(** negate_diag_list ds renvoie la négation de la liste de diagrammes ds
    ¬[d1;d2;...;dn] = ¬d1 ∧ ¬d2 ∧ ... ∧ dn*)
let negate_diag_list (diag_liste : diagramme list) : diagramme list =
  List.fold_left
    (fun acc d -> conj_diag_list acc (negate_diag d))
    [ Diag.empty ] diag_liste

(** disj_of_diag_list ds1 ds2 renvoie la disjonction de deux listes de
    diagrammes ds1 et ds2 *)
let disj_of_diag_list (ds1 : diagramme list) (ds2 : diagramme list) :
    diagramme list =
  List.rev_append ds1 ds2

(** diags_of_bool_comb alpha b renvoie la liste des diagrammes associés à la
    combinaison booléenne b de formules pour syllogismes, sur les prédicats
    issus de b ou de alpha *)
let rec diags_of_bool_comb (alpha : string list) (b : boolCombSyllogismes) :
    diagramme list =
  match b with
  | Vrai -> [ Diag.empty ]
  | Faux -> []
  | Base formule -> diag_from_formule alpha formule
  | Et (bc1, bc2) ->
      conj_diag_list
        (diags_of_bool_comb alpha bc1)
        (diags_of_bool_comb alpha bc2)
  | Ou (bc1, bc2) ->
      disj_of_diag_list
        (diags_of_bool_comb alpha bc1)
        (diags_of_bool_comb alpha bc2)
  | Non bc1 -> negate_diag_list (diags_of_bool_comb alpha bc1)
