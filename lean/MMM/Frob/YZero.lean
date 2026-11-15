/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
The family at y = 0: the indicator of the powers of p in the residue class.
-/
import MMM.Frob.Special

set_option maxHeartbeats 800000

namespace MMM.Frob

noncomputable def alpha (p k : ℕ) (δ : ZMod k) (m : ℕ) : ℤ :=
  haveI := Classical.propDecidable (∃ j : ℕ, m = p ^ j ∧ (j : ZMod k) + δ = 0)
  if ∃ j : ℕ, m = p ^ j ∧ (j : ZMod k) + δ = 0 then 1 else 0

variable {k : ℕ}

theorem pow_inj {p : ℕ} (hp : 2 ≤ p) {a b : ℕ} (h : p ^ a = p ^ b) : a = b :=
  pow_right_injective₀ (a := p) (by omega) (by omega) h

theorem alpha_expand_succ (p : ℕ) [Fact p.Prime] (δ : ZMod k) (j : ℕ) :
    alpha p k δ (p ^ (j + 1)) = alpha p k (δ + 1) (p ^ j) := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have heq : (∃ i : ℕ, p ^ (j + 1) = p ^ i ∧ (i : ZMod k) + δ = 0) ↔
      (∃ i : ℕ, p ^ j = p ^ i ∧ (i : ZMod k) + (δ + 1) = 0) := by
    constructor
    · rintro ⟨i, hi, hiδ⟩
      have hij : i = j + 1 := pow_inj hp hi.symm
      subst hij
      refine ⟨j, rfl, ?_⟩
      push_cast at hiδ ⊢
      linear_combination hiδ
    · rintro ⟨i, hi, hiδ⟩
      refine ⟨i + 1, by rw [pow_succ, pow_succ, hi], ?_⟩
      push_cast at hiδ ⊢
      linear_combination hiδ
  unfold alpha
  by_cases h1 : ∃ i : ℕ, p ^ (j + 1) = p ^ i ∧ (i : ZMod k) + δ = 0
  · have h2 := heq.mp h1
    simp only [h1, h2, ite_true]
  · have h2 : ¬∃ i : ℕ, p ^ j = p ^ i ∧ (i : ZMod k) + (δ + 1) = 0 := by
      intro h
      exact h1 (heq.mpr h)
    simp only [h1, h2, ite_false]

theorem alpha_zeroConstant (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) :
    HasZeroConstant (PowerSeries.mk (alpha p k δ) : PowerSeries ℤ) := by
  rw [HasZeroConstant, PowerSeries.coeff_mk]
  unfold alpha
  rw [if_neg]
  rintro ⟨j, hj, hjδ⟩
  have hp : 0 < p := (Fact.out : p.Prime).pos
  have hpj : 0 < p ^ j := pow_pos hp j
  omega

theorem alpha_one {p : ℕ} [Fact p.Prime] (δ : ZMod k) :
    alpha p k δ 1 = if δ = 0 then 1 else 0 := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  unfold alpha
  by_cases hδ : δ = 0
  · subst hδ
    have hex : ∃ j : ℕ, (1 : ℕ) = p ^ j ∧ (j : ZMod k) + 0 = 0 :=
      ⟨0, by simp, by simp⟩
    rw [if_pos hex, if_pos rfl]
  · rw [if_neg hδ, if_neg]
    rintro ⟨j, hj, hjδ⟩
    have hj0 : j = 0 := by
      by_contra hn
      obtain ⟨i, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hn
      rw [pow_succ] at hj
      have hpd : p ∣ (1 : ℕ) := ⟨p ^ i, by rw [mul_comm, ← hj]⟩
      have hp1 : p = 1 := Nat.dvd_one.mp hpd
      omega
    subst j
    simp only [Nat.cast_zero, zero_add] at hjδ
    exact hδ hjδ

theorem alpha_of_non_power {p : ℕ} {δ : ZMod k} {m : ℕ}
    (h : ¬∃ j : ℕ, m = p ^ j) : alpha p k δ m = 0 := by
  unfold alpha
  rw [if_neg]
  push Not
  intro j hj
  exact fun _ => h ⟨j, hj⟩

theorem expand_cyclic_unique {p : ℕ} [Fact p.Prime] {k : ℕ}
    {F G : ZMod k → PowerSeries ℤ}
    (hFzero : ∀ δ, HasZeroConstant (F δ))
    (hGzero : ∀ δ, HasZeroConstant (G δ))
    (hF : ∀ δ, F δ = (if δ = 0 then PowerSeries.X else 0) +
      PowerSeries.expand p (Fact.out : p.Prime).ne_zero (F (δ + 1)))
    (hG : ∀ δ, G δ = (if δ = 0 then PowerSeries.X else 0) +
      PowerSeries.expand p (Fact.out : p.Prime).ne_zero (G (δ + 1))) : F = G := by
  funext δ
  apply PowerSeries.ext
  intro m
  induction m using Nat.strong_induction_on generalizing δ with
  | ind m ih =>
    by_cases hm : m = 0
    · subst m
      exact (hFzero δ).trans (hGzero δ).symm
    have hmpos : 0 < m := Nat.pos_of_ne_zero hm
    rw [hF δ, hG δ]
    simp only [map_add]
    congr 1
    rw [PowerSeries.coeff_expand, PowerSeries.coeff_expand]
    split_ifs with hdiv
    · apply ih
      have hq : 0 < m / p := by
        rcases Nat.eq_zero_or_pos (m / p) with hzero | hpos
        · exfalso
          have hmul : p * (m / p) = m := Nat.mul_div_cancel' hdiv
          rw [hzero] at hmul
          simp at hmul
          exact hmpos.ne hmul
        · exact hpos
      have hmul : m / p * p = m := by
        rw [mul_comm]
        exact Nat.mul_div_cancel' hdiv
      have hlt : m / p * 1 < m / p * p := by
        apply (Nat.mul_lt_mul_left hq).mpr
        exact (Fact.out : p.Prime).two_le
      rw [mul_one, hmul] at hlt
      exact hlt
    · rfl

theorem evalY0_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) :
    evalY0 (solution p k δ) = PowerSeries.mk (alpha p k δ) := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hp0 : 0 < p := by omega
  have hF : ∀ ε : ZMod k, evalY0 (solution p k ε) =
      (if ε = 0 then PowerSeries.X else 0) +
        PowerSeries.expand p (Fact.out : p.Prime).ne_zero
          (evalY0 (solution p k (ε + 1))) := by
    intro ε
    rw [solution_cyclic p k ε, evalY0_cyclicRHS_expand]
  have hFzero : ∀ ε : ZMod k, HasZeroConstant (evalY0 (solution p k ε)) := by
    intro ε
    rw [HasZeroConstant, evalY0, PowerSeries.coeff_map]
    change Polynomial.eval 0 ((solution p k ε).coeff 0) = 0
    rw [solution_zeroConstant p ε]
    simp
  have hGzero : ∀ ε : ZMod k,
      HasZeroConstant (PowerSeries.mk (alpha p k ε) : PowerSeries ℤ) :=
    fun ε => alpha_zeroConstant p k ε
  have hG : ∀ ε : ZMod k, (PowerSeries.mk (alpha p k ε) : PowerSeries ℤ) =
      (if ε = 0 then PowerSeries.X else 0) +
        PowerSeries.expand p (Fact.out : p.Prime).ne_zero
          (PowerSeries.mk (alpha p k (ε + 1))) := by
    intro ε
    apply PowerSeries.ext
    intro m
    simp only [map_add, PowerSeries.coeff_mk, PowerSeries.coeff_expand]
    by_cases hdiv : p ∣ m
    · rw [if_pos hdiv]
      have hm1 : m ≠ 1 := by
        intro hm
        rw [hm] at hdiv
        have hp1 : p = 1 := Nat.dvd_one.mp hdiv
        omega
      have hx : ((PowerSeries.coeff m) (if ε = 0 then PowerSeries.X else 0) : ℤ) = 0 := by
        split_ifs with hε
        · simp [PowerSeries.coeff_X, hm1]
        · simp
      rw [hx, zero_add]
      by_cases hpow : ∃ j : ℕ, m = p ^ j
      · obtain ⟨j, rfl⟩ := hpow
        have hj : j ≠ 0 := by
          intro hj
          rw [hj, pow_zero] at hm1
          exact hm1 rfl
        obtain ⟨i, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hj
        have hdivpow : p ^ i = p ^ (i + 1) / p := by
          rw [pow_succ, mul_comm]
          exact (Nat.mul_div_cancel_left _ hp0).symm
        rw [← hdivpow]
        exact alpha_expand_succ p ε i
      · rw [alpha_of_non_power hpow, alpha_of_non_power]
        intro hpowdiv
        obtain ⟨j, hj⟩ := hpowdiv
        apply hpow
        refine ⟨j + 1, ?_⟩
        calc
          m = p * (m / p) := by rw [mul_comm]; exact (Nat.div_mul_cancel hdiv).symm
          _ = p * p ^ j := by rw [hj]
          _ = p ^ (j + 1) := by rw [pow_succ, mul_comm]
    · rw [if_neg hdiv]
      simp only [add_zero]
      by_cases hpow : ∃ j : ℕ, m = p ^ j
      · obtain ⟨j, rfl⟩ := hpow
        have hj : j = 0 := by
          by_contra hn
          obtain ⟨i, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hn
          apply hdiv
          rw [pow_succ]
          exact Dvd.intro_left (p ^ i) rfl
        subst j
        simp only [pow_zero]
        rw [alpha_one]
        split_ifs with hε
        · simp [PowerSeries.coeff_X]
        · simp
      · rw [alpha_of_non_power hpow]
        split_ifs with hε
        · simp only [PowerSeries.coeff_X]
          rw [if_neg]
          intro hm1
          apply hpow
          exact ⟨0, hm1.trans (pow_zero p).symm⟩
        · simp
  exact congrFun (expand_cyclic_unique hFzero hGzero hF hG) δ

#print axioms evalY0_solution

end MMM.Frob
