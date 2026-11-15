/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.

  **The end of the lattice-path proof: Kummer's theorem with its residue, and Problem 137.**

`Slots.lean` proves the count of the minimal words (`minWords_eq_slotCount`); `KummerExact.lean`
and `Problem137.lean` derive everything else from that count, stated there as the hypothesis
`SlotHyp p`. This file puts the two together. The statements for the Fuss–Catalan number are
word for word those of `MMM/Problem137.lean` (the tree proof) and `MMM/Frob/Problem137.lean`
(the Frobenius proof).

The note: `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`, Theorem `thm:binom`
and Theorem `thm:main`. No Mathlib theorem about the valuation of a factorial or of a binomial
coefficient is used (see the audit lines in `MMM/Path/Axioms.lean`).
-/
import MMM.Path.Slots
import MMM.Path.Problem137

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- The count of the minimal words, in the form in which `KummerExact.lean` uses it. -/
theorem slotHyp [hp : Fact p.Prime] : SlotHyp p :=
  fun L n B hn hB => minWords_eq_slotCount hp.out.two_le L n B hn hB

/-- **Kummer's theorem** (Theorem `thm:binom`): if `c` is the number of carries when `n` and
`N - n` are added in base `p`, given through the digit sums, then `p ^ c` is the exact power of
`p` in `binom(N, n)`. -/
theorem kummer_exact [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N = ds p n + ds p (N - n)) :
    p ^ c ∣ N.choose n ∧ ¬ p ^ (c + 1) ∣ N.choose n :=
  kummer_exact_of slotHyp N n c hn hc

/-- **The residue of a binomial coefficient** (Theorem `thm:binom`; Anton, Stickelberger,
Hensel): `binom(N, n) ∏ n_j! m_j! ≡ (-p)^c ∏ N_j!  (mod p^(c+1))`. -/
theorem choose_residue [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N = ds p n + ds p (N - n)) :
    (N.choose n : ℤ) * ((digFact p n * digFact p (N - n) : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ c * (digFact p N : ℤ) [ZMOD (p : ℤ) ^ (c + 1)] :=
  choose_residue_of slotHyp N n c hn hc

/-- **Kummer's theorem with Mathlib's definitions only.** The number of carries `c` is given
through the digit sums: `(p - 1) c + s_p(N) = s_p(n) + s_p(N - n)`. -/
theorem kummer_exact_digits (p : ℕ) [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + (Nat.digits p N).sum =
      (Nat.digits p n).sum + (Nat.digits p (N - n)).sum) :
    p ^ c ∣ N.choose n ∧ ¬ p ^ (c + 1) ∣ N.choose n :=
  kummer_exact N n c hn hc

/-- Kummer's theorem as a valuation: `v_p(binom(N, n)) = c`. -/
theorem multiplicity_choose_eq_carries (p : ℕ) [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + (Nat.digits p N).sum =
      (Nat.digits p n).sum + (Nat.digits p (N - n)).sum) :
    multiplicity p (N.choose n) = c :=
  multiplicity_eq_of_exact (kummer_exact N n c hn hc).1 (kummer_exact N n c hn hc).2

/-- **The residue of a binomial coefficient with Mathlib's definitions only** (Anton,
Stickelberger, Hensel): `binom(N, n) ∏ n_j! ∏ m_j! ≡ (-p)^c ∏ N_j!  (mod p^(c+1))`, the products
over Mathlib's lists of base-`p` digits of `n`, `m = N - n` and `N`. -/
theorem choose_residue_digits (p : ℕ) [hp : Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + (Nat.digits p N).sum =
      (Nat.digits p n).sum + (Nat.digits p (N - n)).sum) :
    (N.choose n : ℤ) *
        ((((Nat.digits p n).map Nat.factorial).prod *
          ((Nat.digits p (N - n)).map Nat.factorial).prod : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ c * ((((Nat.digits p N).map Nat.factorial).prod : ℕ) : ℤ)
        [ZMOD (p : ℤ) ^ (c + 1)] := by
  have h := choose_residue N n c hn hc
  rw [digFact_eq_digits hp.out.two_le, digFact_eq_digits hp.out.two_le,
    digFact_eq_digits hp.out.two_le] at h
  exact h

/-- **The residue of the Fuss–Catalan number, by the lattice-path proof.** -/
theorem residue_fussCatalan_path (p : ℕ) [Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
        ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] :=
  residue_fussCatalan_path_of p slotHyp k n t hk ht

/-- **Problem 137 by the lattice-path proof, without conventions.** -/
theorem problem137_fussCatalan_exact_path (p : ℕ) [Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) :=
  problem137_fussCatalan_exact_path_of p slotHyp k n t hk ht

/-- **Problem 137 by the lattice-path proof.** -/
theorem problem137_fussCatalan_path (p : ℕ) [Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
    (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
      (Nat.digits p ((p ^ k - 1) * n + 1)).sum :=
  problem137_fussCatalan_path_of p slotHyp k n hk

end MMM.Path
