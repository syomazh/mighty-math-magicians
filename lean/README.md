# Lean formalization

Written by Claude Fable 5.2 (AI). First versions: the orchestrating AI system of the project, 2026-11-14 and 15. Rewritten as one document on 2026-11-15, about 03:35 PT, by the separate instance that made the third audit (`AUDIT3.md`), at the orchestrator's request, from the files as they were at commit `358e4b0`. Not human-reviewed.

This folder is a Lean 4 project (library `MMM`, 85 files under `MMM/`, 17,533 lines) on top of Mathlib. **All Lean files were written by AI systems, and no human has read any of them.**

A statement is called **checked** in this file when it is in the build of this project on **Lean v4.35.0 with Mathlib v4.35.0**, with no `sorry`, no `native_decide`, and no axioms beyond `propext`, `Classical.choice`, `Quot.sound`. Those are the conditions of the competition's rules for "Lean-verified", together with one that Lean cannot check: that the formal statement says what the written text claims. Section 3 lists every known difference between a formal statement and the written one; Section 6 says who looked for more. The competition's own build decides; ours is described in Section 8.

Who wrote the files (each file's header says it; Section 9 lists them):

- the orchestrating AI system (Claude Fable 5.2 in Claude Code): most files of the tree proof, the last files of each of the other proofs, the audit files, and, according to the project's records, the statements and proof plans given to the others;
- forked or fresh-context instances of the same model, each from a brief: four files of the tree proof, the second half of the algebraic proof, parts three to five of the lattice-path proof, the exact count, the carry budget, closed families and profiles, weights;
- Open Math OS workers: Kimi K3.1 Pro (the first half of the algebraic proof, the first two parts of the lattice-path proof, `Dwork.lean`) and Mistral Large 4.0 (`NormalForm.lean`);
- `ResidueForms.lean` consists of lemmas written by the second auditor.

## 1. What Lean has checked

For a prime p, k ≥ 1, q = p^k and C = binom(qn, n)/((q − 1)n + 1), the Fuss–Catalan number:

    theorem MMM.problem137_fussCatalan {p : ℕ} [Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
        (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
          (Nat.digits p ((p ^ k - 1) * n + 1)).sum

that is, (p − 1)·v_p(C) + 1 = s_p((q − 1)n + 1). With it: p^t divides C and p^(t+1) does not, and the residue C·∏ m_j! ≡ (−p)^t (mod p^(t+1)), where the m_j are the base-p digits of m = (q − 1)n + 1 and (p − 1)t + 1 = s_p(m). These statements contain only Mathlib's definitions. The exact texts are in Section 2.

**Lean has checked three proofs of these statements.**

1. **Rotations of trees** (the main proof; written proof `paper/main.tex`, claims C1 to C8 and C12). Each step has a formal statement (in five places the formal argument is organized differently from the text: Section 3.1): a q-ary tree as a p-ary tree with leaves at depths divisible by k; a rotation class has p^d trees; d ≥ t from digit sums; the trees with d = t as carry-free trees of atoms given by the digits of m; equal atoms; the collapse of a cherry of labelled leaves; the exact power and the residue for every prime power; the closed formula ((q − 1)n + 1)·#(q-ary trees with n nodes) = binom(qn, n), which turns the statement about trees into the one above; the lemma "Normal form"; and for q = 2 the statement v_2(C_n) = s_2(n + 1) − 1 for Mathlib's Catalan numbers.
2. **The algebraic ("Frobenius") proof** (`paper/frobenius_proof.tex`, claim C18). The whole chain: the family F_δ in ℤ[y][[x]], its value at y = p as the generating function of the trees, the lower bound by weights, the leading part, the Hurwitz series H_δ, the carry congruence, the evaluation, and the residue (`MMM.Frob.residue_frobenius`). It reaches no rotation, no class of trees and no cherry (Section 7).
3. **The lattice-path proof** (the note `path_proof.tex` in `notes/2026-11-14_path_proof/` of the first guest session's folder under `guests/`; claim C24). It proves, for every N and n ≤ N, **Kummer's theorem with the exact power and with its residue** (`MMM.Path.kummer_exact_digits`, `MMM.Path.choose_residue_digits`, `MMM.Path.multiplicity_choose_eq_carries`), from rotations of the blocks of a word in two letters, and from them the three statements for C.

**Around these proofs** Lean has also checked: the exact number of minimal classes for q = p (C8, `MMM.card_minimal_classes_mul`); the carry budget (C19, `MMM.PTree.excess`); the congruence for rotation-closed families (C11, `MMM.PTree.card_closed_modEq_classes`); the divisibility of level-profile products (C10, `MMM.pow_dvd_prod_choose_profile`); sums of rotation-invariant weights (C28, `MMM.PTree.pow_dvd_sum_depthWeight`); a product formula for minimal words over arbitrary lists of blocks (C27, `MMM.Path.minWords_eq_slotCount`); and two conclusions of the accounting proof by a classical route, the Dwork form (C20, `MMM.dwork_form`) and Legendre's formula with its residue (`MMM.factorial_eq_pow_mul_prod_mul`).

**"Without valuations of factorials."** In the full closure of each final theorem, through Mathlib, there is no theorem of Mathlib on the power of p in a factorial or in a binomial coefficient, and nothing named after Kummer, Legendre or Lucas. This is a search by names (Section 7). For the algebraic proof it is true only since 2026-11-15, about 03:00 (Section 6). `MMM.dwork_form` and `MMM.factorial_eq_pow_mul_prod_mul` are statements about m! and are outside this claim.

**Status of the written proofs** (`CLAIMS.md`, latest entries; a sign-off is for a written proof and never covers a Lean file): C1 to C8 and C24 `human-signed` (a faculty member of the team approved the main proof and read and verified the lattice-path proof, 2026-11-14; what is recorded about the extent of the first reading is one sentence); C12, C13 read by the same person, not signed; C18 and C19 `ai-reviewed` with qualifications, no human reader; C10, C11, C28 `ai-proved`, no human reader; C27 `computed`, with no written proof; C9 and C17 conjectures.

## 2. The final statements, as they are in the files

`MMM/Problem137.lean` (the tree proof; the file declares `variable {p : ℕ} [hp : Fact p.Prime]`):

    theorem problem137_fussCatalan (k n : ℕ) (hk : 0 < k) :
        (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
          (Nat.digits p ((p ^ k - 1) * n + 1)).sum

    theorem problem137_fussCatalan_exact (k n t : ℕ) (hk : 0 < k)
        (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
        0 < Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
          p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
          ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)

    theorem residue_fussCatalan (k n t : ℕ) (hk : 0 < k)
        (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
        ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
            ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
          (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]

`MMM/Frob/Problem137.lean` (the algebraic proof):

    theorem problem137_fussCatalan_frobenius (p : ℕ) [hp : Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
        (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
          (Nat.digits p ((p ^ k - 1) * n + 1)).sum

    theorem problem137_fussCatalan_exact_frobenius (p : ℕ) [hp : Fact p.Prime] (k n t : ℕ)
        (hk : 0 < k) (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
        p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
          ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)

    theorem residue_fussCatalan_frobenius (p : ℕ) [hp : Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
        (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
        ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
            ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
          (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]

`MMM/Path/Final.lean` (the lattice-path proof):

    theorem problem137_fussCatalan_path (p : ℕ) [Fact p.Prime] (k n : ℕ) (hk : 0 < k) :
        (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
          (Nat.digits p ((p ^ k - 1) * n + 1)).sum

    theorem problem137_fussCatalan_exact_path (p : ℕ) [Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
        (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
        p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
          ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)

    theorem residue_fussCatalan_path (p : ℕ) [Fact p.Prime] (k n t : ℕ) (hk : 0 < k)
        (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
        ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
            ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
          (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]

    theorem kummer_exact_digits (p : ℕ) [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
        (hc : (p - 1) * c + (Nat.digits p N).sum =
          (Nat.digits p n).sum + (Nat.digits p (N - n)).sum) :
        p ^ c ∣ N.choose n ∧ ¬ p ^ (c + 1) ∣ N.choose n

    theorem choose_residue_digits (p : ℕ) [hp : Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
        (hc : (p - 1) * c + (Nat.digits p N).sum =
          (Nat.digits p n).sum + (Nat.digits p (N - n)).sum) :
        (N.choose n : ℤ) *
            ((((Nat.digits p n).map Nat.factorial).prod *
              ((Nat.digits p (N - n)).map Nat.factorial).prod : ℕ) : ℤ) ≡
          (-(p : ℤ)) ^ c * ((((Nat.digits p N).map Nat.factorial).prod : ℕ) : ℤ)
            [ZMOD (p : ℤ) ^ (c + 1)]

`MMM/Profile.lean` (level profiles):

    theorem pow_dvd_prod_choose_profile (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (L : ℕ)
        (n : ℕ → ℕ) (h0 : n 0 = 1) (hL : n L = 0) (t : ℕ)
        (ht : (p - 1) * t + 1 =
          (Nat.digits p ((p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1)).sum) :
        p ^ t ∣ ∏ i ∈ Finset.range L, Nat.choose (p ^ k * n i) (n (i + 1))

The valuation statements of the three proofs are the same proposition, and so are the three residue statements (checked: `rfl` proves the equality of their types; only the binder of p differs). The two companions `Frob.problem137_fussCatalan_exact_frobenius` and `Path.problem137_fussCatalan_exact_path` are **not** word for word `problem137_fussCatalan_exact`: they lack the first part, 0 < C, which follows from the last part.

In `Path.kummer_exact_digits` the number c of carries enters through the digit sums. Such a c always exists and is the number of carries of the addition of n and N − n in base p: `Path.sum_carryAt`, `Path.carryAt_rec`.

## 3. Declarations, what they support, and the differences from the written statements

All names are in the namespace `MMM` (`PTree.x` is `MMM.PTree.x`, `Frob.x` is `MMM.Frob.x`, and so on); files are under `MMM/`. "Text" is the written proof named in the heading. Notation: m leaves, m_j the base-p digits of m, s_p the digit sum, (p − 1)t + 1 = s_p(m), d(T) the number of asymmetric nodes.

### 3.1 The tree proof (text: `paper/main.tex`, Section 3 of the report)

| Declarations (file) | What they say | Supports | Differences from the text |
|---|---|---|---|
| `problem137_fussCatalan`, `problem137_fussCatalan_exact`, `residue_fussCatalan` (`Problem137.lean`) | Section 2 | C6, C7, C12: the main theorem, for the binomial expression | The text's C_n^(q) is the number of trees. Lean uses natural-number division, exact by `PTree.fuss_catalan_formula`; Mathlib's `multiplicity`; n = 0 is allowed. The residue is the compact form modulo p^(t+1); the text states the quotient modulo p. |
| `PTree.problem137`, `PTree.problem137_exact`, `PTree.residue_nodes` (by nodes); `PTree.problem137_leaves`, `PTree.exact_valuation_primePower`, `PTree.residue_primePower`, `PTree.residue_paper_form` (by leaves, for m ≡ 1 mod q − 1) (`ExactB.lean`, `ResidueB.lean`, `ResidueForms.lean`) | the same for the number of q-ary trees | C6, C7, C12, for the number of trees | The number of trees is `Nat.card` of a type of trees. `PTree.residue_paper_form` is the text's form: #trees = p^t·c with c·∏ m_j! = (−1)^t in `ZMod p`. |
| `PTree.exact_valuation`, `PTree.fussCatalan_valuation`, `PTree.fussCatalan_valuation_nodes`, `PTree.residue` (`Exact.lean`, `ExactB.lean`, `Residue.lean`) | the case q = p | the same, k = 1 | none beyond the row above |
| `PTree.fuss_catalan_formula`, `PTree.choose_div_eq_card`, `PTree.card_nodes_mul_eq_choose`, `PTree.forest_card` (`FussFormula.lean`) | ((q − 1)n + 1)·#trees = binom(qn, n); (qn + 1)·#trees = binom(qn + 1, n); forests of r trees | the closed formula, which the text cites | Proved by a recursion on forests and Pascal's rule; the text only recalls the formula. |
| `PTree.card_pow_ary_eq_card_blocked` (`BlockedForm.lean`) | #(q-ary trees with m leaves) = #(p-ary trees with m leaves, all at depths divisible by k) | Lemma "Blocked form" (Step 0) | An equality of two numbers; the bijection is inside the proof. |
| `PTree.rot_iff_eqvGen` (`NormalForm.lean`); `PTree.Rot.refl`, `.symm`, `.trans`, `.leaves_eq`, `.d_eq` (`Trees.lean`, `RotEquiv.lean`) | `PTree.Rot` is the equivalence relation generated by one cyclic shift of the children of one node; leaves and d are class invariants | Lemma "Normal form" | **Difference 1.** Lean defines rotation equivalence directly in the normal form (a shift at the root, then child by child); the text defines it as generated by single rotations. The final statements do not mention the relation. |
| `PTree.card_class` (`ClassSize.lean`) | a rotation class has exactly p^d trees (p prime) | C1, Lemma "Class size" | none |
| `ds_base_mul`, `ds_add_le`, `ds_sum_le`, `ds_add_eq`, `dig_sum`, `ds_sum_pow`, `dig_sum_pow`, `ds_sum_of_dig_lt`, `eq_of_dig_eq` (`Digits.lean`, `DigitsCarry.lean`, `DigitsFree.lean`) | s(pn) = s(n); s(a + b) ≤ s(a) + s(b); equality means no carry; digits of carry-free sums | Lemma "Digit lemma" | Proved from the recursion s(n) = n mod p + s(n div p); no factorial, no valuation. |
| `PTree.lower_bound`, `PTree.t_le_d`, `PTree.pow_dvd_card_trees`, `PTree.pow_dvd_card_blocked_trees` (`Trees.lean`, `Divisibility.lean`, `Blocked.lean`) | s_p(leaves T) ≤ (p − 1)·d(T) + 1; p^t divides the number of trees | C2, Proposition "Lower bound" | The bound holds for every p ≥ 2. |
| `PTree.card_trees_modEq_minimal`, `PTree.card_trees_modEq_classes`, `PTree.exact_of_classes`, `PTree.pow_dvd_card_of_closed`, `PTree.card_modEq_minimal_of_closed` (`Reduction.lean`, `ReductionB.lean`) | #trees ≡ #minimal trees ≡ p^t·#minimal classes (mod p^(t+1)) | the reduction to the minimal classes | Here the congruence with the number of classes is for the family of all trees with m leaves; for any closed family see C11 in 3.4. |
| `PTree.tight_symm_d_zero`, `PTree.tight_asymm`, `PTree.eq_complete_of_d_eq_zero` (`Minimal.lean`); `LTree.minimalEquiv`, `LTree.cnt_eq_dig`, `LTree.typed_iff_cnt`, `LTree.ds_wt`, `LTree.d_realize` (`Atoms.lean`, `Retype.lean`); `LTree.blockedAt_realize`, `LTree.card_minimal_blocked` (`ReductionB.lean`) | the trees with d = t are, one to one, the carry-free trees of atoms of weight m; such a tree has m_j atoms of size p^j; an atom p^j hangs at a depth δ with k ∣ δ + j | C3, Propositions "Local characterization" and "Minimal classes are skeleton trees" | **Differences 2 and 3.** Stated with trees, not classes. Lean never forms cyclic trees or their automorphisms: the Lemmas "Plane representatives", "Skeleton nodes are asymmetric", "Automorphisms of cyclic trees" and "Moving-leaf lemma" have no formal counterpart. |
| `LTree.card_retype`, `LTree.card_refine`, `LTree.exists_distinct`, `LTree.exists_distinct_blocked`, `LTree.exists_distinct_fact`, `LTree.exists_distinct_fact_blocked` (`Retype.lean`, `RetypeB.lean`, `Residue.lean`, `ResidueB.lean`) | #(trees with pairwise different atoms) = ∏ m_j!·#(minimal trees) | C4, Proposition "Removing labelling", as a count | **Difference 4.** The text divides by ∏ m_j! with a free action of the permutations of equal atoms. Lean renames one atom at a time; each renaming multiplies the number of trees by the current multiplicity. No group action is formal. |
| `LTree.card_class` (`LRot.lean`); `LTree.cherry_of_fixed`, `LTree.labelled_valuation` (`Cherry.lean`); `LTree.labelled_valuation_blocked` (`CherryB.lean`); `LTree.labelled_congruence`, `LTree.labelled_congruence_blocked` (`Residue.lean`, `ResidueB.lean`) | a class of labelled trees has p^(nodes) trees; a class fixed by the cyclic relabelling of p labels has them as a cherry; the number of trees with (p − 1)t + 1 distinct labels is ≡ (−p)^t (mod p^(t+1)) | C5, Propositions "A carry collapses a cherry" and "Iterated carries" | **Difference 5.** The text counts the fixed classes exactly (p − 1 cyclic orders), which gives the sign. Lean puts all p! orderings of the cherry on one side and uses Wilson's theorem from Mathlib, an ingredient the text does not need (a congruence, not a valuation). The congruence T(a) ≡ −T(a′) itself is not a formal statement. |
| `multiplicity_two_catalan` (`Exact.lean`), `PTree.card_binary_trees` (`Catalan.lean`) | v_2(`catalan n`) = s_2(n + 1) − 1; binary trees with n + 1 leaves are counted by `catalan n` | the case q = 2 | none; no definition of the project is in the first statement |

### 3.2 The algebraic proof (text: `paper/frobenius_proof.tex`, Appendix B of the report; C18)

| Declarations (file) | What they say | Supports | Differences from the text |
|---|---|---|---|
| `Frob.problem137_fussCatalan_frobenius`, `Frob.problem137_fussCatalan_exact_frobenius`, `Frob.residue_fussCatalan_frobenius` (`Frob/Problem137.lean`) | Section 2 | the theorem, for the binomial expression | In the text C_n^(q) is a coefficient of the solution of G = x + G^q. In Lean it is the number of trees, linked to the binomial expression by `FussFormula.lean` and `BlockedForm.lean`. The companion lacks 0 < C (Section 2). |
| `Frob.residue_frobenius`, `Frob.exact_valuation_blocked_frobenius` (`Frob/Final.lean`) | for m ≡ 1 (mod p^k − 1) with s_p(m) = (p − 1)t + 1: #(p-ary trees with m leaves at depths divisible by k)·∏ m_j! ≡ (−p)^t (mod p^(t+1)); p^t is the exact power | the theorem, for these trees | none beyond the row above |
| `Frob.modSeries_frobeniusLift`, `Frob.theta_spec`, `Frob.theta_add`, `Frob.theta_mul` (`Frob/Theta.lean`, `ThetaDiv.lean`, `ThetaIdents.lean`) | φ(f) ≡ f^p modulo p; p·θ(f) = f^p − φ(f); rules for sums and products | the lemma on θ | θ is chosen from the divisibility, not given by the text's formula; "every monomial of θ(f) is a product of p monomials of f" is not formal. The congruence is proved from the binomial theorem and p ∣ binom(p, k) (`Frob.add_pow_prime_of_natCast_eq_zero`, `Frob.pow_prime_eq_expand_series`), as in the text; until 2026-11-15 it was taken from Mathlib's Frobenius map (Section 6). |
| `Frob.exists_unique_cyclicSystem`, `Frob.evalY_solution`, `Frob.treeGF_eq`, `Frob.treeSystem_unique`, `Frob.evalY_solution_eq_treeGF` (`Frob/Existence.lean`, `Special.lean`, `TreeGF.lean`) | exactly one family F_δ without constant terms satisfies F_δ = [δ = 0]·x + φ(F_(δ+1)) + y·θ(F_(δ+1)); at y = p it is the family of generating functions of the trees whose leaves are at depths ≡ −δ modulo k | the lemma on the system | F_δ is the limit of the iterates of the right-hand side. The text identifies F_0(x, p) with the solution of G = x + G^q; Lean shows that the generating functions of the trees satisfy G_δ = [k ∣ δ]·x + G_(δ+1)^p and that this system has one solution; G = x + G^q is not stated. The first declaration also allows k = 0. |
| `Frob.weight_solution`, `Frob.X_pow_dvd_coeff_solution`, `Frob.pow_dvd_card_blocked_frobenius` (`Frob/Weight.lean`, `Divisibility.lean`) | every monomial x^m y^d of F_δ has s_p(m) ≤ (p − 1)d + 1; y^t divides the coefficient of x^m; p^t divides the number of trees | Lemma "Lower bound" and its corollary | θ is not expanded into monomials: the weights of f^p and of φ(f) are bounded instead. |
| `Frob.evalY0_solution`, `Frob.lead_solution` (`Frob/YZero.lean`, `Lead.lean`) | F_δ at y = 0 is the indicator series of the powers p^j with j ≡ −δ; p·ℓ_δ = p·α_δ + (carry-free p-th power of ℓ_(δ+1)) | Lemma "Leading part" | Stated in ℤ, multiplied by p (the text has 1/p in a ℚ-algebra). The carry-free product is a sum over p-tuples whose digit sums add up. |
| `Frob.exists_unique_Hfam`, `Frob.T_rec` (`Frob/HFamily.lean`, `Carry.lean`) | the family H_δ = z_(−δ) + H_(δ+1)^p/p and the recursion of its coefficients T_δ(a) | the lemma on H_δ | Hurwitz series are integer-valued functions on multi-indices with the binomial convolution (`Frob.Hur`), so T_δ(a) is an integer by construction and uniqueness is among integral families. `Frob.T_rec` is multiplied by p. |
| `Frob.IsDer.iterate_pow_prime`, `Frob.carry` (`Frob/PowDeriv.lean`, `Carry.lean`) | D^p(u^p) for a derivation; p divides T_δ(b + p·e_c) + T_δ(b + e_(c+1)) | the lemma on Hurwitz series, Proposition "The carry operator" | The congruence is applied n times along δ, δ + 1, …, δ + n, not k times around the cycle. |
| `Frob.eval_of_carry` (`Frob/Eval.lean`) | T_0(a) ≡ (−1)^((Σ_c a_c − 1)/(p − 1)) modulo p for a ≠ 0 whose weight Σ_c a_c·p^c is ≡ 1 modulo q − 1 | Proposition "Evaluation" | Stated for any function with T_0(e_0) = 1 and the carry congruence. |
| `Frob.lead_mul_digitFact` (`Frob/Subst.lean`, with `SubstDigits.lean`, `SubstVandermonde.lean`) | ℓ_δ(m)·∏ m_j! = T_δ(a(m)) | Lemma "From the leading part to the labelled series" | Proved by induction on m with a regrouping identity, not through the text's algebra with the carry-free product; stated for any family with the recursion `Frob.LabelledRec`. |

### 3.3 The lattice-path proof (text: the note `path_proof.tex`, Appendix A of the report; C24, C27)

| Declarations (file) | What they say | Supports | Differences from the text |
|---|---|---|---|
| `Path.problem137_fussCatalan_path`, `Path.problem137_fussCatalan_exact_path`, `Path.residue_fussCatalan_path` (`Path/Final.lean`, from `Path/Problem137.lean`) | Section 2 | the main theorem of the note | The identity (qn + 1)·C = binom(qn + 1, n), and with it the exactness of the division, come from the count of trees (`FussFormula.lean`), not from the note's lemma on cyclic shifts. The companion lacks 0 < C. The note's remark on paths under a line is not formal. |
| `Path.kummer_exact`, `Path.choose_residue`; with Mathlib's definitions only `Path.kummer_exact_digits`, `Path.choose_residue_digits`, `Path.multiplicity_choose_eq_carries` (`Path/Final.lean`, from `Path/KummerExact.lean`) | if (p − 1)c + s_p(N) = s_p(n) + s_p(N − n) then p^c is the exact power of p in binom(N, n), and binom(N, n)·∏ n_j! m_j! ≡ (−p)^c·∏ N_j! (mod p^(c+1)) | the theorem on binomial coefficients | The number of carries enters through this hypothesis. The residue is stated in the integers; the text states the quotient modulo p. |
| `Path.carryAt_rec`, `Path.sum_carryAt`, `Path.factorial_add_prime_modEq` (`Path/KummerExact.lean`) | the carries satisfy N_j + p·c_(j+1) = n_j + m_j + c_j and (p − 1)·Σ c_j + s_p(N) = s_p(n) + s_p(N − n); (r + p)! ≡ −p·r! (mod p²) | Lemma "carries"; the congruence in Proposition "count" (Wilson) | The carry into digit j is defined as ⌊N/p^j⌋ − ⌊n/p^j⌋ − ⌊(N − n)/p^j⌋ (`Path.carryAt`). |
| `Path.card_class`, `Path.lower_bound`, `Path.pow_dvd_card`, `Path.card_cntE` (one block); `Path.card_classW`, `Path.lower_boundW`, `Path.card_cntEW` (words) (`Path/ClassSize.lean`, `Bound.lean`, `Count.lean`, `Word.lean`) | a class has p^d words; s_p(a) + s_p(b) ≤ (p − 1)d + (number of top blocks); there are binom(N, n) words with n letters E | Lemmas "class sizes", "lower bound for a piece", Proposition "lower bound" | Paths are words in two letters; a block of length p^h is a complete p-ary tree of letters (`Path.Blk`); a word is a list of blocks (`Path.Word`). |
| `Path.kummer_dvd` (`Path/Kummer.lean`) | if (p − 1)c + s_p(N) ≤ s_p(n) + s_p(N − n) then p^c divides binom(N, n) | the divisibility half | none |
| `Path.choose_modEq_minimal`, `Path.minBlk_succ_iff`, `Path.dW_eq_iff`, `Path.card_minimal_words`, `Path.minCount_succ_eq` (`Path/Minimal.lean`, `MinBlock.lean`, `MinCount.lean`) | binom(N, n) ≡ #(words with d = c) (mod p^(c+1)); when a block and a word attain the bound; the number of such words as a sum over the letter counts of the top blocks | the note's equation (modp); the equality cases of the two bounds | **Lean counts minimal words, never classes of them.** The text's M, the number of minimal classes, and its equation for M have no formal statement. |
| `Path.minWords_eq_slotCount` (`Path/Slots.lean`, with `Slots1.lean`, `Slots2.lean`, definitions in `SlotsDef.lean`); `Path.slotCount_digits` (`Path/KummerExact.lean`) | for every list L of block heights, n ≤ len L and B with len L < p^B: `Path.minWords p L n` = `Path.slotCount p L n B`, a product over the levels j < B of binom(s_j, n_j)·binom(s_j − n_j, m_j); for the digit list of N the product times ∏ n_j! m_j! is ∏ (N_j + p·c_(j+1))! | Proposition "count"; C27 | **A different argument and a more general statement.** The proof removes one top block (all E, all S, or mixed and then replaced by its p sub-blocks) and uses Pascal's rule for trinomial coefficients; the note's Lemmas "atoms are digits" and "mixed segments are carries" are not stated. Three points of reading: (1) `Path.minWords` is defined as a sum, over the letter counts of the top blocks, of products of numbers of minimal blocks; it is the number of words with d = c when a natural number c with (p − 1)c + (number of blocks) = s_p(n) + s_p(m) exists (`Path.card_minimal_words'`). (2) For a list that is not a digit list, "minimal" means "attains the bound of `Path.lower_boundW`", not "has the least d"; when no word attains it both sides are 0 although words exist (p = 2, two blocks of height 0, n = 0). (3) μ_j = (length of the blocks of height ≥ j)/p^j − ⌊n/p^j⌋ − ⌊m/p^j⌋ is formed with truncated subtraction (`Path.muAt`): it is 0 where the formula would be negative. |

### 3.4 Around the main proof, and the conclusions of the accounting proof

| Declarations (file) | What they say | Supports | Differences from the text |
|---|---|---|---|
| `card_minimal_classes_mul`, `card_minimal_mul_factorials`, `card_labelled_mul_factorial` (`ExactCount.lean`) | N_min·t!·p^t·∏ m_j! = (pt)!, N_min the number of rotation classes of p-ary trees with m leaves and d = t | C8, Corollary "Exact count when k = 1" of `paper/main.tex` | Stated without division; N_min is `Nat.card` of a quotient type. The route is that of the residue in Lean with an exact count in place of the congruence; like the text it uses the closed formula. |
| `PTree.totalDrop_add_ds`, `PTree.drop_of_symmetric`, `PTree.excess`, `PTree.d_eq_iff_slack`, `PTree.slack_node_eq_zero_iff` (`CarryBudget.lean`) | the drops of the digit sum over all nodes add up to m − s_p(m); a symmetric node drops (p − 1)·s_p(b); (p − 1)·d(T) + 1 = s_p(m) + slack(T); d = t exactly when the slack is 0 | C19, Facts 1 to 3 and the two consequences of `notes/2026-11-14_carry_budget.md` (Section 4.4 of the report) | Each statement is the text's multiplied by p − 1. The criterion for d = t is stated one node at a time, and "a power of p leaves" appears as "digit sum 1". The statements need only p ≥ 2, so they cover the note's remark on other arities; its remark on Sylow subgroups is not formal. |
| `PTree.pow_dvd_card_of_closed`, `PTree.card_closed_modEq_classes` (`Reduction.lean`, `Closed.lean`) | for a finite family of p-ary trees closed under rotation with d ≥ t for its members: p^t divides its size, and the size is ≡ p^t·#(its classes with d = t) (mod p^(t+1)) | C11, the proposition on closed families (Section 4.5 of the report) | A family is a predicate with a finiteness instance; the classes are a quotient type. The text takes trees with m leaves, where d ≥ t holds by the lower bound. |
| `pow_dvd_prod_choose_profile`, `PTree.card_prof`, `PTree.pow_dvd_card_prof`, `PTree.Rot.prof_eq` (`Profile.lean`) | Section 2; the number of q-ary trees with n(i) nodes at depth i is ∏ binom(q·n(i), n(i + 1)); rotations keep the profile | C10, the corollary on level profiles (Section 4.5) | The profile is prescribed up to a level L with n(L) = 0. The final statement has Mathlib's definitions only. |
| `PTree.pow_dvd_sum_weight_of_closed`, `PTree.pow_dvd_sum_depthWeight`, `PTree.depthWeight_node` (`Weighted.lean`) | p^e divides the sum of a rotation-invariant integer weight over a closed family with d ≥ e; p^t divides Σ_T ∏_v b(depth of v) over the q-ary trees with n nodes | C28, the corollary on weights (Section 4.5) | The sums are Mathlib's `finsum` over a subtype that the file proves finite. The depth weight is defined as ∏ b(i)^(number of nodes at depth i). The second statement is about the project's type of trees, and allows n = 0. |
| `dwork_form`, `factorial_eq_pow_mul_prod_mul` (`Dwork.lean`) | for m ≡ 1 (mod q − 1): #(q-ary trees with m leaves)·m! ≡ (−p)^N (mod p^(N+1)), N = (m − 1)/(p − 1); for every m: m! = p^ν·∏ m_j!·u with u ≡ (−1)^ν (mod p), ν = (m − s_p(m))/(p − 1) | C20 and Legendre's formula with its residue: two conclusions of `paper/accounting_proof.tex` | **Not the argument of the text.** The factorial statement is proved classically (blocks of p − 1 factors and Wilson's theorem); `dwork_form` is derived from the residue of the tree proof and this lemma. |

## 4. Not checked by Lean

- Whether any Lean proof follows its written proof line by line: Lean checks the formal statements, and Section 3 compares statements, not arguments.
- Of the main proof: skeletons as cyclic trees and their automorphisms (four lemmas, Section 3.1), the free action on equal atoms, the congruence T(a) ≡ −T(a′) in the text's form, and the worked examples.
- The argument of the accounting proof (C13: digit-forest structures) and the statement on sand (C14). Only two of its conclusions are checked, by another route.
- Of the algebraic proof: the explicit formula for θ, the section "What each step means for trees", the remark on the support of H_δ, and the equation G = x + G^q itself.
- Of the lattice-path note: the lemmas "atoms are digits", "mixed segments are carries", "cyclic shifts", the remark on paths under a line, and the number M of minimal classes.
- Of the carry budget: the remark on Sylow subgroups.
- C9 (weighted numbers in Konvalinka's sense) and C17 (the bijection with permutations): conjectures. The statements on connections with other fields.

## 5. What one has to trust

- **For the statements of Section 2** and for `multiplicity_two_catalan`: no definition of this project. `Nat.choose`, `Nat.digits`, `multiplicity`, `Nat.factorial`, `Int.ModEq`, `Finset.sum`, `Finset.prod` and `catalan` are Mathlib's. The division in C is natural-number division; it is exact (`PTree.fuss_catalan_formula`).
- **For the statements about numbers of trees:** `PTree`, `PTree.nodes`, `PTree.leaves` (nine lines in `Trees.lean`); for the residues also `ds` and `dig` (the digit sum and the j-th digit); for `Frob.residue_frobenius` also `PTree.BlockedAt` and `Frob.digitFact`.
- **For Kummer's theorem in the form with `ds`** (`Path.kummer_exact`, `Path.choose_residue`): `ds`, `dig`, `Path.digFact`. The forms of Section 2 need none of them.
- **For the exact count, the carry budget, closed families and weights:** in addition `PTree.Rot`, `PTree.Symmetric`, `PTree.d`, `PTree.rotSetoidOn`, `PTree.IsMinimal`; `PTree.drop`, `PTree.totalDrop`, `PTree.slack`; `PTree.prof`, `PTree.depthWeight`.
- **For C27:** `Path.minWords`, `Path.slotCount` and what is under them (`Path.minCount`, `Path.MinBlk`, `Path.Blk`, `Path.cntE`, `Path.Eqv`, `Path.d`, `Path.muAt`, `Path.slotsAt`, `Path.topAt`, `Path.len`); see the three points of reading in Section 3.3.
- **Conventions.** Mathlib sets `multiplicity p 0 = 0` and `Nat.card` of an infinite type to 0. The statements "p^t divides and p^(t+1) does not" are free of both conventions. Subtraction of natural numbers is truncated; the third audit found one place where this changes a reading (`Path.muAt`, Section 3.3) and none where it changes a truth.
- Lean checks that each proof follows from the definitions **as written in the files**. Whether a definition says what the text means is a matter of reading the definitions, and no human has done that.
- **The trust base on the machine used:** Mathlib's compiled files come from its prebuilt cache and were not rebuilt; the toolchain is the release `v4.35.0`; no external replay of the proofs (`lean4checker`) was run.

## 6. The audits

Three audits by separate AI instances with no access to the authoring session (Claude Fable 5.2 each time). They are AI readings: no human took part.

- **`AUDIT.md`, first audit** (2026-11-14, commit `db256de`): the 22 files of the case q = p. Verdict: the statements say what is claimed; no finding of severity WRONG; seven points of wording and scope.
- **`AUDIT.md`, second audit** (2026-11-14, commit `d180c73`): the prime-power and residue files. Verdict: no finding of severity WRONG or OVERCLAIM; seven points. Its own lemmas became `ResidueForms.lean`.
- **`AUDIT3.md`, third audit** (2026-11-15, commit `a13148e`): the algebraic proof, the lattice-path proof, the exact count, the carry budget, closed families, profiles, and the dependency commands. Verdict: no statement is wrong; three gaps of disclosure and six cosmetic points; a last section by the orchestrator says what was done about each. (In the auditor's part of that file the report's section numbers from 4 on are one too high: its "Section 5.5" is the report's Section 4.5, its "Section 8" is Section 7, "Lean", its "Section 9" is Section 8; its line numbers are right.) This README was rewritten by the same auditor.

After the third audit two things changed in the Lean files. `Weighted.lean` was added: it has **not** been audited (the auditor read its statements once and ran one numerical test). The proof in `Frob/Theta.lean` was replaced: the auditor read the new file and scanned it, as told below; no other instance has.

**The history of the first finding of the third audit.** The problem asks for a proof without valuations of factorials. The written algebraic proof needs, for the integrality of θ, only that p divides binom(p, k) for 0 < k < p. The first Lean version of `Frob/Theta.lean` instead took φ(f) ≡ f^p modulo p from Mathlib's Frobenius endomorphism. In the pinned Mathlib the additivity of that map is proved through `Nat.Prime.dvd_choose_pow`, which Mathlib derives from its Kummer theorem (`Nat.Prime.emultiplicity_choose`) and Legendre's formula (`Nat.Prime.emultiplicity_factorial`). So the proof term of every theorem of the algebraic proof that involves θ depended, inside the library, on exactly what the problem asks to avoid, although no file of the project mentioned it; the project's listing of direct references could not see it. The auditor's scan of full closures found it. The file was then rewritten by the orchestrator (commit `8c213da`): (a + b)^p = a^p + b^p in a commutative ring in which p = 0 is proved from the binomial theorem and `Nat.Prime.dvd_choose_self` (`Frob.add_pow_prime_of_natCast_eq_zero`), then the identity for polynomials (`Frob.pow_prime_eq_expand_zmod`, `Frob.pow_prime_eq_expand_map`) and for power series by truncation (`Frob.pow_prime_eq_expand_series`); the statement of `Frob.modSeries_frobeniusLift` is unchanged. How it is checked now: the build prints the full closure search of Section 7, and the auditor re-ran its own scanner on the compiled project on 2026-11-15 at about 03:15. Result for `Frob.residue_frobenius`, `Frob.problem137_fussCatalan_frobenius`, `Frob.residue_fussCatalan_frobenius`: closures of 20,076, 20,293 and 20,361 constants; only the three standard axioms; `frobenius`, `add_pow_expChar`, `Nat.Prime.dvd_choose_pow`, `Nat.Prime.emultiplicity_choose` and `Nat.Prime.emultiplicity_factorial` are not reached; `Nat.Prime.dvd_choose_self` is reached through `Frob.add_pow_prime_of_natCast_eq_zero`. The main proof and the lattice-path proof never had the dependency.

## 7. The dependency commands

`MMM/Frob/Deps.lean` defines four commands. Their output is in the build log, at the end of `MMM/Frob/Axioms.lean`, `MMM/Path/Axioms.lean` and `MMM/AxiomsExtra.lean`. The numbers below are from a run of these three files on the compiled project on 2026-11-15 at about 03:15.

- `#project_modules thm` and `#project_consts_in thm Module` follow the proof term of `thm` through every declaration of the project and print the modules, or the declarations of one module, that it reaches. This is complete for the project: a declaration outside the project cannot refer to it. (The third audit reproduced the listings with its own program.)
  - `Frob.residue_frobenius` reaches 660 declarations of the project. Outside `MMM/Frob/` and the three digit files these are: `PTree` with `PTree.leaves` (`Trees.lean`), `PTree.BlockedAt` (`Blocked.lean`), and `PTree.leaves_pos`, `PTree.child_leaves_lt`, `PTree.finite_leaves_eq` (`Divisibility.lean`).
  - `Frob.problem137_fussCatalan_frobenius` reaches 761. In addition: `PTree.nodes`, the tree-count formula (`FussFormula.lean`), the blocked form (`BlockedForm.lean`), `PTree.leaves_eq_nodes` and `PTree.card_nodes_eq_card_leaves` (`ExactB.lean`), `ds_modEq` (`Exact.lean`), `multiplicity_eq_of_exact` (`ExactCond.lean`); the residue form reaches `PTree.prod_dig_eq_digits` (`ResidueForms.lean`) instead of the last two. (The build prints only the module names for these forms; the declarations are from the audit's scan.)
  - **These theorems of the algebraic proof reach no rotation, no class of trees, no labelled tree and no cherry** (also `Frob.exact_valuation_blocked_frobenius` and the other two Fuss–Catalan forms: the audit's scan).
  - `Path.kummer_exact` reaches 467 declarations: the path files, the digit files, three general counting lemmas (`dvd_card_of_classes`, `card_eq_sum_classes`, `classEquivRel` in `Counting.lean`) and one instance of `ClassSize.lean` (`PTree.instNeZeroOfPrime`: a prime is not zero). `Path.problem137_fussCatalan_path` reaches 545: in addition the tree-count formula with `PTree` and `PTree.nodes`, `ds_modEq`, `multiplicity_eq_of_exact`.
  - `problem137_fussCatalan` (the tree proof) reaches 568; `pow_dvd_prod_choose_profile` reaches 199.
- `#external_consts_matching thm "a" "b" …` lists the declarations outside the project that a reached declaration of the project **refers to directly** and whose name contains one of the strings. **It does not look inside Mathlib's proofs**; it missed the dependency described in Section 6.
- `#closure_consts_matching thm "a" "b" …` lists the declarations outside the project in the **full closure** of `thm`, through Mathlib and the core library (for an inductive type its constructors, for a recursor its rules), whose name contains one of the strings; names of the project are left out. It is run on fourteen theorems with the strings `multiplicity_choose`, `multiplicity_factorial`, `padicval`, `legendre`, `kummer`, `lucas`, `dvd_choose_pow`, `add_pow_char`, `add_pow_expchar`. **Every list is empty.** Closure sizes: `problem137_fussCatalan` 12,732 and `residue_fussCatalan` 13,530; `Frob.residue_frobenius` 20,076 and the two Fuss–Catalan forms 20,293 and 20,361; `Path.kummer_exact`, `Path.choose_residue` and the two path forms 12,187 to 12,621; `card_minimal_classes_mul` 10,477; `PTree.excess` 4,431; `PTree.card_closed_modEq_classes` 7,848; `pow_dvd_prod_choose_profile` 9,294; `PTree.pow_dvd_sum_depthWeight` 9,053.
  - Checked by the auditor: its own scanner gives the same closure size for each of the fourteen; the command lists Mathlib's Kummer and Legendre theorems when it is run on Mathlib's `add_pow_expChar` or on a scratch theorem that uses it, and lists nothing for `Frob.add_pow_prime_of_natCast_eq_zero`.
  - **Its limits.** It is a search by names. It shows that no theorem of Mathlib on the power of p in a factorial or a binomial coefficient, and nothing named after Kummer, Legendre or Lucas, is behind these fourteen theorems. It cannot show that no library proof reasons in such a way under another name.
- **What the proofs do use from the library about factorials and binomial coefficients** (from the audit's scans): a prime p divides n! only if n ≥ p (`Nat.Prime.dvd_factorial`); p divides binom(p, k) for 0 < k < p (`Nat.Prime.dvd_choose_self`, algebraic proof only); the formula binom(n, k)·k!·(n − k)! = n!, multinomial coefficients, and the binomial theorem; Wilson's theorem (`ZMod.wilsons_lemma`) for the residues. The closures of `pow_dvd_prod_choose_profile` and of `PTree.pow_dvd_sum_depthWeight` contain no constant of Mathlib with "factorial" in its name. The statements with Mathlib's `multiplicity` use its definition and elementary lemmas about it.

## 8. How to check

Lean is installed with `elan` in the user's home folder (`~/.elan`), not on the PATH. From this folder:

    export PATH="$USERPROFILE/.elan/bin:$PATH"     # Git Bash on Windows
    lake exe cache get                             # once: fetch Mathlib's prebuilt files
    lake build                                     # compiles everything; any error or `sorry` shows here

- **Versions.** `lean-toolchain` pins `leanprover/lean4:v4.35.0`; `lakefile.toml` asks for Mathlib at the tag `v4.35.0`; `lake-manifest.json` pins that commit (`56a005855ea17e0b0958f73ec801ae140b0a1679`) and those of Mathlib's own dependencies. The project was developed on Lean v4.36.0-rc2 and moved to the required versions in commit `adce044`, which changed five source files: the name of a Mathlib lemma about `multiplicity` in `ExactCond.lean`, and the name of an induction case in four files of `Frob/`.
- **What the build prints.** 172 `#print axioms` lines (84 in `MMM/Axioms.lean`, 18 in `MMM/AxiomsExtra.lean`, 38 in `MMM/Frob/Axioms.lean`, 29 in `MMM/Path/Axioms.lean`, and one each left in `Frob/Subst.lean`, `Frob/Weight.lean`, `Frob/YZero.lean`). Each must show only `propext`, `Classical.choice`, `Quot.sound`. Then the output of the dependency commands (Section 7). `MMM/Axioms.lean` and `MMM/AxiomsExtra.lean` also contain concrete instances that Lean checks, for example v_2(`catalan 6`) = 2, v_2 = 1 for binom(12, 3)/10 = 22 (q = 4, n = 3), v_3 = 2 for binom(18, 2)/17 = 9 (q = 9, n = 2), and one minimal class for p = 2, m = 3.
- **One file at a time**, after a build: `lake env lean MMM/Frob/Axioms.lean` prints that file's lines again without building.
- **Builds on record** (`JOURNAL.md`; this README's author did not run `lake build`): a fresh clone of the pushed commit `c8e8e2a` was built from scratch on the required versions on 2026-11-15 at 01:52 (3272 jobs, no `sorry`). The builds after that were incremental builds on the development machine; the last one recorded is of 2026-11-15, 03:06 to 03:08 (3279 jobs, 172 audit lines, no `sorry`). **Added by the orchestrator, 2026-11-15 03:41:** a fresh clone of commit `fb18213` was then built from scratch on the required versions: 3279 jobs, 172 audit lines, no `sorry`, all fourteen full-closure listings empty; no Lean source has changed after that commit (check with `git diff fb18213 -- lean/MMM lean/MMM.lean lean/lakefile.toml lean/lean-toolchain lean/lake-manifest.json`).
- All 85 files under `MMM/` are imported, directly or not, by `MMM.lean`, so all of them are in the build.
- Disk use on the development machine (measured on 2026-11-15): 7.2 GB for `lean/.lake` (Mathlib with its prebuilt files and the project's build), which is not in git, and 6.5 GB for `~/.elan`, which holds two toolchains (v4.35.0 and the v4.36.0-rc2 used in development).

## 9. Layout

"Orchestrator" is the orchestrating AI system (Claude Fable 5.2); "agent" is a fresh-context or forked instance of the same model working from a brief; "worker" is an Open Math OS model. According to the project's records every file not written by the orchestrator was recompiled and its statements read by the orchestrator.

| Files (under `MMM/`) | Content | Written by |
|---|---|---|
| `Digits.lean`, `DigitsCarry.lean`, `DigitsFree.lean` | base-p digit sums and carry-free sums | orchestrator |
| `Trees.lean`, `RotEquiv.lean`, `ClassSize.lean` | p-ary trees, rotation equivalence, d, class size, lower bound | orchestrator |
| `Counting.lean`, `Divisibility.lean`, `Blocked.lean`, `Reduction.lean`, `ReductionB.lean` | counting by classes, finiteness, divisibility, closed families, reduction to minimal trees, depths | orchestrator |
| `BlockedForm.lean` | q-ary trees as p-ary trees with leaves at depths divisible by k | agent (forked) |
| `Minimal.lean`, `LTree.lean`, `LBlocked.lean`, `Atoms.lean`, `Retype.lean`, `RetypeB.lean` | Step 3: tight trees, trees of atoms, digits, equal atoms, the depth condition | orchestrator |
| `LRot.lean`, `Cherry.lean`, `CherryB.lean` | Step 4: labelled trees, the cherry collapse, with classes modulo k | agents (forked) |
| `ExactCond.lean`, `ExactAll.lean`, `Exact.lean`, `ExactBCond.lean`, `ExactB.lean` | the exact valuation for q = p and for q = p^k | orchestrator |
| `Residue.lean`, `ResidueB.lean` | the residue | orchestrator |
| `ResidueForms.lean` | other forms of the final statements | the second auditor; adopted by the orchestrator |
| `NormalForm.lean` | the lemma "Normal form" | worker W023 (Mistral Large 4.0) |
| `FussFormula.lean`, `Problem137.lean` | the closed formula; the final statements of the tree proof | orchestrator |
| `Catalan.lean` | binary trees and Mathlib's `catalan` | orchestrator |
| `Dwork.lean` | Legendre's formula with its residue; the Dwork form | worker W028 (Kimi K3.1 Pro) |
| `ExactCount.lean` | the exact number of minimal classes (C8) | agent (brief W048) |
| `CarryBudget.lean` | the carry budget (C19) | agent (brief W049) |
| `Closed.lean`, `Profile.lean` | closed families (C11), level profiles (C10) | agent (brief W047) |
| `Weighted.lean` | invariant weights (C28) | agent (brief W051) |
| `Axioms.lean`, `AxiomsExtra.lean` | `#print axioms` lines, instances, dependency listings | orchestrator |
| `Smoke.lean` | a test that the project compiles against Mathlib | orchestrator |
| `Frob/Basic.lean`, `Theta.lean` (definitions and reductions), `ThetaDiv.lean`, `ThetaIdents.lean`, `System.lean`, `Uniqueness.lean` | the ring ℤ[y][[x]], the lift φ, θ and its rules, uniqueness of the family | workers W025, W027 (Kimi K3.1 Pro) |
| `Frob/Theta.lean` (from `Frob.add_pow_prime_of_natCast_eq_zero` on) | φ(f) ≡ f^p modulo p from the binomial theorem | orchestrator, 2026-11-15, after the third audit |
| `Frob/Existence.lean`, `Special.lean` | existence of the family; the values at y = p and y = 0 | worker W031 (Kimi K3.1 Pro) |
| `Frob/Weight.lean`, `TreeGF.lean` | the lower bound; the generating function of the trees | workers W034, W035 (Kimi K3.1 Pro) |
| `Frob/YZero.lean`, `Lead.lean` | the family at y = 0; the leading part | worker W036 (Kimi K3.1 Pro); the last theorem of `Lead.lean` by the orchestrator |
| `Frob/PowDeriv.lean` | the p-th derivative of a p-th power | agent (brief W038) |
| `Frob/Eval.lean` | the evaluation | started by worker W039 (Kimi K3.1 Pro), finished by an agent |
| `Frob/HurwitzC.lean`, `HFamily.lean`, `Carry.lean` | Hurwitz series, the family H_δ, the carry congruence | agent (brief W042); the construction of the ring adapted from a worker's file |
| `Frob/Subst.lean`, `SubstDigits.lean`, `SubstVandermonde.lean` | from the leading part to the labelled series | started by worker W040 (Kimi K3.1 Pro: the definitions and first lemmas of `Subst.lean`), the rest by an agent |
| `Frob/Divisibility.lean`, `FinalGlue.lean`, `Final.lean`, `Problem137.lean` | the divisibility, the residue, the final statements of the algebraic proof | orchestrator |
| `Frob/Deps.lean`, `Frob/Axioms.lean` | the dependency commands; audit lines of the algebraic proof | orchestrator; `Axioms.lean` started by a worker (Kimi K3.1 Pro) |
| `Path/Block.lean`, `ClassSize.lean`, `Bound.lean` | one block: words, classes, the bound | worker W032 (Kimi K3.1 Pro) |
| `Path/Count.lean`, `Word.lean`, `Kummer.lean` | binomial counts, words of several blocks, the divisibility half | worker W033 (Kimi K3.1 Pro) |
| `Path/Minimal.lean`, `MinBlock.lean`, `MinCount.lean` | reduction to minimal words; minimal blocks and their number | agent (brief W041) |
| `Path/SlotsDef.lean` | definitions for the count | orchestrator |
| `Path/Slots1.lean`, `Slots2.lean`, `Slots.lean` | the count for every list of blocks (C27) | agent (brief W043) |
| `Path/KummerExact.lean`, `Path/Problem137.lean` | carries, Kummer's theorem and the residue, the statements for C, each given the count | agent (brief W044) |
| `Path/Final.lean`, `Path/Axioms.lean` | the final statements of the lattice-path proof; audit lines | orchestrator |

Also in this folder: `MMM.lean` (the list of imports), `AUDIT.md`, `AUDIT3.md`, and three working notes that are not part of the checked project (`MMM/ClassSizeDraft.md`, `MMM/Frob/PLAN.md`, `MMM/Path/PLAN.md`).
