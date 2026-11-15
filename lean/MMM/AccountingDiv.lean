/-
Written by Kimi K3.1 Pro (an Open Math OS worker, brief W056b), 2026-11-15. Not human-reviewed.

  **The last step of the accounting proof**: dividing Lemma L1 by Legendre's formula.

  1. `nodes_eq_nu_add`: the number of nodes satisfies `(p - 1) * N + 1 = m` where
     `N = nu p m + t` and `(p - 1) * t + 1 = ds p m`.
  2. `residue_of_L1_of_legendre`: from the L1 congruence and Legendre's formula,
     deduce `C * D ≡ (-p)^t (mod p^(t+1))` where `D = ∏ dig!`.
-/
import MMM.Dwork
import Mathlib.Data.Int.GCD
import Mathlib.RingTheory.Coprime.Basic
import Mathlib.Tactic

namespace MMM

/-- The number of nodes: with `(p - 1) * t + 1 = ds p m`, the number `N = nu p m + t` satisfies
`(p - 1) * N + 1 = m`. -/
theorem nodes_eq_nu_add (p : ℕ) [Fact p.Prime] (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    (p - 1) * (nu p m + t) + 1 = m := by
  have hp2 : 2 ≤ p := (Fact.out : Nat.Prime p).two_le
  have hds_le : ds p m ≤ m := ds_le hp2 m
  have hds_mod : ds p m ≡ m [MOD p - 1] := ds_modEq hp2 m
  have hdvd : (p - 1) ∣ (m - ds p m) := (Nat.modEq_iff_dvd' hds_le).mp hds_mod
  obtain ⟨k, hk⟩ := hdvd
  have hnu : nu p m = ((p - 1) * k) / (p - 1) := by unfold nu; rw [hk]
  have hnu2 : nu p m = k := hnu.trans (Nat.mul_div_cancel_left k (show 0 < p - 1 by omega))
  rw [hnu2]
  calc
    (p - 1) * (k + t) + 1 = (p - 1) * k + ((p - 1) * t + 1) := by rw [mul_add]; ring
    _ = (m - ds p m) + ds p m := by rw [← hk, ← ht]
    _ = m := Nat.sub_add_cancel hds_le

/-- **The last step of the accounting proof.** -/
theorem residue_of_L1_of_legendre (p : ℕ) [Fact p.Prime] (m t C : ℕ)
    (ht : (p - 1) * t + 1 = ds p m)
    (hL1 : (m.factorial : ℤ) * (C : ℤ) ≡
      (-(p : ℤ)) ^ (nu p m + t) [ZMOD (p : ℤ) ^ (nu p m + t + 1)])
    (hLeg : ∃ u : ℕ, m.factorial =
        p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m) :
    (C : ℤ) * ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  classical
  obtain ⟨u, hfact, huc⟩ := hLeg
  have _ht := ht -- used implicitly through ν = nu p m
  have hpne : (p : ℤ) ≠ 0 := by exact_mod_cast (Fact.out : p.Prime).ne_zero
  have hpν_ne : (p : ℤ) ^ nu p m ≠ 0 := pow_ne_zero _ hpne
  set ν := nu p m with hν_def
  set D := (∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) with hD_def
  have hfact' : (m.factorial : ℤ) = (p : ℤ) ^ ν * (D : ℤ) * (u : ℤ) := by
    exact_mod_cast hfact
  -- Step 1: u = (-1)^ν + p * w for some integer w
  have hu : (p : ℤ) ∣ (u : ℤ) - (-1) ^ ν := by
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    push_cast
    rw [huc]
    ring
  obtain ⟨w, hw⟩ := hu
  have hw' : (u : ℤ) = (-1 : ℤ) ^ ν + (p : ℤ) * w := by linarith [hw]
  -- Step 2: cancel p^ν from L1
  obtain ⟨e, he⟩ := Int.modEq_iff_dvd.mp hL1
  rw [hfact'] at he
  have hsplit : (-(p : ℤ)) ^ (ν + t) = (p : ℤ) ^ ν * ((-1 : ℤ) ^ ν * (-(p : ℤ)) ^ t) := by
    rw [pow_add, neg_pow, neg_pow]
    ring
  rw [hsplit] at he
  have hpow : (p : ℤ) ^ (ν + t + 1) = (p : ℤ) ^ ν * (p : ℤ) ^ (t + 1) := by
    have := pow_add (p : ℤ) ν (t + 1)
    linear_combination this
  rw [hpow] at he
  have hcancel : (-1 : ℤ) ^ ν * (-(p : ℤ)) ^ t - ((D : ℤ) * (u : ℤ) * (C : ℤ)) =
      (p : ℤ) ^ (t + 1) * e := by
    have he' : (p : ℤ) ^ ν * ((-1 : ℤ) ^ ν * (-(p : ℤ)) ^ t - ((D : ℤ) * (u : ℤ) * (C : ℤ)))
        = (p : ℤ) ^ ν * ((p : ℤ) ^ (t + 1) * e) := by
      linear_combination he
    exact mul_left_cancel₀ hpν_ne he'
  -- Step 3: p^t ∣ D * u * C
  have hdvd_pt : (p : ℤ) ^ t ∣ (p : ℤ) ^ (t + 1) := pow_dvd_pow _ (Nat.le_succ t)
  have hdvd_negpt : (p : ℤ) ^ t ∣ (-(p : ℤ)) ^ t := ⟨(-1 : ℤ) ^ t, by rw [neg_pow]; ring⟩
  have hpt_dvd_lhs : (p : ℤ) ^ t ∣ ((D : ℤ) * (u : ℤ) * (C : ℤ)) := by
    have h3 : (p : ℤ) ^ t ∣ (p : ℤ) ^ (t + 1) * e :=
      Dvd.dvd.mul_right hdvd_pt e
    have h4 : (p : ℤ) ^ t ∣ (-1 : ℤ) ^ ν * (-(p : ℤ)) ^ t :=
      hdvd_negpt.mul_left _
    have heq : (D : ℤ) * (u : ℤ) * (C : ℤ) =
        (-1 : ℤ) ^ ν * (-(p : ℤ)) ^ t - (p : ℤ) ^ (t + 1) * e := by linarith [hcancel]
    rw [heq]
    exact Dvd.dvd.sub h4 h3
  -- Step 3b: p is coprime to u, so p^t ∣ D * C
  have hcop : IsCoprime (p : ℤ) (u : ℤ) := by
    have hisUnit : IsUnit (u : ZMod p) := by
      rw [huc]
      exact isUnit_one.neg.pow ν
    have hnat := (ZMod.isUnit_iff_coprime u p).mp hisUnit
    have hcp : Nat.Coprime p u := Nat.Coprime.symm hnat
    rw [← Nat.isCoprime_iff_coprime] at hcp
    exact_mod_cast hcp
  have hcop_pt : IsCoprime ((p : ℤ) ^ t) (u : ℤ) := IsCoprime.pow_left hcop
  have hp_dvd_DC : (p : ℤ) ^ t ∣ (D : ℤ) * (C : ℤ) := by
    have hpt : (p : ℤ) ^ t ∣ (u : ℤ) * ((D : ℤ) * (C : ℤ)) := by
      convert hpt_dvd_lhs using 1
      ring
    exact hcop_pt.dvd_of_dvd_mul_left hpt
  -- Step 4: deduce p^(t+1) ∣ (-p)^t - D * C
  -- from hcancel, substituting u = (-1)^ν + p w:
  -- (-1)^ν * (-p)^t - (-1)^ν * (D*C) = p^(t+1)*e + p*w*(D*C)
  have hDUC : (D : ℤ) * (u : ℤ) * (C : ℤ) =
      (-1 : ℤ) ^ ν * ((D : ℤ) * (C : ℤ)) + (p : ℤ) * w * ((D : ℤ) * (C : ℤ)) := by
    rw [hw']
    ring
  -- so (-1)^ν * ((-p)^t - D*C) = p^(t+1) * e + p * w * (D*C)
  have heq : (-1 : ℤ) ^ ν * ((-(p : ℤ)) ^ t - (D : ℤ) * (C : ℤ)) =
      (p : ℤ) ^ (t + 1) * e + (p : ℤ) * w * ((D : ℤ) * (C : ℤ)) := by
    have h := hcancel
    rw [hDUC] at h
    have heq' : (-1 : ℤ) ^ ν * (-(p : ℤ)) ^ t
        - ((-1 : ℤ) ^ ν * ((D : ℤ) * (C : ℤ)) + (p : ℤ) * w * ((D : ℤ) * (C : ℤ))) =
        (p : ℤ) ^ (t + 1) * e := h
    linarith
  -- The RHS is divisible by p^(t+1)
  obtain ⟨k2, hk2⟩ := hp_dvd_DC
  have hdiv : (p : ℤ) ^ (t + 1) ∣
      (p : ℤ) ^ (t + 1) * e + (p : ℤ) * w * ((D : ℤ) * (C : ℤ)) := by
    refine ⟨e + w * k2, ?_⟩
    calc (p : ℤ) ^ (t + 1) * e + (p : ℤ) * w * ((D : ℤ) * (C : ℤ))
        = (p : ℤ) ^ (t + 1) * e + (p : ℤ) * w * ((p : ℤ) ^ t * k2) := by rw [← hk2]
      _ = (p : ℤ) ^ (t + 1) * (e + w * k2) := by rw [pow_succ]; ring
  have hdiv' : (p : ℤ) ^ (t + 1) ∣ (-1 : ℤ) ^ ν * ((-(p : ℤ)) ^ t - (D : ℤ) * (C : ℤ)) :=
    heq ▸ hdiv
  -- Since (-1)^ν is a unit, p^(t+1) ∣ (-p)^t - D*C
  obtain ⟨z, hz⟩ := hdiv'
  refine Int.modEq_iff_dvd.mpr ⟨(-1 : ℤ) ^ ν * z, ?_⟩
  -- Compute: (-p)^t - C*D = (-1)^ν * ((-1)^ν * ((-p)^t - D*C)) = (-1)^ν * (p^(t+1) * z)
  have h : (-(p : ℤ)) ^ t - (C : ℤ) * (D : ℤ) =
      (-1 : ℤ) ^ ν * ((-1 : ℤ) ^ ν * ((-(p : ℤ)) ^ t - (D : ℤ) * (C : ℤ))) := by
    have h2 : (-1 : ℤ) ^ ν * (-1 : ℤ) ^ ν = 1 := by
      calc
        (-1 : ℤ) ^ ν * (-1 : ℤ) ^ ν = ((-1 : ℤ) * (-1 : ℤ)) ^ ν := by rw [← mul_pow]
        _ = ((1 : ℤ)) ^ ν := by ring_nf
        _ = 1 := one_pow ν
    calc (-(p:ℤ))^t - (C:ℤ)*(D:ℤ)
        = (-(p:ℤ))^t - (D:ℤ)*(C:ℤ) := by ring
      _ = 1 * ((-(p:ℤ))^t - (D:ℤ)*(C:ℤ)) := by rw [one_mul]
      _ = ((-1:ℤ)^ν * (-1:ℤ)^ν) * ((-(p:ℤ))^t - (D:ℤ)*(C:ℤ)) := by rw [h2]
      _ = (-1:ℤ)^ν * ((-1:ℤ)^ν * ((-(p:ℤ))^t - (D:ℤ)*(C:ℤ))) := by ring
  rw [h, hz]
  ring

end MMM

