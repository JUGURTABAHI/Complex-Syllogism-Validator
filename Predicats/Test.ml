open ValiditeNaive
open ValiditeViaNegation
open Formule_Syllogisme
open Proposition.Formule

let f : formule = Atome "a"
let g : formule = Atome "b"

(*----------------------------------------------------------------------------*)

(** 1. ∀x ¬ f(x) ⊢ ¬∃x f(x) *)
let syllogisme_1 () =
  let bc1 : boolCombSyllogismes = Base (PourTout (Non f)) in
  let c : boolCombSyllogismes = Non (Base (IlExiste f)) in
  print_endline "Syllogisme 1 : ∀x ¬ f(x) ⊢ ¬∃x f(x)";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_1 ()
(*---------------------------------------------------------------------------*)

(** 2. ¬∃x f(x) ⊢ ∀x ¬ f(x) *)
let syllogisme_2 () =
  let bc1 : boolCombSyllogismes = Non (Base (IlExiste f)) in
  let c : boolCombSyllogismes = Base (PourTout (Non f)) in
  print_endline "Syllogisme 2 : ¬∃x f(x) ⊢ ∀x ¬ f(x) ";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_2 ()

(*---------------------------------------------------------------------------*)

(** 3. ∃x ¬f(x) ⊢ ¬∀x f(x) *)
let syllogisme_3 () =
  let bc1 : boolCombSyllogismes = Base (IlExiste (Non f)) in
  let c : boolCombSyllogismes = Non (Base (PourTout f)) in
  print_endline "Syllogisme 3 : ∃x ¬f(x) ⊢ ¬∀x f(x)";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_3 ()
(*---------------------------------------------------------------------------*)

(** 4. ∃x (f(x) ∨ g(x)) ⊢ ∃x f(x) ∨ ∃x g(x) *)
let syllogisme_4 () =
  let bc1 : boolCombSyllogismes = Base (IlExiste (Ou (f, g))) in
  let c : boolCombSyllogismes = Ou (Base (IlExiste f), Base (IlExiste g)) in
  print_endline "Syllogisme 4 : ∃x (f(x) ∨ g(x)) ⊢ ∃x f(x) ∨ ∃x g(x)";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_4 ()
(*---------------------------------------------------------------------------*)

(** 5. ∃x f(x) ∨ ∃x g(x) ⊢ ∃x (f(x) ∨ g(x)) *)
let syllogisme_5 () =
  let bc1 : boolCombSyllogismes = Ou (Base (IlExiste f), Base (IlExiste g)) in
  let c : boolCombSyllogismes = Base (IlExiste (Ou (f, g))) in
  print_endline "Syllogisme 5 : ∃x f(x) ∨ ∃x g(x) ⊢ ∃x (f(x) ∨ g(x))";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_5 ()
(*---------------------------------------------------------------------------*)

(** 6. ∃x (f(x) ∧ g(x)) ⊢ ∃x f(x) ∧ ∃x g(x) *)
let syllogisme_6 () =
  let bc1 : boolCombSyllogismes = Base (IlExiste (Et (f, g))) in
  let c : boolCombSyllogismes = Et (Base (IlExiste f), Base (IlExiste g)) in
  print_endline "Syllogisme 6 : ∃x (f(x) ∧ g(x)) ⊢ ∃x f(x) ∧ ∃x g(x)";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"

(*syllogisme_6 ()*)
(*---------------------------------------------------------------------------*)

(** 7. ∀x (f(x) ∧ g(x)) ⊢ ∀x f(x) ∧ ∀x g(x) *)
let syllogisme_7 () =
  let bc1 : boolCombSyllogismes = Base (PourTout (Et (f, g))) in
  let c : boolCombSyllogismes = Et (Base (PourTout f), Base (PourTout g)) in
  print_endline "Syllogisme 7 : ∀x (f(x) ∧ g(x)) ⊢ ∀x f(x) ∧ ∀x g(x)";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_7 ()
(*---------------------------------------------------------------------------*)

(** 8. ∀x f(x) ∧ ∀x g(x) ⊢ ∀x (f(x) ∧ g(x)) *)
let syllogisme_8 () =
  let bc1 : boolCombSyllogismes = Et (Base (PourTout f), Base (PourTout g)) in
  let c : boolCombSyllogismes = Base (PourTout (Et (f, g))) in
  print_endline "Syllogisme 8 : ∀x f(x) ∧ ∀x g(x) ⊢ ∀x (f(x) ∧ g(x))";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_8 ()
(*---------------------------------------------------------------------------*)

(** 9. ∀x f(x) ∨ ∀x g(x) ⊢ ∀x (f(x) ∨ g(x)) *)
let syllogisme_9 () =
  let bc1 : boolCombSyllogismes = Ou (Base (PourTout f), Base (PourTout g)) in
  let c : boolCombSyllogismes = Base (PourTout (Ou (f, g))) in
  print_endline "Syllogisme 9 : ∀x f(x) ∨ ∀x g(x) ⊢ ∀x (f(x) ∨ g(x))";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_9 ()

(*---------------------------------------------------------------------------*)

(** 14. ¬∀x ¬f(x) ⊢ ¬¬∃x f(x) *)
let syllogisme_14 () =
  let bc1 : boolCombSyllogismes = Non (Base (PourTout (Non f))) in
  let c : boolCombSyllogismes = Non (Non (Base (IlExiste f))) in
  print_endline "Syllogisme 14 : ¬∀x¬f ⊢ ¬¬∃xf";
  print_endline
    ("\t Méthode naive:\t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation:\t"
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_14 ()

(*---------------------------------------------------------------------------*)

(** 15. ∀x f(x) ⊢ ¬∃x ¬f(x) *)
let syllogisme_15 () =
  let bc1 = Base (PourTout f) in
  let c : boolCombSyllogismes = Non (Base (IlExiste (Non f))) in
  print_endline "Syllogisme 15 : ∀xf ⊢ ¬∃x¬f";
  print_endline
    ("\t Méthode naive:\t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation:\t"
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_15 ()

(*---------------------------------------------------------------------------*)

(** 17. ∃x f(x) ⊢ ¬∀x ¬f(x) *)
let syllogisme_17 () =
  let bc1 : boolCombSyllogismes = Base (IlExiste f) in
  let c : boolCombSyllogismes = Non (Base (PourTout (Non f))) in
  print_endline "Syllogisme 17 : ∃xf ⊢ ¬∀x¬f";
  print_endline
    ("\t Méthode naive:\t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation:\t"
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_17 ()

(*---------------------------------------------------------------------------*)

(** 18. ⊢ ∀x ¬¬(f(x) ∨ ¬f(x)) (tautologie) *)
let syllogisme_18 () =
  let tautologie = Ou (f, Non f) in
  let bc1 = Vrai in
  (* prémisses vides *)
  let c = Base (PourTout (Non (Non tautologie))) in
  print_endline "Syllogisme 18 : ⊢ ∀x¬¬(f∨¬f)";
  print_endline
    ("\t Méthode naive:\t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation:\t"
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_18 ()

(*---------------------------------------------------------------------------*)

(** 19. Faux ⊢ ∃x (b(x) → Faux) *)
let syllogisme_19 () =
  let bc1 = Faux in
  let c = Base (IlExiste (Imp (g, Bot))) in
  print_endline "Syllogisme 19 : Faux ⊢ ∃x(b→Faux)";
  print_endline
    ("\t Méthode naive:\t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation:\t"
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_19 ()

(** 16. ¬∃x ¬ f(x)||> ∀x ¬¬ f(x) *)
let syllogisme_16 () =
  let bc1 : boolCombSyllogismes = Non (Base (IlExiste (Non f))) in
  let c : boolCombSyllogismes = Base (PourTout (Non (Non f))) in
  print_endline "Syllogisme 2 : ¬∃x ¬ f(x) ⊢ ∀x ¬¬ f(x)";
  print_endline
    ("\t Méthode naive: \t" ^ string_of_bool (est_valid_premiss_conc bc1 c));
  print_endline
    ("\t Méthode ViaNegation :  "
    ^ string_of_bool (est_valid_premiss_conc' bc1 c));
  print_endline "\n"
;;

syllogisme_16 ()
(*----------------------------------------------------------------------------*)
