/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Uniqueness of the cyclic Frobenius/theta system, with zero constant terms.
-/
import MMM.Frob.System

namespace MMM.Frob

/-- The indicated variable contributes exactly once in the zero residue class. -/
noncomputable def cyclicRHS (p : ℕ) [Fact p.Prime] {k : ℕ}
    (F : ZMod k → Lambda) (δ : ZMod k) : Lambda :=
  (if δ = 0 then PowerSeries.X else 0) +
    frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero (F (δ + 1)) +
      PowerSeries.C Polynomial.X * theta p (F (δ + 1))

/-- The equations of the cyclic system, without the zero-constant condition. -/
def CyclicSystem (p : ℕ) [Fact p.Prime] {k : ℕ} (F : ZMod k → Lambda) : Prop :=
  ∀ δ, F δ = cyclicRHS p F δ

lemma coeff_zero_pow {R : Type*} [CommSemiring R] (f : PowerSeries R) (p : ℕ) :
    (f ^ p).coeff 0 = (f.coeff 0) ^ p :=
  (congrFun PowerSeries.coeff_zero_eq_constantCoeff (f ^ p)).trans
    ((map_pow PowerSeries.constantCoeff f p).trans
      (congrArg (· ^ p) (congrFun PowerSeries.coeff_zero_eq_constantCoeff f).symm))

lemma coeff_frobeniusLift_zero_of_zero {p : ℕ} [Fact p.Prime] (f : Lambda)
    (hf : HasZeroConstant f) :
    (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff 0 = 0 := by
  simp only [coeff_frobeniusLift_zero, show f.coeff 0 = 0 from hf, map_zero]

lemma coeff_theta_zero_of_zero {p : ℕ} [Fact p.Prime] (f : Lambda)
    (hf : HasZeroConstant f) : (theta p f).coeff 0 = 0 := by
  have hpow : (f ^ p).coeff 0 = 0 := by
    rw [coeff_zero_pow, show f.coeff 0 = 0 from hf]
    exact zero_pow (Fact.out : p.Prime).ne_zero
  have hfp := congrArg (fun s : Lambda => s.coeff 0) (theta_spec p f)
  have hf0 : f.coeff 0 = 0 := hf
  have hpf : (p : Polynomial ℤ) * (theta p f).coeff 0 = 0 := by
    simpa only [PowerSeries.coeff_natCast_mul, map_sub, hpow,
      coeff_frobeniusLift_zero (p := p), hf0, map_zero, sub_zero] using hfp
  exact (mul_eq_zero.mp hpf).resolve_left (by
    simpa only [ne_eq, Nat.cast_eq_zero] using (Fact.out : p.Prime).ne_zero)

lemma zeroConstant_cyclicRHS {p : ℕ} [Fact p.Prime] {k : ℕ}
    (F : ZMod k → Lambda) (hF : ∀ δ, HasZeroConstant (F δ)) (δ : ZMod k) :
    HasZeroConstant (cyclicRHS p F δ) := by
  have hf0 := coeff_frobeniusLift_zero_of_zero (p := p) (F (δ + 1)) (hF (δ + 1))
  have ht0 := coeff_theta_zero_of_zero (p := p) (F (δ + 1)) (hF (δ + 1))
  simp only [HasZeroConstant, cyclicRHS, map_add, hf0, ht0,
    PowerSeries.coeff_C_mul, mul_zero, add_zero]
  split_ifs with hδ
  · simp
  · simp

lemma cyclicSystem_unique {p : ℕ} [Fact p.Prime] {k : ℕ} {F G : ZMod k → Lambda}
    (hFzero : ∀ δ, HasZeroConstant (F δ)) (hGzero : ∀ δ, HasZeroConstant (G δ))
    (hF : CyclicSystem p F) (hG : CyclicSystem p G) : F = G := by
  funext δ
  apply PowerSeries.ext
  intro m
  induction m using Nat.strong_induction_on generalizing δ with
  | _ m ih =>
    by_cases hm : m = 0
    · subst m
      exact (hFzero δ).trans (hGzero δ).symm
    have hmpos : 0 < m := Nat.pos_of_ne_zero hm
    have hlower : ∀ j < m, (F (δ + 1)).coeff j = (G (δ + 1)).coeff j :=
      fun j hj => ih j hj (δ + 1)
    rw [hF δ, hG δ]
    simp only [cyclicRHS, map_add]
    congr 1
    · rw [coeff_frobeniusLift_lower hmpos hlower]
    · rw [PowerSeries.coeff_C_mul, PowerSeries.coeff_C_mul,
        coeff_theta_lower hmpos (hFzero (δ + 1)) (hGzero (δ + 1)) hlower]

end MMM.Frob
