/-
Written by `open-math — kimi-k3.1-pro` (model `moonshotai/kimi-k3.1-pro`), 2026-11-14; not human-reviewed.
-/
import MMM.Digits
import Mathlib.Data.Nat.Digits.Lemmas

namespace MMM.Acct

open MMM

def Nval (p m : ℕ) : ℕ := (m - 1) / (p - 1)
def nu (p m : ℕ) : ℕ := (m - ds p m) / (p - 1)
def tval (p m : ℕ) : ℕ := (ds p m - 1) / (p - 1)

theorem ds_le (p : ℕ) (hp : 2 ≤ p) (m : ℕ) : ds p m ≤ m := by
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    rcases Nat.eq_zero_or_pos m with rfl | hm
    · simp
    · have hlt : m / p < m := Nat.div_lt_self hm (by omega)
      have hle_q : ds p (m / p) ≤ m / p := ih _ hlt
      have hrec : ds p m = m % p + ds p (m / p) := ds_rec (p := p) hp m
      -- `m = p*(m/p) + m%p` and `p*(m/p) = m/p + (p−1)*(m/p)`
      have hm_eq : p * (m / p) + m % p = m := Nat.div_add_mod m p
      have hsplit : p * (m / p) = m / p + (p - 1) * (m / p) := by
        have hp_eq : p = (p - 1) + 1 := by omega
        calc p * (m / p) = ((p - 1) + 1) * (m / p) := by rw [← hp_eq]
          _ = (p - 1) * (m / p) + 1 * (m / p) := by rw [Nat.add_mul]
          _ = (p - 1) * (m / p) + (m / p) := by rw [Nat.one_mul]
          _ = m / p + (p - 1) * (m / p) := by rw [Nat.add_comm]
      have hbound : m % p + m / p ≤ m := by omega
      calc ds p m = m % p + ds p (m / p) := hrec
        _ ≤ m % p + (m / p) := Nat.add_le_add_left hle_q _
        _ ≤ m := hbound

theorem sub_one_dvd_m_sub_s (p m : ℕ) (_hp : 2 ≤ p) : (p - 1) ∣ (m - ds p m) := by
  have hleg : (p - 1) * (∑ i ∈ Finset.range (Nat.log p m).succ, m / p ^ (i + 1)) =
      m - (Nat.digits p m).sum :=
    Nat.sub_one_mul_sum_log_div_pow_eq_sub_sum_digits (p := p) m
  have hds : (Nat.digits p m).sum = ds p m := rfl
  rw [hds] at hleg
  exact Dvd.intro _ hleg

theorem sub_one_mul_nu (p m : ℕ) (hp : 2 ≤ p) : (p - 1) * nu p m = m - ds p m := by
  unfold nu; exact Nat.mul_div_cancel' (sub_one_dvd_m_sub_s p m hp)

theorem nu_add_t_eq_Nval (hp : 2 ≤ p) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (_hm1 : 1 ≤ m) : nu p m + t = Nval p m := by
  unfold Nval nu
  have hp1 : 0 < p - 1 := by omega
  have h1' : ds p m - 1 = (p - 1) * t := by omega
  have h2 : (m - ds p m) + (ds p m - 1) = m - 1 := by
    have hle := ds_le p hp m; omega
  have hdvd_s : (p - 1) ∣ (ds p m - 1) := Dvd.intro t h1'.symm
  have ht' : t = (ds p m - 1) / (p - 1) :=
    (Nat.div_eq_of_eq_mul_left hp1 (by rw [Nat.mul_comm]; exact h1')).symm
  have h3 : (ds p m - 1) / (p - 1) + (m - ds p m) / (p - 1) = (m - 1) / (p - 1) := by
    have hdiv : ((ds p m - 1) + (m - ds p m)) / (p - 1) =
        (ds p m - 1) / (p - 1) + (m - ds p m) / (p - 1) :=
      Nat.add_div_of_dvd_right hdvd_s
    have hadd : (ds p m - 1) + (m - ds p m) = m - 1 := by omega
    rw [hadd] at hdiv; exact hdiv.symm
  calc nu p m + t = (m - ds p m) / (p - 1) + t := rfl
    _ = (m - ds p m) / (p - 1) + (ds p m - 1) / (p - 1) := by rw [ht']
    _ = (ds p m - 1) / (p - 1) + (m - ds p m) / (p - 1) := by rw [Nat.add_comm]
    _ = (m - 1) / (p - 1) := h3

end MMM.Acct
