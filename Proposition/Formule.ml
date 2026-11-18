(** Le module Formule contient les types et définitions de base permettant la
    manipulation des formules de la logique propositionnelle. *)

(** Type des formules de la logique propositionnelle, avec des string comme
    atomes. *)
type formule =
  | Bot
  | Top
  | Atome of string
  | Non of formule
  | Imp of (formule * formule)
  | Ou of (formule * formule)
  | Et of (formule * formule)
  | Nand of (formule * formule)
  | Xor of (formule * formule)
  | Xnor of (formule * formule)
  | AndNot of (formule * formule)
  | NotAnd of (formule * formule)
  | OrNot of (formule * formule)
  | Nor of (formule * formule)
  | BufA of (formule * formule)
  | BufB of (formule * formule)
  | Diff of (formule * formule)
  | Equiv of (formule * formule)
  | Aucun of (formule * formule * formule)
  | Tous of (formule * formule * formule)
  | UnSeul of (formule * formule * formule)
  | Meme of (formule * formule * formule)
  | Exactement_2 of (formule * formule * formule)
  | AuMoins_2 of (formule * formule * formule)
  | AuPlus_2 of (formule * formule * formule)

(** Calcule la hauteur de l'arbre syntaxique d'une formule. *)
let hauteur (f : formule) =
  let rec aux f acc =
    match f with
    | Bot | Top | Atome _ -> acc
    | Non f1 -> aux f1 (acc + 1)
    | Ou (f1, f2)
    | Et (f1, f2)
    | Imp (f1, f2)
    | Nor (f1, f2)
    | Nand (f1, f2)
    | Xor (f1, f2)
    | Diff (f1, f2)
    | Equiv (f1, f2)
    | BufA (f1, f2)
    | BufB (f1, f2)
    | Xnor (f1, f2)
    | AndNot (f1, f2)
    | NotAnd (f1, f2)
    | OrNot (f1, f2) ->
        max (aux f1 (acc + 1)) (aux f2 (acc + 1))
    | Aucun (f1, f2, f3)
    | Tous (f1, f2, f3)
    | UnSeul (f1, f2, f3)
    | Meme (f1, f2, f3)
    | Exactement_2 (f1, f2, f3)
    | AuMoins_2 (f1, f2, f3)
    | AuPlus_2 (f1, f2, f3) ->
        max (aux f1 (acc + 1)) (max (aux f2 (acc + 1)) (aux f3 (acc + 1)))
  in
  aux f 1

(** Conversion d'une formule en chaîne de caractères. *)
let rec string_of_formule : formule -> string = function
  | Bot -> " ⊥ "
  | Top -> " T "
  | Atome s -> s
  | Non f -> "¬" ^ "(" ^ string_of_formule f ^ ")"
  | Et (f, g) -> "(" ^ string_of_formule f ^ " ∧ " ^ string_of_formule g ^ ")"
  | Ou (f, g) -> "(" ^ string_of_formule f ^ " V " ^ string_of_formule g ^ ")"
  | Imp (f, g) -> "(" ^ string_of_formule f ^ " → " ^ string_of_formule g ^ ")"
  | Nor (f, g) -> "(" ^ string_of_formule f ^ " ↓ " ^ string_of_formule g ^ ")"
  | Nand (f, g) -> "(" ^ string_of_formule f ^ " ↑ " ^ string_of_formule g ^ ")"
  | Xor (f, g) -> "(" ^ string_of_formule f ^ " ⊕ " ^ string_of_formule g ^ ")"
  | Diff (f, g) ->
      "(" ^ string_of_formule f ^ " \\ " ^ string_of_formule g ^ ")"
  | Equiv (f, g) ->
      "(" ^ string_of_formule f ^ " <--> " ^ string_of_formule g ^ ")"
  | Xnor (f, g) -> "(" ^ string_of_formule f ^ " ≡ " ^ string_of_formule g ^ ")"
  | AndNot (f, g) ->
      "(" ^ string_of_formule f ^ " ∧ ¬ " ^ string_of_formule g ^ ")"
  | NotAnd (f, g) ->
      "(¬" ^ string_of_formule f ^ " ∧ " ^ string_of_formule g ^ ")"
  | OrNot (f, g) ->
      "(" ^ string_of_formule f ^ " v ¬" ^ string_of_formule g ^ ")"
  | BufA (f, _) -> "(" ^ string_of_formule f ^ " → " ^ string_of_formule f ^ ")"
  | BufB (_, g) -> "(" ^ string_of_formule g ^ " → " ^ string_of_formule g ^ ")"
  | Aucun (f1, f2, f3) ->
      "Aucun(" ^ string_of_formule f1 ^ ", " ^ string_of_formule f2 ^ ", "
      ^ string_of_formule f3 ^ ")"
  | Tous (f1, f2, f3) ->
      "Tous(" ^ string_of_formule f1 ^ ", " ^ string_of_formule f2 ^ ", "
      ^ string_of_formule f3 ^ ")"
  | UnSeul (f1, f2, f3) ->
      "UnSeul(" ^ string_of_formule f1 ^ ", " ^ string_of_formule f2 ^ ", "
      ^ string_of_formule f3 ^ ")"
  | Meme (f1, f2, f3) ->
      "Meme(" ^ string_of_formule f1 ^ ", " ^ string_of_formule f2 ^ ", "
      ^ string_of_formule f3 ^ ")"
  | Exactement_2 (f1, f2, f3) ->
      "Exactement_2(" ^ string_of_formule f1 ^ ", " ^ string_of_formule f2
      ^ ", " ^ string_of_formule f3 ^ ")"
  | AuMoins_2 (f1, f2, f3) ->
      "AuMoins_2(" ^ string_of_formule f1 ^ ", " ^ string_of_formule f2 ^ ", "
      ^ string_of_formule f3 ^ ")"
  | AuPlus_2 (f1, f2, f3) ->
      "AuPlus_2(" ^ string_of_formule f1 ^ ", " ^ string_of_formule f2 ^ ", "
      ^ string_of_formule f3 ^ ")"

(** Transforme une liste de formules [[f1; f2; ... ; fl]] en la formule
    [f1 ∧ f2 ∧ ... ∧ fl] en considérant les éléments suivants : Si un des [fi]
    vaut [Bot], renvoie [Bot]. Si un des [fi] vaut [Top], il n'apparait pas dans
    le résultat. Si tous les [fi] valent [Top], renvoie [Top]. *)
let rec conj_of_list (l : formule list) : formule =
  match l with
  | [] -> Top
  | h :: t -> (
      match h with
      | Bot -> Bot
      | Top -> conj_of_list t
      | _ -> Et (h, conj_of_list t))

(** Transforme une liste de formules [[f1; f2; ... ; fl]] en la formule
    [f1 ∨ f2 ∨ ... ∨ fl] en considérant les éléments suivants : Si un des [fi]
    vaut [Top], renvoie [Top]. Si un des [fi] vaut [Bot], il n'apparait pas dans
    le résultat. Si tous les [fi] valent [Bot], renvoie [Bot]. *)
let rec disj_of_list (l : formule list) : formule =
  match l with
  | [] -> Bot
  | h :: t -> (
      match h with
      | Top -> Top
      | Bot -> disj_of_list t
      | _ -> Ou (h, disj_of_list t))

type interpretation = string -> bool
(** Type des interprétations. *)

(** Évalue une formule en fonction d'une interprétation. *)
let rec eval (i : string -> bool) (f : formule) : bool =
  match f with
  | Bot -> false
  | Top -> true
  | Atome s -> i s
  | Non f1 -> not (eval i f1)
  | Et (f1, f2) -> eval i f1 && eval i f2
  | Ou (f1, f2) -> eval i f1 || eval i f2
  | Imp (f1, f2) -> (not (eval i f1)) || eval i f2
  | Nor (f1, f2) -> not (eval i f1 || eval i f2)
  | Nand (f1, f2) -> not (eval i f1 && eval i f2)
  | Xor (f1, f2) -> eval i f1 <> eval i f2
  | Xnor (f1, f2) -> eval i f1 = eval i f2
  | Diff (f1, f2) -> eval i f1 && not (eval i f2)
  | Equiv (f1, f2) -> eval i f1 = eval i f2
  | AndNot (f1, f2) -> eval i f1 && not (eval i f2)
  | NotAnd (f1, f2) -> (not (eval i f1)) && eval i f2
  | OrNot (f1, f2) -> eval i f1 || not (eval i f2)
  | BufA (f1, _) -> eval i f1
  | BufB (_, f2) -> eval i f2
  | Aucun (f1, f2, f3) -> not (eval i f1 || eval i f2 || eval i f3)
  | Tous (f1, f2, f3) -> eval i f1 && eval i f2 && eval i f3
  | UnSeul (f1, f2, f3) ->
      let vals = [ eval i f1; eval i f2; eval i f3 ] in
      List.fold_left (fun acc x -> acc + if x then 1 else 0) 0 vals = 1
  | Meme (f1, f2, f3) ->
      let vals = [ eval i f1; eval i f2; eval i f3 ] in
      List.for_all (( = ) (List.hd vals)) (List.tl vals)
  | Exactement_2 (f1, f2, f3) ->
      let vals = [ eval i f1; eval i f2; eval i f3 ] in
      List.fold_left (fun acc x -> acc + if x then 1 else 0) 0 vals = 2
  | AuMoins_2 (f1, f2, f3) ->
      let vals = [ eval i f1; eval i f2; eval i f3 ] in
      List.fold_left (fun acc x -> acc + if x then 1 else 0) 0 vals >= 2
  | AuPlus_2 (f1, f2, f3) ->
      let vals = [ eval i f1; eval i f2; eval i f3 ] in
      List.fold_left (fun acc x -> acc + if x then 1 else 0) 0 vals <= 2

(** Transforme une liste de string en une interprétation. *)
let interpretation_of_list (l : string list) : interpretation =
 fun s -> List.exists (fun x -> x = s) l

(** Calcule la liste de toutes les sous-listes d'une liste donnée. *)
let rec all_sublists (l : 'a list) : 'a list list =
  match l with
  | [] -> [ [] ]
  | h :: t ->
      let sub_t = all_sublists t in
      let sub_h = List.map (fun x -> h :: x) sub_t in
      sub_t @ sub_h

(** Calcule toutes les interprétations pour une liste d'atomes donnée. *)
let all_interpretations (l : string list) : interpretation list =
  let sub_liste = all_sublists l in
  List.map interpretation_of_list sub_liste

(** Calcule la liste (triée et sans doublon) des atomes d'une formule. *)
let atomes (f : formule) : string list =
  let rec aux f acc =
    match f with
    | Atome s -> s :: acc
    | Bot | Top -> acc
    | Non f1 -> aux f1 acc
    | Et (f1, f2)
    | Ou (f1, f2)
    | Imp (f1, f2)
    | Nor (f1, f2)
    | Nand (f1, f2)
    | Xor (f1, f2)
    | Xnor (f1, f2)
    | Diff (f1, f2)
    | Equiv (f1, f2)
    | AndNot (f1, f2)
    | NotAnd (f1, f2)
    | OrNot (f1, f2)
    | BufA (f1, f2)
    | BufB (f1, f2) ->
        let acc1 = aux f1 acc in
        aux f2 acc1
    | Aucun (f1, f2, f3)
    | Tous (f1, f2, f3)
    | UnSeul (f1, f2, f3)
    | Meme (f1, f2, f3)
    | Exactement_2 (f1, f2, f3)
    | AuMoins_2 (f1, f2, f3)
    | AuPlus_2 (f1, f2, f3) ->
        let acc1 = aux f1 acc in
        let acc2 = aux f2 acc1 in
        aux f3 acc2
  in
  List.sort_uniq compare (aux f [])

(** Détermine si une formule est satisfaisable. *)
let est_satisfaisable (f : formule) : bool =
  let atomes = atomes f in
  let interprets = all_interpretations atomes in
  List.exists (fun x -> eval x f) interprets

(** Renvoie un témoin de la satisfaisabilité d'une formule, s'il en existe. *)
let ex_sat (f : formule) : interpretation option =
  let atomes = atomes f in
  let interprets = all_interpretations atomes in
  List.find_opt (fun x -> eval x f) interprets

(** Détermine si une formule est une tautologie. *)
let est_tautologie (f : formule) : bool =
  let atomes = atomes f in
  let interprets = all_interpretations atomes in
  List.for_all (fun x -> eval x f) interprets

(** Détermine si une formule est une contradiction. *)
let est_contradiction (f : formule) : bool = not (est_satisfaisable f)

(** Détermine si une formule est contingente. *)
let est_contingente (f : formule) : bool =
  est_satisfaisable f && not (est_tautologie f)

type ligne = string list * bool
(** Type d'une ligne d'une table de vérité. *)

type table = ligne list
(** Type d'une table de vérité. *)

(** Calcule la table de vérité associée à une formule. *)
let table_of_formule (f : formule) : table =
  let atomes = atomes f in
  let interprets = all_interpretations atomes in
  List.map
    (fun i ->
      let values = List.map (fun x -> string_of_bool (i x)) atomes in
      (values, eval i f))
    interprets

let reset = "\027[0m"
let bold = "\027[1m"
let red = "\027[31m"
let green = "\027[32m"

let color_bool b =
  if b then bold ^ green ^ "true" ^ reset else bold ^ red ^ "false" ^ reset

let print_table (f : formule) =
  let t = table_of_formule f in
  let atoms = atomes f in

  let col_widths = List.map (fun a -> max (String.length a) 5) atoms in
  let pad s w = s ^ String.make (w - String.length s) ' ' in

  print_endline
    (String.make 10 ' ' ^ bold ^ "Formule : " ^ string_of_formule f ^ reset);
  print_endline " ";

  let header = List.mapi (fun i a -> pad a (List.nth col_widths i)) atoms in
  let header_line =
    String.make 10 ' '
    ^ (bold ^ String.concat " | " header ^ reset)
    ^ " | " ^ bold ^ "résultat" ^ reset
  in
  print_endline header_line;

  let total_width =
    40 + List.fold_left ( + ) 0 (List.map (fun w -> w + 3) col_widths) + 10
  in
  print_endline
    (String.make 10 ' ' ^ String.make (total_width - 2 - 40) '-' ^ "|");
  List.iter
    (fun (vals, res) ->
      let vals_padded =
        List.mapi
          (fun i v ->
            let padded = pad v (List.nth col_widths i) in
            bold ^ padded ^ reset)
          vals
      in
      print_endline
        (String.make 10 ' '
        ^ String.concat " | " vals_padded
        ^ " | " ^ color_bool res))
    t
