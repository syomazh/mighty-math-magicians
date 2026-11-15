/-
Written by Kimi K3.1 Pro (an Open Math OS worker, brief W057b), 2026-11-15; the worker was stopped
after its time limit with everything up to `choose_add_prime_modEq` proved, and the orchestrator
(Claude Fable 5.2) removed two duplicated lines and repaired the proof of the last lemma (the
induction on `a` and the cast). Not human-reviewed.

Translation by a group of order p acts on the r-subsets of `ZMod p ⊕ Fin n`.
For r < p its fixed subsets are the r-subsets of `Fin n`; this proves the required
congruences for binomial coefficients by counting fixed points of the group action.
-/

import Mathlib.GroupTheory.PGroup
import Mathlib.GroupTheory.GroupAction.SubMulAction.Combination
import Mathlib.Algebra.Group.Action.Sum

open scoped Pointwise

namespace MMM

section

variable (p n : ℕ) [Fact p.Prime]

instance additiveFinAction : AddAction (ZMod p) (Fin n) where
  vadd _ x := x
  zero_vadd _ := rfl
  add_vadd _ _ _ := rfl

instance multiplicativeFinAction : MulAction (Multiplicative (ZMod p)) (Fin n) :=
  Multiplicative.mulAction

instance translationZModAction : MulAction (Multiplicative (ZMod p)) (ZMod p) :=
  Multiplicative.mulAction

instance translationAction : MulAction (Multiplicative (ZMod p)) (ZMod p ⊕ Fin n) :=
  inferInstance

omit [Fact p.Prime] in
@[simp] theorem translationAction_inl (g : Multiplicative (ZMod p)) (x : ZMod p) :
    g • (Sum.inl x : ZMod p ⊕ Fin n) = Sum.inl (g.toAdd + x) := rfl

omit [Fact p.Prime] in
@[simp] theorem translationAction_inr (g : Multiplicative (ZMod p)) (x : Fin n) :
    g • (Sum.inr x : ZMod p ⊕ Fin n) = Sum.inr x := rfl

omit [Fact p.Prime] in
/-- A fixed subset contains its whole orbit under translation into its left summand. -/
theorem mem_inl_all_of_mem_fixedPoints {r : ℕ}
    (s : MulAction.fixedPoints (Multiplicative (ZMod p))
      (Set.powersetCard (ZMod p ⊕ Fin n) r))
    (x : ZMod p) (hx : Sum.inl x ∈ s.1.1) (u : ZMod p) : Sum.inl u ∈ s.1.1 := by
  have hfix : Multiplicative.ofAdd (u - x) • s.1 = s.1 := s.2 _
  rw [← hfix]
  change Sum.inl u ∈ (Multiplicative.ofAdd (u - x) • s.1.1 : Finset (ZMod p ⊕ Fin n))
  have hmem : Sum.inl u ∈ (Multiplicative.ofAdd (u - x)) • s.1.1 ↔
      Sum.inl x ∈ s.1.1 := by
    have hg : (Sum.inl u : ZMod p ⊕ Fin n) =
        Multiplicative.ofAdd (u - x) • Sum.inl x := by
      change (Sum.inl u : ZMod p ⊕ Fin n) = Sum.inl ((u - x) + x)
      exact congrArg Sum.inl (sub_add_cancel u x).symm
    rw [hg]
    exact Finset.smul_mem_smul_finset_iff _
  exact hmem.mpr hx

/-- A fixed `r`-subset has no points of the left summand. -/
theorem not_mem_inl_of_mem_fixedPoints {r : ℕ} (hr : r < p)
    (s : MulAction.fixedPoints (Multiplicative (ZMod p))
      (Set.powersetCard (ZMod p ⊕ Fin n) r))
    (x : ZMod p) : Sum.inl x ∉ s.1.1 := by
  intro hx
  have hsubset : (Finset.univ : Finset (ZMod p)).map
      (Function.Embedding.inl : ZMod p ↪ ZMod p ⊕ Fin n) ⊆ s.1.1 := by
    intro y hy
    simp only [Finset.mem_map, Finset.mem_univ, true_and] at hy
    obtain ⟨y, rfl⟩ := hy
    exact mem_inl_all_of_mem_fixedPoints p n s x hx y
  have hle := Finset.card_le_card hsubset
  rw [Finset.card_map, Finset.card_univ, ZMod.card,
    Set.powersetCard.card_eq s.1] at hle
  exact (Nat.not_le_of_lt hr) hle

/-- Fixed points of the translation action on `r`-element finsets are exactly the
`r`-subsets of the right summand, because a left-hand orbit already has size p. -/
noncomputable def fixedPointsEquivRight {r : ℕ} (hr : r < p) :
    MulAction.fixedPoints (Multiplicative (ZMod p))
      (Set.powersetCard (ZMod p ⊕ Fin n) r) ≃
    Set.powersetCard (Fin n) r where
  toFun s := ⟨s.1.1.toRight, Set.powersetCard.mem_iff.mpr (by
    by_cases hs : s.1.1.toLeft = ∅
    · have hi : s.1.1.toLeft.card + s.1.1.toRight.card = s.1.1.card :=
        Finset.card_toLeft_add_card_toRight
      simp [hs, Set.powersetCard.card_eq s.1] at hi
      exact hi
    · exfalso
      obtain ⟨x, hx⟩ := Finset.nonempty_iff_ne_empty.mpr hs
      exact not_mem_inl_of_mem_fixedPoints p n hr s x (by simpa using hx))⟩
  invFun t := ⟨⟨t.1.map (Function.Embedding.inr : Fin n ↪ ZMod p ⊕ Fin n), by
    simp [Set.powersetCard.mem_iff]⟩, by
    rw [MulAction.mem_fixedPoints]
    intro g
    apply Subtype.ext
    change g • (t.1.map (Function.Embedding.inr : Fin n ↪ ZMod p ⊕ Fin n) :
      Finset (ZMod p ⊕ Fin n)) =
        t.1.map (Function.Embedding.inr : Fin n ↪ ZMod p ⊕ Fin n)
    rw [Finset.ext_iff]
    rintro (x | x)
    · rw [← Finset.inv_smul_mem_iff, translationAction_inl]
      simp
    · rw [← Finset.inv_smul_mem_iff, translationAction_inr]⟩

  left_inv s := by
    apply Subtype.ext
    apply Subtype.ext
    have hs : s.1.1.toLeft = ∅ := Finset.not_nonempty_iff_eq_empty.mp (by
      intro h
      obtain ⟨x, hx⟩ := h
      exact not_mem_inl_of_mem_fixedPoints p n hr s x (by simpa using hx))
    calc
      (s.1.1.toRight.map Function.Embedding.inr : Finset (ZMod p ⊕ Fin n)) =
          s.1.1.toLeft.disjSum s.1.1.toRight := by simp [hs]
      _ = s.1.1 := Finset.toLeft_disjSum_toRight
  right_inv t := by
    apply Subtype.ext
    ext x
    simp

end

/-- One step: a group of order p acts on the r-subsets of `ZMod p ⊕ Fin n`; the fixed ones are the
r-subsets of `Fin n`. -/
theorem choose_add_prime_modEq (p : ℕ) [Fact p.Prime] (n r : ℕ) (hr : r < p) :
    Nat.choose (p + n) r ≡ Nat.choose n r [MOD p] := by
  have hG : IsPGroup p (Multiplicative (ZMod p)) := IsPGroup.of_card (n := 1) (by
    calc
      Nat.card (Multiplicative (ZMod p)) = Nat.card (ZMod p) :=
        Nat.card_congr Multiplicative.toAdd
      _ = p ^ 1 := by simp)
  have hmod := hG.card_modEq_card_fixedPoints (Set.powersetCard (ZMod p ⊕ Fin n) r)
  rw [Nat.card_congr (fixedPointsEquivRight p n hr), Set.powersetCard.card,
    Set.powersetCard.card, Nat.card_sum] at hmod
  simpa using hmod

theorem choose_mul_add_modEq_one_action (p : ℕ) [Fact p.Prime] (a r : ℕ) (hr : r < p) :
    ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1 := by
  have hmod : Nat.choose (p * a + r) r ≡ 1 [MOD p] := by
    induction a with
    | zero =>
      have h0 : Nat.choose (p * 0 + r) r = 1 := by
        rw [Nat.mul_zero, Nat.zero_add, Nat.choose_self]
      show Nat.choose (p * 0 + r) r % p = 1 % p
      rw [h0]
    | succ a ih =>
      have h : p * (a + 1) + r = p + (p * a + r) := by
        rw [Nat.mul_succ]
        omega
      rw [h]
      exact (choose_add_prime_modEq p (p * a + r) r hr).trans ih
  have h1 := (ZMod.natCast_eq_natCast_iff _ _ p).mpr hmod
  simpa using h1

#print axioms MMM.choose_mul_add_modEq_one_action

end MMM
