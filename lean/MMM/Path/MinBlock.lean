/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W041), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **When a block attains the lower bound (the equality cases of the note's Lemma `lem:bound`).**

A block `u` of length `p^h` is *minimal* (`MinBlk`) when equality holds in `lower_bound`:
`(p - 1) * d h u + 1 = s_p(cntE u) + s_p(p^h - cntE u)`.

* A block has `d = 0` exactly when all its letters are equal (`d_eq_zero_of_mono`,
  `mono_of_d_eq_zero`); such a block is minimal (`minBlk_of_mono`).
* A block with both letters is minimal exactly when its `p` sub-blocks are minimal and their
  numbers of letters E, and of letters S, add up without carries (`minBlk_succ_iff`). In
  particular it is then asymmetric (`not_sym_of_minBlk`).

The proofs follow `lower_bound` in `Bound.lean` and keep track of equality. No factorial and no
valuation is used; `p` needs not be prime.
-/
import MMM.Path.Bound
import MMM.DigitsCarry

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- Equality in `lower_bound`. -/
def MinBlk [NeZero p] (h : ℕ) (u : Blk p h) : Prop :=
  (p - 1) * d h u + 1 = ds p (cntE h u) + ds p (p ^ h - cntE h u)

section mono

/-- If a block has no letter E, neither have its sub-blocks. -/
theorem cntE_sub_eq_zero {h : ℕ} {u : Blk p (h + 1)} (hu : cntE (h + 1) u = 0) (j : Fin p) :
    cntE h (u j) = 0 := by
  have h1 : ∑ j, cntE h (u j) = 0 := hu
  exact (Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => Nat.zero_le _)).mp h1 j (Finset.mem_univ j)

/-- If all letters of a block are E, the same holds for its sub-blocks. -/
theorem cntE_sub_eq_pow [NeZero p] {h : ℕ} {u : Blk p (h + 1)}
    (hu : cntE (h + 1) u = p ^ (h + 1)) (j : Fin p) : cntE h (u j) = p ^ h := by
  have h1 : ∑ j, cntE h (u j) = ∑ _j : Fin p, p ^ h := by
    have h2 : ∑ j, cntE h (u j) = p ^ (h + 1) := hu
    rw [h2]
    simp [pow_succ']
  exact (Finset.sum_eq_sum_iff_of_le (fun i _ => cntE_le h (u i))).mp h1 j (Finset.mem_univ j)

/-- There is only one block without a letter E. -/
theorem eq_of_cntE_eq_zero : ∀ (h : ℕ) (u v : Blk p h), cntE h u = 0 → cntE h v = 0 → u = v := by
  intro h
  induction h with
  | zero =>
    intro u v
    show (if u then 1 else 0) = 0 → (if v then 1 else 0) = 0 → u = v
    cases u <;> cases v <;> simp
  | succ h ih =>
    intro u v hu hv
    funext j
    exact ih (u j) (v j) (cntE_sub_eq_zero hu j) (cntE_sub_eq_zero hv j)

/-- There is only one block all of whose letters are E. -/
theorem eq_of_cntE_eq_pow [NeZero p] :
    ∀ (h : ℕ) (u v : Blk p h), cntE h u = p ^ h → cntE h v = p ^ h → u = v := by
  intro h
  induction h with
  | zero =>
    intro u v
    show (if u then 1 else 0) = p ^ 0 → (if v then 1 else 0) = p ^ 0 → u = v
    cases u <;> cases v <;> simp
  | succ h ih =>
    intro u v hu hv
    funext j
    exact ih (u j) (v j) (cntE_sub_eq_pow hu j) (cntE_sub_eq_pow hv j)

/-- A block all of whose letters are equal has d = 0. -/
theorem d_eq_zero_of_mono [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p h)
    (hu : cntE h u = 0 ∨ cntE h u = p ^ h) : d h u = 0 := by
  revert u
  induction h with
  | zero => intro u _; rfl
  | succ h ih =>
    intro u hu
    have hsub : ∀ j, cntE h (u j) = 0 ∨ cntE h (u j) = p ^ h := by
      intro j
      rcases hu with hu | hu
      · exact Or.inl (cntE_sub_eq_zero hu j)
      · exact Or.inr (cntE_sub_eq_pow hu j)
    have hsym : Sym h u := by
      intro i j
      rcases hu with hu | hu
      · rw [eq_of_cntE_eq_zero h (u i) (u j) (cntE_sub_eq_zero hu i) (cntE_sub_eq_zero hu j)]
        exact Eqv.refl h _
      · rw [eq_of_cntE_eq_pow h (u i) (u j) (cntE_sub_eq_pow hu i) (cntE_sub_eq_pow hu j)]
        exact Eqv.refl h _
    rw [d_succ_symm u hsym]
    exact Finset.sum_eq_zero (fun j _ => ih (u j) (hsub j))

/-- Conversely: a block with d = 0 has all its letters equal. -/
theorem mono_of_d_eq_zero [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p h) (hd : d h u = 0) :
    cntE h u = 0 ∨ cntE h u = p ^ h := by
  revert u
  induction h with
  | zero =>
    intro b _
    show (if b then 1 else 0) = 0 ∨ (if b then 1 else 0) = p ^ 0
    cases b <;> simp
  | succ h ih =>
    intro u hd
    by_cases hs : Sym h u
    · rw [d_succ_symm u hs] at hd
      have hd0 : d h (u 0) = 0 :=
        (Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => Nat.zero_le _)).mp hd 0 (Finset.mem_univ 0)
      have hb : ∀ i, cntE h (u i) = cntE h (u 0) := fun i => cntE_eq_of_eqv (hs i 0)
      have hsumE : cntE (h + 1) u = p * cntE h (u 0) := by
        show (∑ i, cntE h (u i)) = p * cntE h (u 0)
        rw [Finset.sum_congr rfl (fun i _ => hb i)]
        simp
      rw [hsumE]
      rcases ih (u 0) hd0 with h0 | h0
      · left; rw [h0, Nat.mul_zero]
      · right; rw [h0, pow_succ']
    · rw [d_succ_asymm u hs] at hd
      omega

/-- A block all of whose letters are equal attains the bound. -/
theorem minBlk_of_mono [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p h)
    (hu : cntE h u = 0 ∨ cntE h u = p ^ h) : MinBlk h u := by
  unfold MinBlk
  rw [d_eq_zero_of_mono hp h u hu]
  rcases hu with hu | hu
  · rw [hu]; simp [ds_pow hp]
  · rw [hu]; simp [ds_pow hp]

end mono

section mixed

/-- The letters S of a block are the letters S of its sub-blocks. -/
theorem pow_sub_cntE_succ [NeZero p] (h : ℕ) (u : Blk p (h + 1)) :
    p ^ (h + 1) - cntE (h + 1) u = ∑ j, (p ^ h - cntE h (u j)) := by
  rw [Finset.sum_tsub_distrib _ (fun i _ => cntE_le h (u i))]
  simp [pow_succ']

/-- A symmetric block with both letters does not attain the bound. -/
theorem not_minBlk_of_sym [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p (h + 1))
    (hmix : 0 < cntE (h + 1) u ∧ cntE (h + 1) u < p ^ (h + 1)) (hs : Sym h u) :
    ¬ MinBlk (h + 1) u := by
  intro hmin
  have hb : ∀ i, cntE h (u i) = cntE h (u 0) := fun i => cntE_eq_of_eqv (hs i 0)
  have hdb : ∀ i, d h (u i) = d h (u 0) := fun i => d_eq_of_eqv (hs i 0)
  have hsumE : cntE (h + 1) u = p * cntE h (u 0) := by
    show (∑ i, cntE h (u i)) = p * cntE h (u 0)
    rw [Finset.sum_congr rfl (fun i _ => hb i)]
    simp
  have hsumS : p ^ (h + 1) - cntE (h + 1) u = p * (p ^ h - cntE h (u 0)) := by
    rw [hsumE, pow_succ', Nat.mul_sub]
  have hD : ∑ i, d h (u i) = p * d h (u 0) := by
    rw [Finset.sum_congr rfl (fun i _ => hdb i)]
    simp
  have ha_pos : 0 < cntE h (u 0) := by
    rcases Nat.eq_zero_or_pos (cntE h (u 0)) with h0 | h0
    · have h1 := hmix.1
      rw [hsumE, h0] at h1
      simp at h1
    · exact h0
  have ha_lt : cntE h (u 0) < p ^ h := by
    have h1 := hmix.2
    rw [hsumE, pow_succ'] at h1
    exact Nat.lt_of_mul_lt_mul_left h1
  have hd_pos : 0 < d h (u 0) := by
    rcases Nat.eq_zero_or_pos (d h (u 0)) with hz | hz
    · rcases mono_of_d_eq_zero hp h (u 0) hz with h1 | h1 <;> omega
    · exact hz
  unfold MinBlk at hmin
  rw [d_succ_symm u hs, hD, hsumS, hsumE, ds_base_mul hp, ds_base_mul hp] at hmin
  have h0 := lower_bound hp h (u 0)
  have hx : 0 < (p - 1) * d h (u 0) := Nat.mul_pos (by omega) hd_pos
  have e1 : (p - 1) * (p * d h (u 0)) = p * ((p - 1) * d h (u 0)) := Nat.mul_left_comm _ _ _
  have e2 : 2 * ((p - 1) * d h (u 0)) ≤ p * ((p - 1) * d h (u 0)) := Nat.mul_le_mul_right _ hp
  omega

/-- A block with both letters that attains the bound is asymmetric. -/
theorem not_sym_of_minBlk [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p (h + 1))
    (hmix : 0 < cntE (h + 1) u ∧ cntE (h + 1) u < p ^ (h + 1)) (hmin : MinBlk (h + 1) u) :
    ¬ Sym h u :=
  fun hs => not_minBlk_of_sym hp h u hmix hs hmin

/-- In a symmetric block with at least one letter E, the numbers of letters E of the sub-blocks
do not add up without carries. -/
theorem sum_ds_ne_of_sym [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p (h + 1))
    (hpos : 0 < cntE (h + 1) u) (hs : Sym h u) :
    ∑ j, ds p (cntE h (u j)) ≠ ds p (cntE (h + 1) u) := by
  intro hA
  have hb : ∀ i, cntE h (u i) = cntE h (u 0) := fun i => cntE_eq_of_eqv (hs i 0)
  have hsumE : cntE (h + 1) u = p * cntE h (u 0) := by
    show (∑ i, cntE h (u i)) = p * cntE h (u 0)
    rw [Finset.sum_congr rfl (fun i _ => hb i)]
    simp
  have ha_pos : 0 < cntE h (u 0) := by
    rcases Nat.eq_zero_or_pos (cntE h (u 0)) with h0 | h0
    · rw [hsumE, h0] at hpos
      simp at hpos
    · exact h0
  have hsumA : ∑ j, ds p (cntE h (u j)) = p * ds p (cntE h (u 0)) := by
    rw [Finset.sum_congr rfl (fun i _ => by rw [hb i])]
    simp
  rw [hsumA, hsumE, ds_base_mul hp] at hA
  have h1 := ds_pos hp _ ha_pos
  have h2 : 2 * ds p (cntE h (u 0)) ≤ p * ds p (cntE h (u 0)) := Nat.mul_le_mul_right _ hp
  omega

/-- A mixed block attains the bound exactly when its p sub-blocks attain it and their numbers of
letters E, and of letters S, add up without carries. -/
theorem minBlk_succ_iff [NeZero p] (hp : 2 ≤ p) (h : ℕ) (u : Blk p (h + 1))
    (hmix : 0 < cntE (h + 1) u ∧ cntE (h + 1) u < p ^ (h + 1)) :
    MinBlk (h + 1) u ↔
      (∀ j, MinBlk h (u j)) ∧
      ∑ j, ds p (cntE h (u j)) = ds p (cntE (h + 1) u) ∧
      ∑ j, ds p (p ^ h - cntE h (u j)) = ds p (p ^ (h + 1) - cntE (h + 1) u) := by
  by_cases hs : Sym h u
  · -- symmetric and mixed: both sides are false
    constructor
    · intro hmin
      exact absurd hmin (not_minBlk_of_sym hp h u hmix hs)
    · rintro ⟨-, hA, -⟩
      exact absurd hA (sum_ds_ne_of_sym hp h u hmix.1 hs)
  · -- asymmetric: the chain of inequalities of `lower_bound` is an equality iff each link is
    have hE : ds p (cntE (h + 1) u) ≤ ∑ j, ds p (cntE h (u j)) := ds_sum_le hp _ _
    have hS : ds p (p ^ (h + 1) - cntE (h + 1) u) ≤ ∑ j, ds p (p ^ h - cntE h (u j)) := by
      rw [pow_sub_cntE_succ h u]
      exact ds_sum_le hp _ _
    have hsub : ∀ j ∈ (Finset.univ : Finset (Fin p)),
        ds p (cntE h (u j)) + ds p (p ^ h - cntE h (u j)) ≤ (p - 1) * d h (u j) + 1 :=
      fun j _ => lower_bound hp h (u j)
    have hsum_le : ∑ j, (ds p (cntE h (u j)) + ds p (p ^ h - cntE h (u j))) ≤
        ∑ j : Fin p, ((p - 1) * d h (u j) + 1) := Finset.sum_le_sum hsub
    have e3 : ∑ j : Fin p, ((p - 1) * d h (u j) + 1) = (p - 1) * (∑ j, d h (u j)) + p := by
      rw [Finset.sum_add_distrib, ← Finset.mul_sum]
      simp
    have e4 : ∑ j, (ds p (cntE h (u j)) + ds p (p ^ h - cntE h (u j))) =
        (∑ j, ds p (cntE h (u j))) + ∑ j, ds p (p ^ h - cntE h (u j)) := Finset.sum_add_distrib
    have e5 : (p - 1) * ((∑ j, d h (u j)) + 1) + 1 = (p - 1) * (∑ j, d h (u j)) + p := by
      rw [Nat.mul_add, Nat.mul_one]
      omega
    have hall : (∀ j, MinBlk h (u j)) ↔
        ∑ j, (ds p (cntE h (u j)) + ds p (p ^ h - cntE h (u j))) =
          ∑ j : Fin p, ((p - 1) * d h (u j) + 1) := by
      rw [Finset.sum_eq_sum_iff_of_le hsub]
      constructor
      · intro hm j _
        exact (hm j).symm
      · intro hm j
        exact (hm j (Finset.mem_univ j)).symm
    have hmin_iff : MinBlk (h + 1) u ↔
        (p - 1) * ((∑ j, d h (u j)) + 1) + 1 =
          ds p (cntE (h + 1) u) + ds p (p ^ (h + 1) - cntE (h + 1) u) := by
      unfold MinBlk
      rw [d_succ_asymm u hs]
    rw [hmin_iff, hall]
    constructor
    · intro hm
      refine ⟨?_, ?_, ?_⟩ <;> omega
    · rintro ⟨hm, hA, hB⟩
      omega

end mixed

end MMM.Path
