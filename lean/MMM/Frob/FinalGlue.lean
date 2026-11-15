/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
Small lemmas for the last step of the Frobenius proof (`Final.lean`): the digit vector a(m) of
`Subst.lean` has total s_p(m) and weight ≡ m modulo p^k - 1; the leading coefficient is the
coefficient of y^t; and a polynomial divisible by X^t, evaluated at x, is x^t times its
coefficient of X^t modulo x^(t+1).
-/
import MMM.Frob.Subst
import MMM.Frob.Eval
import Mathlib.Algebra.BigOperators.ModEq
import Mathlib.Algebra.Polynomial.Div

namespace MMM.Frob

open MMM

theorem final_lt_pow {p : ℕ} (hp : 2 ≤ p) (m : ℕ) : m < p ^ (m + 1) :=
  (Nat.lt_pow_self (by omega : 1 < p)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))

/-- The base-p expansion: m is the sum of its digits times the powers of p. -/
theorem eq_sum_dig_mul_pow {p : ℕ} (hp : 2 ≤ p) : ∀ (B m : ℕ), m < p ^ B →
    m = ∑ j ∈ Finset.range B, dig p j m * p ^ j := by
  intro B
  induction B with
  | zero =>
    intro m hm
    have h0 : m = 0 := by simpa using hm
    subst h0
    simp
  | succ B ih =>
    intro m hm
    have hdiv : m / p < p ^ B := by
      rw [Nat.div_lt_iff_lt_mul (by omega)]
      rw [pow_succ] at hm
      exact hm
    have e := ih (m / p) hdiv
    rw [Finset.sum_range_succ']
    have h1 : ∑ j ∈ Finset.range B, dig p (j + 1) m * p ^ (j + 1) = p * (m / p) := by
      have e' : p * (m / p) = p * ∑ j ∈ Finset.range B, dig p j (m / p) * p ^ j := by rw [← e]
      rw [e', Finset.mul_sum]
      refine Finset.sum_congr rfl (fun j _ => ?_)
      rw [dig_succ, pow_succ]
      ring
    rw [h1, dig_zero, pow_zero, mul_one]
    exact (Nat.div_add_mod m p).symm

/-- The entries of a(m) add up to the digit sum of m. -/
theorem sum_digitVec {p : ℕ} (hp : 2 ≤ p) (k : ℕ) [NeZero k] (m : ℕ) :
    ∑ c, digitVec p k m c = ds p m := by
  unfold digitVec
  rw [Finset.sum_comm, ds_eq_sum_dig hp (m + 1) m (final_lt_pow hp m)]
  refine Finset.sum_congr rfl (fun j _ => ?_)
  simp

theorem digitVec_ne_zero {p : ℕ} (hp : 2 ≤ p) (k : ℕ) [NeZero k] {m : ℕ} (hm : 0 < m) :
    digitVec p k m ≠ 0 := by
  intro h
  have hs := sum_digitVec hp k m
  rw [h] at hs
  have hpos := ds_pos hp m hm
  simp at hs
  omega

/-- The weight of a(m) is congruent to m modulo p^k - 1. -/
theorem wt_digitVec (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (m : ℕ) :
    wt p k (digitVec p k m) ≡ m [MOD p ^ k - 1] := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have h1 : wt p k (digitVec p k m) =
      ∑ j ∈ Finset.range (m + 1), dig p j m * p ^ (j % k) := by
    unfold wt digitVec
    simp only [Finset.sum_mul]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl (fun j _ => ?_)
    rw [Finset.sum_eq_single (j : ZMod k)]
    · simp [ZMod.val_natCast]
    · intro c _ hc
      rw [if_neg (fun h => hc h.symm), zero_mul]
    · intro h
      exact absurd (Finset.mem_univ _) h
  have h2 : m = ∑ j ∈ Finset.range (m + 1), dig p j m * p ^ j :=
    eq_sum_dig_mul_pow hp (m + 1) m (final_lt_pow hp m)
  have h3 : ∑ j ∈ Finset.range (m + 1), dig p j m * p ^ (j % k) ≡
      ∑ j ∈ Finset.range (m + 1), dig p j m * p ^ j [MOD p ^ k - 1] :=
    Nat.ModEq.sum (fun j _ => (pow_mod_modEq p k j (by omega)).mul_left _)
  rw [← h2] at h3
  rw [h1]
  exact h3

/-- The leading coefficient at x^m is the coefficient of x^m y^t when s_p(m) = (p - 1) t + 1. -/
theorem lead_eq_coeff {p : ℕ} (hp : 2 ≤ p) (f : Lambda) (m t : ℕ)
    (ht : ds p m = (p - 1) * t + 1) : lead p f m = (f.coeff m).coeff t := by
  have hm : 0 < m := by
    rcases Nat.eq_zero_or_pos m with h | h
    · subst h
      rw [ds_zero] at ht
      omega
    · exact h
  have hd : (p - 1) ∣ ds p m - 1 := ⟨t, by omega⟩
  have hq : (ds p m - 1) / (p - 1) = t := by
    rw [ht, Nat.add_sub_cancel]
    exact Nat.mul_div_cancel_left t (by omega)
  unfold lead
  rw [if_pos ⟨hm, hd⟩, hq]

/-- A polynomial divisible by X^t, evaluated at x, is x^t times its coefficient of X^t,
modulo x^(t+1). -/
theorem eval_modEq_of_X_pow_dvd (P : Polynomial ℤ) (x : ℤ) (t : ℕ)
    (h : (Polynomial.X : Polynomial ℤ) ^ t ∣ P) :
    P.eval x ≡ x ^ t * P.coeff t [ZMOD x ^ (t + 1)] := by
  obtain ⟨Q, rfl⟩ := h
  have hc : (Polynomial.X ^ t * Q).coeff t = Q.coeff 0 := by
    have := Polynomial.coeff_X_pow_mul Q t 0
    simpa using this
  rw [hc, Polynomial.eval_mul, Polynomial.eval_pow, Polynomial.eval_X]
  have hd : x ∣ Q.coeff 0 - Q.eval x := by
    have := Polynomial.sub_dvd_eval_sub x 0 Q
    rw [sub_zero, ← Polynomial.coeff_zero_eq_eval_zero] at this
    exact (dvd_sub_comm).mp this
  have hq : Q.eval x ≡ Q.coeff 0 [ZMOD x] := Int.modEq_iff_dvd.mpr hd
  have := hq.mul_left' (c := x ^ t)
  rwa [← pow_succ] at this

end MMM.Frob
