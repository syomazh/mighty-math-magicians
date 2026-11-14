/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **The theorem for `q = p` prime: the exact power of `p` in the number of `p`-ary trees.**

      v_p( number of p-ary trees with m leaves ) = t,   where (p - 1) * t + 1 = s_p(m),

and for `p = 2`, with Mathlib's Catalan numbers:   v_2(C_n) = s_2(n + 1) - 1.

The proof is the tree-symmetry proof of the paper, in this order:
  Step 1  a rotation class has `p ^ d` trees                      (`MMM/ClassSize.lean`)
  Step 2  `d ≥ t`                                                (`MMM/Trees.lean`)
          so modulo `p ^ (t + 1)` only the minimal trees count    (`MMM/Reduction.lean`)
  Step 3  the minimal trees are the trees of atoms given by the
          digits of `m`                                           (`MMM/Minimal.lean`, `MMM/Atoms.lean`)
          equal atoms are told apart by labels                    (`MMM/Retype.lean`)
  Step 4  labelled trees: the cherry collapse                     (`MMM/LRot.lean`, `MMM/Cherry.lean`)
No factorial valuation (Legendre, Kummer) is used anywhere.

The number of trees is *defined* by counting trees. That it equals the Fuss-Catalan number
`binom(p n, n) / ((p - 1) n + 1)` is classical and is formalized only for `p = 2`
(Mathlib's `catalan`). Prime powers `q = p ^ k` are in `MMM/ExactB.lean`, the residue modulo `p` in
`MMM/Residue.lean` and `MMM/ResidueB.lean`.
-/
import MMM.ExactAll
import MMM.Cherry

namespace MMM

/-- **Step 4** (proved in `MMM/Cherry.lean`). -/
theorem step4 (p : ℕ) [Fact p.Prime] : Step4 p :=
  fun t S hS => (LTree.labelled_valuation t S hS).2

/-- The digit sum of `m` is congruent to `m` modulo `p - 1`. -/
theorem ds_modEq {p : ℕ} (hp : 2 ≤ p) : ∀ m : ℕ, ds p m ≡ m [MOD p - 1] := by
  intro m
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    rcases Nat.eq_zero_or_pos m with rfl | hm
    · simp [Nat.ModEq]
    · have hp1 : p ≡ 1 [MOD p - 1] :=
        ((Nat.modEq_iff_dvd' (by omega : 1 ≤ p)).mpr (dvd_refl _)).symm
      have h1 : ds p (m / p) ≡ m / p [MOD p - 1] := ih _ (Nat.div_lt_self hm (by omega))
      have h2 : p * (m / p) ≡ 1 * (m / p) [MOD p - 1] := hp1.mul_right _
      rw [one_mul] at h2
      have h3 : m % p + ds p (m / p) ≡ m % p + p * (m / p) [MOD p - 1] :=
        (h1.trans h2.symm).add_left _
      rw [ds_rec hp]
      have e : m % p + p * (m / p) = m := by
        have := Nat.div_add_mod m p
        omega
      rw [e] at h3
      exact h3

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- **Main theorem (`q = p`).** If `(p - 1) * t + 1` is the base-`p` digit sum of `m`, then
`p ^ t` divides the number of `p`-ary trees with `m` leaves and `p ^ (t + 1)` does not. -/
theorem exact_valuation (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m} :=
  exact_valuation_of_step4 (step4 p) m t ht

/-- The same as a valuation: `v_p(#trees with m leaves) = t`. -/
theorem multiplicity_card_trees (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    multiplicity p (Nat.card {T : PTree p // T.leaves = m}) = t :=
  multiplicity_eq_of_exact (exact_valuation m t ht).1 (exact_valuation m t ht).2

/-- **The formula of Problem 137 for `q = p`.** With `n` the number of internal nodes, a `p`-ary
tree has `(p - 1) * n + 1` leaves, and
`(p - 1) * v_p(#trees) + 1 = s_p((p - 1) * n + 1)`,
that is, `v_p = (s_p((p - 1) n + 1) - 1) / (p - 1)`. -/
theorem fussCatalan_valuation (n : ℕ) :
    (p - 1) * multiplicity p (Nat.card {T : PTree p // T.leaves = (p - 1) * n + 1}) + 1 =
      (Nat.digits p ((p - 1) * n + 1)).sum := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hpos : 0 < ds p ((p - 1) * n + 1) := ds_pos hp2 _ (Nat.succ_pos _)
  have h1 : ds p ((p - 1) * n + 1) ≡ 1 [MOD p - 1] := by
    refine (ds_modEq hp2 _).trans ?_
    have : (p - 1) * n + 1 ≡ 0 + 1 [MOD p - 1] :=
      (Nat.modEq_zero_iff_dvd.mpr (dvd_mul_right _ _)).add_right 1
    rw [zero_add] at this
    exact this
  obtain ⟨t, ht⟩ := (Nat.modEq_iff_dvd' (by omega : 1 ≤ ds p ((p - 1) * n + 1))).mp h1.symm
  have ht' : (p - 1) * t + 1 = ds p ((p - 1) * n + 1) := by omega
  rw [multiplicity_card_trees _ t ht', ht']
  rfl

end PTree

/-- **Catalan numbers.** The exact power of 2 in the Catalan number `C_n` is `s_2(n + 1) - 1`,
proved by tree symmetry. Both sides are Mathlib's own definitions. -/
theorem multiplicity_two_catalan (n : ℕ) :
    multiplicity 2 (catalan n) = (Nat.digits 2 (n + 1)).sum - 1 :=
  multiplicity_two_catalan_of_step4 (step4 2) n

end MMM
