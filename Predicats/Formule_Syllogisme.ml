open Proposition.Formule

(** Type des formules utilisées pour les syllogismes *)
type formule_syllogisme = PourTout of formule | IlExiste of formule

(** string_of_formule_log_prop_var s f : conversion d'une formule f en chaîne de
    caractères, en les représentant comme des prédicats unaires appliqués sur
    des occurrences de la variable s. *)
let rec string_of_formule_log_prop_var (s : string) (f : formule) : string =
  match f with
  | Bot -> "⊥"
  | Top -> "⊤"
  | Atome p -> p ^ "(" ^ s ^ ")"
  | Non f1 -> "¬(" ^ string_of_formule_log_prop_var s f1 ^ ")"
  | Et (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ∧ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Ou (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ∨ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Imp (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " -> "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Nor (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ↓ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Nand (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ↑ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Xor (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ⊕ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Xnor (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ≡ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | AndNot (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ∧ ¬"
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | NotAnd (f1, f2) ->
      "(¬"
      ^ string_of_formule_log_prop_var s f1
      ^ " ∧ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | OrNot (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " ∨ ¬"
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | BufA (f1, _) -> "(" ^ string_of_formule_log_prop_var s f1 ^ " → A)"
  | BufB (_, f2) -> "(" ^ string_of_formule_log_prop_var s f2 ^ " → B)"
  | Diff (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " \\ "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Equiv (f1, f2) ->
      "("
      ^ string_of_formule_log_prop_var s f1
      ^ " <-> "
      ^ string_of_formule_log_prop_var s f2
      ^ ")"
  | Aucun (f1, f2, f3) ->
      "Aucun("
      ^ string_of_formule_log_prop_var s f1
      ^ ", "
      ^ string_of_formule_log_prop_var s f2
      ^ ", "
      ^ string_of_formule_log_prop_var s f3
      ^ ")"
  | Tous (f1, f2, f3) ->
      "Tous("
      ^ string_of_formule_log_prop_var s f1
      ^ ", "
      ^ string_of_formule_log_prop_var s f2
      ^ ", "
      ^ string_of_formule_log_prop_var s f3
      ^ ")"
  | UnSeul (f1, f2, f3) ->
      "UnSeul("
      ^ string_of_formule_log_prop_var s f1
      ^ ", "
      ^ string_of_formule_log_prop_var s f2
      ^ ", "
      ^ string_of_formule_log_prop_var s f3
      ^ ")"
  | Meme (f1, f2, f3) ->
      "Meme("
      ^ string_of_formule_log_prop_var s f1
      ^ ", "
      ^ string_of_formule_log_prop_var s f2
      ^ ", "
      ^ string_of_formule_log_prop_var s f3
      ^ ")"
  | Exactement_2 (f1, f2, f3) ->
      "Exactement_2("
      ^ string_of_formule_log_prop_var s f1
      ^ ", "
      ^ string_of_formule_log_prop_var s f2
      ^ ", "
      ^ string_of_formule_log_prop_var s f3
      ^ ")"
  | AuMoins_2 (f1, f2, f3) ->
      "AuMoins_2("
      ^ string_of_formule_log_prop_var s f1
      ^ ", "
      ^ string_of_formule_log_prop_var s f2
      ^ ", "
      ^ string_of_formule_log_prop_var s f3
      ^ ")"
  | AuPlus_2 (f1, f2, f3) ->
      "AuPlus_2("
      ^ string_of_formule_log_prop_var s f1
      ^ ", "
      ^ string_of_formule_log_prop_var s f2
      ^ ", "
      ^ string_of_formule_log_prop_var s f3
      ^ ")"

(** string_of_formule_syllogisme f : conversion d'une formule f en chaîne de
    caractères, en considérant des prédicats unaires appliqués sur des
    occurrences de la variable s. *)

let string_of_formule_syllogisme (f : formule_syllogisme) : string =
  match f with
  | PourTout phi -> "∀" ^ "x " ^ string_of_formule_log_prop_var "x" phi
  | IlExiste phi -> "∃" ^ "x " ^ string_of_formule_log_prop_var "x" phi

(** Type des combinaisons booléennes pour les syllogismes *)
type boolCombSyllogismes =
  | Vrai
  | Faux
  | Base of formule_syllogisme
  | Et of boolCombSyllogismes * boolCombSyllogismes
  | Ou of boolCombSyllogismes * boolCombSyllogismes
  | Non of boolCombSyllogismes
