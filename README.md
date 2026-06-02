# Cantor Diagonal Argument in Lean 4

## Project Overview

This project formalizes the core idea of Cantor's diagonal argument for infinite
binary sequences in Lean 4. An infinite binary sequence is represented as a
function from natural numbers to Boolean values:

```lean
Nat -> Bool
```

A proposed list of all such sequences is represented as a function assigning one
binary sequence to each natural number:

```lean
Nat -> (Nat -> Bool)
```

The main construction is the diagonal sequence. Given a proposed list `f`, the
diagonal sequence `diag f` is defined so that its `n`th value is the opposite of
the `n`th value of the `n`th sequence in the list:

```lean
def diag (f : Nat -> (Nat -> Bool)) : Nat -> Bool :=
  fun n => Bool.not ((f n) n)
```

Because `diag f` differs from each listed sequence `f n` at position `n`, it
cannot be equal to any sequence in the proposed list. Therefore, no function

```lean
Nat -> (Nat -> Bool)
```

can list all infinite binary sequences.

## Main Result

The main theorem is:

```lean
theorem cantor_bool_diagonal :
    ∀ f : Nat -> (Nat -> Bool), ∃ g : Nat -> Bool, ∀ n : Nat, g ≠ f n
```

This states that for any attempted enumeration `f` of infinite binary sequences,
there exists a binary sequence `g` that is not equal to any sequence in the list.

The project also proves the equivalent surjectivity form:

```lean
theorem cantor_bool_not_surjective (f : Nat -> (Nat -> Bool)) :
    ¬ Function.Surjective f
```

This states that no attempted list `f` is surjective onto the type of infinite
binary sequences.

## File Structure

The Lean file is organized into the following sections:

1. Definition of the diagonal sequence.
2. Proof that a Boolean value is never equal to its negation.
3. Proof that the diagonal sequence differs from each listed sequence at the
   diagonal position.
4. A helper theorem showing that pointwise difference implies function
   inequality.
5. The main diagonal argument and non-surjectivity theorem.
6. A small concrete example list with computational checks.
7. Optional axiom audit commands.

## Requirements

This project uses only Lean 4 core functionality and does not require Mathlib.
There are no uses of `sorry`.

## How to Run

From the directory containing the Lean file, run:

```bash
lean CantorDiagonal.lean
```

The file should compile successfully and print the expected results from the
`#eval` sanity checks.

## Mathematical Meaning

The proof follows Cantor's classical diagonal method. If someone claims to have
listed every infinite binary sequence, we construct a new sequence by flipping
the diagonal entries of that list. This new sequence differs from the first
listed sequence at position `0`, from the second listed sequence at position
`1`, from the third listed sequence at position `2`, and so on. Hence it is not
on the list, contradicting the claim that the list contains every sequence.

Thus, the type of infinite binary sequences is not countable.
