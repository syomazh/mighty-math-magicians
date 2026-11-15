/-
Started by Kimi K3.1 Pro (Open Math OS worker W040, cut off), continued by Claude Fable 5.2
(a subagent of the orchestrator), 2026-11-14. Not human-reviewed.
(This file was written entirely by Claude Fable 5.2.)

Carry-free p-tuples, for Lemma "From the leading part to the labelled series" (`Subst.lean`).

* `cfTuples p m`: the p-tuples of natural numbers with sum `m` and no carry (the index set of
  `cfpow` in `Lead.lean`).
* `mem_cfTuples_iff_dig`: no carry means that the digits add up position by position.
* `sum_cfTuples_divMod`: a carry-free tuple of `m` is a tuple of last digits with sum `m % p`
  together with a carry-free tuple of `m / p`.
* `prod_factorial_dig_of_mem_cfTuples`: the product of the factorials of the digits of `m` is
  the product of the multinomial coefficients of the columns of digits, times the products of the
  factorials of the digits of the entries.

No factorial valuation is used.
-/
import MMM.DigitsFree
import Mathlib.Data.Fin.Tuple.NatAntidiagonal
import Mathlib.Data.Nat.Choose.Multinomial

namespace MMM.Frob

open MMM

variable {p m : ℕ}

/-- The carry-free `p`-tuples with sum `m`: the index set of `cfpow`. -/
def cfTuples (p m : ℕ) : Finset (Fin p → ℕ) :=
  (Finset.Nat.antidiagonalTuple p m).filter (fun c => ∑ i, ds p (c i) = ds p m)

lemma mem_cfTuples {c : Fin p → ℕ} :
    c ∈ cfTuples p m ↔ ∑ i, c i = m ∧ ∑ i, ds p (c i) = ds p m := by
  rw [cfTuples, Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple]

/-- Every entry of a tuple with sum `m` is at most `m`. -/
lemma le_of_mem_cfTuples {c : Fin p → ℕ} (hc : c ∈ cfTuples p m) (i : Fin p) : c i ≤ m := by
  rw [← (mem_cfTuples.mp hc).1]
  exact Finset.single_le_sum (fun _ _ => Nat.zero_le _) (Finset.mem_univ i)

/-- In a carry-free tuple the digits add up position by position. -/
lemma sum_dig_of_mem_cfTuples (hp : 2 ≤ p) {c : Fin p → ℕ} (hc : c ∈ cfTuples p m) (j : ℕ) :
    ∑ i, dig p j (c i) = dig p j m := by
  obtain ⟨h1, h2⟩ := mem_cfTuples.mp hc
  have h := dig_sum hp Finset.univ c (by rw [h1, h2]) j
  rw [h1] at h
  exact h.symm

/-- **Carry-free tuples are digit matrices**: a tuple with sum `m` is carry-free exactly when the
digits add up position by position. -/
lemma mem_cfTuples_iff_dig (hp : 2 ≤ p) {c : Fin p → ℕ} :
    c ∈ cfTuples p m ↔ ∑ i, c i = m ∧ ∀ j, ∑ i, dig p j (c i) = dig p j m := by
  constructor
  · intro hc
    exact ⟨(mem_cfTuples.mp hc).1, sum_dig_of_mem_cfTuples hp hc⟩
  · rintro ⟨h1, h2⟩
    refine mem_cfTuples.mpr ⟨h1, ?_⟩
    rw [← h1]
    refine (ds_sum_of_dig_lt hp Finset.univ c (fun j => ?_)).symm
    rw [h2 j]
    exact dig_lt hp j m

lemma cfTuples_zero (p : ℕ) : cfTuples p 0 = {0} := by
  ext c
  rw [mem_cfTuples, Finset.mem_singleton]
  constructor
  · rintro ⟨h, -⟩
    funext i
    exact Finset.sum_eq_zero_iff.mp h i (Finset.mem_univ i)
  · rintro rfl
    simp

/-- The last digits and the quotients of a carry-free tuple of `m`. -/
lemma divMod_mem (hp : 2 ≤ p) {c : Fin p → ℕ} (hc : c ∈ cfTuples p m) :
    (fun i => c i % p) ∈ Finset.Nat.antidiagonalTuple p (m % p) ∧
      (fun i => c i / p) ∈ cfTuples p (m / p) := by
  obtain ⟨h1, h2⟩ := mem_cfTuples.mp hc
  have hp0 : 0 < p := by omega
  have hmod : ∑ i, c i % p = m % p := by
    have h := sum_dig_of_mem_cfTuples hp hc 0
    simpa using h
  have hsplit : ∑ i, c i = (∑ i, c i % p) + p * ∑ i, c i / p := by
    rw [Finset.mul_sum, ← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun i _ => (Nat.mod_add_div (c i) p).symm)
  have hdiv : ∑ i, c i / p = m / p := by
    have hm := Nat.mod_add_div m p
    have h : p * ∑ i, c i / p = p * (m / p) := by omega
    exact Nat.eq_of_mul_eq_mul_left hp0 h
  have hds : ∑ i, ds p (c i) = (∑ i, c i % p) + ∑ i, ds p (c i / p) := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun i _ => ds_rec hp (c i))
  refine ⟨Finset.Nat.mem_antidiagonalTuple.mpr hmod, mem_cfTuples.mpr ⟨hdiv, ?_⟩⟩
  have h := ds_rec hp m
  omega

/-- Conversely: last digits with sum `m % p` and a carry-free tuple of `m / p` give a carry-free
tuple of `m`. -/
lemma add_mul_mem (hp : 2 ≤ p) {e c' : Fin p → ℕ}
    (he : e ∈ Finset.Nat.antidiagonalTuple p (m % p)) (hc : c' ∈ cfTuples p (m / p)) :
    (∀ i, e i < p) ∧ (fun i => e i + p * c' i) ∈ cfTuples p m := by
  have hp0 : 0 < p := by omega
  have he' := Finset.Nat.mem_antidiagonalTuple.mp he
  obtain ⟨h1, h2⟩ := mem_cfTuples.mp hc
  have hlt : ∀ i, e i < p := fun i =>
    (Finset.single_le_sum (fun _ _ => Nat.zero_le _) (Finset.mem_univ i)).trans_lt
      (by rw [he']; exact Nat.mod_lt m hp0)
  refine ⟨hlt, mem_cfTuples.mpr ⟨?_, ?_⟩⟩
  · rw [Finset.sum_add_distrib, ← Finset.mul_sum, he', h1]
    exact Nat.mod_add_div m p
  · have hi : ∀ i, ds p (e i + p * c' i) = e i + ds p (c' i) := fun i => by
      rw [ds_rec hp, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt (hlt i),
        Nat.add_mul_div_left _ _ hp0, Nat.div_eq_of_lt (hlt i), zero_add]
    rw [Finset.sum_congr rfl (fun i _ => hi i), Finset.sum_add_distrib, he', h2]
    exact (ds_rec hp m).symm

/-- A sum over the carry-free tuples of `m`, sorted by the last digits. -/
lemma sum_cfTuples_divMod (hp : 2 ≤ p) {M : Type*} [AddCommMonoid M] (m : ℕ)
    (Φ : (Fin p → ℕ) → (Fin p → ℕ) → M) :
    ∑ c ∈ cfTuples p m, Φ (fun i => c i % p) (fun i => c i / p) =
      ∑ e ∈ Finset.Nat.antidiagonalTuple p (m % p), ∑ c' ∈ cfTuples p (m / p), Φ e c' := by
  have hp0 : 0 < p := by omega
  rw [← Finset.sum_product']
  refine Finset.sum_nbij' (fun c => (fun i => c i % p, fun i => c i / p))
    (fun x => fun i => x.1 i + p * x.2 i) ?_ ?_ ?_ ?_ ?_
  · intro c hc
    exact Finset.mem_product.mpr (divMod_mem hp hc)
  · intro x hx
    obtain ⟨h1, h2⟩ := Finset.mem_product.mp hx
    exact (add_mul_mem hp h1 h2).2
  · intro c _
    funext i
    exact Nat.mod_add_div (c i) p
  · intro x hx
    obtain ⟨h1, h2⟩ := Finset.mem_product.mp hx
    have hlt := (add_mul_mem hp h1 h2).1
    refine Prod.ext (funext fun i => ?_) (funext fun i => ?_)
    · show (x.1 i + p * x.2 i) % p = x.1 i
      rw [Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt (hlt i)]
    · show (x.1 i + p * x.2 i) / p = x.2 i
      rw [Nat.add_mul_div_left _ _ hp0, Nat.div_eq_of_lt (hlt i), zero_add]
  · intro c _
    rfl

/-- The factorials of the digits of `m`, split along a carry-free tuple. -/
lemma prod_factorial_dig_of_mem_cfTuples (hp : 2 ≤ p) {c : Fin p → ℕ} (hc : c ∈ cfTuples p m)
    (N : ℕ) :
    ∏ j ∈ Finset.range N, (dig p j m).factorial =
      (∏ j ∈ Finset.range N, Nat.multinomial Finset.univ (fun i => dig p j (c i))) *
        ∏ i, ∏ j ∈ Finset.range N, (dig p j (c i)).factorial := by
  rw [Finset.prod_comm, ← Finset.prod_mul_distrib]
  refine Finset.prod_congr rfl (fun j _ => ?_)
  rw [← sum_dig_of_mem_cfTuples hp hc j, mul_comm]
  exact (Nat.multinomial_spec Finset.univ (fun i => dig p j (c i))).symm

end MMM.Frob
