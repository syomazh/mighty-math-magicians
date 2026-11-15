/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
The coefficient ring and the Frobenius lift for the algebraic proof.
-/
import Mathlib.RingTheory.PowerSeries.Expand
import Mathlib.Algebra.Polynomial.Expand

namespace MMM.Frob

/-- One-variable power series with integral polynomial coefficients. -/
abbrev Lambda := PowerSeries (Polynomial ℤ)

/-- The lift `f(x,y) ↦ f(xᵖ,yᵖ)` as an algebra homomorphism over `ℤ[y]`. -/
noncomputable def frobeniusLiftRingHom (p : ℕ) (hp : p ≠ 0) : Lambda →+* Lambda where
  toFun f := PowerSeries.expand p hp
    (PowerSeries.map (Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) f)
  map_one' := by simp
  map_mul' _ _ := by simp
  map_zero' := by simp
  map_add' _ _ := by simp

@[simp] theorem frobeniusLift_X (p : ℕ) (hp : p ≠ 0) :
    frobeniusLiftRingHom p hp (PowerSeries.X : Lambda) = PowerSeries.X ^ p := by
  simp [frobeniusLiftRingHom]

@[simp] theorem frobeniusLift_coeff_X (p : ℕ) (hp : p ≠ 0) :
    frobeniusLiftRingHom p hp (PowerSeries.C Polynomial.X : Lambda) =
      PowerSeries.C (Polynomial.X ^ p : Polynomial ℤ) := by
  simp only [frobeniusLiftRingHom, RingHom.coe_mk, MonoidHom.coe_mk, OneHom.coe_mk]
  rw [PowerSeries.map_C]
  change PowerSeries.expand p hp (PowerSeries.C ((Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) Polynomial.X)) = _
  have h : ((Polynomial.expand ℤ p : Polynomial ℤ →+* Polynomial ℤ) Polynomial.X) =
      Polynomial.X ^ p := by
    exact Polynomial.expand_X (R := ℤ) (p := p)
  rw [h, PowerSeries.expand_C]

end MMM.Frob
