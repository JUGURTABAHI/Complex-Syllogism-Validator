open DiagVenn
open Formule_Syllogisme

let alpha = [ "a"; "b"; "c" ]

(** complete_diags d ats renvoie la liste des extensions complètes de d en
    considérant les atomes de la liste ats pour considérer les zones à
    compléter. Par exemple, un diagramme défini par une contrainte vide sur une
    zone A pourrait être complété en considérant les zones définies par une
    liste d'atomes [A; B; C]. *)
let complete_diags (diag : diagramme) (ats : string list) : diagramme list =
  let rec all_subsets = function
    | [] -> [ Predicate_set.empty ]
    | x :: xs ->
        let rest = all_subsets xs in
        rest @ List.map (fun s -> Predicate_set.add x s) rest
  in
  let all_zones = all_subsets ats in
  let rec aux ds zones =
    match zones with
    | [] -> ds
    | z :: zs ->
        let ds' =
          List.concat_map
            (fun d ->
              if Diag.mem z d then [ d ]
              else
                let d_vide = Diag.add z Vide d in
                let d_nonvide = Diag.add z NonVide d in
                [ d_vide; d_nonvide ])
            ds
        in
        aux ds' zs
  in
  aux [ diag ] all_zones

(** is_contradiction d1 d2 teste si les diagrammes d1 et d2 sont en
    contradiction, c'est-à-dire s'il existe une zone non-vide de d1 qui est vide
    dans d2 ou inversement *)
let is_contradiction (diag1 : diagramme) (diag2 : diagramme) : bool =
  let all_zones =
    let keys1 = List.map fst (Diag.bindings diag1) in
    let keys2 = List.map fst (Diag.bindings diag2) in
    List.sort_uniq compare (keys1 @ keys2)
  in
  List.exists
    (fun zone ->
      match (Diag.find_opt zone diag1, Diag.find_opt zone diag2) with
      | Some Vide, Some NonVide | Some NonVide, Some Vide -> true
      | _ -> false)
    all_zones

(** est_valid_premiss_conc b1 b2 teste si pour deux combinaisons booléennes de
    formules pour syllogismes b1 et b2, b1 valide b2*)
let est_valid_premiss_conc (b1 : boolCombSyllogismes) (b2 : boolCombSyllogismes)
    : bool =
  let diags_p = diags_of_bool_comb alpha b1 in
  let diags_c = diags_of_bool_comb alpha b2 in
  let extensions = List.concat_map (fun d -> complete_diags d alpha) diags_p in
  not
    (List.exists
       (fun ext -> List.for_all (fun dc -> is_contradiction ext dc) diags_c)
       extensions)

(** temoins_invalidite_premisses_conc b1 b2 renvoie les diagrammes de la
    combinaison des prémisses b1 invalidant la conclusion b2 *)
let temoins_invalidite_premisses_conc (b1 : boolCombSyllogismes)
    (b2 : boolCombSyllogismes) : diagramme list =
  let diags_p = diags_of_bool_comb alpha b1 in
  let diags_c = diags_of_bool_comb alpha b2 in
  List.filter
    (fun dp ->
      let extensions = complete_diags dp alpha in
      List.exists
        (fun ext -> List.for_all (fun dc -> is_contradiction ext dc) diags_c)
        extensions)
    diags_p
