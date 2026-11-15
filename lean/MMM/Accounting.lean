/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.

  **The accounting proof of Problem 137 (Appendix C of the report; `paper/accounting_proof.tex`),
  assembled, and stated with Mathlib's definitions only.**

The text's proof has three parts; each is a file written by an Open Math OS worker and joined here.

* **Lemma L1** (`factorial_mul_card_blocked_modEq`, `MMM/AccountingL1.lean`):
  `m! * C ≡ (-p) ^ N (mod p ^ (N + 1))`, where `C` is the number of `p`-ary trees with `m` leaves,
  all at depths divisible by `k`, and `(p - 1) N + 1 = m`. Proof as in the text: label the leaves
  with `m` distinct labels (`m! * C` labelled trees) and count the labelled trees by the cherry
  collapse (`LTree.labelled_congruence_blocked`, which is part of the tree proof).
* **Legendre's formula with its residue** (the text's Lemmas L3 and L4):
  `m! = p ^ ν * ∏ m_j! * u` with `u ≡ (-1) ^ ν (mod p)`. See `legendre_accounting` below for what
  is proved as in the text and what is not.
* **The last step** (`residue_of_L1_of_legendre`, `MMM/AccountingDiv.lean`): divide the first by
  the second, with `N = ν + t`.

The final statements are those of `MMM/Problem137.lean`, proved a fourth time. Three general
facts are borrowed from the files of the Frobenius proof; none of them has to do with that proof:
`Frob.fussCatalan_eq_card_blocked` (the Fuss–Catalan number counts these trees) and
`Frob.fuss_leaves_modEq`, and from `MMM/ResidueForms.lean` the arithmetic `PTree.exact_of_residue`
(the congruence gives the exact power of `p`, because the digits are smaller than `p`).
-/
import MMM.AccountingL1
import MMM.AccountingDiv
import MMM.LegendreSym
import MMM.Frob.Problem137

namespace MMM.Acc

open MMM PTree

/-- **The theorem of the accounting proof**, from Lemma L1 and the last step, with Legendre's
formula and its residue as a hypothesis. -/
theorem residue_accounting_of (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m) (hm : m ≡ 1 [MOD p ^ k - 1])
    (hLeg : ∃ u : ℕ, m.factorial =
        p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m) :
    (Nat.card {U : PTree p // U.leaves = m ∧ PTree.BlockedAt k 0 U} : ℤ) *
        ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] :=
  residue_of_L1_of_legendre p m t _ ht
    (factorial_mul_card_blocked_modEq p k hk m (nu p m + t) (nodes_eq_nu_add p m t ht) hm) hLeg

/-- **Legendre's formula with its residue, as far as the text's argument is formalized.**
`m! = p ^ ν(m) * ∏ m_j! * u` with `u ≡ (-1) ^ ν(m) (mod p)`.

As in the text: `u` is the number `forestCount p m` defined by the recursion of Lemma L3,
`|F(m)| = binom(m, m_0) * K(m / p) * |F(m / p)|`, where `K(a)` is the number of permutations of
`p a` points all of whose cycles have length `p` (`Kcount`, with `Kcount_mul` from Mathlib's count
of the permutations of a given cycle type); Lemma L3 is `factorial_eq_forestCount` and Lemma L4 is
`forestCount_modEq_of`, from the two congruences `binom(p a + r, r) ≡ 1` and `K(a) ≡ (-1) ^ a`.

The two congruences are supplied below; the docstrings of `choose_congruence` and
`Kcount_congruence` say by which argument. -/
theorem legendre_accounting_of (p : ℕ) [Fact p.Prime]
    (hK : ∀ a, (Kcount p a : ZMod p) = (-1) ^ a)
    (hC : ∀ a r, r < p → ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1) (m : ℕ) :
    ∃ u : ℕ, m.factorial = p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m :=
  factorial_eq_pow_mul_prod_mul_sym_of p hK hC m

/-- `binom(p a + r, r) ≡ 1 (mod p)` for `r < p`: by the elementary computation `choose_cast` of `MMM/Dwork.lean`
(NOT the argument of the text, which lets a group of order `p` act on the `r`-subsets). -/
theorem choose_congruence (p : ℕ) [Fact p.Prime] (a r : ℕ) (hr : r < p) :
    ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1 :=
  choose_cast hr a

/-- `K(a) ≡ (-1) ^ a (mod p)`: from `K(a) = W(a)` (`Kcount_eq_W`) and Wilson's theorem
(`Kcount_modEq_wilson`; NOT the argument of the text, which is conjugation by a `p`-cycle). -/
theorem Kcount_congruence (p : ℕ) [Fact p.Prime] (a : ℕ) : (Kcount p a : ZMod p) = (-1) ^ a :=
  Kcount_modEq_wilson p a

/-- Legendre's formula with its residue: the recursion of the text with the two congruences
above. -/
theorem legendre_accounting (p : ℕ) [Fact p.Prime] (m : ℕ) :
    ∃ u : ℕ, m.factorial = p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m :=
  legendre_accounting_of p (Kcount_congruence p) (choose_congruence p) m

/-- **The theorem of the accounting proof**: for `m ≡ 1 (mod p ^ k - 1)` with digit sum
`(p - 1) t + 1`, the number `C` of `p`-ary trees with `m` leaves, all at depths divisible by `k`,
satisfies `C * ∏_j m_j! ≡ (-p) ^ t (mod p ^ (t + 1))`. -/
theorem residue_accounting (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
    (Nat.card {U : PTree p // U.leaves = m ∧ PTree.BlockedAt k 0 U} : ℤ) *
        ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] :=
  residue_accounting_of p k hk m t ht hm (legendre_accounting p m)

/-- **The residue of the Fuss–Catalan number, by the accounting proof.** -/
theorem residue_fussCatalan_accounting (p : ℕ) [hp : Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
        ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  rw [Frob.fussCatalan_eq_card_blocked p k n hk, ← PTree.prod_dig_eq_digits p _ hp.out.two_le]
  exact residue_accounting p k hk _ t ht (Frob.fuss_leaves_modEq _ n)

/-- **Problem 137 by the accounting proof, without conventions**: `p ^ t` is the exact power of
`p` in the Fuss–Catalan number. -/
theorem problem137_fussCatalan_exact_accounting (p : ℕ) [hp : Fact p.Prime] (k n t : ℕ)
    (hk : 0 < k) (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) := by
  rw [Frob.fussCatalan_eq_card_blocked p k n hk]
  exact PTree.exact_of_residue p hp.out _ ((p ^ k - 1) * n + 1) t
    (residue_accounting p k hk _ t ht (Frob.fuss_leaves_modEq _ n))

/-- **Problem 137 by the accounting proof**: `(p - 1) * v_p(C) + 1 = s_p((q - 1) n + 1)` for the
Fuss–Catalan number `C = binom(q n, n) / ((q - 1) n + 1)`, `q = p ^ k`. -/
theorem problem137_fussCatalan_accounting (p : ℕ) [hp : Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
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
  obtain ⟨e1, e2⟩ := problem137_fussCatalan_exact_accounting p k n t hk ht'
  rw [multiplicity_eq_of_exact e1 e2, ht']
  rfl

end MMM.Acc
