/-
The definitions and the reduction lemmas (`modPoly`, `modSeries`, `coeff_modSeries`,
`coeff_modPoly_map_expand`, `modPoly_expand`, `modSeries_expand`) were written by Kimi K3.1 Pro,
2026-11-14. The proof of the Frobenius identity (everything from `add_pow_prime_of_natCast_eq_zero`
on) was rewritten by Claude Fable 5.2 (orchestrator) on 2026-11-15, after the third audit
(`lean/AUDIT3.md`, finding 1). Not human-reviewed.

Coefficientwise reduction modulo p, and: modulo p the lift φ is the p-th power map.

Why the proof was rewritten. The first version used Mathlib's Frobenius endomorphism. In the
version of Mathlib that the project is pinned to, the additivity of that map is derived from a
divisibility of binomial coefficients which Mathlib proves through Kummer's theorem and Legendre's
formula. The written proof (`paper/frobenius_proof.tex`) uses only that p divides binom(p, k) for
0 < k < p. This file now does the same: `(a + b)^p = a^p + b^p` in a ring in which p = 0 is
proved from the binomial theorem and `Nat.Prime.dvd_choose_self`, and the identity for power
series from it, by truncation. Mathlib's `frobenius` is not used.
-/
import MMM.Frob.Basic
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.RingTheory.PowerSeries.Trunc
import Mathlib.Data.Nat.Choose.Dvd
import Mathlib.Data.Nat.Choose.Sum

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

/-- Modulo p, expansion in `x` commutes with reduction of coefficients. -/
lemma modSeries_expand (p : ℕ) (hp : p ≠ 0) (f : Lambda) :
    modSeries p ((PowerSeries.expand p hp) f) =
      PowerSeries.expand p hp (modSeries p f) := by
  exact PowerSeries.map_expand (R := Polynomial ℤ) (S := Polynomial (ZMod p)) p hp (modPoly p) f

/-- **The p-th power is additive in a commutative ring in which p = 0**: from the binomial
theorem and the fact that p divides binom(p, k) for 0 < k < p. -/
theorem add_pow_prime_of_natCast_eq_zero {R : Type*} [CommRing R] (p : ℕ) [hp : Fact p.Prime]
    (h0 : (p : R) = 0) (a b : R) : (a + b) ^ p = a ^ p + b ^ p := by
  rw [add_pow, Finset.sum_eq_add (p : ℕ) 0 hp.out.ne_zero]
  · simp
  · intro c hc hne
    have hcp : c < p := by
      have := Finset.mem_range.mp hc
      omega
    obtain ⟨q, hq⟩ := hp.out.dvd_choose_self hne.2 hcp
    rw [hq, Nat.cast_mul, h0, zero_mul, mul_zero]
  · intro h
    exact absurd (Finset.mem_range.mpr (Nat.lt_succ_self p)) h
  · intro h
    exact absurd (Finset.mem_range.mpr (Nat.succ_pos p)) h

/-- p = 0 in `(ZMod p)[y]`. -/
theorem natCast_poly_zmod_eq_zero (p : ℕ) : ((p : ℕ) : Polynomial (ZMod p)) = 0 := by
  rw [← map_natCast (Polynomial.C : ZMod p →+* Polynomial (ZMod p)), ZMod.natCast_self, map_zero]

/-- p = 0 in `(ZMod p)[y][x]`. -/
theorem natCast_poly_poly_zmod_eq_zero (p : ℕ) :
    ((p : ℕ) : Polynomial (Polynomial (ZMod p))) = 0 := by
  rw [← map_natCast (Polynomial.C : Polynomial (ZMod p) →+* Polynomial (Polynomial (ZMod p))),
    natCast_poly_zmod_eq_zero, map_zero]

/-- In `(ZMod p)[y]` the p-th power is substitution by `y ^ p`. -/
theorem pow_prime_eq_expand_zmod (p : ℕ) [Fact p.Prime] (P : Polynomial (ZMod p)) :
    P ^ p = Polynomial.expand (ZMod p) p P := by
  induction P using Polynomial.induction_on' with
  | add P Q hP hQ =>
    rw [add_pow_prime_of_natCast_eq_zero p (natCast_poly_zmod_eq_zero p), hP, hQ, map_add]
  | monomial d a =>
    simp only [← Polynomial.C_mul_X_pow_eq_monomial, map_mul, map_pow,
      Polynomial.expand_C, Polynomial.expand_X, mul_pow, ← Polynomial.C_pow,
      ZMod.pow_card, ← pow_mul, mul_comm d p]

/-- Substitution by `y ^ p` in the coefficients, as a ring homomorphism of `(ZMod p)[y]`. -/
noncomputable def expandY (p : ℕ) : Polynomial (ZMod p) →+* Polynomial (ZMod p) :=
  (Polynomial.expand (ZMod p) p : Polynomial (ZMod p) →+* Polynomial (ZMod p))

theorem expandY_apply (p : ℕ) (a : Polynomial (ZMod p)) :
    expandY p a = Polynomial.expand (ZMod p) p a := rfl

/-- In `(ZMod p)[y][x]` the p-th power is substitution by `x ^ p` and by `y ^ p`. -/
theorem pow_prime_eq_expand_map (p : ℕ) [Fact p.Prime] (P : Polynomial (Polynomial (ZMod p))) :
    P ^ p = Polynomial.expand (Polynomial (ZMod p)) p (P.map (expandY p)) := by
  induction P using Polynomial.induction_on' with
  | add P Q hP hQ =>
    rw [add_pow_prime_of_natCast_eq_zero p (natCast_poly_poly_zmod_eq_zero p), hP, hQ,
      Polynomial.map_add, map_add]
  | monomial d a =>
    rw [← Polynomial.C_mul_X_pow_eq_monomial, mul_pow, ← Polynomial.C_pow,
      pow_prime_eq_expand_zmod, ← pow_mul, Polynomial.map_mul, Polynomial.map_C,
      Polynomial.map_pow, Polynomial.map_X, map_mul, Polynomial.expand_C, map_pow,
      Polynomial.expand_X, ← pow_mul, expandY_apply, mul_comm d p]

/-- **In `(ZMod p)[y][[x]]` the p-th power is substitution by `x ^ p` and by `y ^ p`.**
A coefficient of `g ^ p` depends only on a truncation of `g`, and for polynomials the statement
is `pow_prime_eq_expand_map`. -/
theorem pow_prime_eq_expand_series (p : ℕ) [hp : Fact p.Prime]
    (g : PowerSeries (Polynomial (ZMod p))) :
    g ^ p = PowerSeries.expand p hp.out.ne_zero (PowerSeries.map (expandY p) g) := by
  apply PowerSeries.ext
  intro n
  have hlt : n < n + 1 := Nat.lt_succ_self n
  have h1 : PowerSeries.coeff n (g ^ p) =
      PowerSeries.coeff n
        (((PowerSeries.trunc (n + 1) g : Polynomial (Polynomial (ZMod p))) :
          PowerSeries (Polynomial (ZMod p))) ^ p) := by
    calc PowerSeries.coeff n (g ^ p)
        = PowerSeries.coeff n
            ((PowerSeries.trunc (n + 1) (g ^ p) : Polynomial (Polynomial (ZMod p))) :
              PowerSeries (Polynomial (ZMod p))) :=
          (PowerSeries.coeff_coe_trunc_of_lt hlt).symm
      _ = PowerSeries.coeff n
            ((PowerSeries.trunc (n + 1)
                (((PowerSeries.trunc (n + 1) g : Polynomial (Polynomial (ZMod p))) :
                  PowerSeries (Polynomial (ZMod p))) ^ p) :
              Polynomial (Polynomial (ZMod p))) : PowerSeries (Polynomial (ZMod p))) := by
          rw [PowerSeries.trunc_trunc_pow]
      _ = _ := PowerSeries.coeff_coe_trunc_of_lt hlt
  rw [h1, ← Polynomial.coe_pow, Polynomial.coeff_coe, pow_prime_eq_expand_map,
    Polynomial.coeff_expand hp.out.pos, PowerSeries.coeff_expand]
  by_cases hd : p ∣ n
  · have hdiv : n / p < n + 1 := lt_of_le_of_lt (Nat.div_le_self n p) hlt
    rw [if_pos hd, if_pos hd, Polynomial.coeff_map, PowerSeries.coeff_trunc, if_pos hdiv,
      PowerSeries.coeff_map]
  · rw [if_neg hd, if_neg hd]

/-- Frobenius modulo `p` is the `p`-th power map. -/
lemma modSeries_frobeniusLift (p : ℕ) [Fact p.Prime] (f : Lambda) :
    modSeries p (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) = (modSeries p f) ^ p := by
  change modSeries p (PowerSeries.expand p (Fact.out : p.Prime).ne_zero
      (PowerSeries.map (Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) f)) = _
  rw [modSeries_expand, pow_prime_eq_expand_series]
  congr 1
  ext n a
  rw [PowerSeries.coeff_map, coeff_modSeries, coeff_modSeries, PowerSeries.coeff_map,
    expandY_apply]
  exact congrArg (fun P : Polynomial (ZMod p) ↦ P.coeff a) (coeff_modPoly_map_expand p (f.coeff n))

end MMM.Frob
