/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Divisibility of the Frobenius difference, torsion cancellation, and theta.
-/
import MMM.Frob.Theta

namespace MMM.Frob

lemma coeff_sub_modSeries_zero (p : ℕ) [Fact p.Prime] (f : Lambda) (n : ℕ) :
    Polynomial.map (Int.castRingHom (ZMod p))
      ((f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff n) = 0 := by
  rw [← coeff_modSeries, map_sub, modSeries_frobeniusLift, map_pow, sub_self]
  rfl

lemma coeff_div_modPoly (p : ℕ) [Fact p.Prime] (f : Lambda) (n : ℕ) :
    Polynomial.C (p : ℤ) ∣
      (f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff n := by
  apply (Polynomial.C_dvd_iff_dvd_coeff _ _).mpr
  intro d
  apply (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp
  have h := congrArg (fun P : Polynomial (ZMod p) => P.coeff d)
    (coeff_sub_modSeries_zero p f n)
  simpa [Polynomial.coeff_map] using h

lemma natCast_lambda_eq_C (p : ℕ) :
    (p : Lambda) = PowerSeries.C (p : Polynomial ℤ) := by rw [map_natCast]

lemma coeff_natCast_mul (p n d : ℕ) (f : Lambda) :
    (((p : Lambda) * f).coeff n).coeff d = p * (f.coeff n).coeff d := by
  rw [natCast_lambda_eq_C, PowerSeries.coeff_C_mul, Polynomial.coeff_natCast_mul]

lemma exists_frobenius_sub_eq_natCast_mul (p : ℕ) [Fact p.Prime] (f : Lambda) :
    ∃ g : Lambda, f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f =
      (p : Lambda) * g := by
  choose Q hQ using coeff_div_modPoly p f
  let g : Lambda := PowerSeries.mk Q
  refine ⟨g, ?_⟩
  ext n d
  change ((f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff n).coeff d =
    (((p : Lambda) * g).coeff n).coeff d
  have hQn := hQ n
  change (f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff n =
    Polynomial.C (p : ℤ) * Q n at hQn
  rw [hQn]
  rw [PowerSeries.coeff_natCast_mul, PowerSeries.coeff_mk, Polynomial.coeff_natCast_mul]
  rw [Polynomial.C_eq_natCast, Polynomial.coeff_natCast_mul]

lemma mul_natCast_prime_cancel (p : ℕ) [Fact p.Prime] {g h : Lambda} :
    (p : Lambda) * g = (p : Lambda) * h → g = h := by
  intro hp
  ext n d
  have hn := congrArg (fun s : Lambda ↦ (s.coeff n).coeff d) hp
  have hn' : (p : ℤ) * (g.coeff n).coeff d = (p : ℤ) * (h.coeff n).coeff d := by
    simpa using hn
  exact mul_left_cancel₀ (Int.natCast_ne_zero.mpr (Fact.out : p.Prime).ne_zero) hn'

noncomputable def theta (p : ℕ) [Fact p.Prime] (f : Lambda) : Lambda :=
  (exists_frobenius_sub_eq_natCast_mul p f).choose

theorem theta_spec (p : ℕ) [Fact p.Prime] (f : Lambda) :
    (p : Lambda) * theta p f =
      f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f :=
  (exists_frobenius_sub_eq_natCast_mul p f).choose_spec.symm

end MMM.Frob
