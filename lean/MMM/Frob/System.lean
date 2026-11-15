/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Lower-degree coefficient recursion for the cyclic Frobenius system.
-/
import MMM.Frob.ThetaIdents

set_option maxHeartbeats 800000

namespace MMM.Frob

/-- Series with no constant term. -/
def HasZeroConstant {R : Type*} [Semiring R] (f : PowerSeries R) : Prop := f.coeff 0 = 0

lemma div_lt_of_prime_mul {p n m : ℕ} [Fact p.Prime] (hpn : p * n = m)
    (hn : n ≠ 0) : n < m := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hnpos : 0 < n := Nat.pos_of_ne_zero hn
  rw [← hpn]
  nlinarith

lemma coeff_frobeniusLift_zero {p : ℕ} [Fact p.Prime] (f : Lambda) :
    (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff 0 =
      Polynomial.expand ℤ p (f.coeff 0) := by
  simp only [frobeniusLiftRingHom, RingHom.coe_mk, MonoidHom.coe_mk, OneHom.coe_mk]
  rw [PowerSeries.coeff_expand]
  simp

lemma coeff_frobeniusLift_lower {p : ℕ} [Fact p.Prime] {f g : Lambda} {m : ℕ}
    (hm : 0 < m) (h : ∀ j < m, f.coeff j = g.coeff j) :
    (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff m =
      (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero g).coeff m := by
  simp only [frobeniusLiftRingHom, RingHom.coe_mk, MonoidHom.coe_mk, OneHom.coe_mk]
  rw [PowerSeries.coeff_expand, PowerSeries.coeff_expand]
  simp only [PowerSeries.coeff_map]
  split_ifs with hdvd
  · apply congrArg (Polynomial.expand (R := ℤ) p)
    by_cases hz : m = 0
    · omega
    · apply h
      refine div_lt_of_prime_mul (Nat.mul_div_cancel' hdvd) ?_
      intro hn
      apply hz
      rw [← Nat.div_mul_cancel hdvd, hn, zero_mul]
  · rfl

/-- For at least two positive summands, each is below the total. -/
lemma lt_of_sum_pos {p n : ℕ} [Fact p.Prime] {f : Fin p → ℕ}
    (hpos : ∀ i, f i ≠ 0) (hn : ∑ i, f i = n) (j : Fin p) : f j < n := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  obtain ⟨k, -, hk⟩ := Finset.exists_mem_ne (s := (Finset.univ : Finset (Fin p)))
    (by simpa only [Finset.card_univ, Fintype.card_fin, Nat.lt_iff_add_one_le]) j
  have hother : 0 < ∑ i ∈ Finset.univ.erase j, f i := by
    apply Finset.sum_pos
    · intro i hi
      exact Nat.pos_of_ne_zero (hpos i)
    · exact ⟨k, Finset.mem_erase.mpr ⟨hk, Finset.mem_univ k⟩⟩
  rw [← Finset.sum_erase_add _ _ (Finset.mem_univ j)] at hn
  omega

/-- The finite antidiagonal indexed by `Fin p` has the expected finite sum. -/
lemma finsuppAntidiag_sum_range {p n : ℕ} {l : ℕ →₀ ℕ}
    (hl : l ∈ Finset.finsuppAntidiag (Finset.range p) n) :
    ∑ i : Fin p, l i = n := by
  rw [← Finset.sum_range l]
  exact (Finset.mem_finsuppAntidiag.mp hl).1

/-- Positive coefficients of a prime power of a zero-constant series depend
only on strictly lower coefficients. -/
lemma coeff_pow_lower {p : ℕ} [Fact p.Prime] {f g : Lambda} {m : ℕ}
    (_hm : 0 < m) (hf : HasZeroConstant f) (hg : HasZeroConstant g)
    (h : ∀ j < m, f.coeff j = g.coeff j) :
    (f ^ p).coeff m = (g ^ p).coeff m := by
  rw [PowerSeries.coeff_pow, PowerSeries.coeff_pow]
  apply Finset.sum_congr rfl
  intro l hl
  by_cases hz : ∃ i : Fin p, l i = 0
  · obtain ⟨j, hj⟩ := hz
    have hmem : (j : ℕ) ∈ Finset.range p := Finset.mem_range.mpr j.isLt
    have hzero (r : Lambda) (hr : HasZeroConstant r) :
        ∏ i ∈ Finset.range p, r.coeff (l i) = 0 := by
      apply Finset.prod_eq_zero hmem
      rw [hj]
      exact hr
    rw [hzero f hf, hzero g hg]
  · push Not at hz
    apply Finset.prod_congr rfl
    intro i hi
    let j : Fin p := ⟨i, Finset.mem_range.mp hi⟩
    change f.coeff (l j) = g.coeff (l j)
    apply h
    exact lt_of_sum_pos hz (finsuppAntidiag_sum_range hl) j

/-- A coefficient of θ depends only on strictly lower coefficients, away
from the constant coefficient. -/
lemma coeff_theta_lower {p : ℕ} [Fact p.Prime] {f g : Lambda} {m : ℕ}
    (hm : 0 < m) (hf : HasZeroConstant f) (hg : HasZeroConstant g)
    (h : ∀ j < m, f.coeff j = g.coeff j) :
    (theta p f).coeff m = (theta p g).coeff m := by
  ext d
  have hfp : ((f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff m).coeff d =
      ((g ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero g).coeff m).coeff d := by
    rw [map_sub, map_sub, coeff_pow_lower hm hf hg h,
      coeff_frobeniusLift_lower hm h]
  rw [← theta_spec p f, ← theta_spec p g, coeff_natCast_mul,
    coeff_natCast_mul] at hfp
  exact mul_left_cancel₀ (Int.natCast_ne_zero.mpr (Fact.out : p.Prime).ne_zero) hfp

end MMM.Frob
