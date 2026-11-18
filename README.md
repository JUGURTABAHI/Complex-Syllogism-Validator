# Complex Syllogism Validator

**Validation of complex syllogisms using Venn diagrams**

![Language](https://img.shields.io/badge/Language-OCaml-EC7A00?logo=ocaml)
![Build](https://img.shields.io/badge/Build-Dune-blue)

---

## Overview

This project implements an automated system for validating complex syllogisms using Venn diagrams.

Unlike traditional syllogisms, which generally involve simple categorical propositions, complex syllogisms can combine multiple logical statements using Boolean operators such as conjunction, disjunction and negation.

The objective is to formally represent these logical expressions, translate them into Venn diagrams and determine their validity using two independent algorithms:

- A naive algorithm based on the generation of complete diagram extensions.
- A negation-based algorithm that checks for contradictions between the premises and the negated conclusion.

The project combines concepts from propositional logic, predicate logic and functional programming in OCaml.

---

## 1. Logical Foundations

### 1.1. What Is a Syllogism?

A syllogism is a deductive argument consisting of premises and a conclusion.

A syllogism is valid when the truth of all its premises necessarily guarantees the truth of its conclusion.

**Example of a valid syllogism:**

- All mammals are animals.
- All dogs are mammals.
- Therefore, all dogs are animals.

The conclusion necessarily follows from the premises.

**Example of an invalid syllogism:**

- All dogs are animals.
- All cats are animals.
- Therefore, all cats are dogs.

The premises may be true without the conclusion being true.

### 1.2. The Four Categorical Propositions

Traditional syllogistic logic distinguishes four types of categorical propositions:

| Type | Name | Logical Form | Meaning |
|---|---|---|---|
| A | Universal Affirmative | All S are P | S is included in P |
| E | Universal Negative | No S are P | S and P are disjoint |
| I | Particular Affirmative | Some S are P | S and P have a non-empty intersection |
| O | Particular Negative | Some S are not P | Part of S lies outside P |

These four forms define the fundamental constraints represented by Venn diagrams.

### 1.3. Complex Syllogisms

This project extends traditional syllogistic reasoning by allowing multiple propositions to be combined using Boolean operators.

Supported operators include:

- **AND:** conjunction of two logical constraints.
- **OR:** disjunction of two logical constraints.
- **NOT:** negation of a logical constraint.
- **TRUE:** a proposition that is always satisfied.
- **FALSE:** a proposition that is never satisfied.

Complex syllogisms are represented using recursive algebraic data types, forming logical syntax trees.

### 1.4. Formal Definition of Validity

Let `P₁, P₂, ..., Pₙ` represent the premises and `C` represent the conclusion.

A syllogism is valid if:

```text
(P₁ ∧ P₂ ∧ ... ∧ Pₙ) ⇒ C
```

is a tautology.

Equivalently, validity can be established by checking whether:

```text
P₁ ∧ P₂ ∧ ... ∧ Pₙ ∧ ¬C
```

is unsatisfiable.

In other words, there must be no interpretation in which all premises are satisfied while the conclusion is false.

This property is the theoretical foundation of the second validation algorithm.

---

## 2. Venn Diagram Representation

### 2.1. Principle

Venn diagrams provide a graphical representation of relationships between sets.

In this project, each diagram is represented as a mapping between regions and their logical states.

A region corresponds to a combination of positive and negative predicates.

For two predicates A and B, four regions can be distinguished:

| Region | Representation | Meaning |
|---|---|---|
| 1 | A ∩ B | Belongs to both A and B |
| 2 | A ∩ ¬B | Belongs to A but not B |
| 3 | ¬A ∩ B | Belongs to B but not A |
| 4 | ¬A ∩ ¬B | Belongs to neither A nor B |

### 2.2. Region States

Each region can have three possible states:

- `Vide`: the region must be empty.
- `NonVide`: the region must contain at least one element.
- **Undefined:** no constraint is imposed on the region.

This representation allows logical propositions to be translated into constraints on sets.

### 2.3. Data Structures

Diagrams are represented using OCaml's standard `Set` and `Map` modules.

```ocaml
module Predicate_set = Set.Make(String)
module Diag = Map.Make(Predicate_set)

type fill = Vide | NonVide
type diagramme = fill Diag.t
```

The map keys represent regions as sets of predicates.

This representation makes it possible to manipulate logical constraints and compare diagrams efficiently.

---

## 3. Project Architecture

The project is organized into two main modules: `Proposition` and `Predicats`.

```text
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
```

### 3.1. Proposition Module

#### `Formule.ml`

This module provides the foundation for logical formula representation.

It defines propositional formulas and provides operations for manipulating and evaluating them, including truth-table generation.

Supported operators include:

- Implication.
- Conjunction and disjunction.
- Negation.
- NAND, NOR, XOR and XNOR.
- Equivalence and difference.
- Several three-argument logical operators.

### 3.2. Predicats Module

#### `Formule_Syllogisme.ml`

Defines the structures used to represent syllogistic formulas.

Two quantifiers are supported:

- `PourTout`: universal quantification.
- `IlExiste`: existential quantification.

Syllogistic formulas can then be combined using Boolean operators.

#### `DiagVenn.ml`

Implements the data structures and operations required to manipulate Venn diagrams:

- Construction of diagrams from formulas.
- Diagram negation.
- Conjunction and disjunction.
- Diagram list operations.
- Compatibility checking.
- Region manipulation.

#### `ValiditeNaive.ml`

Implements the first validation algorithm, based on the generation of complete diagram extensions.

#### `ValiditeViaNegation.ml`

Implements the second validation algorithm, based on the negation of the conclusion and contradiction detection.

#### `Test.ml`

Contains tests for the different functionalities and validation algorithms.

---

## 4. Operations on Venn Diagrams

The `DiagVenn.ml` module provides the operations required to manipulate logical representations.

| Operation | Description |
|---|---|
| `diag_from_formule` | Converts a syllogistic formula into one or more Venn diagrams. |
| Diagram negation | Generates diagrams representing the negation of a diagram. |
| List negation | Applies negation to a list of diagrams. |
| Conjunction | Combines two compatible diagrams. |
| List conjunction | Generates compatible combinations of two diagram lists. |
| Disjunction | Represents the disjunction of two compatible diagrams. |
| List disjunction | Combines diagrams from two lists. |
| Compatibility | Checks whether two diagrams have compatible constraints. |

### 4.1. Formula-to-Diagram Conversion

The `diag_from_formule` function translates a syllogistic formula into one or more Venn diagram representations.

- For universal formulas, it identifies the regions that must be empty.
- For existential formulas, it generates the possible diagrams corresponding to regions that must contain at least one element.

This conversion is the starting point of both validation algorithms.

---

## 5. Validation Algorithms

Two complementary approaches are implemented to determine the validity of complex syllogisms.

### 5.1. Naive Algorithm

**File:** `ValiditeNaive.ml`

The first approach relies on generating all complete extensions of the premise diagrams.

A complete extension assigns a state to every previously undefined region.

For each premise diagram:

1. Generate all its complete extensions.
2. Examine each extension.
3. Check whether it contradicts every possible conclusion diagram.
4. If such an extension exists, the syllogism is invalid.

#### Principle

A syllogism is invalid if and only if there exists a complete extension of the premises that contradicts every possible conclusion diagram.

#### Complexity

If `k` represents the number of undefined regions, the number of possible extensions is exponential:

```text
2^k
```

Consequently, this approach can become expensive as the number of regions increases.

### 5.2. Negation-Based Algorithm

**File:** `ValiditeViaNegation.ml`

The second approach directly uses the logical characterization of validity.

Instead of generating all possible extensions, it checks whether the premises can be satisfied simultaneously with the negation of the conclusion.

#### Principle

```text
Premises ∧ ¬Conclusion = ∅ ⇔ Syllogism is valid
```

#### Steps

1. Compute the negation of the conclusion.
2. Combine the premise diagrams with the diagrams representing the negated conclusion.
3. Eliminate incompatible combinations.
4. Examine the result:
   - **Empty list:** the syllogism is valid.
   - **Non-empty list:** the syllogism is invalid.

This approach avoids exhaustive generation of complete extensions.

### 5.3. Algorithm Comparison

| Criterion | Naive Algorithm | Negation-Based Algorithm |
|---|---|---|
| File | `ValiditeNaive.ml` | `ValiditeViaNegation.ml` |
| Principle | Complete extensions | Negation of conclusion |
| Search | Complete counterexamples | Contradictions |
| Complexity | Exponential in undefined regions | Depends on diagram combinations |
| Advantage | Exhaustive approach | Avoids exhaustive extension generation |

The negation-based approach provides an alternative that can be more efficient when the number of undefined regions becomes large.

---

## 6. Formula Examples

### 6.1. Universal Syllogistic Formula

**Statement:** "All B are A."

```ocaml
Base (
  PourTout (
    Imp (Atome "b", Atome "a")
  )
)
```

### 6.2. Existential Syllogistic Formula

**Statement:** "There exists a B that is not A."

```ocaml
Base (
  IlExiste (
    Et (
      Atome "b",
      Non (Atome "a")
    )
  )
)
```

### 6.3. Complex Syllogism

**Statement:** "Either all B are A, or there exists a B that is not A."

```ocaml
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
```

These examples illustrate how simple syllogistic formulas can be combined using Boolean operators to construct more complex logical expressions.

---

## 7. Technical Choices

The project relies on functional programming principles in OCaml.

Several technical choices were made:

- **Persistent data structures:** `Map` and `Set` are used to represent diagrams and their regions.
- **Algebraic data types:** formulas and logical operators are explicitly represented using recursive types.
- **Tail recursion:** accumulators are used in selected functions to efficiently process lists and syntax trees.
- **Non-tail recursion:** used when constructing results requires combining the results of recursive calls.

These choices provide a clear representation of logical objects while facilitating their manipulation.

---

## 8. Installation and Compilation

### 8.1. Requirements

- OCaml
- Dune

### 8.2. Build

From the root directory of the project, run:

```bash
dune build
```

### 8.3. Run Tests

```bash
dune exec ./Predicats/Test.ml
```

This command assumes that the `Test` executable is declared in `Predicats/dune`.

---

## 10. Author

**Jugurta BAHI**

- **Supervisor:** Ludovic Mignot
- **Date:** December 21, 2025

Academic project on logical formalization and functional programming in OCaml.
