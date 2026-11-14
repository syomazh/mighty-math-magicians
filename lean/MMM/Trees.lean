/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

`p`-ary trees, rotation equivalence, the number `d` of asymmetric nodes, and

  **Step 2 of the main proof (the lower bound):**
      (digit sum of the number of leaves)  ≤  (p - 1) * d(T) + 1,
  that is, `d(T) ≥ t = (s_p(m) - 1)/(p - 1)`.

The proof is the one of the paper (Proposition "Lower bound"): induction on the tree, with the
subadditivity of digit sums at an asymmetric node and `s(p b) = s(b)` at a symmetric node.
It uses no factorial and no valuation, and it does not need `p` to be prime.
-/
import MMM.Digits
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Group.Fin.Basic
import Mathlib.Data.Fintype.BigOperators

namespace MMM

/-- A `p`-ary tree: a leaf, or a node with an ordered family of `p` subtrees. -/
inductive PTree (p : ℕ) : Type
  | leaf : PTree p
  | node : (Fin p → PTree p) → PTree p

namespace PTree

variable {p : ℕ}

/-- The number of leaves. -/
def leaves : PTree p → ℕ
  | leaf => 1
  | node f => ∑ i, (f i).leaves

/-- The number of internal nodes. -/
def nodes : PTree p → ℕ
  | leaf => 0
  | node f => 1 + ∑ i, (f i).nodes

/-- **Rotation equivalence** (in the normal form of the paper, Lemma "Normal form"):
two leaves are equivalent; two nodes are equivalent when, after a cyclic shift `r` of the
children of the first, the children are equivalent one by one. -/
inductive Rot : PTree p → PTree p → Prop
  | leaf : Rot leaf leaf
  | node (f g : Fin p → PTree p) (r : Fin p) (h : ∀ i, Rot (f (i + r)) (g i)) :
      Rot (node f) (node g)

/-- A node is *symmetric* when its `p` subtrees are pairwise rotation equivalent. -/
def Symmetric (f : Fin p → PTree p) : Prop := ∀ i j, Rot (f i) (f j)

open Classical in
/-- `d(T)`: the number of asymmetric nodes. -/
noncomputable def d : PTree p → ℕ
  | leaf => 0
  | node f => (∑ i, (f i).d) + if Symmetric f then 0 else 1

@[simp] theorem leaves_leaf : (leaf : PTree p).leaves = 1 := rfl
@[simp] theorem leaves_node (f : Fin p → PTree p) : (node f).leaves = ∑ i, (f i).leaves := rfl
@[simp] theorem d_leaf : (leaf : PTree p).d = 0 := rfl

theorem d_node_symm (f : Fin p → PTree p) (h : Symmetric f) : (node f).d = ∑ i, (f i).d := by
  simp [d, h]

theorem d_node_asymm (f : Fin p → PTree p) (h : ¬ Symmetric f) :
    (node f).d = (∑ i, (f i).d) + 1 := by
  simp [d, h]

/-- Rotation-equivalent trees have the same number of leaves. -/
theorem Rot.leaves_eq [NeZero p] {S T : PTree p} (h : Rot S T) : S.leaves = T.leaves := by
  induction h with
  | leaf => rfl
  | node f g r _ ih =>
    simp only [leaves_node]
    rw [← Finset.sum_congr rfl (fun i _ => ih i)]
    exact (Fintype.sum_equiv (Equiv.addRight r) (fun i => (f (i + r)).leaves)
      (fun i => (f i).leaves) (fun i => rfl)).symm

/-- **The lower bound (Step 2).** For every `p`-ary tree `T`, `p ≥ 2`:
`s_p(leaves T) ≤ (p - 1) * d(T) + 1`. -/
theorem lower_bound (hp : 2 ≤ p) (T : PTree p) : ds p T.leaves ≤ (p - 1) * T.d + 1 := by
  have : NeZero p := ⟨by omega⟩
  induction T with
  | leaf => simp [ds_one hp]
  | node f ih =>
    by_cases hs : Symmetric f
    · -- symmetric node: all children have the same number `b` of leaves, and `s(p b) = s(b)`
      rw [d_node_symm f hs, leaves_node]
      let i0 : Fin p := ⟨0, by omega⟩
      have hb : ∀ i, (f i).leaves = (f i0).leaves := fun i => (hs i i0).leaves_eq
      have hsum : ∑ i, (f i).leaves = p * (f i0).leaves := by
        rw [Finset.sum_congr rfl (fun i _ => hb i)]
        simp
      rw [hsum, ds_base_mul hp]
      have h0 := ih i0
      have hle : (f i0).d ≤ ∑ i, (f i).d :=
        Finset.single_le_sum (f := fun i => (f i).d) (fun _ _ => Nat.zero_le _) (Finset.mem_univ i0)
      calc ds p (f i0).leaves ≤ (p - 1) * (f i0).d + 1 := h0
        _ ≤ (p - 1) * (∑ i, (f i).d) + 1 := by
            exact Nat.add_le_add_right (Nat.mul_le_mul_left _ hle) 1
    · -- asymmetric node: digit sums are subadditive
      rw [d_node_asymm f hs, leaves_node]
      calc ds p (∑ i, (f i).leaves) ≤ ∑ i, ds p (f i).leaves := ds_sum_le hp _ _
        _ ≤ ∑ i : Fin p, ((p - 1) * (f i).d + 1) := Finset.sum_le_sum (fun i _ => ih i)
        _ = (p - 1) * (∑ i, (f i).d) + p := by
            rw [Finset.sum_add_distrib, ← Finset.mul_sum]
            simp
        _ = (p - 1) * ((∑ i, (f i).d) + 1) + 1 := by
            have : p = (p - 1) + 1 := by omega
            rw [Nat.mul_add, Nat.mul_one]
            omega

/-- The same statement with `t`: if `(p - 1) * t + 1 = s_p(leaves T)` then `t ≤ d(T)`. -/
theorem t_le_d (hp : 2 ≤ p) (T : PTree p) (t : ℕ) (ht : (p - 1) * t + 1 = ds p T.leaves) :
    t ≤ T.d := by
  have h := lower_bound hp T
  rw [← ht] at h
  have hpos : 0 < p - 1 := by omega
  exact Nat.le_of_mul_le_mul_left (by omega) hpos

end PTree

end MMM
