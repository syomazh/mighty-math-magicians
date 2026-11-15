/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Algebraic identities of the delta-ring operator theta.
-/
import MMM.Frob.ThetaDiv

set_option maxHeartbeats 800000

namespace MMM.Frob

private lemma theta_unique (p : ℕ) [Fact p.Prime] (f g : Lambda)
    (hg : (p : Lambda) * g = f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) :
    theta p f = g :=
  (mul_natCast_prime_cancel p (hg.trans (theta_spec p f).symm)).symm

/-- The integral binomial correction, in any commutative ring. -/
noncomputable def binomialCorrection (p : ℕ) [Fact p.Prime] (f g : Lambda) : Lambda :=
  ∑ i ∈ Finset.Ioo 0 p,
    ((p.choose i / p : ℕ) : Lambda) * f ^ i * g ^ (p - i)

lemma add_pow_prime_eq_lambda (p : ℕ) [Fact p.Prime] (f g : Lambda) :
    (f + g) ^ p = f ^ p + g ^ p + (p : Lambda) * binomialCorrection p f g := by
  rw [add_pow_prime_eq' (R := Lambda) (Fact.out : p.Prime) f g]
  simp only [binomialCorrection, Nat.cast_mul, Finset.mul_sum, Finset.sum_mul]
  apply congrArg (fun s => f^p + g^p + s)
  apply Finset.sum_congr rfl
  intro i hi
  show (p : Lambda) * (f ^ i * g ^ (p - i) * ((p.choose i / p : ℕ) : Lambda)) =
    (p : Lambda) * (((p.choose i / p : ℕ) : Lambda) * f ^ i * g ^ (p - i))
  ring

@[simp] theorem theta_zero (p : ℕ) [Fact p.Prime] : theta p 0 = 0 := by
  apply theta_unique p 0 0
  simp [zero_pow (Fact.out : p.Prime).ne_zero]

@[simp] theorem theta_one (p : ℕ) [Fact p.Prime] : theta p 1 = 0 := by
  apply theta_unique p 1 0
  simp

@[simp] theorem theta_X (p : ℕ) [Fact p.Prime] : theta p PowerSeries.X = 0 := by
  apply theta_unique
  rw [frobeniusLift_X]
  simp

@[simp] theorem theta_coeff_X (p : ℕ) [Fact p.Prime] :
    theta p (PowerSeries.C Polynomial.X : Lambda) = 0 := by
  apply theta_unique
  rw [frobeniusLift_coeff_X]
  simp [← map_pow]

theorem theta_add (p : ℕ) [Fact p.Prime] (f g : Lambda) :
    theta p (f + g) = theta p f + theta p g + binomialCorrection p f g := by
  apply theta_unique
  rw [map_add, add_pow_prime_eq_lambda]
  calc
    _ = ((p : Lambda) * theta p f) + ((p : Lambda) * theta p g) +
        (p : Lambda) * binomialCorrection p f g := by ring
    _ = _ := by rw [theta_spec p f, theta_spec p g]; ring

theorem theta_mul (p : ℕ) [Fact p.Prime] (f g : Lambda) :
    theta p (f * g) =
      frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f * theta p g +
        frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero g * theta p f +
        (p : Lambda) * theta p f * theta p g := by
  apply theta_unique
  rw [map_mul]
  calc
    _ = ((p : Lambda) * theta p f) * ((p : Lambda) * theta p g) +
        (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) *
          ((p : Lambda) * theta p g) +
        (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero g) *
          ((p : Lambda) * theta p f) := by ring
    _ = _ := by rw [theta_spec p f, theta_spec p g]; ring

/-- The defining equation in the order used in the Frobenius system. -/
theorem theta_system_eq (p : ℕ) [Fact p.Prime] (f : Lambda) :
    frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f + (p : Lambda) * theta p f = f ^ p := by
  rw [theta_spec]
  ring

end MMM.Frob
