/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **A corollary stated entirely in Mathlib's own vocabulary (p = 2).**
      2 ^ (s_2(n + 1) - 1)  divides  the Catalan number C_n,
  where `catalan` is Mathlib's Catalan number and `Nat.digits` is Mathlib's digit list.

The proof is our tree-symmetry argument (`pow_dvd_card_trees`); the only extra ingredient is
Mathlib's theorem that the number of binary trees with `n` internal nodes is `catalan n`.
No factorial valuation (Legendre, Kummer) is used.

For `p ≥ 3` Mathlib has no Fuss-Catalan numbers, so there the checked statement stays
"`p ^ t` divides the number of `p`-ary trees with `m` leaves" (`MMM/Divisibility.lean`).
-/
import MMM.Divisibility
import Mathlib.Combinatorics.Enumerative.Catalan.Tree

namespace MMM

namespace PTree

/-- Our binary trees, as Mathlib's binary trees. -/
def toBin : PTree 2 → BinaryTree Unit
  | leaf => BinaryTree.nil
  | node f => BinaryTree.node () (toBin (f 0)) (toBin (f 1))

/-- Mathlib's binary trees, as ours. -/
def ofBin : BinaryTree Unit → PTree 2
  | BinaryTree.nil => leaf
  | BinaryTree.node _ l r => node (fun i => if i = 0 then ofBin l else ofBin r)

theorem ofBin_toBin (T : PTree 2) : ofBin (toBin T) = T := by
  induction T with
  | leaf => rfl
  | node f ih =>
    simp only [toBin, ofBin]
    congr 1
    funext i
    by_cases h : i = 0
    · subst h; simp [ih]
    · have h1 : i = 1 := Fin.eq_one_of_ne_zero i h
      subst h1; simp [ih]

theorem toBin_ofBin (B : BinaryTree Unit) : toBin (ofBin B) = B := by
  induction B with
  | nil => rfl
  | node a l r ihl ihr => simp [toBin, ofBin, ihl, ihr]

/-- The two kinds of binary trees correspond one to one. -/
def binEquiv : PTree 2 ≃ BinaryTree Unit where
  toFun := toBin
  invFun := ofBin
  left_inv := ofBin_toBin
  right_inv := toBin_ofBin

theorem numLeaves_toBin (T : PTree 2) : (toBin T).numLeaves = T.leaves := by
  induction T with
  | leaf => rfl
  | node f ih => simp [toBin, Fin.sum_univ_two, ih]

/-- The number of our binary trees with `n + 1` leaves is the Catalan number `C_n`. -/
theorem card_binary_trees (n : ℕ) : Nat.card {T : PTree 2 // T.leaves = n + 1} = catalan n := by
  have e1 : {T : PTree 2 // T.leaves = n + 1} ≃ {B : BinaryTree Unit // B.numNodes = n} :=
    binEquiv.subtypeEquiv (fun T => by
      show T.leaves = n + 1 ↔ (toBin T).numNodes = n
      rw [← numLeaves_toBin, BinaryTree.numLeaves_eq_numNodes_succ]
      omega)
  have e2 : {B : BinaryTree Unit // B.numNodes = n} ≃
      {B : BinaryTree Unit // B ∈ BinaryTree.treesOfNumNodesEq n} :=
    Equiv.subtypeEquivRight (fun B => BinaryTree.mem_treesOfNumNodesEq.symm)
  rw [Nat.card_congr (e1.trans e2), Nat.card_eq_fintype_card, Fintype.card_coe,
    BinaryTree.treesOfNumNodesEq_card_eq_catalan]

end PTree

/-- **Catalan numbers, from tree symmetry.** If `t + 1` is the number of ones in the binary
expansion of `n + 1`, then `2 ^ t` divides the Catalan number `C_n`. -/
theorem two_pow_dvd_catalan (n t : ℕ) (ht : t + 1 = (Nat.digits 2 (n + 1)).sum) :
    2 ^ t ∣ catalan n := by
  have h : (2 - 1) * t + 1 = ds 2 (n + 1) := by
    unfold ds
    rw [← ht]
    simp
  have := PTree.pow_dvd_card_trees (p := 2) (n + 1) t h
  rwa [PTree.card_binary_trees] at this

/-- The same statement without the auxiliary `t`. -/
theorem two_pow_digitSum_sub_one_dvd_catalan (n : ℕ) :
    2 ^ ((Nat.digits 2 (n + 1)).sum - 1) ∣ catalan n := by
  have hpos : 0 < ds 2 (n + 1) := ds_pos (by omega) (n + 1) (Nat.succ_pos n)
  unfold ds at hpos
  exact two_pow_dvd_catalan n _ (by omega)

end MMM
