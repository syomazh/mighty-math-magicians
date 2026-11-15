/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Coefficientwise reduction modulo p and Frobenius modulo p for the lift.
-/
import MMM.Frob.Basic
import Mathlib.FieldTheory.Finite.Basic

namespace MMM.Frob

/-- Reduction of integral polynomials modulo p. -/
noncomputable def modPoly (p : ℕ) : Polynomial ℤ →+* Polynomial (ZMod p) :=
  Polynomial.mapRingHom (Int.castRingHom (ZMod p))

/-- Reduction of `Λ = ℤ[y][[x]]` coefficientwise modulo p. -/
noncomputable def modSeries (p : ℕ) : Lambda →+* PowerSeries (Polynomial (ZMod p)) :=
  PowerSeries.map (modPoly p)

@[simp] theorem coeff_modSeries (p : ℕ) (f : Lambda) (n : ℕ) :
    (modSeries p f).coeff n = Polynomial.map (Int.castRingHom (ZMod p)) (f.coeff n) := by
  simp [modSeries, modPoly, PowerSeries.coeff_map]

/-- Reduction modulo `p` commutes with polynomial substitution. -/
lemma coeff_modPoly_map_expand (p : ℕ) (P : Polynomial ℤ) :
    (modPoly p) ((Polynomial.expand ℤ p) P) =
      Polynomial.expand (ZMod p) p (modPoly p P) :=
  Polynomial.map_expand

/-- Compatibility of polynomial reduction and expansion, as stated by W025. -/
lemma modPoly_expand (p : ℕ) [Fact p.Prime] (P : Polynomial ℤ) :
    modPoly p (Polynomial.expand ℤ p P) =
      Polynomial.expand (ZMod p) p (modPoly p P) :=
  coeff_modPoly_map_expand p P

/-- Substitution by `yᵖ` modulo `p` is the `p`-th power map. -/
lemma modPoly_expand_eq_pow (p : ℕ) [Fact p.Prime] (P : Polynomial ℤ) :
    modPoly p (Polynomial.expand ℤ p P) = (modPoly p P) ^ p := by
  rw [coeff_modPoly_map_expand]
  have h := Polynomial.map_frobenius_expand (R := ZMod p) p (modPoly p P)
  rw [ZMod.frobenius_zmod] at h
  simpa using h

/-- The coefficientwise Frobenius on `ZMod p[y]` is substitution by `yᵖ`. -/
lemma frobenius_poly_eq_expand (p : ℕ) [Fact p.Prime] (P : Polynomial (ZMod p)) :
    frobenius (Polynomial (ZMod p)) p P = Polynomial.expand (ZMod p) p P := by
  change P ^ p = Polynomial.expand (ZMod p) p P
  induction P using Polynomial.induction_on' with
  | add P Q hP hQ => simp only [map_add, hP, hQ, add_pow_expChar]
  | monomial d a =>
    simp only [← Polynomial.C_mul_X_pow_eq_monomial, map_mul, map_pow,
      Polynomial.expand_C, Polynomial.expand_X, mul_pow, ← Polynomial.C_pow,
      ZMod.pow_card, ← pow_mul, mul_comm d p]

/-- Modulo p, expansion in `x` commutes with reduction of coefficients. -/
lemma modSeries_expand (p : ℕ) (hp : p ≠ 0) (f : Lambda) :
    modSeries p ((PowerSeries.expand p hp) f) =
      PowerSeries.expand p hp (modSeries p f) := by
  exact PowerSeries.map_expand (R := Polynomial ℤ) (S := Polynomial (ZMod p)) p hp (modPoly p) f

/-- Modulo p, polynomial substitution is followed by a reduction by Frobenius. -/
lemma modSeries_map_expand {p : ℕ} [Fact p.Prime] (f : Lambda) :
    PowerSeries.map (modPoly p)
      (PowerSeries.map (Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) f) =
      PowerSeries.map (frobenius (Polynomial (ZMod p)) p) (modSeries p f) := by
  ext n a
  rw [PowerSeries.coeff_map, PowerSeries.coeff_map, PowerSeries.coeff_map,
    frobenius_poly_eq_expand, coeff_modSeries]
  exact congrArg (fun P : Polynomial (ZMod p) ↦ P.coeff a) (coeff_modPoly_map_expand p (f.coeff n))

/-- Frobenius modulo `p` is the `p`-th power map. -/
lemma modSeries_frobeniusLift (p : ℕ) [Fact p.Prime] (f : Lambda) :
    modSeries p (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) = (modSeries p f) ^ p := by
  change modSeries p (PowerSeries.expand p (Fact.out : p.Prime).ne_zero
      (PowerSeries.map (Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) f)) = _
  calc
    _ = PowerSeries.expand p (Fact.out : p.Prime).ne_zero
        (PowerSeries.map (modPoly p)
          (PowerSeries.map (Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) f)) :=
      modSeries_expand p (Fact.out : p.Prime).ne_zero
        (PowerSeries.map (Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) f)
    _ = PowerSeries.expand p (Fact.out : p.Prime).ne_zero
        (PowerSeries.map (frobenius (Polynomial (ZMod p)) p) (modSeries p f)) :=
      congrArg (PowerSeries.expand p (Fact.out : p.Prime).ne_zero) (modSeries_map_expand f)
    _ = PowerSeries.map (frobenius (Polynomial (ZMod p)) p)
        (PowerSeries.expand p (Fact.out : p.Prime).ne_zero (modSeries p f)) :=
      (PowerSeries.map_expand p (Fact.out : p.Prime).ne_zero
        (frobenius (Polynomial (ZMod p)) p) (modSeries p f)).symm
    _ = (modSeries p f) ^ p :=
      PowerSeries.map_frobenius_expand p (Fact.out : p.Prime).ne_zero

end MMM.Frob
