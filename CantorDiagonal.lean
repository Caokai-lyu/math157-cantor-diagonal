-- This file formalizes the core of Cantor's diagonal argument for infinite binary sequences.
-- We represent an infinite binary sequence as a function from natural numbers
-- to Boolean values, and we represent a proposed list of all such sequences as
-- a function that assigns one binary sequence to each natural number.  The key
-- construction is the diagonal sequence, which flips the nth value of the nth
-- listed sequence.  This guarantees that the diagonal sequence differs from
-- every sequence in the proposed list at least at one position, so no such list
-- can contain all infinite binary sequences.

-- CantorDiagonal.lean — Math 157 Week 9
-- Cantor's diagonal argument: no f : ℕ → (ℕ → Bool) is surjective.
-- No sorry. Lean 4 core only (no Mathlib).


-- §1. Diagonal sequence: diag f n := !(f n n)
def diag (f : Nat → (Nat → Bool)) : Nat → Bool :=
  fun n => Bool.not ((f n) n)


-- §2. A Bool never equals its negation
theorem bool_ne_not (b : Bool) : b ≠ !b := by
  cases b
  · decide  -- false ≠ true
  · decide  -- true  ≠ false


-- §3. diag f differs from every f n at position n
theorem diag_pointwise_ne (f : Nat → (Nat → Bool)) (n : Nat) :
    diag f n ≠ (f n) n := by
  unfold diag
  exact Ne.symm (bool_ne_not ((f n) n))


-- §4. Pointwise difference implies function inequality
theorem fun_ne_of_pointwise_ne {g h : Nat → Bool} (n : Nat)
    (hne : g n ≠ h n) : g ≠ h := by
  intro heq
  exact hne (congrFun heq n)


-- §5. Main theorem: diag f ∉ range f
theorem cantor_bool_diagonal (f : Nat → (Nat → Bool)) (n : Nat) :
    diag f ≠ f n :=
  fun_ne_of_pointwise_ne n (diag_pointwise_ne f n)


-- §6. Sanity check: f 0 = all-false, f 1 = all-true, f k = all-false
def exampleList : Nat → (Nat → Bool)
  | 0 => fun _ => false
  | 1 => fun _ => true
  | _ => fun _ => false

#eval diag exampleList 0   -- true
#eval diag exampleList 1   -- false
#eval diag exampleList 2   -- true

#eval (diag exampleList 0 != exampleList 0 0)  -- true
#eval (diag exampleList 1 != exampleList 1 1)  -- true
#eval (diag exampleList 2 != exampleList 2 2)  -- true


-- §7. Axiom audit (uncomment to inspect)
-- #print axioms bool_ne_not
-- #print axioms diag_pointwise_ne
-- #print axioms fun_ne_of_pointwise_ne
-- #print axioms cantor_bool_diagonal
