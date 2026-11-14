/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Problem 137, stated with Mathlib's definitions only.**

For a prime `p`, `q = p ^ k` with `k ≥ 1`, and the Fuss–Catalan number
`C = binom(q n, n) / ((q - 1) n + 1)`:

* `problem137_fussCatalan`:  `(p - 1) * v_p(C) + 1 = s_p((q - 1) n + 1)`;
* `problem137_fussCatalan_exact`:  `C > 0`, `p ^ t ∣ C` and `p ^ (t + 1) ∤ C`, where
  `(p - 1) t + 1 = s_p((q - 1) n + 1)`;
* `residue_fussCatalan`:  `C * ∏ (digits of (q - 1) n + 1)! ≡ (-p) ^ t  (mod p ^ (t + 1))`.

Nothing in these statements is defined in this project: `Nat.choose`, `Nat.digits`,
`multiplicity`, `Nat.factorial`, `Int.ModEq` are Mathlib's. Trees appear only in the proofs:
`MMM/FussFormula.lean` shows that `C` is the number of `q`-ary trees with `n` internal nodes, and
`MMM/ExactB.lean`, `MMM/ResidueForms.lean` contain the tree-symmetry proof for that number.
-/
import MMM.FussFormula
import MMM.ResidueForms

namespace MMM

variable {p : ℕ} [hp : Fact p.Prime]

/-- **Problem 137.** The exponent `v_p` of `p` in the Fuss–Catalan number
`binom(q n, n) / ((q - 1) n + 1)`, `q = p ^ k`, satisfies
`(p - 1) * v_p + 1 = s_p((q - 1) n + 1)`. -/
theorem problem137_fussCatalan (k n : ℕ) (hk : 0 < k) :
    (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
      (Nat.digits p ((p ^ k - 1) * n + 1)).sum := by
  rw [PTree.choose_div_eq_card (Nat.one_le_pow _ _ hp.out.pos) n]
  exact PTree.problem137 k n hk

/-- The same without conventions: the Fuss–Catalan number is positive, `p ^ t` divides it and
`p ^ (t + 1)` does not. -/
theorem problem137_fussCatalan_exact (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    0 < Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) := by
  rw [PTree.choose_div_eq_card (Nat.one_le_pow _ _ hp.out.pos) n]
  exact PTree.problem137_exact p hp.out k n t hk ht

/-- **The residue of the Fuss–Catalan number.** With `m = (q - 1) n + 1`:
`C * ∏ (digits of m)! ≡ (-p) ^ t  (mod p ^ (t + 1))`. -/
theorem residue_fussCatalan (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
        ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  rw [PTree.choose_div_eq_card (Nat.one_le_pow _ _ hp.out.pos) n]
  exact PTree.residue_nodes p hp.out k n t hk ht

end MMM
