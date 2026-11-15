/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W041), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Reduction to the minimal words (the note's equation (modp)).**

If every word with `n` letters E has `dW w ≥ c`, then modulo `p ^ (c + 1)` the number of words
with `n` letters E is congruent to the number of those with `dW w = c`: the other words form a
union of rotation classes, and each of these classes has `p ^ dW w` elements with `dW w ≥ c + 1`.

Together with `card_cntEW` (the number of words is a binomial coefficient) and `lower_boundW`
this gives `choose_modEq_minimal`. No factorial and no valuation is used.
-/
import MMM.Path.Kummer

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- Equivalent words have the same number of asymmetric blocks. -/
theorem dW_eq_of_eqv [NeZero p] {L : List ℕ} {w w' : Word p L} (hw : EqvW w w') :
    dW w = dW w' :=
  Finset.sum_congr rfl (fun i _ => d_eq_of_eqv (hw i))

/-- If `c ≤ dW w` for every word with `n` letters E, then `p ^ (c + 1)` divides the number of
those words with `dW w ≠ c`. -/
theorem pow_succ_dvd_card_not_minimal [Fact p.Prime] (L : List ℕ) (n c : ℕ)
    (hc : ∀ w : Word p L, cntEW w = n → c ≤ dW w) :
    p ^ (c + 1) ∣ Nat.card {w : Word p L // cntEW w = n ∧ dW w ≠ c} := by
  let s : Setoid {w : Word p L // cntEW w = n ∧ dW w ≠ c} :=
    ⟨fun a b => EqvW a.1 b.1,
      ⟨fun _ i => Eqv.refl _ _, fun h i => (h i).symm, fun h h' i => (h i).trans (h' i)⟩⟩
  refine dvd_card_of_classes s (p ^ (c + 1)) (fun w => ?_)
  let e : {z : {w' : Word p L // cntEW w' = n ∧ dW w' ≠ c} // s.r z w} ≃
      {w' : Word p L // EqvW w.1 w'} :=
    { toFun := fun z => ⟨z.1.1, fun i => (z.2 i).symm⟩
      invFun := fun z => ⟨⟨z.1, (cntEW_eq_of_eqv z.2).symm.trans w.2.1,
        fun hz => w.2.2 ((dW_eq_of_eqv z.2).trans hz)⟩, fun i => (z.2 i).symm⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [Nat.card_congr e, card_classW]
  apply pow_dvd_pow
  have h1 := hc w.1 w.2.1
  have h2 := w.2.2
  omega

/-- The words with `n` letters E are those with `dW w = c` and those with `dW w ≠ c`. -/
theorem card_cntEW_split [NeZero p] (L : List ℕ) (n c : ℕ) :
    Nat.card {w : Word p L // cntEW w = n} =
      Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} +
        Nat.card {w : Word p L // cntEW w = n ∧ dW w ≠ c} := by
  classical
  rw [← Nat.card_congr (Equiv.subtypeSubtypeEquivSubtypeInter
      (fun w : Word p L => cntEW w = n) (fun w => dW w = c)),
    ← Nat.card_congr (Equiv.subtypeSubtypeEquivSubtypeInter
      (fun w : Word p L => cntEW w = n) (fun w => dW w ≠ c)),
    ← Nat.card_sum]
  exact Nat.card_congr
    (Equiv.sumCompl (fun x : {w : Word p L // cntEW w = n} => dW x.1 = c)).symm

/-- **Reduction to the minimal words.** Modulo `p ^ (c + 1)`, only the words with `dW w = c`
count. -/
theorem card_cntEW_modEq_minimal [Fact p.Prime] (L : List ℕ) (n c : ℕ)
    (hc : ∀ w : Word p L, cntEW w = n → c ≤ dW w) :
    Nat.card {w : Word p L // cntEW w = n} ≡
      Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} [MOD p ^ (c + 1)] := by
  obtain ⟨k, hk⟩ := pow_succ_dvd_card_not_minimal L n c hc
  rw [card_cntEW_split L n c, hk]
  exact Nat.add_mul_mod_self_left _ _ _

/-- **Equation (modp) of the note.** If `c` is the number of carries (given through the digit
sums and the number of top blocks), then modulo `p ^ (c + 1)` the binomial coefficient is the
number of minimal words. -/
theorem choose_modEq_minimal [hp : Fact p.Prime] (L : List ℕ) (n c : ℕ) (hn : n ≤ len p L)
    (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) :
    (len p L).choose n ≡ Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} [MOD p ^ (c + 1)] := by
  rw [← card_cntEW L n]
  refine card_cntEW_modEq_minimal L n c (fun w hw => ?_)
  have hb := lower_boundW hp.out.two_le w
  rw [hw, ← hc] at hb
  have hp0 : 0 < p - 1 := Nat.sub_pos_of_lt hp.out.two_le
  exact Nat.le_of_mul_le_mul_left (Nat.le_of_add_le_add_right hb) hp0

end MMM.Path
