/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

Digit sums in base `p`, proved directly from the recursion `s(n) = n % p + s(n / p)`.
No factorial and no valuation is used anywhere in this file.
-/
import Mathlib

namespace MMM

/-- The sum of the base-`p` digits of `n`. -/
def ds (p n : ℕ) : ℕ := (Nat.digits p n).sum

@[simp] theorem ds_zero (p : ℕ) : ds p 0 = 0 := by simp [ds]

/-- `s(n) = n % p + s(n / p)`. -/
theorem ds_rec {p : ℕ} (hp : 2 ≤ p) (n : ℕ) : ds p n = n % p + ds p (n / p) := by
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · simp
  · unfold ds
    rw [Nat.digits_def' (by omega) hn]
    simp

/-- A number below the base is its own digit sum. -/
theorem ds_of_lt {p : ℕ} (hp : 2 ≤ p) {n : ℕ} (h : n < p) : ds p n = n := by
  rw [ds_rec hp, Nat.mod_eq_of_lt h, Nat.div_eq_of_lt h, ds_zero, add_zero]

theorem ds_one {p : ℕ} (hp : 2 ≤ p) : ds p 1 = 1 := ds_of_lt hp (by omega)

/-- Multiplying by the base shifts the digits: the digit sum does not change. -/
theorem ds_base_mul {p : ℕ} (hp : 2 ≤ p) (n : ℕ) : ds p (p * n) = ds p n := by
  rw [ds_rec hp (p * n), Nat.mul_mod_right, Nat.mul_div_cancel_left n (by omega), zero_add]

/-- A positive number has a positive digit sum. -/
theorem ds_pos {p : ℕ} (hp : 2 ≤ p) : ∀ n : ℕ, 0 < n → 0 < ds p n := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro hn
    rw [ds_rec hp]
    by_cases h : n % p = 0
    · have hdiv : 0 < n / p := by
        have := Nat.div_add_mod n p
        rcases Nat.eq_zero_or_pos (n / p) with h0 | h0
        · rw [h0, h] at this; omega
        · exact h0
      have hlt : n / p < n := Nat.div_lt_self hn (by omega)
      have := ih (n / p) hlt hdiv
      omega
    · omega

/-- **Digit sums are subadditive.** Each carry lowers the digit sum. -/
theorem ds_add_le {p : ℕ} (hp : 2 ≤ p) : ∀ a b : ℕ, ds p (a + b) ≤ ds p a + ds p b := by
  intro a b
  induction h : a + b using Nat.strong_induction_on generalizing a b with
  | _ n ih =>
    rcases Nat.eq_zero_or_pos n with hn | hn
    · have ha : a = 0 := by omega
      have hb : b = 0 := by omega
      subst ha hb
      simp
    · have hp0 : 0 < p := by omega
      rw [ds_rec hp (a + b), ds_rec hp a, ds_rec hp b]
      have hdiv := Nat.add_div (a := a) (b := b) hp0
      have hmod := Nat.add_mod_eq_ite (m := a) (n := b) (k := p)
      have hlt : (a + b) / p < n := by
        rw [h]; exact Nat.div_lt_self hn (by omega)
      by_cases hc : p ≤ a % p + b % p
      · rw [if_pos hc] at hdiv hmod
        -- one carry
        have h1 : ds p (a / p + b / p + 1) ≤ ds p (a / p + b / p) + ds p 1 :=
          ih (a / p + b / p + 1) (by rw [← hdiv]; exact hlt) (a / p + b / p) 1 rfl
        have h2 : ds p (a / p + b / p) ≤ ds p (a / p) + ds p (b / p) := by
          have hlt2 : a / p + b / p < n := by omega
          exact ih (a / p + b / p) hlt2 (a / p) (b / p) rfl
        rw [ds_one hp] at h1
        rw [hdiv, hmod]
        omega
      · rw [if_neg hc] at hdiv hmod
        have h2 : ds p (a / p + b / p) ≤ ds p (a / p) + ds p (b / p) := by
          have hlt2 : a / p + b / p < n := by omega
          exact ih (a / p + b / p) hlt2 (a / p) (b / p) rfl
        rw [hdiv, hmod, add_zero]
        omega

/-- Subadditivity for a finite family. -/
theorem ds_sum_le {p : ℕ} (hp : 2 ≤ p) {ι : Type*} (s : Finset ι) (f : ι → ℕ) :
    ds p (∑ i ∈ s, f i) ≤ ∑ i ∈ s, ds p (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
    rw [Finset.sum_insert ha, Finset.sum_insert ha]
    exact (ds_add_le hp _ _).trans (by omega)

end MMM
