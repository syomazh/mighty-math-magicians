/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

Carry-free additions. If the digit sum of `a + b` equals the sum of the digit sums ("no carry"),
then the addition is digit by digit. The same for finite sums, and the digits of a sum of
distinct powers of `p`. No factorial and no valuation is used.
-/
import MMM.Digits
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Ring.GeomSum
import Mathlib.Data.Finset.Max

namespace MMM

/-- The `j`-th base-`p` digit of `n`. -/
def dig (p j n : ℕ) : ℕ := (n / p ^ j) % p

@[simp] theorem dig_zero (p n : ℕ) : dig p 0 n = n % p := by simp [dig]

theorem dig_succ (p j n : ℕ) : dig p (j + 1) n = dig p j (n / p) := by
  unfold dig
  rw [pow_succ', Nat.div_div_eq_div_mul]

theorem dig_lt {p : ℕ} (hp : 2 ≤ p) (j n : ℕ) : dig p j n < p := Nat.mod_lt _ (by omega)

/-- **No carry means digit by digit.** If `s(a + b) = s(a) + s(b)`, the last digits add without
carry, and the same holds for the remaining digits. -/
theorem ds_add_eq {p : ℕ} (hp : 2 ≤ p) {a b : ℕ} (h : ds p (a + b) = ds p a + ds p b) :
    (a + b) % p = a % p + b % p ∧ (a + b) / p = a / p + b / p ∧
      ds p (a / p + b / p) = ds p (a / p) + ds p (b / p) := by
  have hp0 : 0 < p := by omega
  rw [ds_rec hp (a + b), ds_rec hp a, ds_rec hp b] at h
  have hdiv := Nat.add_div (a := a) (b := b) hp0
  have hmod := Nat.add_mod_eq_ite (m := a) (n := b) (k := p)
  have h2 := ds_add_le hp (a / p) (b / p)
  by_cases hc : p ≤ a % p + b % p
  · -- a carry would lower the digit sum
    simp only [hc, ↓reduceIte] at hdiv hmod
    have h1 := ds_add_le hp (a / p + b / p) 1
    rw [ds_one hp] at h1
    rw [hdiv, hmod] at h
    omega
  · simp only [hc, ↓reduceIte] at hdiv hmod
    rw [hdiv, hmod, add_zero] at h
    refine ⟨hmod, by rw [hdiv, add_zero], by omega⟩

/-- Every digit of a carry-free sum is the sum of the digits. -/
theorem dig_add {p : ℕ} (hp : 2 ≤ p) : ∀ (j a b : ℕ), ds p (a + b) = ds p a + ds p b →
    dig p j (a + b) = dig p j a + dig p j b := by
  intro j
  induction j with
  | zero =>
    intro a b h
    simpa using (ds_add_eq hp h).1
  | succ j ih =>
    intro a b h
    obtain ⟨-, h2, h3⟩ := ds_add_eq hp h
    rw [dig_succ, dig_succ, dig_succ, h2]
    exact ih _ _ h3

/-- A carry-free finite sum stays carry-free when one summand is split off. -/
theorem ds_sum_eq_split {p : ℕ} (hp : 2 ≤ p) {ι : Type*} [DecidableEq ι] {a : ι} {s : Finset ι}
    (ha : a ∉ s) (f : ι → ℕ)
    (h : ds p (∑ i ∈ insert a s, f i) = ∑ i ∈ insert a s, ds p (f i)) :
    ds p (f a + ∑ i ∈ s, f i) = ds p (f a) + ds p (∑ i ∈ s, f i) ∧
      ds p (∑ i ∈ s, f i) = ∑ i ∈ s, ds p (f i) := by
  rw [Finset.sum_insert ha, Finset.sum_insert ha] at h
  have h1 := ds_add_le hp (f a) (∑ i ∈ s, f i)
  have h2 := ds_sum_le hp s f
  constructor <;> omega

/-- Every digit of a carry-free finite sum is the sum of the digits. -/
theorem dig_sum {p : ℕ} (hp : 2 ≤ p) {ι : Type*} (s : Finset ι) (f : ι → ℕ)
    (h : ds p (∑ i ∈ s, f i) = ∑ i ∈ s, ds p (f i)) (j : ℕ) :
    dig p j (∑ i ∈ s, f i) = ∑ i ∈ s, dig p j (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [dig]
  | insert a s ha ih =>
    obtain ⟨h1, h2⟩ := ds_sum_eq_split hp ha f h
    rw [Finset.sum_insert ha, Finset.sum_insert ha, dig_add hp j _ _ h1, ih h2]

/-- A power of `p` has digit sum 1. -/
theorem ds_pow {p : ℕ} (hp : 2 ≤ p) (i : ℕ) : ds p (p ^ i) = 1 := by
  induction i with
  | zero => simpa using ds_one hp
  | succ i ih => rw [pow_succ', ds_base_mul hp, ih]

/-- The digits of a power of `p`. -/
theorem dig_pow {p : ℕ} (hp : 2 ≤ p) (j i : ℕ) : dig p j (p ^ i) = if i = j then 1 else 0 := by
  unfold dig
  have hp0 : 0 < p := by omega
  rcases lt_trichotomy i j with h | h | h
  · rw [Nat.div_eq_of_lt (Nat.pow_lt_pow_right (by omega) h)]
    simp [h.ne]
  · subst h
    rw [Nat.div_self (pow_pos hp0 i), Nat.mod_eq_of_lt (by omega)]
    simp
  · rw [Nat.pow_div h.le hp0]
    obtain ⟨k, hk⟩ : ∃ k, i - j = k + 1 := ⟨i - j - 1, by omega⟩
    rw [hk, pow_succ', Nat.mul_mod_right]
    simp [h.ne']

/-- Adding a power of `p` above a number adds one to the digit sum. -/
theorem ds_pow_add {p : ℕ} (hp : 2 ≤ p) : ∀ (a r : ℕ), r < p ^ a → ds p (p ^ a + r) = 1 + ds p r := by
  intro a
  induction a with
  | zero =>
    intro r hr
    have : r = 0 := by simpa using hr
    subst this
    simp [ds_one hp]
  | succ a ih =>
    intro r hr
    have hp0 : 0 < p := by omega
    rw [ds_rec hp (p ^ (a + 1) + r), ds_rec hp r]
    have h1 : (p ^ (a + 1) + r) % p = r % p := by rw [pow_succ', Nat.mul_add_mod]
    have h2 : (p ^ (a + 1) + r) / p = p ^ a + r / p := by rw [pow_succ', Nat.mul_add_div hp0]
    have h3 : r / p < p ^ a := by
      rw [Nat.div_lt_iff_lt_mul hp0]
      rw [pow_succ] at hr
      exact hr
    rw [h1, h2, ih _ h3]
    omega

/-- **A sum of distinct powers of `p` has as many digits 1 as it has terms.** -/
theorem ds_sum_pow {p : ℕ} (hp : 2 ≤ p) (A : Finset ℕ) : ds p (∑ j ∈ A, p ^ j) = A.card := by
  induction A using Finset.induction_on_max with
  | empty => simp
  | insert a B hB ih =>
    have ha : a ∉ B := fun h => lt_irrefl _ (hB a h)
    rw [Finset.sum_insert ha, Finset.card_insert_of_notMem ha,
      ds_pow_add hp a _ (Nat.geomSum_lt hp hB), ih]
    omega

/-- The digits of a sum of distinct powers of `p`. -/
theorem dig_sum_pow {p : ℕ} (hp : 2 ≤ p) (A : Finset ℕ) (j : ℕ) :
    dig p j (∑ i ∈ A, p ^ i) = if j ∈ A then 1 else 0 := by
  rw [dig_sum hp A _ (by rw [ds_sum_pow hp]; simp [ds_pow hp]) j]
  simp [dig_pow hp]

/-- A number whose digits are all 0 or 1 is a sum of distinct powers of `p`. -/
theorem exists_sum_pow {p : ℕ} (hp : 2 ≤ p) : ∀ m : ℕ, (∀ j, dig p j m ≤ 1) →
    ∃ D : Finset ℕ, ∑ j ∈ D, p ^ j = m := by
  intro m
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    intro h
    rcases Nat.eq_zero_or_pos m with rfl | hm
    · exact ⟨∅, by simp⟩
    · obtain ⟨D', hD'⟩ := ih (m / p) (Nat.div_lt_self hm (by omega))
        (fun j => by rw [← dig_succ]; exact h (j + 1))
      have h0 : m % p ≤ 1 := by simpa using h 0
      have hshift : ∑ j ∈ D'.map ⟨Nat.succ, Nat.succ_injective⟩, p ^ j = p * (m / p) := by
        rw [Finset.sum_map, ← hD', Finset.mul_sum]
        exact Finset.sum_congr rfl (fun j _ => by simp [pow_succ'])
      have hm' := Nat.div_add_mod m p
      by_cases h1 : m % p = 1
      · refine ⟨insert 0 (D'.map ⟨Nat.succ, Nat.succ_injective⟩), ?_⟩
        rw [Finset.sum_insert (by simp), hshift]
        simp
        omega
      · exact ⟨D'.map ⟨Nat.succ, Nat.succ_injective⟩, by rw [hshift]; omega⟩

end MMM
