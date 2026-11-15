/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
The lower weight bound for the cyclic Frobenius system and its divisibility corollary.
-/
import MMM.Frob.Special
import MMM.Digits

set_option maxHeartbeats 800000

open MMM

namespace MMM.Frob

/-- Every monomial x^m y^d of f satisfies s_p(m) ≤ (p - 1) d + c: its weight is at least -c. -/
def WB (p c : ℕ) (f : Lambda) : Prop :=
  ∀ m d, (f.coeff m).coeff d ≠ 0 → ds p m ≤ (p - 1) * d + c

variable {p c a b : ℕ} {f g h : Lambda}

theorem WB_zero : WB p c 0 := by
  intro m d h
  simp at h

theorem WB_one : WB p 0 1 := by
  intro m d h
  by_cases hm : m = 0
  · subst m
    simp
  · simp [PowerSeries.coeff_one, hm] at h

theorem WB_X (hp : 2 ≤ p) : WB p 1 (PowerSeries.X : Lambda) := by
  intro m d h
  rw [show m = 1 by
    by_contra hm
    simp [PowerSeries.coeff_X, hm] at h] at *
  simp [ds_one hp] at h ⊢

theorem WB_mono (h : a ≤ b) : WB p a f → WB p b f := by
  intro hf m d hne
  exact (hf m d hne).trans (by omega)

theorem WB_add : WB p c f → WB p c g → WB p c (f + g) := by
  intro hf hg m d hne
  by_cases hfne : (f.coeff m).coeff d = 0
  · have hgne : (g.coeff m).coeff d ≠ 0 := by
      intro hz
      apply hne
      simp [hfne, hz]
    exact hg m d hgne
  · exact hf m d hfne

theorem WB_sub : WB p c f → WB p c g → WB p c (f - g) := by
  intro hf hg m d hne
  by_cases hfne : (f.coeff m).coeff d = 0
  · have hgne : (g.coeff m).coeff d ≠ 0 := by
      intro hz
      apply hne
      simp [hfne, hz]
    exact hg m d hgne
  · exact hf m d hfne

theorem WB_mul (hp : 2 ≤ p) : WB p a f → WB p b g → WB p (a + b) (f * g) := by
  intro hf hg m d hne
  have hprod : ((f * g).coeff m).coeff d =
      ∑ i ∈ Finset.antidiagonal m,
        ∑ j ∈ Finset.antidiagonal d,
          (f.coeff i.1).coeff j.1 * (g.coeff i.2).coeff j.2 := by
    rw [PowerSeries.coeff_mul, Polynomial.finsetSum_coeff]
    apply Finset.sum_congr rfl
    intro i hi
    exact Polynomial.coeff_mul _ _ _
  obtain ⟨⟨m1, m2⟩, hm, hmn⟩ := Finset.exists_ne_zero_of_sum_ne_zero (by rw [← hprod]; exact hne)
  obtain ⟨⟨d1, d2⟩, hd, hdn⟩ := Finset.exists_ne_zero_of_sum_ne_zero hmn
  have hmsum : m1 + m2 = m := Finset.mem_antidiagonal.mp hm
  have hdsum : d1 + d2 = d := Finset.mem_antidiagonal.mp hd
  rcases mul_ne_zero_iff.mp hdn with ⟨hf1, hg1⟩
  have hf' := hf m1 d1 hf1
  have hg' := hg m2 d2 hg1
  have hfinal := ds_add_le hp m1 m2
  have hdmul : (p - 1) * (d1 + d2) = (p - 1) * d1 + (p - 1) * d2 := Nat.mul_add _ _ _
  rw [← hmsum, ← hdsum, hdmul]
  omega

theorem WB_pow (hp : 2 ≤ p) : WB p a f → ∀ n, WB p (n * a) (f ^ n) := by
  intro hf n
  induction n with
  | zero => simpa using WB_one (p := p)
  | succ n ih =>
    rw [Nat.succ_mul, pow_succ]
    exact WB_mul hp ih hf

theorem WB_frobeniusLift [Fact p.Prime] : WB p c f →
    WB p c (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) := by
  intro hf m d hne
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hp0 : 0 < p := by omega
  simp only [frobeniusLiftRingHom, RingHom.coe_mk, MonoidHom.coe_mk, OneHom.coe_mk] at hne
  rw [PowerSeries.coeff_expand] at hne
  split_ifs at hne with hdiv
  · rw [PowerSeries.coeff_map] at hne
    change ((Polynomial.expand ℤ p) (f.coeff (m / p))).coeff d ≠ 0 at hne
    rw [Polynomial.coeff_expand hp0] at hne
    obtain ⟨m0, rfl⟩ := hdiv
    split_ifs at hne with hddiv
    · obtain ⟨d0, rfl⟩ := hddiv
      rw [Nat.mul_div_cancel_left _ hp0, Nat.mul_div_cancel_left _ hp0] at hne
      have h := hf m0 d0 hne
      rw [ds_base_mul hp]
      have hmul : (p - 1) * (p * d0) = p * ((p - 1) * d0) := by ring
      rw [hmul]
      have hx : p * ((p - 1) * d0) = ((p - 1) * d0) + (p - 1) * ((p - 1) * d0) := by
        calc p * ((p - 1) * d0) = (1 + (p - 1)) * ((p - 1) * d0) := by congr 1; omega
        _ = ((p - 1) * d0) + (p - 1) * ((p - 1) * d0) := by rw [add_mul, one_mul]
      omega
    · simp at hne
  · rw [show (0 : Polynomial ℤ).coeff d = 0 by simp] at hne
    exact absurd rfl hne

theorem WB_theta [Fact p.Prime] : WB p 1 f → WB p p (theta p f) := by
  intro hf m d hne
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hmul : (((p : Lambda) * theta p f).coeff m).coeff d ≠ 0 := by
    rw [coeff_natCast_mul]
    exact mul_ne_zero (by exact_mod_cast (Fact.out : p.Prime).ne_zero) hne
  rw [theta_spec] at hmul
  have hpow : WB p p (f ^ p) := by simpa using WB_pow hp hf p
  have hfrob : WB p 1 (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) :=
    WB_frobeniusLift hf
  have hsub : WB p p (f ^ p - frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) :=
    WB_sub hpow (WB_mono (by omega) hfrob)
  exact hsub m d hmul

theorem WB_C_X_mul : WB p (c + (p - 1)) h → WB p c (PowerSeries.C Polynomial.X * h) := by
  intro hw m d hne
  rw [PowerSeries.coeff_C_mul] at hne
  by_cases hd : d = 0
  · subst d
    rw [Polynomial.coeff_X_mul_zero] at hne
    exact absurd rfl hne
  · obtain ⟨d0, rfl⟩ : ∃ d0, d = d0 + 1 := ⟨d - 1, by omega⟩
    rw [Polynomial.coeff_X_mul] at hne
    have h := hw m d0 hne
    have hmul : (p - 1) * (d0 + 1) = (p - 1) * d0 + (p - 1) := by ring
    rw [hmul]
    omega

theorem WB_cyclicRHS [Fact p.Prime] (F : ZMod k → Lambda) (hF : ∀ δ, WB p 1 (F δ))
    (δ : ZMod k) : WB p 1 (cyclicRHS p F δ) := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hhead : WB p 1 (if δ = 0 then PowerSeries.X else 0) := by
    split_ifs
    · exact WB_X hp
    · exact WB_zero
  have hphi : WB p 1 (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero (F (δ + 1))) :=
    WB_frobeniusLift (hF (δ + 1))
  have hthet : WB p p (theta p (F (δ + 1))) := WB_theta (hF (δ + 1))
  have hytheta : WB p 1 (PowerSeries.C Polynomial.X * theta p (F (δ + 1))) := by
    apply WB_C_X_mul
    exact WB_mono (by omega) hthet
  exact WB_add (WB_add hhead hphi) hytheta

/-- The note's Lemma "Lower bound": every monomial of F_δ has weight at least -1. -/
theorem weight_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) :
    WB p 1 (solution p k δ) := by
  have hiter : ∀ n : ℕ, ∀ δ : ZMod k, WB p 1 (iter p k n δ) := by
    intro n
    induction n with
    | zero => intro δ; exact WB_zero
    | succ n ih => intro δ; exact WB_cyclicRHS _ ih δ
  intro m d hne
  rw [coeff_solution] at hne
  exact hiter (m + 1) δ m d hne

/-- The note's Corollary: y^t divides the coefficient of x^m, and p^t divides its value at y = p. -/
theorem X_pow_dvd_coeff_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m t : ℕ)
    (ht : ds p m = (p - 1) * t + 1) : (Polynomial.X : Polynomial ℤ) ^ t ∣ (solution p k δ).coeff m := by
  rw [Polynomial.X_pow_dvd_iff]
  intro d hd
  by_contra hne
  have hne : ((solution p k δ).coeff m).coeff d ≠ 0 := by
    simpa only [decide_not] using hne
  have h := weight_solution p k δ m d hne
  rw [ht] at h
  have hmul : (p - 1) * d ≤ (p - 1) * t := Nat.mul_le_mul_left (p - 1) (Nat.le_of_lt hd)
  have hle : (p - 1) * t + 1 ≤ (p - 1) * d + 1 := h
  have hle2 : (p - 1) * d + 1 ≤ (p - 1) * t + 1 := Nat.add_le_add_right hmul 1
  have : (p - 1) * d + 1 = (p - 1) * t + 1 := Nat.le_antisymm hle2 hle
  have hds : (p - 1) * d = (p - 1) * t := Nat.add_right_cancel this
  have hcast : (p - 1 : ℕ) > 0 := by
    have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
    omega
  exact (Nat.not_le_of_gt hd (Nat.le_of_mul_le_mul_left (by omega) hcast)).elim

theorem pow_dvd_coeff_evalY_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m t : ℕ)
    (ht : ds p m = (p - 1) * t + 1) : (p : ℤ) ^ t ∣ (evalY p (solution p k δ)).coeff m := by
  obtain ⟨r, hr⟩ := X_pow_dvd_coeff_solution p k δ m t ht
  have heval : (evalY p (solution p k δ)).coeff m =
      Polynomial.eval (p : ℤ) ((solution p k δ).coeff m) := by simp [evalY]
  rw [heval, hr, Polynomial.eval_mul, Polynomial.eval_pow, Polynomial.eval_X]
  exact dvd_mul_right _ _

#print axioms pow_dvd_coeff_evalY_solution

end MMM.Frob