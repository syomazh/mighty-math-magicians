/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Step 3 of the main proof, first half: when is the lower bound attained?**

A tree is *tight* when `(p - 1) * d(T) + 1 = s_p(leaves T)` (equality in Step 2). This file
goes through the proof of Step 2 and records what equality forces at each node:

* a tight *symmetric* node has no asymmetric node below it, so it is a complete tree;
* a tight *asymmetric* node has tight children, and their numbers of leaves add up without
  any carry.

Complete trees are the "atoms" of the paper.
-/
import MMM.Reduction
import MMM.DigitsCarry

namespace MMM

namespace PTree

variable {p : ℕ}

/-- The complete `p`-ary tree of height `j`; it has `p ^ j` leaves. -/
def complete : ℕ → PTree p
  | 0 => leaf
  | j + 1 => node fun _ => complete j

@[simp] theorem complete_zero : (complete 0 : PTree p) = leaf := rfl

theorem complete_succ (j : ℕ) : (complete (j + 1) : PTree p) = node fun _ => complete j := rfl

theorem leaves_complete (j : ℕ) : (complete j : PTree p).leaves = p ^ j := by
  induction j with
  | zero => simp
  | succ j ih =>
    rw [complete_succ, leaves_node]
    simp [ih, pow_succ']

/-- A complete tree has no asymmetric node. -/
theorem d_complete [NeZero p] (j : ℕ) : (complete j : PTree p).d = 0 := by
  induction j with
  | zero => rfl
  | succ j ih =>
    rw [complete_succ, d_node_symm _ (fun _ _ => Rot.refl _)]
    simp [ih]

/-- A tree without asymmetric nodes is complete. -/
theorem eq_complete_of_d_eq_zero (hp : 2 ≤ p) : ∀ T : PTree p, T.d = 0 → ∃ j, T = complete j := by
  have : NeZero p := ⟨by omega⟩
  intro T
  induction T with
  | leaf => intro _; exact ⟨0, rfl⟩
  | node f ih =>
    intro h
    by_cases hs : Symmetric f
    · rw [d_node_symm f hs] at h
      have hz : ∀ i, (f i).d = 0 := fun i => by
        have h1 := Finset.single_le_sum (f := fun i => (f i).d) (fun _ _ => Nat.zero_le _)
          (Finset.mem_univ i)
        beta_reduce at h1
        omega
      choose j hj using fun i => ih i (hz i)
      have hjj : ∀ i, j i = j 0 := fun i => by
        have h1 := (hs i 0).leaves_eq
        rw [hj i, hj 0, leaves_complete, leaves_complete] at h1
        exact Nat.pow_right_injective hp h1
      refine ⟨j 0 + 1, ?_⟩
      rw [complete_succ]
      congr 1
      funext i
      rw [hj i, hjj i]
    · rw [d_node_asymm f hs] at h
      omega

/-- `T` attains the lower bound of Step 2. -/
def Tight (T : PTree p) : Prop := (p - 1) * T.d + 1 = ds p T.leaves

/-- For a tree with `m` leaves, tight means: exactly `t` asymmetric nodes. -/
theorem tight_iff_d (hp : 2 ≤ p) {m t : ℕ} (ht : (p - 1) * t + 1 = ds p m) (T : PTree p)
    (hl : T.leaves = m) : T.Tight ↔ T.d = t := by
  unfold Tight
  rw [hl, ← ht]
  constructor
  · intro h
    exact Nat.eq_of_mul_eq_mul_left (by omega : 0 < p - 1) (by omega)
  · intro h
    rw [h]

/-- **Equality at a symmetric node:** nothing below it is asymmetric. -/
theorem tight_symm_d_zero (hp : 2 ≤ p) (f : Fin p → PTree p) (hs : Symmetric f)
    (ht : Tight (node f)) : (node f).d = 0 := by
  have : NeZero p := ⟨by omega⟩
  unfold Tight at ht
  rw [d_node_symm f hs, leaves_node] at ht
  rw [d_node_symm f hs]
  have hsum : ∑ i, (f i).leaves = p * (f 0).leaves := by
    rw [Finset.sum_congr rfl (fun i _ => (hs i 0).leaves_eq)]
    simp
  have hdsum : ∑ i, (f i).d = p * (f 0).d := by
    rw [Finset.sum_congr rfl (fun i _ => (hs i 0).d_eq)]
    simp
  rw [hsum, ds_base_mul hp, hdsum] at ht
  rw [hdsum]
  have h0 := lower_bound hp (f 0)
  have h1 : (p - 1) * (p * (f 0).d) ≤ (p - 1) * (f 0).d := by omega
  have h2 : p * (f 0).d ≤ (f 0).d := Nat.le_of_mul_le_mul_left h1 (by omega)
  have h3 : 2 * (f 0).d ≤ p * (f 0).d := Nat.mul_le_mul_right _ hp
  have h4 : (f 0).d = 0 := by omega
  simp [h4]

/-- **Equality at an asymmetric node:** the children are tight, and their numbers of leaves
are added without carry. -/
theorem tight_asymm (hp : 2 ≤ p) (f : Fin p → PTree p) (hs : ¬ Symmetric f)
    (ht : Tight (node f)) :
    (∀ i, Tight (f i)) ∧ ds p (∑ i, (f i).leaves) = ∑ i, ds p (f i).leaves := by
  unfold Tight at ht
  rw [d_node_asymm f hs, leaves_node] at ht
  have h1 : ds p (∑ i, (f i).leaves) ≤ ∑ i, ds p (f i).leaves := ds_sum_le hp _ _
  have h2 : ∑ i, ds p (f i).leaves ≤ ∑ i : Fin p, ((p - 1) * (f i).d + 1) :=
    Finset.sum_le_sum (fun i _ => lower_bound hp (f i))
  have h3 : ∑ i : Fin p, ((p - 1) * (f i).d + 1) = (p - 1) * (∑ i, (f i).d) + p := by
    rw [Finset.sum_add_distrib, ← Finset.mul_sum]
    simp
  have h4 : (p - 1) * ((∑ i, (f i).d) + 1) + 1 = (p - 1) * (∑ i, (f i).d) + p := by
    rw [Nat.mul_add, Nat.mul_one]
    omega
  have e1 : ds p (∑ i, (f i).leaves) = ∑ i, ds p (f i).leaves := by omega
  have e2 : ∑ i, ds p (f i).leaves = ∑ i : Fin p, ((p - 1) * (f i).d + 1) := by omega
  refine ⟨fun i => ?_, e1⟩
  exact ((Finset.sum_eq_sum_iff_of_le (fun i _ => lower_bound hp (f i))).mp e2 i
    (Finset.mem_univ i)).symm

end PTree

end MMM
