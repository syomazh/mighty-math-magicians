/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.

  **Problem 137 by the Frobenius proof, stated with Mathlib's definitions only.**

For a prime `p`, `q = p ^ k` with `k ≥ 1`, and the Fuss–Catalan number
`C = binom(q n, n) / ((q - 1) n + 1)`:

* `problem137_fussCatalan_frobenius`:  `(p - 1) * v_p(C) + 1 = s_p((q - 1) n + 1)`;
* `problem137_fussCatalan_exact_frobenius`:  `p ^ t ∣ C` and `p ^ (t + 1) ∤ C`, where
  `(p - 1) t + 1 = s_p((q - 1) n + 1)`;
* `residue_fussCatalan_frobenius`:  `C * ∏ (digits of (q - 1) n + 1)! ≡ (-p) ^ t  (mod p ^ (t + 1))`.

These are the statements of `MMM/Problem137.lean`, proved a second time: the valuation and the
residue come from `MMM/Frob/Final.lean` (the algebraic proof of `paper/frobenius_proof.tex`), in
which no symmetry of trees occurs. This file borrows from the files of the tree proof only facts
that have nothing to do with rotations:

* `PTree.choose_div_eq_card` (`FussFormula.lean`): `C` is the number of `q`-ary trees with `n`
  internal nodes;
* `PTree.card_nodes_eq_card_leaves` (`ExactB.lean`): such a tree has `(q - 1) n + 1` leaves;
* `PTree.card_pow_ary_eq_card_blocked` (`BlockedForm.lean`): a `q`-ary tree is a `p`-ary tree
  with all leaves at depths divisible by `k`;
* `PTree.prod_dig_eq_digits` (`ResidueForms.lean`), `ds_modEq` (`Exact.lean`),
  `multiplicity_eq_of_exact` (`ExactCond.lean`): arithmetic.

What the theorems reach is listed by `#project_modules` at the end of `MMM/Frob/Axioms.lean`.
-/
import MMM.Frob.Final
import MMM.Problem137

namespace MMM.Frob

open MMM PTree

/-- ∏_j m_j! of `Subst.lean` is the product of the factorials of Mathlib's digit list. -/
theorem digitFact_eq_digits {p : ℕ} (hp : 2 ≤ p) (m : ℕ) :
    digitFact p m = ((Nat.digits p m).map Nat.factorial).prod := by
  rw [← PTree.prod_dig_eq_digits p m hp]
  unfold digitFact
  rw [Finset.prod_range_succ,
    dig_eq_zero_of_lt (Nat.lt_pow_self (by omega : 1 < p)), Nat.factorial_zero, mul_one]

theorem fuss_leaves_modEq (q n : ℕ) : (q - 1) * n + 1 ≡ 1 [MOD q - 1] := by
  have h : (q - 1) * n + 1 ≡ 0 + 1 [MOD q - 1] :=
    (Nat.modEq_zero_iff_dvd.mpr (dvd_mul_right _ _)).add_right 1
  rw [zero_add] at h
  exact h

/-- The Fuss–Catalan number is the number of p-ary trees with (q - 1) n + 1 leaves, all at
depths divisible by k. -/
theorem fussCatalan_eq_card_blocked (p : ℕ) [hp : Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
    Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) =
      Nat.card {T : PTree p // T.leaves = (p ^ k - 1) * n + 1 ∧ BlockedAt k 0 T} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hq : 2 ≤ p ^ k := by
    calc 2 ≤ p := hp2
      _ = p ^ 1 := (pow_one p).symm
      _ ≤ p ^ k := Nat.pow_le_pow_right (by omega) hk
  rw [PTree.choose_div_eq_card (Nat.one_le_pow _ _ hp.out.pos) n,
    PTree.card_nodes_eq_card_leaves hq n, card_pow_ary_eq_card_blocked hp2 k hk]

/-- **The residue of the Fuss–Catalan number, by the Frobenius proof.** -/
theorem residue_fussCatalan_frobenius (p : ℕ) [hp : Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
        ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  have : NeZero k := ⟨by omega⟩
  rw [fussCatalan_eq_card_blocked p k n hk, ← digitFact_eq_digits hp.out.two_le]
  exact residue_frobenius p k _ t (fuss_leaves_modEq _ n) ht.symm

/-- **Problem 137 by the Frobenius proof, without conventions**: `p ^ t` is the exact power of
`p` in the Fuss–Catalan number. -/
theorem problem137_fussCatalan_exact_frobenius (p : ℕ) [hp : Fact p.Prime] (k n t : ℕ)
    (hk : 0 < k) (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) := by
  have : NeZero k := ⟨by omega⟩
  rw [fussCatalan_eq_card_blocked p k n hk]
  exact exact_valuation_blocked_frobenius p k _ t (fuss_leaves_modEq _ n) ht.symm

/-- **Problem 137 by the Frobenius proof**: `(p - 1) * v_p(C) + 1 = s_p((q - 1) n + 1)` for the
Fuss–Catalan number `C = binom(q n, n) / ((q - 1) n + 1)`, `q = p ^ k`. -/
theorem problem137_fussCatalan_frobenius (p : ℕ) [hp : Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
    (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
      (Nat.digits p ((p ^ k - 1) * n + 1)).sum := by
  have hp2 : 2 ≤ p := hp.out.two_le
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
  obtain ⟨e1, e2⟩ := problem137_fussCatalan_exact_frobenius p k n t hk ht'
  rw [multiplicity_eq_of_exact e1 e2, ht']
  rfl

end MMM.Frob
