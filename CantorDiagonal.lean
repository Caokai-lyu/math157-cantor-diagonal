-- This file formalizes the core of Cantor's diagonal argument for infinite binary sequences.
-- We represent an infinite binary sequence as a function from natural numbers
-- to Boolean values, and we represent a proposed list of all such sequences as
-- a function that assigns one binary sequence to each natural number.  The key
-- construction is the diagonal sequence, which flips the nth value of the nth
-- listed sequence.  This guarantees that the diagonal sequence differs from
-- every sequence in the proposed list at least at one position, so no such list
-- can contain all infinite binary sequences.

-- CantorDiagonal.lean -- Math 157 Week 9
-- Cantor's diagonal argument: no f : Nat -> (Nat -> Bool) lists every sequence.
-- No sorry. Lean 4 core only (no Mathlib).


-- Section 1. Diagonal sequence: diag f n := !(f n n)
def diag (f : Nat -> (Nat -> Bool)) : Nat -> Bool :=
  fun n => Bool.not ((f n) n)


-- Section 2. A Bool never equals its negation
theorem bool_ne_not (b : Bool) : b ≠ !b := by
  cases b
  · decide  -- false ≠ true
  · decide  -- true ≠ false


-- Section 3. diag f differs from every f n at position n
theorem diag_pointwise_ne (f : Nat -> (Nat -> Bool)) (n : Nat) :
    diag f n ≠ (f n) n := by
  unfold diag
  exact Ne.symm (bool_ne_not ((f n) n))


-- Section 4. Pointwise difference implies function inequality
theorem fun_ne_of_pointwise_ne {g h : Nat -> Bool} (n : Nat)
    (hne : g n ≠ h n) : g ≠ h := by
  intro heq
  exact hne (congrFun heq n)


-- Section 5a. Helper: diag f differs from f n at index n
theorem cantor_diag_ne (f : Nat -> (Nat -> Bool)) (n : Nat) :
    diag f ≠ f n :=
  fun_ne_of_pointwise_ne n (diag_pointwise_ne f n)


-- Section 5b. The diagonal sequence is missing from the entire proposed list
theorem diag_not_in_range (f : Nat -> (Nat -> Bool)) :
    ∀ n : Nat, diag f ≠ f n := by
  intro n
  exact cantor_diag_ne f n


-- Section 5c. Main theorem: no f : Nat -> (Nat -> Bool) lists every binary sequence
theorem cantor_bool_diagonal :
    ∀ f : Nat -> (Nat -> Bool), ∃ g : Nat -> Bool, ∀ n : Nat, g ≠ f n := by
  intro f
  exact ⟨diag f, diag_not_in_range f⟩


-- Section 5d. Surjectivity form: no attempted list is onto
theorem cantor_bool_not_surjective (f : Nat -> (Nat -> Bool)) :
    ¬ Function.Surjective f := by
  intro hsurj
  obtain ⟨n, hn⟩ := hsurj (diag f)
  exact cantor_diag_ne f n (Eq.symm hn)


-- Section 6. Sanity check: f 0 = all-false, f 1 = all-true, f k = all-false
def exampleList : Nat -> (Nat -> Bool)
  | 0 => fun _ => false
  | 1 => fun _ => true
  | _ => fun _ => false

#eval diag exampleList 0   -- true
#eval diag exampleList 1   -- false
#eval diag exampleList 2   -- true

#eval (diag exampleList 0 != exampleList 0 0)  -- true
#eval (diag exampleList 1 != exampleList 1 1)  -- true
#eval (diag exampleList 2 != exampleList 2 2)  -- true


-- Section 6b. The same example checks as formal theorem statements
theorem example_diag_zero : diag exampleList 0 = true := by
  decide

theorem example_diag_one : diag exampleList 1 = false := by
  decide

theorem example_diag_two : diag exampleList 2 = true := by
  decide

theorem example_diag_differs_zero :
    diag exampleList 0 ≠ exampleList 0 0 := by
  decide

theorem example_diag_differs_one :
    diag exampleList 1 ≠ exampleList 1 1 := by
  decide

theorem example_diag_differs_two :
    diag exampleList 2 ≠ exampleList 2 2 := by
  decide

theorem example_diag_differs_first_three :
    diag exampleList ≠ exampleList 0 ∧
    diag exampleList ≠ exampleList 1 ∧
    diag exampleList ≠ exampleList 2 := by
  exact ⟨cantor_diag_ne exampleList 0,
      ⟨cantor_diag_ne exampleList 1, cantor_diag_ne exampleList 2⟩⟩


-- Section 7. Axiom audit (uncomment to inspect)
-- #print axioms bool_ne_not
-- #print axioms diag_pointwise_ne
-- #print axioms fun_ne_of_pointwise_ne
-- #print axioms diag_not_in_range
-- #print axioms cantor_bool_diagonal
-- #print axioms cantor_bool_not_surjective
