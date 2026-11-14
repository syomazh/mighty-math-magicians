/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **The exact valuation for every `m`, given Step 4** (`q = p` prime).

`MMM/ExactCond.lean` needs the digits of `m` to be 0 or 1. Here the general case follows by
telling equal atoms apart (`MMM/Retype.lean`): the number of labelled trees is a multiple of the
number of minimal trees, so a power of `p` that does not divide the first cannot divide the
second.

Everything is proved from `Step4 p` as a hypothesis; `MMM/Exact.lean` removes the hypothesis.
-/
import MMM.ExactCond
import MMM.Retype
import Mathlib.Algebra.BigOperators.Group.Multiset.Basic

namespace MMM

namespace LTree

variable {p : ℕ}

/-- The content given by the digits of `m`: `m_j` copies of `j`. -/
def digitMultiset (p m : ℕ) : Multiset ℕ := ∑ j ∈ Finset.range m, dig p j m • ({j} : Multiset ℕ)

theorem count_digitMultiset (hp : 2 ≤ p) (m i : ℕ) : (digitMultiset p m).count i = dig p i m := by
  unfold digitMultiset
  rw [Multiset.count_sum']
  simp only [Multiset.count_nsmul, Multiset.count_singleton]
  by_cases hi : i < m
  · rw [Finset.sum_eq_single i]
    · simp
    · intro j _ hj
      simp [Ne.symm hj]
    · intro h
      exact absurd (Finset.mem_range.mpr hi) h
  · rw [Finset.sum_eq_zero]
    · symm
      apply dig_eq_zero_of_lt
      exact (Nat.lt_pow_self (by omega)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))
    · intro j hj
      have hjm : j < m := Finset.mem_range.mp hj
      have hne : i ≠ j := by omega
      simp [hne]

theorem card_digitMultiset (hp : 2 ≤ p) (m : ℕ) : Multiset.card (digitMultiset p m) = ds p m := by
  unfold digitMultiset
  rw [Multiset.card_sum]
  simp only [Multiset.card_nsmul, Multiset.card_singleton, mul_one]
  exact (ds_eq_sum_dig hp m m (Nat.lt_pow_self (by omega))).symm

/-- The trees labelled by `D` without repetition are the trees with content `D`. -/
theorem good_lab_iff_cnt (hp : 2 ≤ p) (D : Finset ℕ) (U : LTree p ℕ) :
    (U.Good ∧ U.lab = D) ↔ ∀ i, U.cnt i = D.val.count i := by
  rw [good_lab_iff hp D U, typed_iff_cnt hp]
  refine forall_congr' (fun i => ?_)
  rw [dig_sum_pow hp, Multiset.count_eq_of_nodup D.nodup]
  simp

/-- **Step 4 passes from the labelled trees to the minimal trees.** -/
theorem not_dvd_card_typed [hp : Fact p.Prime] (h4 : Step4 p) (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m) :
    ¬ p ^ (t + 1) ∣ Nat.card {U : LTree p ℕ // U.CarryFree ∧ U.wt = m} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  obtain ⟨D, K, hD, hK⟩ := exists_distinct p (digitMultiset p m)
  rw [card_digitMultiset hp2, ← ht] at hD
  have h := h4 t D hD
  have e1 : Nat.card {U : LTree p ℕ // U.Good ∧ U.lab = D} = Nat.card (WithContent p D.val) :=
    Nat.card_congr (Equiv.subtypeEquivRight (fun U => good_lab_iff_cnt hp2 D U))
  have e2 : Nat.card {U : LTree p ℕ // U.CarryFree ∧ U.wt = m} =
      Nat.card (WithContent p (digitMultiset p m)) :=
    Nat.card_congr (Equiv.subtypeEquivRight (fun U => by
      rw [typed_iff_cnt hp2]
      exact forall_congr' (fun i => by rw [count_digitMultiset hp2])))
  rw [e1, hK, ← e2] at h
  exact fun hdvd => h (Dvd.dvd.mul_left hdvd K)

end LTree

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- **The exact valuation, given Step 4:** `p ^ t` is the exact power of `p` in the number of
`p`-ary trees with `m` leaves, where `(p - 1) * t + 1 = s_p(m)`. -/
theorem exact_valuation_of_step4 (h4 : Step4 p) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m} := by
  refine exact_of_minimal m t ht ?_
  rw [← Nat.card_congr (LTree.minimalEquiv hp.out.two_le m t ht)]
  exact LTree.not_dvd_card_typed h4 m t ht

end PTree

end MMM
