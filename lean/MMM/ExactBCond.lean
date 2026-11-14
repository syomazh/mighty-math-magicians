/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Prime powers `q = p ^ k`: the exact valuation, given Step 4 with the depth condition.**

`Step4B p k` is the statement about labelled trees with the depth condition that the cherry
collapse proves (`MMM/CherryB.lean`). From it, by Steps 1, 2, 3 with depths
(`MMM/ReductionB.lean`) and the separation of equal atoms (`MMM/RetypeB.lean`):

  if `m ≡ 1 (mod p ^ k - 1)` and `(p - 1) * t + 1 = s_p(m)`, then `p ^ t` is the exact power of
  `p` in the number of `p`-ary trees with `m` leaves all at depths divisible by `k`.

The congruence on `m` is what makes such trees exist; it enters as `∑ p ^ type ≡ 1`, a quantity
that renaming atoms within their classes modulo `k` does not change.
-/
import MMM.ExactAll
import MMM.ReductionB
import MMM.RetypeB
import Mathlib.Tactic.Ring

namespace MMM

/-- **Step 4 with the depth condition, as a statement** about trees with distinctly labelled
leaves, the label `x` being allowed at depth `δ` when `k ∣ δ + x`. -/
def Step4B (p k : ℕ) : Prop :=
  ∀ (t : ℕ) (S : Finset ℕ), S.card = (p - 1) * t + 1 →
    (∑ x ∈ S, p ^ x) ≡ 1 [MOD p ^ k - 1] →
      ¬ p ^ (t + 1) ∣ Nat.card {T : LTree p ℕ // T.Good ∧ T.lab = S ∧ T.BlockedL k id 0}

/-- Modulo `p ^ k - 1`, a power of `p` depends only on the exponent modulo `k`. -/
theorem pow_modEq_pow_mod {p : ℕ} (hp : 1 ≤ p) (k a : ℕ) :
    p ^ a ≡ p ^ (a % k) [MOD p ^ k - 1] := by
  have h1 : p ^ k ≡ 1 [MOD p ^ k - 1] :=
    ((Nat.modEq_iff_dvd' (Nat.one_le_pow _ _ hp)).mpr (dvd_refl _)).symm
  have h2 : (p ^ k) ^ (a / k) ≡ 1 ^ (a / k) [MOD p ^ k - 1] := h1.pow _
  rw [one_pow] at h2
  have h3 := h2.mul_right (p ^ (a % k))
  rw [one_mul, ← pow_mul, ← pow_add, Nat.div_add_mod] at h3
  exact h3

/-- The sum of `p ^ type` over a content, modulo `p ^ k - 1`, depends only on the classes of the
types modulo `k`. -/
theorem sum_pow_modEq_map_mod {p : ℕ} (hp : 1 ≤ p) (k : ℕ) (M : Multiset ℕ) :
    (M.map (p ^ ·)).sum ≡ ((M.map (· % k)).map (p ^ ·)).sum [MOD p ^ k - 1] := by
  induction M using Multiset.induction_on with
  | empty => rfl
  | cons a s ih =>
    simp only [Multiset.map_cons, Multiset.sum_cons]
    exact (pow_modEq_pow_mod hp k a).add ih

/-- A number is the sum of its digits times the powers of `p`. -/
theorem sum_dig_mul_pow {p : ℕ} (hp : 2 ≤ p) : ∀ (B m : ℕ), m < p ^ B →
    ∑ j ∈ Finset.range B, dig p j m * p ^ j = m := by
  intro B
  induction B with
  | zero =>
    intro m hm
    have : m = 0 := by simpa using hm
    subst this
    simp
  | succ B ih =>
    intro m hm
    have hp0 : 0 < p := by omega
    have h1 : m / p < p ^ B := by
      rw [Nat.div_lt_iff_lt_mul hp0, ← pow_succ]; exact hm
    have h2 : ∑ j ∈ Finset.range B, dig p (j + 1) m * p ^ (j + 1) =
        p * ∑ j ∈ Finset.range B, dig p j (m / p) * p ^ j := by
      rw [Finset.mul_sum]
      refine Finset.sum_congr rfl (fun j _ => ?_)
      rw [dig_succ, pow_succ]
      ring
    rw [Finset.sum_range_succ', h2, ih _ h1, dig_zero, pow_zero, mul_one]
    exact Nat.div_add_mod m p

namespace LTree

variable {p : ℕ}

/-- The content given by the digits of `m` has weight `m`. -/
theorem sum_map_pow_digitMultiset (hp : 2 ≤ p) (m : ℕ) :
    ((digitMultiset p m).map (p ^ ·)).sum = m := by
  rw [Finset.sum_multiset_map_count]
  simp only [count_digitMultiset hp, smul_eq_mul]
  have hsub : (digitMultiset p m).toFinset ⊆ Finset.range m := by
    intro x hx
    rw [Multiset.mem_toFinset, ← Multiset.count_pos, count_digitMultiset hp] at hx
    rw [Finset.mem_range]
    by_contra hge
    have h0 : dig p x m = 0 := dig_eq_zero_of_lt
      ((Nat.lt_pow_self (by omega)).trans_le (Nat.pow_le_pow_right (by omega) (by omega)))
    omega
  rw [Finset.sum_subset hsub (fun x _ hx => by
    have h0 : dig p x m = 0 := by
      by_contra hne
      exact hx (Multiset.mem_toFinset.mpr (Multiset.count_pos.mp (by
        rw [count_digitMultiset hp]; omega)))
    rw [h0, zero_mul])]
  exact sum_dig_mul_pow hp m m (Nat.lt_pow_self (by omega))

/-- If the distinct types `D` have the same classes modulo `k` as the digits of `m`, and
`m ≡ 1`, then `∑_{x ∈ D} p ^ x ≡ 1` modulo `p ^ k - 1`. -/
theorem sum_pow_modEq_one (hp : 2 ≤ p) (k : ℕ) (D : Finset ℕ) (m : ℕ)
    (hres : D.val.map (· % k) = (digitMultiset p m).map (· % k))
    (hm : m ≡ 1 [MOD p ^ k - 1]) : (∑ x ∈ D, p ^ x) ≡ 1 [MOD p ^ k - 1] := by
  have e : ∑ x ∈ D, p ^ x = (D.val.map (p ^ ·)).sum := rfl
  rw [e]
  refine (sum_pow_modEq_map_mod (by omega) k D.val).trans ?_
  rw [hres]
  refine (sum_pow_modEq_map_mod (by omega) k (digitMultiset p m)).symm.trans ?_
  rw [sum_map_pow_digitMultiset hp]
  exact hm

/-- **Step 4 passes from the labelled trees to the minimal trees, with the depth condition.** -/
theorem not_dvd_card_typed_blocked [hp : Fact p.Prime] {k : ℕ} (hk : 0 < k) (h4 : Step4B p k)
    (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
    ¬ p ^ (t + 1) ∣
      Nat.card {U : LTree p ℕ // (U.CarryFree ∧ U.wt = m) ∧ BlockedL k id 0 U} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  obtain ⟨D, K, hD, hres, hK⟩ := exists_distinct_blocked p k hk (digitMultiset p m)
  rw [card_digitMultiset hp2, ← ht] at hD
  have h := h4 t D hD (sum_pow_modEq_one hp2 k D m hres hm)
  have e1 : Nat.card {T : LTree p ℕ // T.Good ∧ T.lab = D ∧ T.BlockedL k id 0} =
      Nat.card (WithContentB p k D.val) :=
    Nat.card_congr (Equiv.subtypeEquivRight (fun U => by
      rw [← and_assoc, good_lab_iff_cnt hp2 D U]))
  have e2 : Nat.card {U : LTree p ℕ // (U.CarryFree ∧ U.wt = m) ∧ BlockedL k id 0 U} =
      Nat.card (WithContentB p k (digitMultiset p m)) :=
    Nat.card_congr (Equiv.subtypeEquivRight (fun U => by
      rw [typed_iff_cnt hp2]
      exact and_congr_left' (forall_congr' (fun i => by rw [count_digitMultiset hp2]))))
  rw [e1, hK, ← e2] at h
  exact fun hdvd => h (Dvd.dvd.mul_left hdvd K)

end LTree

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- **The exact valuation for blocked trees, given Step 4 with the depth condition.** -/
theorem exact_valuation_blocked_of_step4B {k : ℕ} (hk : 0 < k) (h4 : Step4B p k) (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} := by
  refine ⟨pow_dvd_card_blocked_trees k m t ht, fun h => ?_⟩
  have h1 := ((card_blocked_modEq_minimal k m t ht).dvd_iff (dvd_refl _)).mp h
  rw [LTree.card_minimal_blocked hp.out.two_le k m t ht] at h1
  exact LTree.not_dvd_card_typed_blocked hk h4 m t ht hm h1

end PTree

end MMM
