Validation de syllogismes complexes à l'aide des diagrammes de Venn

Implémentation en OCaml de méthodes de validation logique fondées sur les diagrammes de Venn.

![Language](https://img.shields.io/badge/Language-OCaml-EC7A00?logo=ocaml) ![Build](https://img.shields.io/badge/Build-Dune-blue)

Présentation

Ce projet consiste à développer un programme capable de déterminer automatiquement la validité de syllogismes complexes à l'aide de diagrammes de Venn.

Contrairement aux syllogismes classiques, limités à une structure relativement simple, les syllogismes étudiés ici peuvent combiner plusieurs propositions logiques à l'aide d'opérateurs booléens : conjonction, disjonction et négation.

L'objectif est de construire une représentation formelle de ces raisonnements, de les traduire en diagrammes de Venn, puis de vérifier leur validité à travers deux algorithmes indépendants :

Un algorithme naïf fondé sur la génération des extensions complètes des diagrammes.
Un algorithme fondé sur la négation de la conclusion et la recherche de contradictions.

Le projet met en œuvre des concepts de logique propositionnelle, de logique des prédicats et de programmation fonctionnelle en OCaml.

1. Fondements logiques
1.1. Qu'est-ce qu'un syllogisme ?

Un syllogisme est un raisonnement déductif constitué de prémisses et d'une conclusion.

Un raisonnement est valide lorsque la vérité de toutes ses prémisses garantit nécessairement celle de sa conclusion.

Exemple :

Tous les mammifères sont des animaux.
Tous les chiens sont des mammifères.
Donc, tous les chiens sont des animaux.

La conclusion découle nécessairement des deux prémisses : le raisonnement est valide.

À l'inverse :

Tous les chiens sont des animaux.
Tous les chats sont des animaux.
Donc, tous les chats sont des chiens.

Les prémisses peuvent être vraies sans que la conclusion le soit : le raisonnement est invalide.

1.2. Les quatre formes catégoriques

La syllogistique traditionnelle distingue quatre formes de propositions :

Type	Nom	Forme logique	Signification
A	Universelle affirmative	Tout S est P	S est inclus dans P
E	Universelle négative	Aucun S n'est P	S et P sont disjoints
I	Particulière affirmative	Certains S sont P	S et P ont une intersection non vide
O	Particulière négative	Certains S ne sont pas P	Une partie de S se trouve hors de P

Ces formes permettent de représenter les contraintes imposées aux ensembles dans un diagramme de Venn.

1.3. Syllogismes complexes

Le projet étend cette représentation aux formules combinant plusieurs propositions syllogistiques.

Les opérateurs pris en charge sont :

ET : conjonction de deux contraintes.
OU : disjonction de deux contraintes.
NON : négation d'une contrainte.
VRAI : formule toujours satisfaite.
FAUX : formule toujours insatisfaite.

Les syllogismes complexes sont représentés sous forme d'arbres syntaxiques, permettant de combiner librement ces opérateurs.

1.4. Définition formelle de la validité

Soient P₁, P₂, ..., Pₙ les prémisses et C la conclusion.

Le syllogisme est valide si :

(P₁ ∧ P₂ ∧ ... ∧ Pₙ) ⇒ C

est une tautologie.

Une formulation équivalente consiste à vérifier que :

P₁ ∧ P₂ ∧ ... ∧ Pₙ ∧ ¬C

est insatisfaisable.

Autrement dit, il ne doit exister aucune interprétation dans laquelle toutes les prémisses sont satisfaites et la conclusion est fausse.

Cette propriété constitue le fondement du second algorithme du projet.

2. Représentation par diagrammes de Venn
2.1. Principe

Un diagramme de Venn permet de représenter les relations entre plusieurs ensembles.

Dans ce projet, chaque diagramme est modélisé par une association entre des zones et leur état logique.

Une zone correspond à une combinaison de prédicats positifs ou négatifs.

Pour deux prédicats A et B, on distingue quatre zones :

Zone	Représentation	Signification
1	A ∩ B	Appartient à A et à B
2	A ∩ ¬B	Appartient à A, mais pas à B
3	¬A ∩ B	Appartient à B, mais pas à A
4	¬A ∩ ¬B	N'appartient ni à A ni à B
2.2. États des zones

Chaque zone peut prendre trois états :

Vide : la zone est nécessairement vide.
NonVide : la zone contient nécessairement au moins un élément.
Absence de contrainte : la zone reste indéterminée.

Cette représentation permet de traduire les propositions logiques en contraintes sur les ensembles.

2.3. Structures de données

Les diagrammes sont représentés à l'aide des modules Set et Map de la bibliothèque standard OCaml.

ocaml
module Predicate_set = Set.Make(String)
module Diag = Map.Make(Predicate_set)

type fill = Vide | NonVide
type diagramme = fill Diag.t


Les clés de la map représentent les zones, sous forme d'ensembles de prédicats.

Cette représentation permet de manipuler efficacement les contraintes logiques et de comparer les diagrammes entre eux.

3. Architecture du projet

Le projet est organisé en deux modules principaux : Proposition et Predicats.

text
.
├── Proposition/
│   ├── dune
│   └── Formule.ml
│
├── Predicats/
│   ├── dune
│   ├── DiagVenn.ml
│   ├── Formule_Syllogisme.ml
│   ├── Test.ml
│   ├── ValiditeNaive.ml
│   └── ValiditeViaNegation.ml
│
├── dune-project
├── README.md
└── .gitignore

3.1. Module Proposition

Formule.ml

Ce module constitue la base de la représentation logique.

Il définit les formules propositionnelles et fournit les opérations nécessaires à leur manipulation, notamment l'évaluation des formules et la génération de tables de vérité.

Il prend en charge différents opérateurs logiques, notamment :

Implication.
Conjonction et disjonction.
Négation.
NAND, NOR, XOR et XNOR.
Équivalence et différence.
Plusieurs opérateurs logiques à trois arguments.
3.2. Module Predicats

Formule_Syllogisme.ml

Définit les structures permettant de représenter les formules syllogistiques.

Deux quantificateurs sont utilisés :

PourTout : contrainte universelle.
IlExiste : contrainte existentielle.

Les formules syllogistiques peuvent ensuite être combinées à l'aide d'opérateurs booléens.

DiagVenn.ml

Contient les structures de données et les opérations sur les diagrammes de Venn :

Construction d'un diagramme à partir d'une formule.
Négation d'un diagramme.
Conjonction et disjonction.
Gestion des listes de diagrammes.
Vérification de compatibilité.
Manipulation des zones.

ValiditeNaive.ml

Implémente le premier algorithme de validation, fondé sur la génération des extensions complètes des diagrammes.

ValiditeViaNegation.ml

Implémente le second algorithme, fondé sur la négation de la conclusion et la recherche de contradictions.

Test.ml

Regroupe les tests permettant de vérifier le comportement des différentes fonctionnalités et des algorithmes de validation.

4. Opérations sur les diagrammes

Le module DiagVenn.ml fournit les opérations nécessaires à la manipulation des représentations logiques.

Opération	Description
diag_from_formule	Transforme une formule syllogistique en diagramme(s) de Venn.
Négation	Génère les diagrammes représentant la négation d'un diagramme.
Négation de liste	Applique la négation à une liste de diagrammes.
Conjonction	Combine deux diagrammes compatibles.
Conjonction de listes	Génère les combinaisons compatibles de deux listes.
Disjonction	Représente la disjonction de deux diagrammes compatibles.
Disjonction de listes	Combine les diagrammes de deux listes.
Compatibilité	Vérifie si les contraintes de deux diagrammes peuvent coexister.
Conversion d'une formule en diagramme

La fonction diag_from_formule traduit une formule syllogistique en une ou plusieurs représentations sous forme de diagrammes.

Pour une formule universelle, elle identifie les zones devant être vides.
Pour une formule existentielle, elle génère les possibilités correspondant aux zones devant contenir au moins un élément.

Cette conversion constitue le point de départ des algorithmes de validation.

5. Algorithmes de validation

Deux méthodes complémentaires sont implémentées pour déterminer la validité d'un syllogisme complexe.

5.1. Algorithme naïf — ValiditeNaive.ml

Cette première méthode repose sur la génération des extensions complètes des diagrammes de prémisses.

Une extension complète consiste à attribuer un état à chacune des zones encore indéterminées.

Pour chaque diagramme de prémisses :

Générer toutes ses extensions complètes.
Examiner chaque extension.
Vérifier si elle contredit tous les diagrammes possibles de la conclusion.
Si une telle extension existe, le syllogisme est invalide.

Principe :

Il existe une extension complète des prémisses qui contredit toutes les possibilités de la conclusion si et seulement si le syllogisme est invalide.

Complexité :

Si k représente le nombre de zones indéterminées, le nombre d'extensions possibles est exponentiel :

2ᵏ

Cette approche peut donc devenir coûteuse lorsque le nombre de zones augmente.

5.2. Algorithme par négation — ValiditeViaNegation.ml

Le second algorithme utilise directement la caractérisation logique de la validité.

Au lieu d'énumérer toutes les extensions possibles, il cherche à déterminer si les prémisses peuvent être satisfaites simultanément avec la négation de la conclusion.

Principe :

Prémisses ∧ ¬Conclusion = ∅ ⇔ Syllogisme valide

Étapes :

Calculer la négation de la conclusion.
Combiner les diagrammes des prémisses avec ceux de la négation de la conclusion.
Éliminer les combinaisons incompatibles.
Examiner le résultat :
Liste vide : le syllogisme est valide.
Liste non vide : le syllogisme est invalide.

Cette méthode évite la génération exhaustive des extensions complètes.

5.3. Comparaison des deux algorithmes
Critère	Algorithme naïf	Algorithme par négation
Fichier	ValiditeNaive.ml	ValiditeViaNegation.ml
Principe	Génération des extensions	Négation de la conclusion
Recherche	Contre-exemples complets	Contradictions
Complexité	Exponentielle en nombre de zones indéterminées	Dépend des combinaisons de diagrammes
Avantage	Approche directe et exhaustive	Évite l'énumération exhaustive des extensions

L'approche par négation constitue une alternative plus efficace lorsque le nombre de zones indéterminées devient important.

6. Exemples de formules
Syllogisme universel

« Tous les B sont des A. »

Représentation :

ocaml
Base (
  PourTout (
    Imp (Atome "b", Atome "a")
  )
)

Syllogisme existentiel

« Il existe un B qui n'est pas A. »

Représentation :

ocaml
Base (
  IlExiste (
    Et (
      Atome "b",
      Non (Atome "a")
    )
  )
)

Syllogisme complexe

« Soit tous les B sont des A, soit il existe un B qui n'est pas A. »

Représentation :

ocaml
Ou (
  Base (
    PourTout (
      Imp (Atome "b", Atome "a")
    )
  ),
  Base (
    IlExiste (
      Et (
        Atome "b",
        Non (Atome "a")
      )
    )
  )
)


Ces exemples illustrent la construction de formules syllogistiques simples et leur combinaison à l'aide d'opérateurs booléens.

7. Choix techniques

Le projet repose sur une approche fonctionnelle en OCaml.

Plusieurs choix techniques ont été privilégiés :

Structures persistantes : utilisation de Map et Set pour représenter les diagrammes et leurs zones.
Types algébriques : représentation explicite des formules et des opérateurs logiques.
Récursivité terminale : utilisation d'accumulateurs pour certaines fonctions manipulant des listes ou des arbres syntaxiques.
Récursivité non terminale : utilisée lorsque la reconstruction d'un résultat nécessite de combiner les résultats des appels récursifs.

L'objectif est de conserver une représentation claire des objets logiques tout en facilitant leur manipulation.

8. Installation et compilation
Prérequis
OCaml
Dune
Compilation

Depuis la racine du dépôt :

bash
dune build

Exécution des tests
bash
dune exec ./Predicats/Test.exe


Cette commande suppose que l'exécutable Test est déclaré dans le fichier Predicats/dune.

9. Rapport

Le rapport complet du projet est disponible ici :

📄 Consulter le rapport de projet

Il présente notamment les fondements théoriques, les structures de données, les opérations sur les diagrammes de Venn, les propriétés démontrées, les deux algorithmes de validation ainsi que les difficultés rencontrées lors du développement.

10. Auteur

Jugurta BAHI

Projet réalisé dans le cadre d'un projet universitaire.

Encadrant : Ludovic Mignot

Date : 21 décembre 2025

Projet de formalisation logique et de programmation fonctionnelle en OCaml.
