/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Existence and uniqueness of the cyclic Frobenius system by iteration.
-/
import MMM.Frob.Uniqueness

set_option maxHeartbeats 800000

namespace MMM.Frob

variable {k : ℕ}

/-- The n-th iterate of the right-hand side, starting from 0. -/
noncomputable def iter (p : ℕ) [Fact p.Prime] (k : ℕ) : ℕ → ZMod k → Lambda
  | 0 => fun _ => 0
  | n + 1 => fun δ => cyclicRHS p (iter p k n) δ

theorem iter_zero (p : ℕ) [Fact p.Prime] (δ : ZMod k) : iter p k 0 δ = 0 := rfl

theorem iter_succ (p : ℕ) [Fact p.Prime] (a : ℕ) (δ : ZMod k) :
    iter p k (a + 1) δ = cyclicRHS p (iter p k a) δ := rfl

theorem iter_zeroConstant (p : ℕ) [Fact p.Prime] (n : ℕ) :
    ∀ δ : ZMod k, HasZeroConstant (iter p k n δ) := by
  induction n with
  | zero => intro δ; rfl
  | succ n ih =>
    intro δ
    exact zeroConstant_cyclicRHS (iter p k n) ih δ

/-- Normal form of stability used in the induction. -/
theorem iter_stable_eq (p : ℕ) [Fact p.Prime] :
    ∀ m : ℕ, ∀ n ≥ m + 1, ∀ δ : ZMod k,
      (iter p k n δ).coeff m = (iter p k (m + 1) δ).coeff m := by
  intro m
  induction m using Nat.strong_induction_on with
  | ind m ih =>
    by_cases hm : m = 0
    · subst m
      intro n hn δ
      exact (iter_zeroConstant p n δ).trans (iter_zeroConstant p (0 + 1) δ).symm
    have hmpos : 0 < m := Nat.pos_of_ne_zero hm
    obtain ⟨a, ha⟩ : ∃ a, m = a + 1 := ⟨m - 1, by omega⟩
    subst ha
    intro n hn δ
    obtain ⟨b, hb⟩ : ∃ b, n = b + 1 := ⟨n - 1, by omega⟩
    subst hb
    have hba : b ≥ a + 1 := by omega
    have hlow : ∀ j < a + 1,
        (iter p k b (δ + 1)).coeff j = (iter p k (a + 1) (δ + 1)).coeff j := by
      intro j hj
      have hjb : b ≥ j + 1 := le_trans hj hba
      have hja : a + 1 ≥ j + 1 := by omega
      have h1 : (iter p k b (δ + 1)).coeff j = (iter p k (j + 1) (δ + 1)).coeff j :=
        ih j hj b hjb (δ + 1)
      have h2 : (iter p k (a + 1) (δ + 1)).coeff j =
          (iter p k (j + 1) (δ + 1)).coeff j := ih j hj (a + 1) hja (δ + 1)
      exact h1.trans h2.symm
    have hzer : HasZeroConstant (iter p k b (δ + 1)) := iter_zeroConstant p b (δ + 1)
    have hzea : HasZeroConstant (iter p k (a + 1) (δ + 1)) :=
      iter_zeroConstant p (a + 1) (δ + 1)
    calc
      (iter p k (b + 1) δ).coeff (a + 1) = (cyclicRHS p (iter p k b) δ).coeff (a + 1) := rfl
      _ = (cyclicRHS p (iter p k (a + 1)) δ).coeff (a + 1) := by
        simp only [cyclicRHS, map_add, PowerSeries.coeff_C_mul]
        congr 1
        · rw [coeff_frobeniusLift_lower (by omega : 0 < a + 1) hlow]
        · rw [coeff_theta_lower (by omega : 0 < a + 1) hzer hzea hlow]
      _ = (iter p k (a + 2) δ).coeff (a + 1) := rfl

/-- Coefficients stabilise: the coefficient of x^m no longer changes after m + 1 steps. -/
theorem iter_stable {p : ℕ} [Fact p.Prime] {m n n' : ℕ} (hn : m < n) (hn' : m < n')
    (δ : ZMod k) : (iter p k n δ).coeff m = (iter p k n' δ).coeff m := by
  exact (iter_stable_eq p m n (by omega) δ).trans (iter_stable_eq p m n' (by omega) δ).symm

noncomputable def solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) : Lambda :=
  PowerSeries.mk fun m => (iter p k (m + 1) δ).coeff m

/-- The defining coefficient formula. -/
theorem coeff_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m : ℕ) :
    (solution p k δ).coeff m = (iter p k (m + 1) δ).coeff m := by
  unfold solution
  rw [PowerSeries.coeff_mk]

theorem solution_zeroConstant (p : ℕ) [Fact p.Prime] (δ : ZMod k) :
    HasZeroConstant (solution p k δ) := by
  rw [HasZeroConstant, coeff_solution]
  exact iter_zeroConstant p 1 δ

theorem solution_cyclic (p : ℕ) [Fact p.Prime] (k : ℕ) : CyclicSystem p (solution p k) := by
  intro δ
  apply PowerSeries.ext
  intro m
  by_cases hm : m = 0
  · subst m
    exact (solution_zeroConstant p δ).trans (zeroConstant_cyclicRHS (solution p k)
      (fun ε => solution_zeroConstant p ε) δ).symm
  have hmpos : 0 < m := Nat.pos_of_ne_zero hm
  have hlow : ∀ j < m, (iter p k (m + 1) (δ + 1)).coeff j =
      (solution p k (δ + 1)).coeff j := by
    intro j hj
    rw [coeff_solution]
    exact iter_stable_eq p j (m + 1) (by omega) (δ + 1) |>.trans
      (iter_stable_eq p j (j + 1) (Nat.le_refl (j + 1)) (δ + 1)).symm
  calc
    (solution p k δ).coeff m = (iter p k (m + 1) δ).coeff m := coeff_solution p k δ m
    _ = (iter p k (m + 2) δ).coeff m := iter_stable_eq p m (m + 1) (by omega) δ |>.trans
      (iter_stable_eq p m (m + 2) (by omega) δ).symm
    _ = (cyclicRHS p (iter p k (m + 1)) δ).coeff m := rfl
    _ = (cyclicRHS p (solution p k) δ).coeff m := by
      simp only [cyclicRHS, map_add, PowerSeries.coeff_C_mul]
      rw [coeff_frobeniusLift_lower hmpos hlow,
        coeff_theta_lower hmpos (iter_zeroConstant p (m + 1) (δ + 1))
          (solution_zeroConstant p (δ + 1)) hlow]

theorem exists_unique_cyclicSystem (p : ℕ) [Fact p.Prime] (k : ℕ) :
    ∃! F : ZMod k → Lambda, (∀ δ, HasZeroConstant (F δ)) ∧ CyclicSystem p F := by
  refine ⟨solution p k, ⟨fun δ => solution_zeroConstant p δ, solution_cyclic p k⟩, ?_⟩
  rintro G ⟨hGzero, hGsystem⟩
  exact (cyclicSystem_unique (fun ε => solution_zeroConstant p ε) hGzero
    (solution_cyclic p k) hGsystem).symm

end MMM.Frob
