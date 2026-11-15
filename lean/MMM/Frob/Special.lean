/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
The cyclic Frobenius system after substituting the prime for the polynomial variable.
-/
import MMM.Frob.Existence

namespace MMM.Frob

/-- Substitution of `p` for the polynomial variable `y`, coefficientwise. -/
noncomputable def evalY (p : ℕ) : Lambda →+* PowerSeries ℤ :=
  PowerSeries.map (Polynomial.evalRingHom (p : ℤ))

variable {k : ℕ}

@[simp] theorem evalY_map_X (p : ℕ) : evalY p PowerSeries.X = PowerSeries.X := by
  simp [evalY, PowerSeries.map_X]

@[simp] theorem evalY_coeff_X (p : ℕ) :
    evalY p (PowerSeries.C Polynomial.X : Lambda) = (p : PowerSeries ℤ) := by
  simp [evalY, PowerSeries.map_C]

theorem evalY_cyclicRHS (p : ℕ) [Fact p.Prime] (F : ZMod k → Lambda) (δ : ZMod k) :
    evalY p (cyclicRHS p F δ) = (if δ = 0 then PowerSeries.X else 0) +
      (evalY p (F (δ + 1))) ^ p := by
  have hsys := congrArg (fun t : Lambda => evalY p t) (theta_system_eq p (F (δ + 1)))
  simp only [map_add, map_mul, map_pow, map_natCast] at hsys
  have hfrob : evalY p (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero (F (δ + 1))) =
      (evalY p (F (δ + 1))) ^ p - (p : PowerSeries ℤ) * evalY p (theta p (F (δ + 1))) := by
    exact eq_sub_of_add_eq hsys
  simp only [cyclicRHS, map_add, map_mul, hfrob, evalY_coeff_X]
  split_ifs <;> simp only [evalY_map_X, map_zero] <;> abel

theorem evalY_solution (p : ℕ) [Fact p.Prime] (δ : ZMod k) :
    evalY p (solution p k δ) = (if δ = 0 then PowerSeries.X else 0) +
      (evalY p (solution p k (δ + 1))) ^ p := by
  rw [solution_cyclic, evalY_cyclicRHS]

/-- Substitution of `0` for the polynomial variable `y`, coefficientwise. -/
noncomputable def evalY0 : Lambda →+* PowerSeries ℤ :=
  PowerSeries.map (Polynomial.evalRingHom 0)

@[simp] theorem evalY0_map_X : evalY0 PowerSeries.X = PowerSeries.X := by
  simp [evalY0, PowerSeries.map_X]

@[simp] theorem evalY0_coeff_X :
    evalY0 (PowerSeries.C Polynomial.X : Lambda) = 0 := by
  simp [evalY0, PowerSeries.map_C]

/-- Polynomial evaluation at zero commutes with expansion in the variable. -/
theorem evalY0_polynomial_expand (p : ℕ) [Fact p.Prime] (P : Polynomial ℤ) :
    Polynomial.eval 0 (Polynomial.expand ℤ p P) = Polynomial.eval 0 P := by
  rw [Polynomial.expand_eval, zero_pow (Fact.out : p.Prime).ne_zero]

/-- At `y = 0`, the Frobenius lift is exactly expansion of the `x` variable. -/
theorem evalY0_frobeniusLift (p : ℕ) [Fact p.Prime] (f : Lambda) :
    evalY0 (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) =
      PowerSeries.expand p (Fact.out : p.Prime).ne_zero (evalY0 f) := by
  unfold frobeniusLiftRingHom
  simp only [RingHom.coe_mk, MonoidHom.coe_mk, OneHom.coe_mk]
  unfold evalY0
  rw [PowerSeries.map_expand]
  apply PowerSeries.ext
  intro n
  rw [PowerSeries.coeff_expand, PowerSeries.coeff_expand]
  split_ifs
  · rw [PowerSeries.coeff_map, PowerSeries.coeff_map]
    exact evalY0_polynomial_expand p (f.coeff (n / p))
  · rfl

theorem evalY0_cyclicRHS (p : ℕ) [Fact p.Prime] (F : ZMod k → Lambda) (δ : ZMod k) :
    evalY0 (cyclicRHS p F δ) = (if δ = 0 then PowerSeries.X else 0) +
      evalY0 (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero (F (δ + 1))) := by
  simp only [cyclicRHS, map_add, map_mul, evalY0_coeff_X, zero_mul, add_zero]
  split_ifs with hδ
  · simp [evalY0_map_X]
  · simp

theorem evalY0_cyclicRHS_expand (p : ℕ) [Fact p.Prime] (F : ZMod k → Lambda) (δ : ZMod k) :
    evalY0 (cyclicRHS p F δ) = (if δ = 0 then PowerSeries.X else 0) +
      PowerSeries.expand p (Fact.out : p.Prime).ne_zero (evalY0 (F (δ + 1))) := by
  rw [evalY0_cyclicRHS, evalY0_frobeniusLift]

end MMM.Frob
