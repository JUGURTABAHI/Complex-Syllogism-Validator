open DiagVenn
open Formule_Syllogisme

let alpha = [ "a"; "b"; "c" ]

(** est_valid_premiss_conc b1 b2 teste si pour deux combinaisons booléennes de
    formules pour syllogismes b1 et b2, b1 valide b2, en utilisant la méthode de
    la conjonction avec les diagrammes inverses de la conclusion *)
let est_valid_premiss_conc' (premisse : boolCombSyllogismes)
    (conclusion : boolCombSyllogismes) : bool =
  let diags_p : diagramme list = diags_of_bool_comb alpha premisse in
  let diags_c : diagramme list = diags_of_bool_comb alpha conclusion in
  conj_diag_list diags_p (negate_diag_list diags_c) = []

(** temoins_invalidite_premisses_conc' b1 b2 renvoie les diagrammes de la
    conjonction des diagrammes de b1 avec la négation de b2, qui contredisent
    chaque diagramme de b2 *)
let temoins_invalidite_premisses_conc' (premisse : boolCombSyllogismes)
    (conclusion : boolCombSyllogismes) : diagramme list =
  let diags_p : diagramme list = diags_of_bool_comb alpha premisse in
  let diags_c : diagramme list = diags_of_bool_comb alpha conclusion in
  conj_diag_list diags_p (negate_diag_list diags_c)
