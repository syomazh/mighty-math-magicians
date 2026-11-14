# Lean formalization

Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Two files (`MMM/LRot.lean`, `MMM/Cherry.lean`) were written by a forked instance of the same model. Not human-reviewed.

This folder is a Lean 4 project that depends on Mathlib. A statement listed below as **checked** is one that Lean has compiled without `sorry` and with no axioms beyond Lean's three standard ones. Nothing else in this folder counts as verified.

## In one paragraph

Lean has checked **the theorem for q = p prime, by the tree-symmetry proof**: the exact power of p in the number of p-ary trees with m leaves is p^t, where t = (s_p(m) − 1)/(p − 1). In the indexing of Problem 137, with n internal nodes: (p − 1)·v_p + 1 = s_p((p − 1)n + 1). For p = 2 the statement uses only Mathlib's own definitions: **v_2(C_n) = s_2(n + 1) − 1** for the Catalan numbers. No factorial valuation (Legendre, Kummer) is used. Lean has **not** checked: prime powers q = p^k with k ≥ 2 (only the divisibility, in its p-ary form), the residue modulo p, the closed formula for the number of trees when p ≥ 3, and the accounting and Frobenius proofs.

## The three final statements

    theorem MMM.PTree.exact_valuation {p : ℕ} [Fact p.Prime] (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
        p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} ∧
          ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m}

    theorem MMM.PTree.fussCatalan_valuation {p : ℕ} [Fact p.Prime] (n : ℕ) :
        (p - 1) * multiplicity p (Nat.card {T : PTree p // T.leaves = (p - 1) * n + 1}) + 1 =
          (Nat.digits p ((p - 1) * n + 1)).sum

    theorem MMM.multiplicity_two_catalan (n : ℕ) :
        multiplicity 2 (catalan n) = (Nat.digits 2 (n + 1)).sum - 1

Here `ds p m` is the base-p digit sum `(Nat.digits p m).sum`, `multiplicity p c` is Mathlib's p-adic valuation of a natural number, and `catalan` is Mathlib's Catalan number.

## Status (last full build: 2026-11-14, `lake build` succeeded, no `sorry`)

| Step of the paper | Statement | Lean name | File |
|---|---|---|---|
| digits | s(p·n) = s(n); s(a + b) ≤ s(a) + s(b), also for finite sums | `ds_base_mul`, `ds_add_le`, `ds_sum_le` | `Digits.lean` |
| digits | no carry ⟹ the sum is digit by digit; digits of a sum of distinct powers; a number is determined by its digits | `ds_add_eq`, `dig_sum`, `ds_sum_pow`, `dig_sum_pow`, `ds_sum_of_dig_lt`, `eq_of_dig_eq` | `DigitsCarry.lean`, `DigitsFree.lean` |
| Step 0 | rotation equivalence is an equivalence relation; leaves and d are class invariants | `PTree.Rot.refl/.symm/.trans`, `.leaves_eq`, `.d_eq` | `Trees.lean`, `RotEquiv.lean` |
| **Step 1** | a rotation class has exactly p^d trees (p prime) | `PTree.card_class` | `ClassSize.lean` |
| **Step 2** | s_p(leaves T) ≤ (p − 1)·d(T) + 1, so d ≥ t | `PTree.lower_bound`, `PTree.t_le_d` | `Trees.lean` |
| divisibility | p^t divides the number of p-ary trees with m leaves | `PTree.pow_dvd_card_trees` | `Divisibility.lean` |
| divisibility, q = p^k | the same for p-ary trees with all leaves at depths divisible by k | `PTree.pow_dvd_card_blocked_trees` | `Blocked.lean` |
| closed families (C11) | a finite family closed under rotation with d ≥ e everywhere has size divisible by p^e | `PTree.pow_dvd_card_of_closed` | `Reduction.lean` |
| reduction | #trees ≡ #minimal trees ≡ p^t · #minimal classes (mod p^(t+1)); exactness follows once p ∤ #minimal classes | `PTree.card_trees_modEq_minimal`, `.card_trees_modEq_classes`, `.exact_of_classes` | `Reduction.lean` |
| **Step 3** | equality in Step 2: a symmetric node is then a complete tree; an asymmetric node has tight children added without carry | `PTree.tight_symm_d_zero`, `PTree.tight_asymm`, `PTree.eq_complete_of_d_eq_zero` | `Minimal.lean` |
| **Step 3** | the minimal trees with m leaves are, one to one, the carry-free trees of atoms of weight m | `LTree.minimalEquiv` | `Atoms.lean` |
| **Step 3** | such a tree has exactly m_j atoms of size p^j (the digits of m), and t nodes, all asymmetric | `LTree.cnt_eq_dig`, `LTree.typed_iff_cnt`, `LTree.ds_wt`, `LTree.d_realize` | `Atoms.lean`, `Retype.lean` |
| equal atoms | giving one of c equal atoms a new name multiplies the number of trees by c; so #labelled trees = K · #minimal trees | `LTree.card_retype`, `LTree.card_refine`, `LTree.exists_distinct` | `Retype.lean` |
| **Step 4** | labelled trees: a class has p^(number of nodes) trees | `LTree.card_class` | `LRot.lean` |
| **Step 4** | a class fixed by the cyclic relabelling of p labels has these labels as a cherry | `LTree.cherry_of_fixed` | `Cherry.lean` |
| **Step 4** | the number of p-ary trees with (p − 1)t + 1 distinctly labelled leaves is divisible by p^t and not by p^(t+1) | `LTree.labelled_valuation` | `Cherry.lean` |
| **Theorem, q = p** | exact power of p in the number of p-ary trees with m leaves | `PTree.exact_valuation`, `PTree.multiplicity_card_trees`, `PTree.fussCatalan_valuation` | `Exact.lean` |
| p = 2 | our binary trees with n + 1 leaves are counted by Mathlib's `catalan n` | `PTree.card_binary_trees` | `Catalan.lean` |
| **Catalan numbers** | v_2(C_n) = s_2(n + 1) − 1 | `multiplicity_two_catalan` | `Exact.lean` |

`MMM/Axioms.lean` prints the axioms behind each of these. Every line shows only `propext`, `Classical.choice`, `Quot.sound` (Lean's standard axioms), and none shows `sorryAx`. It also checks three concrete instances (2^2 divides C_6 = 132; v_2(C_6) = 2; C_7 = 429 is odd).

## Where the Lean proof differs from the paper

The strategy and the order of the steps are the paper's. Four things are organized differently, and a reader who compares the two should know them.

1. **Rotation equivalence is defined directly in the normal form** (a shift at the root, then child by child). The paper defines it as generated by single rotations and proves the normal form as a lemma; that lemma is not formalized. The final statements do not mention the relation.
2. **Step 3 is stated with trees, not with classes:** a bijection between the minimal trees and the carry-free trees of atoms (`realize`).
3. **Equal atoms.** The paper divides by ∏ m_j! using a free action of the permutations of equal atoms. Lean renames one atom at a time, which shows that the number of labelled trees is a multiple K of the number of minimal trees. That is enough for non-divisibility; the value of K is not needed.
4. **Step 4.** The paper counts the classes fixed by the cyclic relabelling exactly (p − 1 cyclic orders), which also gives the residue (−1)^t. Lean puts all p! orderings of the cherry on one side and uses only that p does not divide (p − 1)!. This gives the exact power of p, not the residue.

## Not checked by Lean

| Part | Why it matters |
|---|---|
| **Prime powers q = p^k, k ≥ 2:** the exact valuation, the depth condition on atoms, the lemma "Blocked form" | For k ≥ 2 Lean has only the divisibility for the p-ary trees with leaves at depths divisible by k. |
| **The residue** C/p^t ≡ (−1)^t/∏ m_j! (mod p) | See difference 4. |
| The closed formula: the number of p-ary trees with n nodes is binom(pn, n)/((p − 1)n + 1) | Classical. In Lean the number of trees is defined by counting; it is tied to a known sequence only for p = 2 (Catalan numbers). Mathlib has no Fuss–Catalan numbers. |
| Lemma "Normal form" | See difference 1. |
| The accounting proof and the Frobenius proof | Nothing of either is formalized. |

## What one has to trust

- For `fussCatalan_valuation`: two short definitions of ours (`PTree` and `PTree.leaves`, six lines), Mathlib's `multiplicity` and `Nat.digits`, and the Lean kernel. Everything else (rotations, atoms, labels, cherries) occurs only inside the proof.
- For `multiplicity_two_catalan`: nothing of ours.
- Lean checks that each proof follows from the definitions **as written in the file**. Whether a definition says what the paper means is a matter of reading the definitions.

## Layout

| File | Content |
|---|---|
| `MMM/Digits.lean`, `DigitsCarry.lean`, `DigitsFree.lean` | base-p digit sums and carry-free sums, from the recursion; no factorial, no valuation |
| `MMM/Trees.lean`, `RotEquiv.lean`, `ClassSize.lean` | p-ary trees, rotation equivalence, d, Steps 1 and 2 |
| `MMM/Divisibility.lean`, `Blocked.lean`, `Counting.lean`, `Reduction.lean` | finiteness, divisibility, closed families, reduction to minimal trees |
| `MMM/Minimal.lean`, `LTree.lean`, `Atoms.lean`, `Retype.lean` | Step 3: tight trees, trees of atoms, digits, equal atoms |
| `MMM/LRot.lean`, `Cherry.lean` | Step 4: labelled trees, the cherry collapse |
| `MMM/ExactCond.lean`, `ExactAll.lean`, `Exact.lean` | the exact valuation, first with Step 4 as a hypothesis, then without |
| `MMM/Catalan.lean` | the link to Mathlib's Catalan numbers for p = 2 |
| `MMM/Axioms.lean` | prints the axioms; three concrete instances |
| `MMM/Smoke.lean` | a one-line test that the project compiles against Mathlib |
| `MMM/ClassSizeDraft.md` | the plan that `RotEquiv.lean` and `ClassSize.lean` carried out (a working note) |

## How to check

Lean is installed with `elan` in the user's home folder (`~/.elan`), not on the PATH. From this folder:

    export PATH="$USERPROFILE/.elan/bin:$PATH"     # Git Bash on Windows
    lake exe cache get                             # once: fetch Mathlib's prebuilt files
    lake build                                     # compiles everything; any error or `sorry` shows here

`lean-toolchain` pins the Lean version (`leanprover/lean4:v4.36.0-rc2`); `lake-manifest.json` pins the Mathlib commit. A full build takes a few minutes once Mathlib's prebuilt files are present. Disk use on this machine: about 3.2 GB for the toolchain (`~/.elan`) and about 7 GB for `lean/.lake` (Mathlib and its prebuilt files), which is not in git.
