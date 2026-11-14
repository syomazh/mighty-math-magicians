/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Prime powers `q = p ^ k`: the reduction and Step 3 with the depth condition.**

A `q`-ary tree is read as a `p`-ary tree with all leaves at depths divisible by `k` ("blocked").
Rotations do not change depths, so everything before Step 4 goes through for the blocked trees:

* modulo `p ^ (t + 1)` only the minimal blocked trees count (`card_blocked_modEq_minimal`);
* the minimal blocked trees are, one to one, the carry-free trees of atoms in which an atom with
  `p ^ j` leaves hangs at a depth `δ` with `k ∣ δ + j` (`card_minimal_blocked`): the depth
  condition of the paper.
-/
import MMM.Atoms
import MMM.Blocked
import MMM.LBlocked

namespace MMM

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- **Reduction for any closed family.** In a finite family closed under rotation in which every
tree has at least `t` asymmetric nodes, only the trees with exactly `t` count modulo
`p ^ (t + 1)`. -/
theorem card_modEq_minimal_of_closed (P : PTree p → Prop) (hP : ∀ S T, Rot S T → P T → P S)
    [Finite {T : PTree p // P T}] (t : ℕ) (ht : ∀ T, P T → t ≤ T.d) :
    Nat.card {T : PTree p // P T} ≡ Nat.card {T : PTree p // P T ∧ T.d = t} [MOD p ^ (t + 1)] := by
  have hfin1 : Finite {T : PTree p // P T ∧ T.d = t} :=
    Finite.of_equiv _ (Equiv.subtypeSubtypeEquivSubtypeInter P (fun T => T.d = t))
  have hfin2 : Finite {T : PTree p // P T ∧ T.d ≠ t} :=
    Finite.of_equiv _ (Equiv.subtypeSubtypeEquivSubtypeInter P (fun T => T.d ≠ t))
  have hbig : p ^ (t + 1) ∣ Nat.card {T : PTree p // P T ∧ T.d ≠ t} := by
    refine pow_dvd_card_of_closed (fun T => P T ∧ T.d ≠ t) ?_ (t + 1) ?_
    · rintro S T h ⟨hl, hd⟩
      exact ⟨hP S T h hl, by rw [h.d_eq]; exact hd⟩
    · rintro T ⟨hl, hd⟩
      have := ht T hl
      omega
  have hsplit : Nat.card {T : PTree p // P T} =
      Nat.card {T : PTree p // P T ∧ T.d = t} + Nat.card {T : PTree p // P T ∧ T.d ≠ t} := by
    rw [← Nat.card_sum]
    refine Nat.card_congr ?_
    exact (Equiv.sumCompl (fun x : {T : PTree p // P T} => x.1.d = t)).symm.trans
      (Equiv.sumCongr
        (Equiv.subtypeSubtypeEquivSubtypeInter P (fun T => T.d = t))
        (Equiv.subtypeSubtypeEquivSubtypeInter P (fun T => ¬ T.d = t)))
  rw [hsplit]
  have h0 := Nat.modEq_zero_iff_dvd.mpr hbig
  simpa using (Nat.ModEq.refl (Nat.card {T : PTree p // P T ∧ T.d = t})).add h0

/-- **Blocked trees: only the minimal ones count modulo `p ^ (t + 1)`.** -/
theorem card_blocked_modEq_minimal (k m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} ≡
      Nat.card {T : PTree p // (T.leaves = m ∧ BlockedAt k 0 T) ∧ T.d = t} [MOD p ^ (t + 1)] := by
  have hfin : Finite {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} :=
    finite_of_leaves m (BlockedAt k 0)
  refine card_modEq_minimal_of_closed (fun T => T.leaves = m ∧ BlockedAt k 0 T) ?_ t ?_
  · rintro S T h ⟨hl, hb⟩
    exact ⟨h.leaves_eq.trans hl, (h.blockedAt 0).mpr hb⟩
  · rintro T ⟨hl, -⟩
    exact t_le_d hp.out.two_le T t (by rw [hl]; exact ht)

end PTree

namespace LTree

variable {p : ℕ}

/-- A complete tree of height `j` hanging at depth `δ` has its leaves at depth `δ + j`. -/
theorem blockedAt_complete [NeZero p] (k : ℕ) : ∀ (j δ : ℕ),
    PTree.BlockedAt k δ (PTree.complete j : PTree p) ↔ k ∣ δ + j := by
  intro j
  induction j with
  | zero => intro δ; simp [PTree.BlockedAt]
  | succ j ih =>
    intro δ
    rw [PTree.complete_succ]
    simp only [PTree.BlockedAt]
    rw [forall_const, ih (δ + 1)]
    have : δ + 1 + j = δ + (j + 1) := by omega
    rw [this]

/-- The realized tree is blocked exactly when the tree of atoms satisfies the depth condition. -/
theorem blockedAt_realize [NeZero p] (k : ℕ) (U : LTree p ℕ) : ∀ δ,
    PTree.BlockedAt k δ U.realize ↔ BlockedL k id δ U := by
  induction U with
  | leaf j =>
    intro δ
    rw [realize_leaf, blockedAt_complete]
    rfl
  | node f ih =>
    intro δ
    rw [realize_node]
    simp only [PTree.BlockedAt, blockedL_node]
    exact forall_congr' (fun i => ih i (δ + 1))

theorem minimalEquiv_apply_val (hp : 2 ≤ p) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (U : {U : LTree p ℕ // U.CarryFree ∧ U.wt = m}) :
    (minimalEquiv hp m t ht U).1 = U.1.realize := rfl

/-- **Step 3 with the depth condition.** The minimal blocked trees with `m` leaves are as many as
the carry-free trees of atoms of weight `m` that satisfy the depth condition. -/
theorem card_minimal_blocked (hp : 2 ≤ p) (k m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card {T : PTree p // (T.leaves = m ∧ PTree.BlockedAt k 0 T) ∧ T.d = t} =
      Nat.card {U : LTree p ℕ // (U.CarryFree ∧ U.wt = m) ∧ BlockedL k id 0 U} := by
  have : NeZero p := ⟨by omega⟩
  -- restrict the bijection of Step 3 to the trees with the depth condition
  have e := (minimalEquiv hp m t ht).subtypeEquiv
    (p := fun U => BlockedL k id 0 U.1) (q := fun T => PTree.BlockedAt k 0 T.1)
    (fun U => by rw [minimalEquiv_apply_val, blockedAt_realize])
  have eA : {T : PTree p // (T.leaves = m ∧ PTree.BlockedAt k 0 T) ∧ T.d = t} ≃
      {y : {T : PTree p // PTree.IsMinimal m t T} // PTree.BlockedAt k 0 y.1} :=
    { toFun := fun x => ⟨⟨x.1, x.2.1.1, x.2.2⟩, x.2.1.2⟩
      invFun := fun y => ⟨y.1.1, ⟨y.1.2.1, y.2⟩, y.1.2.2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [Nat.card_congr eA, ← Nat.card_congr e]
  exact Nat.card_congr
    (Equiv.subtypeSubtypeEquivSubtypeInter (fun U : LTree p ℕ => U.CarryFree ∧ U.wt = m)
      (fun U => BlockedL k id 0 U))

end LTree

end MMM
