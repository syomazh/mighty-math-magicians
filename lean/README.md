# Lean formalization

Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Four files (`MMM/LRot.lean`, `MMM/Cherry.lean`, `MMM/CherryB.lean`, `MMM/BlockedForm.lean`) were written by forked instances of the same model from the orchestrator's proof plans; `MMM/ResidueForms.lean` consists of lemmas written by the second auditor (another instance of the same model); `MMM/NormalForm.lean` was written by an Open Math OS worker (Mistral Large 4.0). Not human-reviewed.

This folder is a Lean 4 project that depends on Mathlib. A statement listed below as **checked** is one that Lean has compiled without `sorry` and with no axioms beyond Lean's three standard ones. Nothing else in this folder counts as verified.

## In one paragraph

Lean has checked **the theorem of Problem 137 for every prime power q = p^k, by the tree-symmetry proof**: if v_p is the exponent of p in the number of q-ary trees with n internal nodes, then (p − 1)·v_p + 1 = s_p((q − 1)n + 1), that is, v_p = (s_p((q − 1)n + 1) − 1)/(p − 1). Lean has also checked **the residue**, in the form (number of q-ary trees with m leaves)·∏ m_j! ≡ (−p)^t (mod p^(t+1)) for m ≡ 1 (mod q − 1), where the m_j are the base-p digits of m; and the paper's lemma "Normal form" for rotation equivalence. Lean has also checked the classical closed formula, that the number of q-ary trees with n internal nodes is the Fuss–Catalan number binom(qn, n)/((q − 1)n + 1). So **the theorem is stated with Mathlib's own definitions only** (`problem137_fussCatalan`): for C = binom(qn, n)/((q − 1)n + 1), (p − 1)·v_p(C) + 1 = s_p((q − 1)n + 1). No factorial valuation (Legendre, Kummer) is used in the tree-symmetry part; the closed formula is proved by a recursion on forests and Pascal's rule. Lean has **not** checked the accounting and Frobenius proofs.

**Since 2026-11-15 00:15 Lean has also checked a second proof of the same statements, the Frobenius proof** (`paper/frobenius_proof.tex`, claim C18): `MMM.Frob.problem137_fussCatalan_frobenius`, `MMM.Frob.problem137_fussCatalan_exact_frobenius` and `MMM.Frob.residue_fussCatalan_frobenius` in `MMM/Frob/Problem137.lean` are word for word the statements of `MMM/Problem137.lean`, and they are derived from `MMM.Frob.residue_frobenius` (`MMM/Frob/Final.lean`): for m ≡ 1 (mod p^k − 1) with s_p(m) = (p − 1)t + 1, the number C of p-ary trees with m leaves, all at depths divisible by k, satisfies C·∏ m_j! ≡ (−p)^t (mod p^(t+1)). This proof is algebra in ℤ[y][[x]] and in a ring of Hurwitz series; it uses no symmetry of trees. That is itself checked: `MMM/Frob/Deps.lean` defines a command that follows a proof term through every declaration of this project, and its output (at the end of `MMM/Frob/Axioms.lean`) shows that `residue_frobenius` reaches, outside `MMM/Frob/` and the digit files, only the definition of the trees and of the number of leaves, the definition `BlockedAt`, and three elementary facts (`leaves_pos`, `child_leaves_lt`, `finite_leaves_eq`); the form for the Fuss–Catalan number reaches in addition the tree-count formula, the blocked form of a q-ary tree and three arithmetic lemmas. The Lean proof follows the note's lemmas in order and differs from it in method at three places: the lemma "From the leading part to the labelled series" is proved by induction on m with a regrouping identity (`Subst.lean`), not through the note's algebra with a carry-free product; the carry congruence is applied n times along δ, δ + 1, …, δ + n (`Carry.lean`); Hurwitz series are functions on multi-indices with the binomial convolution (`HurwitzC.lean`). No human has read these files.

**Since 2026-11-15 00:59 Lean has also checked a third proof, the lattice-path proof** (the note in `guests/andrei-claude/notes/2026-11-14_path_proof/`, claim C24): `MMM.Path.problem137_fussCatalan_path`, `MMM.Path.problem137_fussCatalan_exact_path` and `MMM.Path.residue_fussCatalan_path` in `MMM/Path/Final.lean` are again word for word the statements of `MMM/Problem137.lean`. They come from two classical theorems, proved here from rotations of blocks of a word in two letters: `MMM.Path.kummer_exact` (Kummer: if (p − 1)c + s_p(N) = s_p(n) + s_p(N − n), then p^c divides binom(N, n) and p^(c+1) does not) and `MMM.Path.choose_residue` (binom(N, n)·∏ n_j! m_j! ≡ (−p)^c·∏ N_j! modulo p^(c+1), with the base-p digits of n, N − n and N). Both are also stated with Mathlib's definitions only (`MMM.Path.kummer_exact_digits`, `MMM.Path.choose_residue_digits`, and as a valuation `MMM.Path.multiplicity_choose_eq_carries`). No theorem of Mathlib about the valuation of a factorial or of a binomial coefficient is used: the audit at the end of `MMM/Path/Axioms.lean` lists, among Mathlib's declarations with such names, only `Nat.Prime.dvd_factorial` (p divides n! only if n ≥ p) and Wilson's theorem. Lean differs from the note in method at one place: the count of the minimal words is proved for every list of top blocks, by an induction that removes one block (`Slots1.lean`, `Slots2.lean`, `Slots.lean`), where the note describes the choices level by level for the digits of N. No human has read these files. **Version (since 2026-11-15 01:29):** the project is on **Lean v4.35.0 and Mathlib v4.35.0**, the versions the competition's rules require; a full build from scratch passes there (3272 jobs, no `sorry`, standard axioms only). A fresh clone of the pushed repository was built from scratch as well (2026-11-15 01:52), to imitate the competition's automated check. It was developed on Lean v4.36.0-rc2; the move needed two changes in the sources (the name of one Mathlib lemma about `multiplicity` in `ExactCond.lean`, and the name of a case of `Nat.strong_induction_on` in four files of `Frob/`).

## The final statements

    theorem MMM.problem137_fussCatalan {p : ℕ} [Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
        (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
          (Nat.digits p ((p ^ k - 1) * n + 1)).sum

    theorem MMM.residue_fussCatalan {p : ℕ} [Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
        (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
        ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
            ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
          (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]

These two (`MMM/Problem137.lean`) contain no definition of this project. The statements below are the same facts about the number of trees, from which they are derived.

    theorem MMM.PTree.fuss_catalan_formula {q : ℕ} (hq : 1 ≤ q) (n : ℕ) :
        ((q - 1) * n + 1) * Nat.card {T : PTree q // T.nodes = n} = Nat.choose (q * n) n

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

## Status (last full build: 2026-11-15 01:29, on Lean v4.35.0 and Mathlib v4.35.0, `lake build` succeeded, 3272 jobs, no `sorry`)

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
| **Closed formula** | (q t + r)·#(forests of r trees with t nodes) = r·binom(q t + r, t); ((q − 1)n + 1)·#(q-ary trees with n nodes) = binom(qn, n) | `PTree.forest_card`, `PTree.fuss_catalan_formula`, `PTree.choose_div_eq_card` | `FussFormula.lean` |
| **Problem 137, Mathlib's terms** | the valuation formula, its convention-free form, and the residue, for C = binom(qn, n)/((q − 1)n + 1) | `problem137_fussCatalan`, `problem137_fussCatalan_exact`, `residue_fussCatalan` | `Problem137.lean` |
| Dwork form (C20) | Legendre's formula with its residue, m! = p^ν·∏ m_j!·u with u ≡ (−1)^ν (mod p); and #trees·m! ≡ (−p)^N (mod p^(N+1)), N = (m − 1)/(p − 1). This statement is about m!, so it uses factorials by its nature (Wilson's theorem, block by block) | `factorial_eq_pow_mul_prod_mul`, `dwork_form` | `Dwork.lean` (worker W028, Kimi K3.1 Pro) |
| q = 2 | our binary trees with n + 1 leaves are counted by Mathlib's `catalan n` | `PTree.card_binary_trees` | `Catalan.lean` |
| **Catalan numbers** | v_2(C_n) = s_2(n + 1) − 1 | `multiplicity_two_catalan` | `Exact.lean` |

`MMM/Axioms.lean` prints the axioms behind these theorems (84 lines). Every line shows only `propext`, `Classical.choice`, `Quot.sound` (Lean's standard axioms), and none shows `sorryAx`. It also contains concrete instances that Lean checks: 2^2 divides `catalan 6`; v_2(`catalan 6`) = 2; v_2(`catalan 7`) = 0; for quaternary trees (q = 4) v_2 = 2 with 2 nodes and v_2 = 1 with 3 nodes; for 9-ary trees v_3 = 2 with 2 nodes; and the residue statement instantiated for binary trees with 7 leaves.

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
| The corollary with the exact number of minimal classes for k = 1, (pt)!/(t!·p^t·∏ m_j!) | A consequence of the closed formula that has not been written out in Lean. |
| The paper's definitions and lemmas on skeletons as cyclic trees; the worked examples of the paper | See difference 3. |
| The accounting proof | Its own argument is not formalized. (Its conclusion, the Dwork form C20, is checked by another route: see the status table.) |
| The Frobenius proof, beyond its first layer | Checked (`MMM/Frob/`, see the layout table): the ring, the lift, θ and its rules, and the uniqueness of the family F_δ. Since 19:00 also the existence of the family (`exists_unique_cyclicSystem`, worker W031) and its equation at y = p, G_δ = [δ = 0]·x + G_(δ+1)^p (`evalY_solution`). Since 19:25 also the note's lower bound and its corollary (`Weight.lean`, worker W034): every monomial x^m y^d of F_δ has s_p(m) ≤ (p − 1)d + 1 (`weight_solution`), so y^t divides the coefficient of x^m and p^t divides its value at y = p (`pow_dvd_coeff_evalY_solution`). Since 19:38 also `TreeGF.lean` (worker W035): the generating functions of the blocked trees satisfy G_δ = [k ∣ δ]·x + G_(δ+1)^p (`treeGF_eq`), that system has one solution (`treeSystem_unique`), hence the family at y = p is the generating function of the trees (`evalY_solution_eq_treeGF`); and `Divisibility.lean` (the orchestrator): **p^t divides the number of blocked trees with m leaves, by the Frobenius route** (`pow_dvd_card_blocked_frobenius`), a second machine-checked proof of the divisibility half, with no symmetry of trees in it. Since 22:48 also the note's Lemma "Leading part" (`YZero.lean`, `Lead.lean`; worker W036, the last theorem by the orchestrator): the family at y = 0 is the indicator series of the powers p^j with j ≡ −δ modulo k (`evalY0_solution`), and the coefficients ℓ_δ(m) of the monomials of weight −1 satisfy p·ℓ_δ = p·α_δ + (ℓ_(δ+1) to the carry-free p-th power) (`lead_solution`). Since 2026-11-15 00:15 **everything is checked**: the p-th derivative of a p-th power (`PowDeriv.lean`), Hurwitz series, the family H and its recursion, the carry congruence (`HurwitzC.lean`, `HFamily.lean`, `Carry.lean`), the evaluation (`Eval.lean`), the passage from the leading part to the labelled series (`Subst*.lean`), and the exactness and the residue by this route (`Final.lean`, `Problem137.lean`); see "In one paragraph". |

## What one has to trust

- For `problem137_fussCatalan` and `residue_fussCatalan`: nothing of ours. `Nat.choose`, `Nat.digits`, `multiplicity`, `Nat.factorial`, `Int.ModEq` are Mathlib's; the statement is the problem's, with natural-number division (exact here, by `fuss_catalan_formula`).
- For `problem137`: three short definitions of ours (`PTree`, `PTree.nodes`, and for the other forms `PTree.leaves`; nine lines), Mathlib's `multiplicity`, `Nat.digits` and `Nat.card`, and the Lean kernel. Everything else (rotations, atoms, labels, cherries, depths) occurs only inside the proof.
- For the residue statements: in addition `ds` and `dig` (the digit sum and the j-th digit, two lines), Mathlib's `Int.ModEq`, `Nat.ModEq`, `Finset.prod` and `Nat.factorial`. `PTree.residue_nodes` replaces `dig` by Mathlib's digit list.
- For `multiplicity_two_catalan`: nothing of ours.
- Lean checks that each proof follows from the definitions **as written in the file**. Whether a definition says what the paper means is a matter of reading the definitions.
- The trust base as it is on this machine: Mathlib's compiled files come from its prebuilt cache and were not rebuilt here; the Lean toolchain is the release `v4.35.0`; no external replay of the proofs (`lean4checker`) was run.
- **An independent audit** of the statements for q = p (a separate AI instance; not a human) is recorded in `AUDIT.md`: no error found, seven points of wording and scope, all addressed above. A second audit, of the prime-power and residue files, is recorded there too: no error and no overclaim, seven points, all addressed. `ResidueForms.lean` (the second auditor's own lemmas), `NormalForm.lean`, `FussFormula.lean` and `Problem137.lean` were added after the audits and are covered only by the Lean kernel and the orchestrator's reading. Both audits checked numerically that the number of q-ary trees equals binom(qn, n)/((q − 1)n + 1) (up to n = 110 for ten values of q).

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
| `MMM/FussFormula.lean`, `Problem137.lean` | the closed formula; Problem 137 and the residue for the binomial expression |
| `MMM/Catalan.lean` | the link to Mathlib's Catalan numbers for q = 2 |
| `MMM/Axioms.lean` | prints the axioms; seven concrete instances |
| `MMM/Frob/Basic.lean`, `Theta.lean`, `ThetaDiv.lean`, `ThetaIdents.lean`, `System.lean`, `Uniqueness.lean`, `Axioms.lean` | the first layer of the Frobenius proof (workers W025 and W027, Kimi K3.1 Pro; recompiled and read by the orchestrator): Λ = ℤ[y][[x]] and the lift φ: f(x, y) ↦ f(x^p, y^p) (`frobeniusLiftRingHom`); φ(f) ≡ f^p modulo p (`modSeries_frobeniusLift`); θ with p·θ(f) = f^p − φ(f) (`theta_spec`), its rules for sums and products (`theta_add`, `theta_mul`); a coefficient of f^p, φ(f), θ(f) of positive degree depends only on lower coefficients of f (`coeff_pow_lower`, `coeff_frobeniusLift_lower`, `coeff_theta_lower`); two families with zero constant terms that satisfy F_δ = [δ = 0]·x + φ(F_(δ+1)) + y·θ(F_(δ+1)) are equal (`cyclicSystem_unique`). `Frob/PLAN.md` is the workers' plan. `Existence.lean`, `Special.lean` (worker W031, Kimi K3.1 Pro): the family exists and is unique (`exists_unique_cyclicSystem`), built as the limit of the iterates of the right-hand side; substituting y = p turns the system into G_δ = [δ = 0]·x + G_(δ+1)^p (`evalY_solution`); substituting y = 0 turns it into f_δ = [δ = 0]·x + f_(δ+1)(x^p) (`evalY0_cyclicRHS_expand`). |
| `MMM/Path/Block.lean`, `ClassSize.lean`, `Bound.lean`, `Axioms.lean` | the path proof (claim C24), first part, for one block of length p^h (worker W032, Kimi K3.1 Pro; recompiled and read by the orchestrator): words as complete p-ary trees of letters (`Blk`), equivalence under rotations of sub-blocks (`Eqv`), the class of a word has p^d elements (`card_class`), s_p(a) + s_p(p^h − a) ≤ (p − 1)·d + 1 for a word with a letters E (`lower_bound`), and p^c divides the number of words with n letters E when c is the number of carries (`pow_dvd_card`). `Count.lean`, `Word.lean`, `Kummer.lean` (worker W033, Kimi K3.1 Pro; 19:33): the words on a block with n letters E number binom(p^h, n) (`card_cntE`); words cut into several blocks, their classes of size p^d and the bound (`card_classW`, `lower_boundW`); the base-p digits of N as a list of blocks (`exists_blocks`); and **Kummer's theorem, divisibility half, for every N** (`kummer_dvd`: if (p − 1)c + s_p(N) ≤ s_p(n) + s_p(N − n) then p^c divides binom(N, n)), proved from the action, with no theorem of Mathlib about valuations of factorials or binomial coefficients. **Not yet:** the smallest classes, their count and the residue (the exactness half), and the Fuss–Catalan corollary. |
| `MMM/Frob/PowDeriv.lean`, `Eval.lean`, `HurwitzC.lean`, `HFamily.lean`, `Carry.lean`, `Subst.lean`, `SubstDigits.lean`, `SubstVandermonde.lean` | the second half of the Frobenius proof (fresh-context Claude agents, briefs W038 to W042; `Eval.lean` started by worker W039; all recompiled and read by the orchestrator): D^p(u^p) for a derivation (`IsDer.iterate_pow_prime`); the evaluation T_0(a) ≡ (−1)^((|a| − 1)/(p − 1)) from the carry congruence (`eval_of_carry`); the ring of Hurwitz series `Hur ι`, `der`, `divPow`; the family H_δ = z_(−δ) + H_(δ+1)^p/p (`exists_unique_Hfam`), its coefficients `T` and their recursion (`T_rec`); the carry congruence (`carry`); ℓ_δ(m)·∏ m_j! = T_δ(a(m)) (`lead_mul_digitFact`) |
| `MMM/Frob/FinalGlue.lean`, `Final.lean`, `Problem137.lean`, `Deps.lean` | the end of the Frobenius proof (the orchestrator): digit lemmas for the glue; `residue_frobenius`, `exact_valuation_blocked_frobenius`; the three statements for the Fuss–Catalan number; the dependency audit (`#project_modules`, `#project_consts_in`) |
| `MMM/Path/Minimal.lean`, `MinBlock.lean`, `MinCount.lean`, `SlotsDef.lean` | the path proof, third part (a Claude agent, brief W041; `SlotsDef.lean` by the orchestrator): binom(N, n) is congruent modulo p^(c+1) to the number of words with d = c (`choose_modEq_minimal`); when a block and a word attain the bound (`minBlk_succ_iff`, `dW_eq_iff`); the number of minimal words as a sum over the letter counts of the top blocks (`card_minimal_words`); the number of minimal blocks by a closed recursion (`minCount_succ_eq`); definitions for the count (`minWords`, `slotCount`). The rest of the path proof followed on 2026-11-15 (next row). |
| `MMM/Path/Slots1.lean`, `Slots2.lean`, `Slots.lean`, `KummerExact.lean`, `Problem137.lean`, `Final.lean` | the path proof, fourth and fifth parts (Claude agents, briefs W043 and W044; `Final.lean` by the orchestrator; all recompiled and read): the number of minimal words over any list of top blocks satisfies a three-term recursion (`minWords_cons_succ`) and so does the closed formula (`slotCount_cons_succ`, by `trinomial_pascal`), hence they agree (`minWords_eq_slotCount`); the carries (`carryAt_rec`, `sum_carryAt`); the count for the digits of N is ∏ (N_j + p c_(j+1))!/(n_j! m_j!) (`slotCount_digits`); (r + p)! ≡ −p·r! modulo p² (`factorial_add_prime_modEq`, Wilson); `kummer_exact`, `choose_residue`; the three statements for the Fuss–Catalan number |
| `MMM/Smoke.lean` | a one-line test that the project compiles against Mathlib |
| `MMM/ClassSizeDraft.md` | the plan that `RotEquiv.lean` and `ClassSize.lean` carried out (a working note) |
| `AUDIT.md` | the independent audit of the statements for q = p |

Files in `MMM/` that are not imported by `MMM.lean` (for example work in progress by Open Math OS workers) are not part of the checked project and are not covered by anything said here.

## How to check

Lean is installed with `elan` in the user's home folder (`~/.elan`), not on the PATH. From this folder:

    export PATH="$USERPROFILE/.elan/bin:$PATH"     # Git Bash on Windows
    lake exe cache get                             # once: fetch Mathlib's prebuilt files
    lake build                                     # compiles everything; any error or `sorry` shows here

`lean-toolchain` pins the Lean version (`leanprover/lean4:v4.35.0`); `lakefile.toml` asks for Mathlib at the tag `v4.35.0` and `lake-manifest.json` pins that commit and those of Mathlib's own dependencies. A full build takes a few minutes once Mathlib's prebuilt files are present. Disk use on this machine: about 3.2 GB for the toolchain (`~/.elan`) and about 7 GB for `lean/.lake` (Mathlib and its prebuilt files), which is not in git.
