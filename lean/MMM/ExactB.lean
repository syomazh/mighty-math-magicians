/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Problem 137 for every prime power `q = p ^ k`: the exact power of `p` in the number of
  `q`-ary trees.**

      (p - 1) * v_p( number of q-ary trees with n internal nodes ) + 1 = s_p((q - 1) * n + 1),

that is, `v_p = (s_p((q - 1) n + 1) - 1) / (p - 1)`.

The proof is the tree-symmetry proof of the paper:
  blocked form   a `q`-ary tree is a `p`-ary tree with all leaves at depths divisible by `k`
                 (`MMM/BlockedForm.lean`)
  Steps 1, 2     class size `p ^ d`, `d ≥ t`; rotations keep the depths  (`MMM/Blocked.lean`)
  Step 3         minimal trees = trees of atoms with the depth condition (`MMM/ReductionB.lean`),
                 equal atoms renamed within their classes modulo `k`     (`MMM/RetypeB.lean`)
  Step 4         the cherry collapse with classes modulo `k`             (`MMM/CherryB.lean`)
No factorial valuation (Legendre, Kummer) is used.

The number of trees is *defined* by counting trees. That it equals the Fuss-Catalan number
`binom(q n, n) / ((q - 1) n + 1)` is classical and is not part of this file.
-/
import MMM.Exact
import MMM.ExactBCond
import MMM.CherryB
import MMM.BlockedForm

namespace MMM

/-- **Step 4 with the depth condition** (proved in `MMM/CherryB.lean`). -/
theorem step4B (p k : ℕ) [Fact p.Prime] (hk : 0 < k) : Step4B p k :=
  fun t S hS hI => (LTree.labelled_valuation_blocked k hk id t S hS hI).2

namespace PTree

/-- A `q`-ary tree with `n` internal nodes has `(q - 1) * n + 1` leaves. -/
theorem leaves_eq_nodes {q : ℕ} (hq : 1 ≤ q) (T : PTree q) :
    T.leaves = (q - 1) * T.nodes + 1 := by
  induction T with
  | leaf => simp [PTree.nodes]
  | node f ih =>
    simp only [PTree.leaves_node, PTree.nodes]
    rw [Finset.sum_congr rfl (fun i _ => ih i), Finset.sum_add_distrib, ← Finset.mul_sum]
    simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul, mul_one]
    rw [Nat.mul_add, Nat.mul_one]
    omega

/-- Counting by internal nodes or by leaves is the same. -/
theorem card_nodes_eq_card_leaves {q : ℕ} (hq : 2 ≤ q) (n : ℕ) :
    Nat.card {T : PTree q // T.nodes = n} =
      Nat.card {T : PTree q // T.leaves = (q - 1) * n + 1} :=
  Nat.card_congr (Equiv.subtypeEquivRight (fun T => by
    rw [leaves_eq_nodes (by omega) T]
    constructor
    · intro h
      rw [h]
    · intro h
      have h' : (q - 1) * T.nodes = (q - 1) * n := by omega
      exact Nat.eq_of_mul_eq_mul_left (by omega) h'))

variable {p : ℕ} [hp : Fact p.Prime]

/-- The formula for `q = p`, indexed by internal nodes. -/
theorem fussCatalan_valuation_nodes (n : ℕ) :
    (p - 1) * multiplicity p (Nat.card {T : PTree p // T.nodes = n}) + 1 =
      (Nat.digits p ((p - 1) * n + 1)).sum := by
  rw [card_nodes_eq_card_leaves hp.out.two_le n]
  exact fussCatalan_valuation n

/-- **Exact valuation for the blocked `p`-ary trees.** -/
theorem exact_valuation_blocked (k : ℕ) (hk : 0 < k) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (hm : m ≡ 1 [MOD p ^ k - 1]) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} :=
  exact_valuation_blocked_of_step4B hk (step4B p k hk) m t ht hm

/-- **Main theorem for `q = p ^ k`.** If `m ≡ 1 (mod q - 1)` and `(p - 1) * t + 1 = s_p(m)`,
then `p ^ t` divides the number of `q`-ary trees with `m` leaves and `p ^ (t + 1)` does not. -/
theorem exact_valuation_primePower (k : ℕ) (hk : 0 < k) (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
    p ^ t ∣ Nat.card {T : PTree (p ^ k) // T.leaves = m} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree (p ^ k) // T.leaves = m} := by
  rw [card_pow_ary_eq_card_blocked hp.out.two_le k hk m]
  exact exact_valuation_blocked k hk m t ht hm

/-- The formula of Problem 137, indexed by leaves: a `q`-ary tree with `n` internal nodes has
`(q - 1) * n + 1` leaves. -/
theorem problem137_leaves (k n : ℕ) (hk : 0 < k) :
    (p - 1) * multiplicity p (Nat.card {T : PTree (p ^ k) // T.leaves = (p ^ k - 1) * n + 1}) + 1 =
      (Nat.digits p ((p ^ k - 1) * n + 1)).sum := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hm : (p ^ k - 1) * n + 1 ≡ 1 [MOD p ^ k - 1] := by
    have h : (p ^ k - 1) * n + 1 ≡ 0 + 1 [MOD p ^ k - 1] :=
      (Nat.modEq_zero_iff_dvd.mpr (dvd_mul_right _ _)).add_right 1
    rw [zero_add] at h
    exact h
  -- `p - 1` divides `p ^ k - 1`, so the number of leaves is also `≡ 1 (mod p - 1)`
  have hp1 : p ≡ 1 [MOD p - 1] :=
    ((Nat.modEq_iff_dvd' (by omega : 1 ≤ p)).mpr (dvd_refl _)).symm
  have hpk : 1 ≡ p ^ k [MOD p - 1] := by
    have := hp1.pow k
    rw [one_pow] at this
    exact this.symm
  have hdvd : p - 1 ∣ p ^ k - 1 := (Nat.modEq_iff_dvd' (Nat.one_le_pow _ _ (by omega))).mp hpk
  have hm1 : (p ^ k - 1) * n + 1 ≡ 1 [MOD p - 1] := by
    have h : (p ^ k - 1) * n + 1 ≡ 0 + 1 [MOD p - 1] :=
      (Nat.modEq_zero_iff_dvd.mpr (Dvd.dvd.mul_right hdvd n)).add_right 1
    rw [zero_add] at h
    exact h
  have hpos : 0 < ds p ((p ^ k - 1) * n + 1) := ds_pos hp2 _ (Nat.succ_pos _)
  have h1 : ds p ((p ^ k - 1) * n + 1) ≡ 1 [MOD p - 1] := (ds_modEq hp2 _).trans hm1
  obtain ⟨t, ht⟩ := (Nat.modEq_iff_dvd' (by omega : 1 ≤ ds p ((p ^ k - 1) * n + 1))).mp h1.symm
  have ht' : (p - 1) * t + 1 = ds p ((p ^ k - 1) * n + 1) := by omega
  obtain ⟨e1, e2⟩ := exact_valuation_primePower k hk _ t ht' hm
  rw [multiplicity_eq_of_exact e1 e2, ht']
  rfl

/-- **Problem 137.** For a prime `p`, `q = p ^ k` with `k ≥ 1`, and every `n`: the exponent
`v_p` of `p` in the number of `q`-ary trees with `n` internal nodes satisfies
`(p - 1) * v_p + 1 = s_p((q - 1) * n + 1)`. -/
theorem problem137 (k n : ℕ) (hk : 0 < k) :
    (p - 1) * multiplicity p (Nat.card {T : PTree (p ^ k) // T.nodes = n}) + 1 =
      (Nat.digits p ((p ^ k - 1) * n + 1)).sum := by
  have hq : 2 ≤ p ^ k := by
    calc 2 ≤ p := hp.out.two_le
      _ = p ^ 1 := (pow_one p).symm
      _ ≤ p ^ k := Nat.pow_le_pow_right (by have := hp.out.two_le; omega) hk
  rw [card_nodes_eq_card_leaves hq n]
  exact problem137_leaves k n hk

end PTree

end MMM
