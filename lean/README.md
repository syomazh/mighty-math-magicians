# Lean formalization

Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Four files (`MMM/LRot.lean`, `MMM/Cherry.lean`, `MMM/CherryB.lean`, `MMM/BlockedForm.lean`) were written by forked instances of the same model from the orchestrator's proof plans; `MMM/ResidueForms.lean` consists of lemmas written by the second auditor (another instance of the same model); `MMM/NormalForm.lean` was written by an Open Math OS worker (Mistral Large 4.0). Not human-reviewed.

This folder is a Lean 4 project that depends on Mathlib. A statement listed below as **checked** is one that Lean has compiled without `sorry` and with no axioms beyond Lean's three standard ones. Nothing else in this folder counts as verified.

## In one paragraph

Lean has checked **the theorem of Problem 137 for every prime power q = p^k, by the tree-symmetry proof**: if v_p is the exponent of p in the number of q-ary trees with n internal nodes, then (p − 1)·v_p + 1 = s_p((q − 1)n + 1), that is, v_p = (s_p((q − 1)n + 1) − 1)/(p − 1). Lean has also checked **the residue**, in the form (number of q-ary trees with m leaves)·∏ m_j! ≡ (−p)^t (mod p^(t+1)) for m ≡ 1 (mod q − 1), where the m_j are the base-p digits of m; and the paper's lemma "Normal form" for rotation equivalence. For q = 2 the valuation statement uses only Mathlib's own definitions: **v_2(C_n) = s_2(n + 1) − 1** for the Catalan numbers. No factorial valuation (Legendre, Kummer) is used. In Lean the number of trees is *defined by counting trees*; that it equals the Fuss–Catalan number binom(qn, n)/((q − 1)n + 1) is classical and is checked in Lean only for q = 2. Lean has **not** checked the accounting and Frobenius proofs.

## The final statements

    theorem MMM.PTree.problem137 {p : ℕ} [Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
        (p - 1) * multiplicity p (Nat.card {T : PTree (p ^ k) // T.nodes = n}) + 1 =
          (Nat.digits p ((p ^ k - 1) * n + 1)).sum

    theorem MMM.PTree.exact_valuation_primePower {p : ℕ} [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m t : ℕ)
        (ht : (p - 1) * t + 1 = ds p m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
        p ^ t ∣ Nat.card {T : PTree (p ^ k) // T.leaves = m} ∧
          ¬ p ^ (t + 1) ∣ Nat.card {T : PTree (p ^ k) // T.leaves = m}

    theorem MMM.PTree.exact_valuation {p : ℕ} [Fact p.Prime] (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
        p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} ∧
          ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m}

    theorem MMM.multiplicity_two_catalan (n : ℕ) :
        multiplicity 2 (catalan n) = (Nat.digits 2 (n + 1)).sum - 1

    theorem MMM.PTree.residue_primePower {p : ℕ} [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m t : ℕ)
        (ht : (p - 1) * t + 1 = ds p m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
        (Nat.card {T : PTree (p ^ k) // T.leaves = m} : ℤ) *
            ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
          (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]

(`dig p j m` is the j-th base-p digit of m; all digits of m have an index below m. The last statement is claim C12 of the ledger; it contains the exact valuation t and the residue (−1)^t/∏ m_j! of the quotient modulo p.)

Here `PTree q` is the type of plane trees in which every internal node has q ordered children, `nodes` and `leaves` count its internal nodes and leaves, `ds p m` is the base-p digit sum `(Nat.digits p m).sum`, `multiplicity p c` is Mathlib's p-adic valuation of a natural number, and `catalan` is Mathlib's Catalan number.

The "divides, does not divide" statements are the convention-free form: Mathlib sets `multiplicity p 0 = 0` and `Nat.card` of an infinite type to 0, and the second half of those statements excludes both cases.

## Status (last full build: 2026-11-14, `lake build` succeeded, no `sorry`)

| Step of the paper | Statement | Lean name | File |
|---|---|---|---|
| digits | s(p·n) = s(n); s(a + b) ≤ s(a) + s(b), also for finite sums | `ds_base_mul`, `ds_add_le`, `ds_sum_le` | `Digits.lean` |
| digits | no carry ⟹ the sum is digit by digit; digits of a sum of distinct powers; a number is determined by its digits | `ds_add_eq`, `dig_sum`, `ds_sum_pow`, `dig_sum_pow`, `ds_sum_of_dig_lt`, `eq_of_dig_eq` | `DigitsCarry.lean`, `DigitsFree.lean` |
| Step 0 | rotation equivalence is an equivalence relation; leaves and d are class invariants | `PTree.Rot.refl/.symm/.trans`, `.leaves_eq`, `.d_eq` | `Trees.lean`, `RotEquiv.lean` |
| Step 0, q = p^k | a q-ary tree is a p-ary tree with all leaves at depths divisible by k, with the same number of leaves | `PTree.card_pow_ary_eq_card_blocked` | `BlockedForm.lean` |
| **Step 1** | a rotation class has exactly p^d trees (p prime) | `PTree.card_class` | `ClassSize.lean` |
| **Step 2** | s_p(leaves T) ≤ (p − 1)·d(T) + 1, so d ≥ t | `PTree.lower_bound`, `PTree.t_le_d` | `Trees.lean` |
| divisibility | p^t divides the number of p-ary trees with m leaves; the same with leaves at depths divisible by k | `PTree.pow_dvd_card_trees`, `PTree.pow_dvd_card_blocked_trees` | `Divisibility.lean`, `Blocked.lean` |
| closed families (C11) | a finite family closed under rotation with d ≥ e everywhere has size divisible by p^e; modulo p^(t+1) only its trees with d = t count | `PTree.pow_dvd_card_of_closed`, `PTree.card_modEq_minimal_of_closed` | `Reduction.lean`, `ReductionB.lean` |
| reduction | #trees ≡ #minimal trees ≡ p^t · #minimal classes (mod p^(t+1)) | `PTree.card_trees_modEq_minimal`, `.card_trees_modEq_classes`, `.exact_of_classes` | `Reduction.lean` |
| **Step 3** | equality in Step 2: a symmetric node is then a complete tree; an asymmetric node has tight children added without carry | `PTree.tight_symm_d_zero`, `PTree.tight_asymm`, `PTree.eq_complete_of_d_eq_zero` | `Minimal.lean` |
| **Step 3** | the minimal trees with m leaves are, one to one, the carry-free trees of atoms of weight m | `LTree.minimalEquiv` | `Atoms.lean` |
| **Step 3** | such a tree has exactly m_j atoms of size p^j (the digits of m), and t nodes, all asymmetric | `LTree.cnt_eq_dig`, `LTree.typed_iff_cnt`, `LTree.ds_wt`, `LTree.d_realize` | `Atoms.lean`, `Retype.lean` |
| **Step 3**, q = p^k | the depth condition: an atom p^j hangs at a depth δ with k ∣ δ + j | `LTree.blockedAt_realize`, `LTree.card_minimal_blocked` | `ReductionB.lean` |
| equal atoms | giving one of c equal atoms a new name multiplies the number of trees by c; so #labelled trees = K · #minimal trees. For q = p^k the new name stays in the same class modulo k | `LTree.card_retype`, `LTree.card_refine`, `LTree.exists_distinct`, `LTree.exists_distinct_blocked` | `Retype.lean`, `RetypeB.lean` |
| **Step 4** | labelled trees: a class has p^(number of nodes) trees | `LTree.card_class` | `LRot.lean` |
| **Step 4** | a class fixed by the cyclic relabelling of p labels has these labels as a cherry | `LTree.cherry_of_fixed` | `Cherry.lean` |
| **Step 4** | the number of p-ary trees with (p − 1)t + 1 distinctly labelled leaves is divisible by p^t and not by p^(t+1) | `LTree.labelled_valuation` | `Cherry.lean` |
| **Step 4**, q = p^k | the same when each label has a class modulo k and must sit at a matching depth, provided ∑ p^class ≡ 1 (mod p^k − 1); a cherry of p labels of class c collapses to one label of class c + 1 | `LTree.labelled_valuation_blocked` | `CherryB.lean` |
| **Theorem, q = p** | exact power of p in the number of p-ary trees | `PTree.exact_valuation`, `PTree.fussCatalan_valuation`, `PTree.fussCatalan_valuation_nodes` | `Exact.lean`, `ExactB.lean` |
| **Theorem, q = p^k** | exact power of p in the number of q-ary trees: Problem 137 | `PTree.exact_valuation_primePower`, `PTree.problem137_leaves`, `PTree.problem137` | `ExactB.lean` |
| **Residue**, labelled trees | the number of labelled trees is ≡ (−p)^t (mod p^(t+1)); the sign comes from Wilson's theorem, (p − 1)! ≡ −1 | `LTree.labelled_congruence`, `LTree.labelled_congruence_blocked` | `Residue.lean`, `ResidueB.lean` |
| **Residue**, equal atoms | the factor between labelled and minimal trees is exactly ∏ (multiplicity)! | `LTree.exists_distinct_fact`, `LTree.exists_distinct_fact_blocked` | `Residue.lean`, `ResidueB.lean` |
| **Residue**, theorem | #trees · ∏ m_j! ≡ (−p)^t (mod p^(t+1)), for q = p and for q = p^k | `PTree.residue`, `PTree.residue_blocked`, `PTree.residue_primePower` | `Residue.lean`, `ResidueB.lean` |
| **Residue**, other forms | by internal nodes with Mathlib's digit list; the paper's form "#trees = p^t·c with c·∏ m_j! = (−1)^t in ZMod p"; the convention-free form of Problem 137 (positive, divides, does not divide) | `PTree.residue_nodes`, `PTree.residue_paper_form`, `PTree.problem137_exact`, `PTree.exact_of_residue` | `ResidueForms.lean` |
| Lemma "Normal form" | the relation `Rot` equals the equivalence relation generated by one cyclic shift of the children of one node | `PTree.rot_iff_eqvGen` | `NormalForm.lean` |
| q = 2 | our binary trees with n + 1 leaves are counted by Mathlib's `catalan n` | `PTree.card_binary_trees` | `Catalan.lean` |
| **Catalan numbers** | v_2(C_n) = s_2(n + 1) − 1 | `multiplicity_two_catalan` | `Exact.lean` |

`MMM/Axioms.lean` prints the axioms behind these theorems (76 lines). Every line shows only `propext`, `Classical.choice`, `Quot.sound` (Lean's standard axioms), and none shows `sorryAx`. It also contains concrete instances that Lean checks: 2^2 divides `catalan 6`; v_2(`catalan 6`) = 2; v_2(`catalan 7`) = 0; for quaternary trees (q = 4) v_2 = 2 with 2 nodes and v_2 = 1 with 3 nodes; for 9-ary trees v_3 = 2 with 2 nodes; and the residue statement instantiated for binary trees with 7 leaves.

## Where the Lean proof differs from the paper

The strategy and the order of the steps are the paper's. Five things are organized differently, and a reader who compares the two should know them.

1. **Rotation equivalence is defined directly in the normal form** (a shift at the root, then child by child). The paper defines it as generated by single rotations and proves the normal form as a lemma. That the two relations agree is `PTree.rot_iff_eqvGen` (`NormalForm.lean`, written by an Open Math OS worker, Mistral Large 4.0, and recompiled and read by the orchestrator). The final statements do not mention the relation.
2. **Step 3 is stated with trees, not with classes:** a bijection between the minimal trees and the carry-free trees of atoms (`realize`).
3. **No cyclic trees, no automorphisms.** The paper works with skeletons as cyclic trees and with lemmas about their automorphisms. Lean never forms these objects: it works with plane trees and counts them, and uses rotation classes only as sets of plane trees.
4. **Equal atoms.** The paper divides by ∏ m_j! using a free action of the permutations of equal atoms. Lean renames one atom at a time: each renaming multiplies the number of trees by the current multiplicity, and the product of these factors is ∏ m_j! (`exists_distinct_fact`). No group action is used.
5. **Step 4.** The paper counts the classes fixed by the cyclic relabelling exactly (p − 1 cyclic orders compatible with it), which gives the sign −1 directly. Lean puts all p! orderings of the cherry on one side. For the exact power of p it then needs only that p does not divide (p − 1)!; for the residue it uses Wilson's theorem, (p − 1)! ≡ −1 (mod p), from Mathlib. Wilson's theorem is a congruence for (p − 1)!, not a factorial valuation, but it is an ingredient the paper's argument does not need.

## Not checked by Lean

| Part | Why it matters |
|---|---|
| The corollary with the exact number of minimal classes for k = 1, (pt)!/(t!·p^t·∏ m_j!) | It needs the closed formula below. |
| The closed formula: the number of q-ary trees with n nodes is binom(qn, n)/((q − 1)n + 1) | Classical. In Lean the number of trees is defined by counting; it is tied to a known sequence only for q = 2 (Catalan numbers). Mathlib has no Fuss–Catalan numbers. |
| The paper's definitions and lemmas on skeletons as cyclic trees; the worked examples of the paper | See difference 3. |
| The accounting proof and the Frobenius proof | Nothing of either is formalized. |

## What one has to trust

- For `problem137`: three short definitions of ours (`PTree`, `PTree.nodes`, and for the other forms `PTree.leaves`; nine lines), Mathlib's `multiplicity`, `Nat.digits` and `Nat.card`, and the Lean kernel. Everything else (rotations, atoms, labels, cherries, depths) occurs only inside the proof.
- For the residue statements: in addition `ds` and `dig` (the digit sum and the j-th digit, two lines), Mathlib's `Int.ModEq`, `Nat.ModEq`, `Finset.prod` and `Nat.factorial`. `PTree.residue_nodes` replaces `dig` by Mathlib's digit list.
- For `multiplicity_two_catalan`: nothing of ours.
- Lean checks that each proof follows from the definitions **as written in the file**. Whether a definition says what the paper means is a matter of reading the definitions.
- The trust base as it is on this machine: Mathlib's compiled files come from its prebuilt cache and were not rebuilt here; the Lean toolchain is a release candidate (`v4.36.0-rc2`); no external replay of the proofs (`lean4checker`) was run.
- **An independent audit** of the statements for q = p (a separate AI instance; not a human) is recorded in `AUDIT.md`: no error found, seven points of wording and scope, all addressed above. A second audit, of the prime-power and residue files, is recorded there too: no error and no overclaim, seven points, all addressed. `ResidueForms.lean` (the second auditor's own lemmas) and `NormalForm.lean` were added after the audits and are covered only by the Lean kernel and the orchestrator's reading.

## Layout

| File | Content |
|---|---|
| `MMM/Digits.lean`, `DigitsCarry.lean`, `DigitsFree.lean` | base-p digit sums and carry-free sums, from the recursion; no factorial, no valuation |
| `MMM/Trees.lean`, `RotEquiv.lean`, `ClassSize.lean` | p-ary trees, rotation equivalence, d, Steps 1 and 2 |
| `MMM/Divisibility.lean`, `Blocked.lean`, `Counting.lean`, `Reduction.lean`, `ReductionB.lean` | finiteness, divisibility, closed families, reduction to minimal trees, depths |
| `MMM/BlockedForm.lean` | q-ary trees as p-ary trees with leaves at depths divisible by k |
| `MMM/Minimal.lean`, `LTree.lean`, `LBlocked.lean`, `Atoms.lean`, `Retype.lean`, `RetypeB.lean` | Step 3: tight trees, trees of atoms, digits, equal atoms, the depth condition |
| `MMM/LRot.lean`, `Cherry.lean`, `CherryB.lean` | Step 4: labelled trees, the cherry collapse, with classes modulo k |
| `MMM/ExactCond.lean`, `ExactAll.lean`, `Exact.lean` | the exact valuation for q = p, first with Step 4 as a hypothesis, then without |
| `MMM/ExactBCond.lean`, `ExactB.lean` | the same for q = p^k; Problem 137 |
| `MMM/Residue.lean`, `ResidueB.lean`, `ResidueForms.lean` | the residue, for q = p and for q = p^k, and its other forms |
| `MMM/NormalForm.lean` | the paper's lemma "Normal form" |
| `MMM/Catalan.lean` | the link to Mathlib's Catalan numbers for q = 2 |
| `MMM/Axioms.lean` | prints the axioms; seven concrete instances |
| `MMM/Smoke.lean` | a one-line test that the project compiles against Mathlib |
| `MMM/ClassSizeDraft.md` | the plan that `RotEquiv.lean` and `ClassSize.lean` carried out (a working note) |
| `AUDIT.md` | the independent audit of the statements for q = p |

Files in `MMM/` that are not imported by `MMM.lean` (for example work in progress by Open Math OS workers) are not part of the checked project and are not covered by anything said here.

## How to check

Lean is installed with `elan` in the user's home folder (`~/.elan`), not on the PATH. From this folder:

    export PATH="$USERPROFILE/.elan/bin:$PATH"     # Git Bash on Windows
    lake exe cache get                             # once: fetch Mathlib's prebuilt files
    lake build                                     # compiles everything; any error or `sorry` shows here

`lean-toolchain` pins the Lean version (`leanprover/lean4:v4.36.0-rc2`); `lake-manifest.json` pins the Mathlib commit. A full build takes a few minutes once Mathlib's prebuilt files are present. Disk use on this machine: about 3.2 GB for the toolchain (`~/.elan`) and about 7 GB for `lean/.lake` (Mathlib and its prebuilt files), which is not in git.
