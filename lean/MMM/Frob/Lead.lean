/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Leading coefficients and carry-free products for the Frobenius proof.
-/
import MMM.Frob.YZero
import MMM.Frob.Weight
import MMM.Frob.TreeGF
import Mathlib.RingTheory.PowerSeries.Basic

set_option maxHeartbeats 800000

open MMM

namespace MMM.Frob

open Classical

/-- The coefficient of the monomial of weight -1 at x^m. -/
noncomputable def lead (p : ℕ) (f : Lambda) (m : ℕ) : ℤ :=
  if 0 < m ∧ (p - 1) ∣ (ds p m - 1) then
    (f.coeff m).coeff ((ds p m - 1) / (p - 1))
  else 0

/-- Carry-free p-fold product. -/
def cfpow (p : ℕ) (g : ℕ → ℤ) (m : ℕ) : ℤ :=
  ∑ c ∈ (Finset.Nat.antidiagonalTuple p m).filter (fun c => ∑ i, ds p (c i) = ds p m),
    ∏ i, g (c i)

variable {p m : ℕ} {f g : Lambda}

theorem ds_pos_eq_one (hp : 2 ≤ p) (m : ℕ) (hm : ds p m = 1) : 0 < m := by
  by_contra h
  have hm0 : m = 0 := by omega
  rw [hm0, ds_zero] at hm
  omega

/-- A positive natural number of digit sum one is a power of the base. -/
theorem eq_pow_of_ds_eq_one (hp : 2 ≤ p) (m : ℕ) (hm : ds p m = 1) : ∃ j : ℕ, m = p ^ j := by
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    have hmpos : 0 < m := ds_pos_eq_one hp m hm
    by_cases hlt : m < p
    · rw [ds_of_lt hp hlt] at hm
      exact ⟨0, hm.trans (pow_zero p).symm⟩
    · have hq : 0 < m / p := Nat.div_pos (by omega) (by omega)
      have hrec := ds_rec hp m
      have hqds : ds p (m / p) = 1 := by
        have hds := ds_pos hp _ hq
        omega
      obtain ⟨j, hj⟩ := ih (m / p) (Nat.div_lt_self hmpos (by omega)) hqds
      have hmod : m % p = 0 := by omega
      have hdm : p * (m / p) = m := Nat.mul_div_cancel' (Nat.dvd_of_mod_eq_zero hmod)
      exact ⟨j + 1, by rw [← hdm, hj, pow_succ, mul_comm]⟩

@[simp] theorem ds_pow (hp : 2 ≤ p) (j : ℕ) : ds p (p ^ j) = 1 := by
  induction j with
  | zero => simpa using ds_one hp
  | succ j ih => rw [pow_succ, mul_comm, ds_base_mul hp, ih]

theorem lead_add : lead p (f + g) m = lead p f m + lead p g m := by
  unfold lead
  split_ifs <;> simp

theorem lead_X (hp : 2 ≤ p) : lead p (PowerSeries.X : Lambda) m = if m = 1 then 1 else 0 := by
  by_cases hm : m = 1
  · subst m
    rw [if_pos rfl]
    unfold lead
    rw [if_pos]
    · simp [ds_one hp]
    · refine ⟨by omega, ?_⟩
      rw [ds_one hp]
      exact dvd_zero _
  · rw [if_neg hm]
    unfold lead
    split_ifs
    · simp [PowerSeries.coeff_X, hm]
    · rfl

theorem coeff_frobeniusLift [Fact p.Prime] (f : Lambda) (m d : ℕ) :
    ((frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff m).coeff d =
      if p ∣ m ∧ p ∣ d then (f.coeff (m / p)).coeff (d / p) else 0 := by
  simp only [frobeniusLiftRingHom, RingHom.coe_mk, MonoidHom.coe_mk, OneHom.coe_mk]
  rw [PowerSeries.coeff_expand]
  by_cases hm : p ∣ m
  · rw [if_pos hm]
    by_cases hd : p ∣ d
    · rw [if_pos ⟨hm, hd⟩, PowerSeries.coeff_map]
      change ((Polynomial.expand ℤ p) (f.coeff (m / p))).coeff d = _
      rw [Polynomial.coeff_expand (Fact.out : p.Prime).pos, if_pos hd]
    · rw [if_neg (fun h => hd h.2), PowerSeries.coeff_map]
      change ((Polynomial.expand ℤ p) (f.coeff (m / p))).coeff d = 0
      rw [Polynomial.coeff_expand (Fact.out : p.Prime).pos, if_neg hd]
  · rw [if_neg hm, if_neg (fun h => hm h.1)]
    simp

theorem lead_frobeniusLift [Fact p.Prime] (hf : WB p 1 f) (M : ℕ) :
    lead p (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f) M =
      if ∃ j : ℕ, M = p ^ (j + 1) then (f.coeff (M / p)).coeff 0 else 0 := by
  classical
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hp0 : 0 < p := by omega
  by_cases hpow : ∃ j : ℕ, M = p ^ (j + 1)
  · obtain ⟨j, rfl⟩ := hpow
    have hm : 0 < p ^ (j + 1) := pow_pos hp0 _
    have hdiv : p - 1 ∣ ds p (p ^ (j + 1)) - 1 := by simp [ds_pow hp]
    have hdvd : p ∣ p ^ (j + 1) := by rw [pow_succ]; exact Dvd.intro_left _ rfl
    have hq : p ^ (j + 1) / p = p ^ j := by
      rw [pow_succ, mul_comm]
      exact Nat.mul_div_cancel_left _ hp0
    rw [show p ^ (j + 1) / p = p ^ j by exact hq]
    unfold lead
    rw [if_pos (show ∃ i : ℕ, p ^ (j + 1) = p ^ (i + 1) from ⟨j, rfl⟩)]
    rw [if_pos ⟨hm, hdiv⟩, ds_pow hp]
    simp only [Nat.sub_self, Nat.zero_div, coeff_frobeniusLift, hq]
    simp
  · rw [if_neg hpow]
    unfold lead
    split_ifs with hc
    · obtain ⟨hm, hdiv⟩ := hc
      rw [coeff_frobeniusLift]
      split_ifs with h
      · obtain ⟨hM, hd⟩ := h
        let d := (ds p M - 1) / (p - 1)
        by_cases hne : ((f.coeff (M / p)).coeff (d / p)) = 0
        · exact hne
        exfalso
        have hb := hf (M / p) (d / p) hne
        rw [← ds_base_mul hp (M / p), Nat.mul_div_cancel' hM] at hb
        obtain ⟨a, ha⟩ := hdiv
        have hdval : d = a := by
          dsimp [d]
          rw [ha, Nat.mul_div_cancel_left _ (by omega : 0 < p - 1)]
        have hds : ds p M = (p - 1) * a + 1 := by
          have hs : 1 ≤ ds p M := ds_pos hp M hm
          omega
        have hdvd' : p ∣ a := by rwa [← hdval]
        have hdiv' : a = a / p * p := (Nat.div_mul_cancel hdvd').symm
        have hb' : ds p M ≤ (p - 1) * (a / p) + 1 := by rwa [hdval] at hb
        rw [hds, hdiv'] at hb'
        have hdivid : a / p * p / p = a / p := by
          rw [mul_comm]
          exact Nat.mul_div_cancel_left _ hp0
        rw [hdivid] at hb'
        have hin : (p - 1) * (a / p) * p + 1 ≤ (p - 1) * (a / p) + 1 := by
          simpa [mul_comm, mul_left_comm, mul_assoc] using hb'
        have hq : a / p = 0 := by
          have hp1 : 1 ≤ p - 1 := by omega
          have hmul : (p - 1) * (a / p) * 2 ≤ (p - 1) * (a / p) * p :=
            Nat.mul_le_mul_left ((p - 1) * (a / p)) hp
          nlinarith [Nat.zero_le ((p - 1) * (a / p))]
        have hdzero : a = 0 := by rw [← Nat.div_mul_cancel hdvd', hq, zero_mul]
        rw [hdzero] at hdval
        have hsmul : ds p M = ds p (M / p) := by
          rw [← ds_base_mul hp (M / p), Nat.mul_div_cancel' hM]
        have hds0 : ds p M = 1 := by rw [hds, hdzero]; simp
        have hqds : ds p (M / p) = 1 := hsmul.symm.trans hds0
        obtain ⟨j, hj⟩ := eq_pow_of_ds_eq_one hp (M / p) hqds
        exact (hpow ⟨j, by rw [← Nat.div_mul_cancel hM, hj, pow_succ]⟩).elim

      · rfl
    · rfl


lemma coe_prod_coeff {ι : Type*} [Fintype ι] (F : ι → Polynomial ℤ) (a : ℕ) :
    (∏ i, F i).coeff a = (PowerSeries.coeff a) (∏ i, (F i : PowerSeries ℤ)) := by
  rw [← Polynomial.coeff_coe]
  congr 1
  exact map_prod Polynomial.coeToPowerSeries.ringHom F Finset.univ

lemma prod_coeff_tuple {R : Type*} [CommSemiring R] (p a : ℕ)
    (F : Fin p → PowerSeries R) :
    PowerSeries.coeff a (∏ i, F i) = ∑ d : {d : Fin p → ℕ // ∑ i, d i = a},
      ∏ i, PowerSeries.coeff (d.1 i) (F i) := by
  letI := fintypeTupleSum p a
  rw [show (∏ i, F i) = ∏ i ∈ Finset.univ, F i by simp, PowerSeries.coeff_prod]
  let g : (Fin p → ℕ) → R := fun u => ∏ i, PowerSeries.coeff (u i) (F i)
  calc
    (∑ l ∈ (Finset.univ : Finset (Fin p)).finsuppAntidiag a,
        ∏ i ∈ (Finset.univ : Finset (Fin p)),
          PowerSeries.coeff (l i) (F i)) =
        ∑ l ∈ ((Finset.univ : Finset (Fin p)).finsuppAntidiag a).attach, g (fun i : Fin p => l.1 i) := by
      rw [← Finset.sum_attach]
    _ = ∑ d : {d : Fin p → ℕ // ∑ i, d i = a}, g d.1 := by
      let e : {l : (Fin p →₀ ℕ) // l ∈ (Finset.univ : Finset (Fin p)).finsuppAntidiag a} ≃
          {d : Fin p → ℕ // ∑ i, d i = a} :=
        { toFun := fun l => ⟨fun i : Fin p => l.1 i, (Finset.mem_finsuppAntidiag.mp l.2).1.trans (by simp)⟩
          invFun := fun d => ⟨Finsupp.equivFunOnFinite.symm d.1, by
            simpa [Finset.mem_finsuppAntidiag] using d.2⟩
          left_inv := by
            intro l
            apply Subtype.ext
            exact Finsupp.equivFunOnFinite.symm_apply_apply l.1
          right_inv := by
            intro d
            apply Subtype.ext
            exact Finsupp.equivFunOnFinite.apply_symm_apply d.1 }
      exact Fintype.sum_equiv e _ _ (fun l => rfl)
    _ = _ := rfl

lemma polynomial_prod_coeff_tuple (p a : ℕ) (F : Fin p → Polynomial ℤ) :
    (∏ i, F i).coeff a = ∑ d : {d : Fin p → ℕ // ∑ i, d i = a},
      ∏ i, (F i).coeff (d.1 i) := by
  letI := fintypeTupleSum p a
  rw [coe_prod_coeff]
  have heq : (∏ i, (F i : PowerSeries ℤ)) =
      ∏ i, (PowerSeries.mk fun n => (F i).coeff n : PowerSeries ℤ) := by
    congr with i
  rw [heq, prod_coeff_tuple]
  simp

lemma lead_zero (n : ℕ) : lead p f n = 0 ↔
    ¬(0 < n ∧ (p - 1) ∣ ds p n - 1) ∨
      (f.coeff n).coeff ((ds p n - 1) / (p - 1)) = 0 := by
  unfold lead
  split_ifs with h
  · simp [h]
  · simp [h]

lemma lead_ne_zero_ds (hp : 2 ≤ p) (hlead : lead p f n ≠ 0) :
    0 < n ∧ ds p n = (p - 1) * ((ds p n - 1) / (p - 1)) + 1 := by
  have hcond : 0 < n ∧ (p - 1) ∣ ds p n - 1 := by
    by_contra h
    exact hlead (by simp [lead, h])
  obtain ⟨hm, hd⟩ := hcond
  obtain ⟨t, ht⟩ := hd
  have hspos : 0 < ds p n := ds_pos hp n hm
  have hdiv : (ds p n - 1) / (p - 1) = t := by
    rw [ht, Nat.mul_div_cancel_left _ (by omega)]
  exact ⟨hm, by rw [hdiv]; omega⟩

lemma lead_eq_coeff_of_digit_sum (hp : 2 ≤ p) (n : ℕ)
    (hd : ds p n = (p-1)*((ds p n-1)/(p-1))+1) :
    lead p f n = (f.coeff n).coeff ((ds p n-1)/(p-1)) := by
  have hn : 0 < n := by
    by_contra h
    have h0 : n = 0 := by omega
    rw [h0, ds_zero] at hd
    simp at hd
  have hspos : 0 < ds p n := ds_pos hp n hn
  have hs : ds p n-1 = (p-1)*((ds p n-1)/(p-1)) := by omega
  rw [lead, if_pos ⟨hn, ⟨_, hs⟩⟩]

lemma coeff_pow_double_tuple (f : Lambda) (m D : ℕ) :
    (((f ^ p).coeff m).coeff D) =
      ∑ c : {c : Fin p → ℕ // ∑ i, c i = m},
        ∑ d : {d : Fin p → ℕ // ∑ i, d i = D},
          ∏ i, (f.coeff (c.1 i)).coeff (d.1 i) := by
  letI := fintypeTupleSum p m
  have hx : (f ^ p).coeff m =
      ∑ c : {c : Fin p → ℕ // ∑ i, c i = m},
        ∏ i, f.coeff (c.1 i) := by
    rw [show f ^ p = ∏ i : Fin p, f by simp, prod_coeff_tuple]
  rw [hx, Polynomial.finsetSum_coeff]
  apply Finset.sum_congr rfl
  intro c _
  exact polynomial_prod_coeff_tuple p D _

lemma sub_one_eq_mul_of_eq_mul_add_self {p T : ℕ} (hp : 1 ≤ p) (s : ℕ)
    (hs : s = (p - 1) * T + p) : s - 1 = (p - 1) * (T + 1) := by
  have h : p = (p-1)+1 := (Nat.sub_add_cancel hp).symm
  calc
    s-1 = ((p-1)*T+p)-1 := congrArg (·-1) hs
    _ = ((p-1)*T+((p-1)+1))-1 := by rw [← h]
    _ = (p-1)*T+(p-1) := by rw [← Nat.add_assoc, Nat.add_sub_cancel]
    _ = (p-1)*(T+1) := by rw [Nat.mul_add, Nat.mul_one]

lemma cfpow_eq_zero (hp : 2 ≤ p) (g : ℕ → ℤ)
    (hg : ∀ n, g n ≠ 0 → 0 < n ∧
      ds p n = (p - 1) * ((ds p n - 1) / (p - 1)) + 1)
    (hm : ¬(0 < m ∧ (p - 1) ∣ ds p m - 1)) : cfpow p g m = 0 := by
  unfold cfpow
  apply Finset.sum_eq_zero
  intro c hc
  by_contra hne
  have hn := Finset.prod_ne_zero_iff.mp hne
  rw [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple] at hc
  have hci : ∀ i, 0 < c i ∧
      ds p (c i) = (p - 1) * ((ds p (c i) - 1) / (p - 1)) + 1 :=
    fun i => hg _ (hn i (Finset.mem_univ i))
  have hds : ds p m = (p - 1) * (∑ i, (ds p (c i) - 1) / (p - 1)) + p := by
    calc
      ds p m = ∑ i, ds p (c i) := hc.2.symm
      _ = ∑ i, ((p - 1) * ((ds p (c i) - 1) / (p - 1)) + 1) :=
        Finset.sum_congr rfl (fun i _ => (hci i).2)
      _ = _ := by rw [Finset.sum_add_distrib, ← Finset.mul_sum]; simp
  apply hm
  let i0 : Fin p := ⟨0, by omega⟩
  have hc_le : c i0 ≤ m := by
    rw [← hc.1]
    exact Finset.single_le_sum (fun i _ => Nat.zero_le _) (Finset.mem_univ i0)
  refine ⟨by have hi := (hci i0).1; omega, ?_⟩
  have hsub : ds p m - 1 = (p - 1) * ((∑ i, (ds p (c i) - 1) / (p - 1)) + 1) :=
    sub_one_eq_mul_of_eq_mul_add_self (by omega) _ hds
  rw [hsub]
  exact Dvd.intro _ rfl


lemma tuple_coefficients_of_ne_zero (hp : 2 ≤ p) (hf : WB p 1 f)
    (hf0 : HasZeroConstant f) (mc dc : Fin p → ℕ) (m D : ℕ)
    (hmc : ∑ i, mc i = m) (hdc : ∑ i, dc i = D)
    (hds : ds p m = (p - 1) * D + p)
    (hne : ∏ i, (f.coeff (mc i)).coeff (dc i) ≠ 0) :
    (∑ i, ds p (mc i)) = ds p m ∧ ∀ i, ds p (mc i) = (p - 1) * dc i + 1 := by
  have hn := Finset.prod_ne_zero_iff.mp hne
  have hpos : ∀ i, 0 < mc i := by
    intro i
    by_contra hi
    have hi0 : mc i = 0 := by omega
    have hz := hn i (Finset.mem_univ i)
    rw [hi0] at hz
    rw [show f.coeff 0 = 0 from hf0] at hz
    simp at hz
  have hw : ∀ i, ds p (mc i) ≤ (p - 1) * dc i + 1 :=
    fun i => hf _ _ (hn i (Finset.mem_univ i))
  have hlo : ∀ i, 1 ≤ ds p (mc i) := fun i => ds_pos hp _ (hpos i)
  have hle : (∑ i, ds p (mc i)) ≤ (p - 1) * D + p := by
    calc
      (∑ i, ds p (mc i)) ≤ ∑ i, ((p - 1) * dc i + 1) :=
        Finset.sum_le_sum (fun i _ => hw i)
      _ = (p - 1) * D + p := by rw [Finset.sum_add_distrib, ← Finset.mul_sum, hdc]; simp
  have hge : (p - 1) * D + p ≤ ∑ i, ds p (mc i) := by
    rw [← hds, ← hmc]
    exact ds_sum_le hp _ _
  have heq : (∑ i, ds p (mc i)) = (p - 1) * D + p := Nat.le_antisymm hle hge
  have hsl : ∑ i, ((p - 1) * dc i + 1 - ds p (mc i)) = 0 := by
    rw [Finset.sum_tsub_distrib _ (fun i _ => hw i)]
    have hs : ∑ i, ((p - 1) * dc i + 1) = (p - 1) * D + p := by
      rw [Finset.sum_add_distrib, ← Finset.mul_sum, hdc]
      simp
    rw [hs, heq, Nat.sub_self]
  have hz := (Finset.sum_eq_zero_iff_of_nonneg (fun i _ => Nat.zero_le _)).mp hsl
  have hdseq : ∀ i, ds p (mc i) = (p - 1) * dc i + 1 := by
    intro i
    have hi := hz i (Finset.mem_univ i)
    have hi' := hw i
    omega
  exact ⟨by rw [heq, hds], hdseq⟩

lemma carryFree_tuple_coefficients_of_ne_zero (hp : 2 ≤ p) (hf : WB p 1 f)
    (hf0 : HasZeroConstant f) (mc : Fin p → ℕ) (hc : ∑ i, mc i = m)
    (hdfs : ∑ i, ds p (mc i) = ds p m) (hds : ds p m = (p - 1) * D + p)
    (hne : ∏ i, lead p f (mc i) ≠ 0) :
    (∑ dc : {dc : Fin p → ℕ // ∑ i, dc i = D},
        ∏ i, (f.coeff (mc i)).coeff (dc.1 i)) = ∏ i, lead p f (mc i) := by
  letI : Fintype {dc : Fin p → ℕ // ∑ i, dc i = D} := fintypeTupleSum p D
  let d0 : Fin p → ℕ := fun i => (ds p (mc i) - 1) / (p - 1)
  have heds : ∀ i, ds p (mc i) = (p - 1) * d0 i + 1 := by
    intro i
    exact (lead_ne_zero_ds hp (Finset.prod_ne_zero_iff.mp hne i (Finset.mem_univ i))).2
  have hsum : ∑ i, d0 i = D := by
    have hs : (p-1) * (∑ i, d0 i) + p = (p-1)*D+p := by
      calc
        (p-1) * (∑ i, d0 i) + p = ∑ i, ((p-1)*d0 i+1) := by
          rw [Finset.sum_add_distrib, ← Finset.mul_sum]
          simp
        _ = ∑ i, ds p (mc i) := Finset.sum_congr rfl (fun i _ => (heds i).symm)
        _ = (p-1)*D+p := hdfs.trans hds
    have hmul : (p-1)*(∑ i, d0 i) = (p-1)*D := Nat.add_right_cancel hs
    exact Nat.eq_of_mul_eq_mul_left (by omega) hmul
  let dc0 : {dc : Fin p → ℕ // ∑ i, dc i = D} := ⟨d0, hsum⟩
  have hother : ∀ dc : {dc : Fin p → ℕ // ∑ i, dc i = D}, dc ≠ dc0 →
      ∏ i, (f.coeff (mc i)).coeff (dc.1 i) = 0 := by
    intro dc hdc
    by_contra hne'
    have h := tuple_coefficients_of_ne_zero hp hf hf0 mc dc.1 m D hc dc.2 hds hne'
    apply hdc
    apply Subtype.ext
    funext i
    have hi := h.2 i
    change dc.1 i = d0 i
    have heq : (p-1) * dc.1 i = (p-1) * d0 i := Nat.add_right_cancel (hi.symm.trans (heds i))
    exact Nat.eq_of_mul_eq_mul_left (by omega) heq
  calc
    (∑ dc : {dc : Fin p → ℕ // ∑ i, dc i = D},
        ∏ i, (f.coeff (mc i)).coeff (dc.1 i)) = ∏ i, (f.coeff (mc i)).coeff (dc0.1 i) :=
      Fintype.sum_eq_single dc0 hother
    _ = _ := by
      apply Finset.prod_congr rfl
      intro i _
      have hi := (lead_ne_zero_ds hp (Finset.prod_ne_zero_iff.mp hne i
        (Finset.mem_univ i))).1
      have hs : ds p (mc i)-1 = (p-1)*d0 i := by rw [heds i, Nat.add_sub_cancel]
      have hdiv : p-1 ∣ ds p (mc i)-1 := ⟨d0 i, hs⟩
      rw [lead, if_pos ⟨hi, hdiv⟩, hs, Nat.mul_div_cancel_left _ (by omega)]
lemma coeff_frobenius_lift_lower [Fact p.Prime] (hf : WB p 1 f)
    (m D : ℕ) (hD : ds p m > (p-1)*D+1) :
    ((frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff m).coeff D = 0 := by
  by_contra hne
  exact (Nat.not_le_of_gt hD) (WB_frobeniusLift hf m D hne)

lemma coeff_Y_mul_theta (hp : 2 ≤ p) [Fact p.Prime] (hf : WB p 1 f)
    (hf0 : HasZeroConstant f) (m D : ℕ) (hds : ds p m = (p-1)*D+p) :
    (p : ℤ) * (((PowerSeries.C Polynomial.X * theta p f).coeff m).coeff (D+1)) =
      ((f^p).coeff m).coeff D := by
  have htheta := congrArg (fun s : Lambda => (s.coeff m).coeff D) (theta_spec p f)
  rw [coeff_natCast_mul] at htheta
  have hfrob : ((frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero f).coeff m).coeff D = 0 :=
    coeff_frobenius_lift_lower hf m D (by omega)
  have hpval : (p : ℤ) * ((theta p f).coeff m).coeff D = ((f^p).coeff m).coeff D := by
    simpa [hfrob] using htheta
  rw [← hpval]
  simp [Polynomial.coeff_X_mul]
lemma tuple_sum_eq_finset {p m : ℕ}
    (q : {c : Fin p → ℕ // ∑ i, c i = m} → ℤ) :
    (∑ c : {c : Fin p → ℕ // ∑ i, c i = m}, q c) =
      ∑ c ∈ Finset.Nat.antidiagonalTuple p m,
        if h : ∑ i, c i = m then q ⟨c, h⟩ else 0 := by
  letI := fintypeTupleSum p m
  symm
  calc
    (∑ c ∈ Finset.Nat.antidiagonalTuple p m, if h : ∑ i, c i = m then q ⟨c, h⟩ else 0) =
      ∑ c : {c : Fin p → ℕ // ∑ i, c i = m},
        if h : ∑ i, c.1 i = m then q ⟨c.1, h⟩ else 0 :=
      Finset.sum_subtype (Finset.Nat.antidiagonalTuple p m)
        (fun c => ⟨Finset.Nat.mem_antidiagonalTuple.mp, Finset.Nat.mem_antidiagonalTuple.mpr⟩) _
    _ = _ := by apply Finset.sum_congr rfl; intro c _; rw [dif_pos c.2]

lemma coeff_pow_leading (hp : 2 ≤ p) [Fact p.Prime] (hf : WB p 1 f) (hf0 : HasZeroConstant f)
    (m D : ℕ) (hds : ds p m = (p-1)*D+p) :
    ((f^p).coeff m).coeff D = cfpow p (lead p f) m := by
  classical
  letI := fintypeTupleSum p m
  letI := fintypeTupleSum p D
  have hzero : ∀ mc : Fin p → ℕ, ∑ i, mc i = m → ∑ i, ds p (mc i) ≠ ds p m →
      (∑ dc : {dc : Fin p → ℕ // ∑ i, dc i = D},
        ∏ i, (f.coeff (mc i)).coeff (dc.1 i)) = 0 := by
    intro mc hmc hne
    apply Finset.sum_eq_zero
    intro dc _
    by_contra hterm
    exact hne (tuple_coefficients_of_ne_zero hp hf hf0 mc dc.1 m D hmc dc.2 hds hterm).1
  have hcarry : ∀ mc : Fin p → ℕ, ∑ i, mc i = m → ∑ i, ds p (mc i) = ds p m →
      (∑ dc : {dc : Fin p → ℕ // ∑ i, dc i = D},
        ∏ i, (f.coeff (mc i)).coeff (dc.1 i)) = ∏ i, lead p f (mc i) := by
    intro mc hmc hcf
    by_cases hne : ∏ i, lead p f (mc i) = 0
    · obtain ⟨i, hi, hli⟩ := Finset.prod_eq_zero_iff.mp hne
      rw [hne]
      apply Finset.sum_eq_zero
      intro dc _
      by_contra hprod
      have h := tuple_coefficients_of_ne_zero hp hf hf0 mc dc.1 m D hmc dc.2 hds hprod
      have hfac := Finset.prod_ne_zero_iff.mp hprod i hi
      have hi_ds : ds p (mc i) = (p-1)*dc.1 i+1 := h.2 i
      have hs : (ds p (mc i)-1)/(p-1) = dc.1 i := by
        have hs' : ds p (mc i)-1 = (p-1)*dc.1 i := by rw [hi_ds, Nat.add_sub_cancel]
        rw [hs', Nat.mul_div_cancel_left _ (by omega)]
      have hds' : ds p (mc i) = (p-1)*((ds p (mc i)-1)/(p-1))+1 := hs ▸ hi_ds
      have hz : lead p f (mc i) = (f.coeff (mc i)).coeff (dc.1 i) := by
        rw [lead_eq_coeff_of_digit_sum hp (mc i) hds', hs]
      rw [← hz] at hfac
      exact hfac hli
    · exact carryFree_tuple_coefficients_of_ne_zero hp hf hf0 mc hmc hcf hds hne
  have hfinal : (∑ c ∈ Finset.Nat.antidiagonalTuple p m,
        if h : ∑ i, c i = m then ∑ d : {d : Fin p → ℕ // ∑ i, d i = D},
          ∏ i, (f.coeff (c i)).coeff (d.1 i) else 0) =
      ∑ c ∈ (Finset.Nat.antidiagonalTuple p m).filter
        (fun c => ∑ i, ds p (c i) = ds p m), ∏ i, lead p f (c i) := by
    rw [Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro mc hm
    have hsum := Finset.Nat.mem_antidiagonalTuple.mp hm
    rw [dif_pos hsum]
    by_cases hcf : ∑ i, ds p (mc i) = ds p m
    · rw [if_pos hcf, hcarry mc hsum hcf]
    · rw [if_neg hcf, hzero mc hsum hcf]
  unfold cfpow
  rw [coeff_pow_double_tuple, tuple_sum_eq_finset, hfinal]

theorem lead_C_X_mul_theta [Fact p.Prime]
    (hf : WB p 1 f) (hf0 : HasZeroConstant f) (m : ℕ) :
    (p : ℤ) * lead p (PowerSeries.C Polynomial.X * theta p f) m =
      cfpow p (lead p f) m := by
  classical
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  by_cases hm : 0 < m ∧ (p-1) ∣ ds p m -1
  · have heqd : ds p m-1 = (p-1)*((ds p m-1)/(p-1)) :=
      (Nat.mul_div_cancel' hm.2).symm
    by_cases hq : (ds p m-1)/(p-1) = 0
    · have hyz : (((PowerSeries.C Polynomial.X * theta p f).coeff m).coeff 0) = 0 := by
        rw [PowerSeries.coeff_C_mul]
        exact Polynomial.coeff_X_mul_zero _
      have hzero : cfpow p (lead p f) m = 0 := by
        unfold cfpow
        apply Finset.sum_eq_zero
        intro c hc
        by_contra hne
        have hn := Finset.prod_ne_zero_iff.mp hne
        rw [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple] at hc
        have hci : ∀ i, ds p (c i) = (p-1)*((ds p (c i)-1)/(p-1))+1 :=
          fun i => (lead_ne_zero_ds hp (hn i (Finset.mem_univ i))).2
        have hds : ds p m = (p-1)*(∑ i, (ds p (c i)-1)/(p-1))+p := by
          calc
            ds p m = ∑ i, ds p (c i) := hc.2.symm
            _ = ∑ i, ((p-1)*((ds p (c i)-1)/(p-1))+1) :=
              Finset.sum_congr rfl (fun i _ => hci i)
            _ = _ := by rw [Finset.sum_add_distrib, ← Finset.mul_sum]; simp
        rw [hq, mul_zero] at heqd
        omega
      rw [lead, if_pos hm, hq, hyz, mul_zero, hzero]
    · have hd : (ds p m-1)/(p-1) = ((ds p m-1)/(p-1)-1)+1 := by
        have hqpos : 0 < (ds p m-1)/(p-1) := Nat.pos_of_ne_zero hq
        omega
      have hds : ds p m = (p-1)*((ds p m-1)/(p-1)-1)+p := by
        rw [hd, Nat.mul_add, Nat.mul_one] at heqd
        have hsp : 0 < ds p m := ds_pos hp m hm.1
        have hps : p-1+1 = p := by omega
        omega
      rw [lead, if_pos hm, hd]
      rw [coeff_Y_mul_theta hp hf hf0 m _ hds]
      exact coeff_pow_leading hp hf hf0 m _ hds
  · rw [lead, if_neg hm, mul_zero]
    exact (cfpow_eq_zero hp (lead p f) (fun n hn => lead_ne_zero_ds hp hn) hm).symm


lemma alpha_eq_indicator_add_shift {p k m : ℕ} [Fact p.Prime] (δ : ZMod k) :
    (if m = 1 then if δ = 0 then (1 : ℤ) else 0 else 0) +
      (if ∃ j : ℕ, m = p^(j+1) then alpha p k (δ+1) (m/p) else 0) =
        alpha p k δ m := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hone : ¬∃ j : ℕ, (1 : ℕ) = p ^ (j + 1) := by
    rintro ⟨j, hj⟩
    have h2 : 2 ≤ p ^ (j + 1) := by
      calc 2 ≤ p := hp
        _ = p ^ 1 := (pow_one p).symm
        _ ≤ p ^ (j + 1) := Nat.pow_le_pow_right (by omega) (by omega)
    omega
  by_cases hm : m = 1
  · subst hm
    rw [if_pos rfl, if_neg hone, add_zero, alpha_one]
  · rw [if_neg hm, zero_add]
    by_cases hpow : ∃ j : ℕ, m = p ^ (j + 1)
    · rw [if_pos hpow]
      obtain ⟨j, rfl⟩ := hpow
      have hq : p ^ (j + 1) / p = p ^ j := by
        rw [pow_succ, mul_comm]
        exact Nat.mul_div_cancel_left _ (by omega)
      rw [hq, alpha_expand_succ]
    · rw [if_neg hpow]
      refine (alpha_of_non_power ?_).symm
      rintro ⟨j, hj⟩
      cases j with
      | zero => exact hm (by simpa using hj)
      | succ j => exact hpow ⟨j, hj⟩

/-- The note's Lemma "Leading part" (ii), in integers: p·ℓ_δ = p·α_δ + ℓ_(δ+1) to the carry-free
p-th power. (Finished by the orchestrator, Claude Fable 5.2, after the worker was cut off.) -/
theorem lead_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m : ℕ) :
    (p : ℤ) * lead p (solution p k δ) m =
      (p : ℤ) * alpha p k δ m + cfpow p (lead p (solution p k (δ + 1))) m := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hcy : lead p (solution p k δ) m =
      lead p (if δ = 0 then (PowerSeries.X : Lambda) else 0) m +
        lead p (frobeniusLiftRingHom p (Fact.out : p.Prime).ne_zero (solution p k (δ + 1))) m +
        lead p (PowerSeries.C Polynomial.X * theta p (solution p k (δ + 1))) m := by
    have h := congrArg (fun F => lead p F m) (solution_cyclic p k δ)
    simpa only [cyclicRHS, lead_add] using h
  have hθ := lead_C_X_mul_theta (weight_solution p k (δ + 1))
    (solution_zeroConstant p (δ + 1)) m
  have hφ := lead_frobeniusLift (weight_solution p k (δ + 1)) m
  have hcoef : ∀ j : ℕ,
      ((solution p k (δ + 1)).coeff (p ^ j)).coeff 0 = alpha p k (δ + 1) (p ^ j) := by
    intro j
    have hc := congrArg (PowerSeries.coeff (p ^ j)) (evalY0_solution p k (δ + 1))
    simpa [evalY0, Polynomial.coeff_zero_eq_eval_zero] using hc
  have hX : lead p (if δ = 0 then (PowerSeries.X : Lambda) else 0) m =
      if m = 1 then (if δ = 0 then (1 : ℤ) else 0) else 0 := by
    by_cases hδ : δ = 0
    · rw [if_pos hδ, lead_X hp]
      by_cases hm : m = 1 <;> simp [hm, hδ]
    · rw [if_neg hδ]
      have h0 : lead p (0 : Lambda) m = 0 := by simp [lead]
      rw [h0]
      by_cases hm : m = 1 <;> simp [hm, hδ]
  have hfrob : (if ∃ j : ℕ, m = p ^ (j + 1) then
        ((solution p k (δ + 1)).coeff (m / p)).coeff 0 else 0) =
      if ∃ j : ℕ, m = p ^ (j + 1) then alpha p k (δ + 1) (m / p) else 0 := by
    by_cases hpow : ∃ j : ℕ, m = p ^ (j + 1)
    · rw [if_pos hpow, if_pos hpow]
      obtain ⟨j, rfl⟩ := hpow
      have hq : p ^ (j + 1) / p = p ^ j := by
        rw [pow_succ, mul_comm]
        exact Nat.mul_div_cancel_left _ (Fact.out : p.Prime).pos
      rw [hq]
      exact hcoef j
    · rw [if_neg hpow, if_neg hpow]
  have hai := alpha_eq_indicator_add_shift (p := p) (k := k) (m := m) δ
  rw [hcy, mul_add, mul_add, hθ, hφ, hX, hfrob, ← mul_add, hai]

end MMM.Frob
