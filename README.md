# Cantor's Diagonal Argument — Math 157 Final Project

A Lean 4 formalization of Cantor's diagonal argument for infinite binary
sequences.

## What This Project Proves

The main theorem is that no function `f : Nat -> (Nat -> Bool)` can list every
infinite binary sequence.

In this project, an infinite binary sequence is represented as a function
`Nat -> Bool`.  A proposed list of all such sequences is represented as a
function `f : Nat -> (Nat -> Bool)`, where `f n` is the `n`-th sequence in the
list.

Given any attempted list `f`, we construct a new sequence `diag f` that is
guaranteed to differ from every entry in the list.  Therefore the proposed list
is always incomplete.

## How the Formal Proof Corresponds to the Informal Argument

| Informal step | Lean name | What it says |
|---|---|---|
| Define the diagonal sequence by flipping the `n`-th bit of the `n`-th sequence. | `diag` | `diag f n := !(f n n)` |
| A bit is never equal to its own flip. | `bool_ne_not` | `b ≠ !b` for any `Bool` value `b` |
| The diagonal sequence differs from `f n` at position `n`. | `diag_pointwise_ne` | `diag f n ≠ (f n) n` |
| If two sequences differ at one position, they are different sequences. | `fun_ne_of_pointwise_ne` | `g n ≠ h n -> g ≠ h` |
| Therefore `diag f` is not equal to any `f n`. | `cantor_bool_diagonal` | `diag f ≠ f n` for all `n` |

## File Structure

```text
CantorDiagonal.lean    -- all definitions, lemmas, and theorems
README.md              -- project explanation
```

## How to Check the Lean File

This project uses Lean 4 core only.  It does not require Mathlib or any
nonstandard dependencies.

To check the file directly, run:

```bash
lean CantorDiagonal.lean
```

The file should compile successfully with no `sorry`.

## Axiom Audit

The Lean file includes commented-out `#print axioms` commands near the bottom.
These can be uncommented to inspect which foundational axioms Lean reports for
the main theorems.

No additional axioms are introduced in this file, and no `sorry` placeholders
are used.

## Reflection

My goal for this project was to practice translating a familiar informal proof
into a precise formal proof that Lean can check.  One important lesson was that
Lean requires even small logical steps to be stated explicitly.  For example,
the informal step "these two sequences differ at position `n`, so they are not
the same sequence" was written as a separate theorem in Lean.
