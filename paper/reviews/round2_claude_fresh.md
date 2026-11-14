# Round 2 referee report (fresh read, unanchored)

Reviewer: Claude Fable 5.2, 2026-11-13.
Input read: `paper/main.tex` only (plus pages 10-12 of `paper/main.pdf` to confirm numbering and inspect the figures). Nothing in `paper/reviews/`, `notes/`, `briefs/`, `CLAIMS.md`, `STATE.md`, `JOURNAL.md`, `FINDINGS.md` or `paper/CHANGES_round1.md` was opened.
Numbering below is the compiled numbering (Theorem 1.1, Lemma 2.3, ..., equations (1)-(8)); LaTeX labels are given in the table.

## 1. Summary verdict

**Is the main theorem fully proved? Yes, modulo the listed gaps.**

I found no step in the chain Lemma 2.3 -> 2.6 -> 2.11 -> 3.1 -> 3.2 -> 4.1 -> 4.3 -> 5.1 -> 5.2 -> 5.3 -> 5.4 -> 5.5 -> 5.6 -> Theorem 1.1 whose conclusion is false or whose argument cannot be completed in a few lines. Every gap below is a missing justification, a missing hypothesis in a statement, or an object/class imprecision; none needs a new idea.

Counts over the 27 numbered environments: **1 WRONG, 6 GAP, 20 CORRECT**. Two further gaps sit in unnumbered text of the Introduction (F7, F8), and there is a scholarship issue (F9).

The one WRONG is in a worked example (Example 7.2): an explanatory sentence about the two pictured skeletons is false. All numbers in all three examples are right.

No use of Legendre's formula, Kummer's theorem, or the valuation of a factorial/binomial was found in the proof of Theorem 1.1, apart from the trivial fact `p does not divide a!` for `a < p` (proved in the text from Euclid's lemma). Corollary 6.1 is not circular.

## 2. Table of verdicts

| # | Environment (label) | Verdict | Reason in one or two sentences |
|---|---|---|---|
| 1.1 | Theorem (`thm:main`) | CORRECT | Proof in Section 6: `C = sum over classes of p^d`, `d >= t`, so `C/p^t = N_min (mod p)`; `N_min * prod m_j! = T(a) = (-1)^t (mod p)` with `prod m_j!` a unit. Inherits the gaps F2-F5. Statement checked numerically for p in {2,3,5,7,11}, k <= 3, n < 300 (n < 60 for q >= 50): no counterexample. |
| 2.1 | Definition (p-ary tree, `K_h`) | CORRECT | Standard. Terminology clash: "node" is declared to mean internal node here, but includes leaves in Def. 4.2, Lemma 5.1 and "number of nodes" in Lemma 2.11 (F10). |
| 2.2 | Definition (k-blocked) | CORRECT | Nothing to prove. |
| 2.3 | Lemma (`lem:blocked`) | CORRECT | Substituting `K_k` for each q-ary node multiplies depths by k; conversely an internal node at depth rk of a k-blocked tree cannot meet a leaf at depths rk+1..rk+k-1, so the top k levels below it form `K_k`. The two maps are mutually inverse. Verified by enumeration (Section 5). |
| 2.4 | Definition (`~`, R1, R2) | GAP (trivial) | The relation is well defined, but the text never says why a smallest such relation exists. See F5. |
| 2.5 | Remark (wreath product) | CORRECT | Standard and explicitly unused. Note that "Sylow p-subgroup of `S_q`" presupposes the p-part of `q!` (F8). |
| 2.6 | Lemma (`lem:normal-form`) | CORRECT | Logical order is sound: (1) R is an equivalence relation, using only that `~` is one; (2) `R => ~` from (R1), (R2), symmetry and transitivity of `~`; (3) R satisfies (R2) using (2), and (R1) by reflexivity; (4) minimality gives `~ => R`. No step uses a later one. |
| 2.7 | Lemma (`lem:depth-invariant`) | GAP | Statement true; the proof is "by induction on the generating steps", but no derivation system was defined. See F4. |
| 2.8 | Definition (asymmetric, `d(T)`) | CORRECT | Well defined once `~` is. |
| 2.9 | Lemma (`lem:d-invariant`) | CORRECT | By Lemma 2.6, `T'_i ~ T_{i+r}`, so the cyclic word of child classes is the same up to rotation and the root has the same symmetry type; induct on size with (2). The opening sentence "It suffices to check the generating steps" is spurious (F4). |
| 2.10 | Lemma (`lem:tuple-rotation`) | CORRECT | For r != 0, `i -> i+r` is a single p-cycle on Z/p because p is prime; fails for composite arity, e.g. (A,B,A,B). |
| 2.11 | Lemma (`lem:class-size`) | CORRECT | `[T]` is the union over r of the product sets `prod_i B_{i+r}`. If `rot_r(U) = rot_s(V)` with `U_i, V_i in B_i`, then `B_{i+r} = B_{i+s}` for all i (classes are equal or disjoint), so the class word is fixed by rotation `s-r`, forcing `r = s` by 2.10. Primality enters only through 2.10, correctly. |
| 3.1 | Lemma (`lem:digit`) | CORRECT | Summing the column recurrence (4) gives (5): defect = `(p-1) * sum of carries`, valid for any number of summands with carries possibly > 1. Equality iff all `c_j = 0`; `c_j = 0` for all j gives column sum `= b_j < p`; conversely column sums `< p` give `c_j = 0` by induction from `c_{-1} = 0`. |
| 3.2 | Proposition (`prop:lower-bound`) | CORRECT | Asymmetric root: `d >= 1 + sum_i t(a_i) = 1 + (sum s_p(a_i) - p)/(p-1) >= 1 + (s_p(a) - p)/(p-1) = t(a)`. Symmetric root: `a = pb`, `d = p d(T_1) >= p t(b) >= t(b) = t(pb)`. Both redone by hand. The symmetric case uses Lemma 2.9 without citing it. |
| 4.1 | Proposition (`prop:minimal-local`) | CORRECT | Equality in the two inequalities of 3.2 is exactly "children minimal" and "carry-free". Symmetric minimal root: `p t(b) <= p d(T_1) = t(b)` forces `t(b) = 0 = d(T_1)`, so T is complete. |
| 4.2 | Definition (`def:skeleton`) | GAP | Contains an unproved assertion that is used throughout Sections 4-6; (S1) is redundant; "equivalent" is used before it is defined. See F2(b),(c). |
| 4.3 | Proposition (`prop:skeleton`) | GAP | The bijection is between minimal classes and *equivalence classes* of skeleton trees, not skeleton trees; "(S1)-(S2) hold" is asserted with only (S2) argued; "same cyclic quotient as [T]" is not a definition. The mathematics is right. See F2. |
| 5.1 | Lemma (`lem:aut-order`) | CORRECT | (i) an automorphism commutes with "parent", so every ancestor of a fixed leaf is fixed. (ii) the rotation induced at the root has order dividing both p and ord(alpha), hence is trivial; recurse into the child subtrees. |
| 5.2 | Proposition (`prop:free`) | CORRECT | If `h` fixes a labelled tree via an automorphism `phi`, then `phi^n = 1` iff `h^n = 1` by 5.1(i), so `ord(phi) = ord(h)`, which divides `prod m_j!` and is prime to p; 5.1(ii) gives `phi = 1`, hence `h = 1`. Relies on the identification in F2(b) and on the redundancy of (S1) (F2(c)). |
| 5.3 | Lemma (`lem:moving-leaves`) | CORRECT | If the parent v of a moved leaf x is fixed, alpha rotates the children of v nontrivially, and since x is a leaf all p children are leaves and all move. If v is moved, its orbit has p pairwise leaf-disjoint members all of whose (at least `p^2`) leaves move. |
| 5.4 | Proposition (`prop:carry`) | CORRECT | Fixed trees are exactly those in which the p chosen labels form a cherry; the label orders compatible with sigma are `f(u) = a + bu`, `b != 0`, i.e. `p-1` cyclic orders; collapsing gives a class-(c+1) leaf at depth `r-1 = -(c+1) (mod k)`, including `c = k-1 -> 0`. `|Fix| = (p-1) T(a')` confirmed exactly by brute force (Section 5). |
| 5.5 | Lemma (`lem:terminal`) | CORRECT | A deepest internal node has p leaf children at one depth, hence of one class, forcing `a_c >= p`. A lone leaf sits at depth 0, hence class 0. |
| 5.6 | Proposition (`prop:carry-termination`) | GAP (statement) | Proof correct, but the statement omits the hypothesis `m = 1 (mod q-1)` that the proof uses; false as literally quantified. See F3. |
| 6.1 | Corollary (`cor:exact-count`) | GAP (minor) | Formula correct and not circular. The step "ordering independently at all t nodes" needs the labelled analogue of Lemma 2.11. See F6. |
| 7.1 | Example (`ex:binary`) | CORRECT | m=7=111_2, t=2, three skeletons, class size 4, C_6=132, 132/4=33, 4!/(2! 2^2)=3: all recomputed. |
| 7.2 | Example (`ex:ternary`) | WRONG (one sentence) | Numbers all correct (m=17=122_3, N_min=10, T(5)=40, T(3)=2, C=43263, 4807). The sentence contrasting the two pictures is false. See F1. |
| 7.3 | Example (`ex:quaternary`) | CORRECT | m=13=1101_2, atoms K_0,K_2,K_3, a=(2,1), (2,1)->(0,2)->(1,0), T=1,1,1, C=140, 35: all recomputed. The figure's depth labels are misplaced (F10). |

## 3. Detailed findings, ordered by severity

### F1. WRONG - Example 7.2, description of the two pictured skeletons

Location: Example 7.2 (`ex:ternary`), sentences
"The right skeleton is one of two rotations for its atom partition. In the first picture the cherry contains a repeated atom of height 0; in the second its three atoms are all different, giving two cyclic orders when the other two upper atoms are fixed."

What is false. The cherry of the second picture is `(K_0, K_1, K_1')`: heights 0, 1, 1. It contains a repeated atom of height 1, exactly as the first cherry `(K_0, K_0', K_1)` contains a repeated atom of height 0. So "its three atoms are all different" is false for heights, and if distinct labels are meant it is equally true of the first picture; under neither reading do the two pictures differ in the way the text claims.

Concrete count (brute force, `check_examples.py`). Write X for the internal child of the root. The ten unlabelled skeletons split by atom partition as

| root-level atoms | cherry atoms | skeletons | where the factor comes from |
|---|---|---|---|
| K_0, K_0 | K_1, K_1, K_2 | 1 | - |
| K_1, K_1 | K_0, K_0, K_2 | 1 | - |
| K_0, K_1 | K_0, K_1, K_2 | 4 | 2 cyclic orders at the root times 2 in the cherry |
| K_0, K_2 | K_0, K_1, K_1 | 2 | root only: (X,K_0,K_2) vs (X,K_2,K_0) |
| K_1, K_2 | K_0, K_0, K_1 | 2 | root only: (X,K_1,K_2) vs (X,K_2,K_1) |

The left picture is in the last row and the right picture in the fourth row. Both partitions give exactly 2 skeletons, and in both the factor 2 comes from the cyclic order of the two leaves at the root, not from the cherry (a cherry with a repeated height has a single cyclic order). With distinct labels each pictured partition gives 2 x 2 = 4 labelled trees. Also, "one of two rotations" is the wrong word: rotations do not change a cyclic tree; the two skeletons differ by the cyclic order at the root.

Fix. Replace the two sentences by the table above (1+1+4+2+2 = 10), or change the second picture to have cherry `(K_0, K_1, K_2)` and root-level leaves `K_0', K_1'` if a cherry with three different atoms is wanted.

Second slip in the same example: "Proposition 5.6 predicts (-1)^2/(2!2!1!) = 4^{-1} = 1 (mod 3)". Proposition 5.6 predicts `T(5) = 1 (mod 3)`; the displayed quantity is the prediction of Theorem 1.1 (or of 5.2 with 5.6).

Impact on the theorem: none.

### F2. GAP - Definition 4.2 and Proposition 4.3: objects versus classes, an unproved identification, (S1)

(a) Location: Proposition 4.3, "cyclic skeleton trees for m satisfying (S2) correspond bijectively to minimal ~-classes of k-blocked p-ary trees with m leaves".
Definition 4.2 itself distinguishes cyclic trees from their equivalence classes ("Two cyclic trees are equivalent if such an isomorphism exists"), and `T(a)` is defined as a "number of equivalence classes". The bijection is with equivalence classes of cyclic skeleton trees. As written, the statement is about the wrong objects. "satisfying (S2)" is redundant, (S2) being part of the definition.
Fix: "equivalence classes of cyclic skeleton trees for m correspond bijectively to ...".

(b) Location: Definition 4.2, "this is exactly the equivalence generated by independent cyclic rotations at every node".
This is a claim, placed inside a definition and never proved. It is what links cyclic-tree isomorphism to `~` on plane representatives, and it is used in 4.3 (both directions of well-definedness), 5.2, 5.4 and 6.1, always for trees with labelled leaves, for which Lemma 2.6 has not been stated.
Fix: add a lemma. For plane p-ary trees whose leaves carry labels (repetitions allowed), let `~` be generated by (R1), (R2) with a leaf equivalent only to a leaf with the same label. The proof of Lemma 2.6 goes through verbatim. Then, by induction on size, two plane labelled trees are equivalent iff their cyclic trees are isomorphic: an isomorphism sends root to root, acts on the root's children by a rotation r, and restricts to isomorphisms `T_{i+r} -> T'_i`, which is the recursion of Lemma 2.6.

(c) Location: Proposition 4.3, proof, "Thus (S1)-(S2) hold."
Up to that sentence only (S2) has been argued. Fill: let v be an internal node of the contracted skeleton and `b_j` the number of height-j atoms below v. By (6) applied to the (minimal) subtree at v, `b_j < p`. If the p child sub-skeletons were all equivalent they would contain equally many atoms of each height, so `p | b_j`, hence `b_j = 0` for all j, impossible. This is the argument the paper gives later, in the converse direction.
The same argument shows that (S1) holds for every cyclic p-ary tree whose leaves bear the atom multiset of m. So (S1) is a redundant axiom, and the sentence after Definition 4.2, "(S1) excludes a cyclic root all of whose child skeletons are equivalent, even if it looks nontrivial before labels are compared", describes a situation that cannot occur. The redundancy is also needed silently in Proposition 5.2: the map "forget the labels for each height separately" must land in skeleton trees, i.e. the image must satisfy (S1), and the remark "distinct labels make (S1) automatic" no longer applies once labels are forgotten.
Fix: drop (S1) from the definition and state it as a one-line lemma, or keep it and prove it where it is claimed.

(d) Location: Proposition 4.3, proof, "Give the resulting tree the same cyclic quotient as [T]."
Not a definition. Fix: define the contraction on plane minimal trees and prove `T ~ T'` implies isomorphic contractions by induction on size using Lemma 2.6: if T is complete then `[T] = {T}` (Lemma 2.11 with d = 0); otherwise `T'_i ~ T_{i+r}`, neither tree is complete, and the contraction of a non-complete tree is the tuple of contractions of its children. The paper's sentence "Contraction is well defined on ~-classes: ..." states the idea but omits the induction and the complete case.

(e) Location: Proposition 4.3, second sentence of the statement, "A minimal tree has exactly `m_j` maximal complete subtrees of height j, and such a subtree of height j begins at a depth congruent to -j (mod k)."
The depth claim holds only for k-blocked minimal trees, and `m_j` must be the digits of `l(T)`. Add both qualifiers.

What I verified in the proof as it stands: the atoms are the base-p digits of m (induction (6): carry-free addition makes the digit vectors add componentwise and stay below p); every skeleton node is asymmetric after expansion (the `b_j = p b'_j < p` argument, which does not use (S1)); hence the maximal complete subtrees of the expansion are exactly the expanded atoms, `d = number of skeleton nodes = (s_p(m)-1)/(p-1)`; the depth condition `r + j = 0 (mod k)` is equivalent to k-blockedness of the expansion because every leaf of the expansion lies in an expanded atom. By computation, the number of unlabelled skeleton classes equals `N_min` in all 16 cases tested.

### F3. GAP - Proposition 5.6 is false as literally stated: missing hypothesis m = 1 (mod q-1)

Location: Proposition 5.6 (`prop:carry-termination`), "For **a** obtained from the digits of m, T(**a**) = (-1)^t (mod p)", together with the opening of Section 5.1, "Fix m and q = p^k".
The proof uses "m = (q-1)n+1" in (7). Sections 3-5 otherwise treat m as arbitrary (4.3 and 5.2 are true for every m), so the reader is entitled to read "Fix m" literally.

Counterexamples to the literal statement:
- (p,k,m) = (2,2,2): m = 10_2, **a** = (0,1), t = 0, but T(0,1) = 0 (a single leaf sits at depth 0 and must have class 0), not 1.
- (p,k,m) = (2,2,3): m = 11_2, **a** = (1,1), t = 1, T(1,1) = 0 (the only shape has two leaves at depth 1, both of which would need class 1), not -1 = 1 (mod 2).
- (p,k,m) = (3,2,3): m = 10_3, **a** = (0,1), t = 0, T(0,1) = 0, not 1.

All three values of T were confirmed by brute-force enumeration.

Fix: add "where m = 1 (mod q-1)" to the statement.

With the hypothesis, I rechecked every relation sign. In (7): the first `=` is a regrouping of j by `j mod k`; the next sign is `=` modulo q-1 because `p^k = 1 (mod q-1)`; then `= m`; then congruent to 1. The change of W under a carry is `-p * p^c + p^{c+1} = 0` for c < k-1 and `-p^k + 1 = -(q-1)` for c = k-1 (this covers k = 1, where c = 0 = k-1). A terminal vector has `0 < W <= (p-1)(1 + p + ... + p^{k-1}) = q-1`, and `W = 1 (mod q-1)` with `q-1 > 1` forces W = 1, hence `b = e_0`. For q = 3: `W = b_0` in {1,2} and odd, so 1. For (p,k) = (2,2): `W = b_0 + 2 b_1` in {1,2,3} and congruent to 1 mod 3, so (1,0). For q = 2 the modulus is 1 and the argument is void; the separate paragraph (`a_0` drops by one per carry until `a_0 = 1`) is correct. The number of carries is t because `sum_c b_c` drops by exactly p-1 per carry from `s_p(m)` to 1. By computation: for 11 pairs (p,k) and n = 0..399, every order of carries ends at `e_0` after exactly t carries.

### F4. GAP - Lemma 2.7: "induction on the generating steps" is not an induction over anything defined

Location: Lemma 2.7 (`lem:depth-invariant`), proof: "We show that every generating step (R1) or (R2) preserves the multiset of leaf depths; iterating such steps then does too", and "by induction on the generating steps".
`~` was defined by minimality. No notion of generating step or derivation has been set up, and (R2) is a closure rule whose premises are themselves `~`-statements, so "iterating steps" does not describe `~` without further argument.
Fix (three lines, same template as Lemma 2.6): let D(T,T') mean "T and T' have the same multiset of leaf depths". D is an equivalence relation. D satisfies (R1) because a rotation permutes the subtrees, and (R2) because the multiset of `(T_1,...,T_p)` is the union of the multisets of the `T_i`, each shifted by 1. By minimality `~` is contained in D.
The same defect is in the first sentence of the proof of Lemma 2.9 ("It suffices to check the generating steps"), but what follows there is an induction on size through Lemma 2.6 and is correct; delete that sentence.

### F5. GAP (trivial) - Definition 2.4: existence of the smallest relation

Location: Definition 2.4, "Let ~ be the smallest equivalence relation on p-ary trees such that ...".
Fill: the family of equivalence relations satisfying (R1) and (R2) contains the all-relation and is closed under arbitrary intersections ((R1) lists required pairs; (R2) is an implication whose hypothesis for the intersection implies the hypothesis for each member). The intersection is the smallest. One sentence suffices.

### F6. GAP (minor) - Corollary 6.1: the factor p^t

Location: Corollary 6.1, proof: "Hence each internal cyclic tuple has p different left-to-right representatives. Ordering independently at all t nodes shows that the number of plane p-ary trees with s distinctly labelled leaves is p^t T(**a**)."
The node-wise statement does not by itself show that the `p^t` global orderings are pairwise distinct plane trees. That is Lemma 2.11 for leaf-labelled trees, which was proved only for unlabelled trees.
Fill: Lemmas 2.6 and 2.11 hold verbatim for trees with labelled leaves (see F2(b)); with distinct labels every internal node is asymmetric, so every class has `p^t` elements. Alternatively: two choices of rotations giving the same plane labelled tree differ by a label-preserving automorphism, which fixes every leaf and is trivial by Lemma 5.1(i).
Also: the Fuss-Catalan formula is attributed to [Konvalinka]; cite a standard source for the formula itself.

Circularity (attack 10): none. The corollary is not used in the proof of Theorem 1.1, and it uses the Fuss-Catalan count for (p, t), not a valuation. Independent consistency check: `(pt)!/(t! p^t) = prod_{i<t} prod_{j=1}^{p-1} (ip+j) = ((p-1)!)^t = (-1)^t (mod p)` by Wilson, which agrees with Proposition 5.6 for k = 1. Verified numerically for p in {2,3,5,7}, t <= 7.

### F7. GAP - Introduction: the identity between the tree count and the binomial expression

Location: Introduction, "the standard tree-counting identity is `C = (1/m) binom(qn, n)`".
No proof and no reference. Theorem 1.1 is proved for `C` defined as a number of trees. The title and abstract, and the reader, take it as a statement about the Fuss-Catalan number as a binomial expression; that needs the identity. The same identity is used with (p, t) in Corollary 6.1 and for the numerical values in Section 7. Add a reference (cycle lemma / Raney).

### F8. GAP (wording of a claim) - "No valuation of a factorial ... is used below"

Location: Introduction, "No valuation of a factorial, a binomial coefficient, or a multinomial coefficient is used below."
Two places touch this.
- Remark 2.5: "a Sylow p-subgroup of the symmetric group `S_q`" presupposes the exact power of p in `q!`. Unused, but it is "below".
- Proposition 5.2: "`prod_j m_j!` is prime to p" is the statement `v_p(a!) = 0` for `a < p`. The proof given (every factor is smaller than p, p is prime) is elementary and correct.
Fix: reword to "apart from the trivial fact that `a!` is prime to p when `a < p`", and drop or flag the Sylow sentence.
For the record: Lemma 3.1 is the carry-counting content of Kummer's theorem, but it is proved from the column recurrence and applied to leaf counts, not to binomial coefficients. I found no hidden use of Legendre or Kummer in Sections 2-6.

### F9. Scholarship - uncited bibliography, unverified description of prior work

- `[DeutschSagan]` and `[PostnikovSagan]` are in the bibliography and are never cited in the text.
- The Introduction's account of Konvalinka's method ("the branches at each node are permuted by a full symmetric group, orbit sizes are products of multinomial coefficients, and the argument proves divisibility; the factorial formula is then invoked to obtain exactness") is a specific claim about someone else's proof. I did not consult the source and cannot confirm it.
- From memory only, not checked: for p = 2, k = 1 an orbit argument of this kind (orbit sizes powers of 2, an odd number of minimal orbits given by a double factorial) is already in the two uncited papers. Corollary 6.1 at p = 2 gives `(2t)!/(t! 2^t) = (2t-1)!!`, which fits. The paper must say precisely what is new relative to all three references. Someone has to read them.

### F10. Minor points (no effect on correctness)

1. Proposition 3.2, symmetric case: "by (2), induction, and Lemma 3.1, `d(T) = p d(T_1)`" also needs Lemma 2.9 for `d(T_i) = d(T_1)`.
2. Lemma 3.1, "`c_j = 0` for j beyond the top column": true for the top column of the sum, not of the summands. With p = 2 and five summands equal to 1, `c_0 = 2` and `c_1 = 1`.
3. Lemma 5.3, proof: "because the leaf below the child containing x moves" - x is itself the child of v.
4. Proof of Theorem 1.1: Lemma 2.7 should be cited for the fact that the class of a k-blocked tree with m leaves consists of such trees. In the last paragraph integrality of `C/p^t` is stated after it has been used in (8), and "Its denominator is prime to p" refers to `prod m_j!` two sentences earlier. In the statement of Theorem 1.1, "In particular, it is prime to p" has an ambiguous antecedent.
5. "node": Definition 2.1 says nodes are internal nodes; Definition 4.2 ("bijection on the set of nodes"), Lemma 5.1 ("A node of maximal depth is a leaf") and Lemma 2.11 ("number of nodes") include leaves.
6. Overloaded symbols: `r` (rotation amount; number of summands in 3.1; depth in (S2) and 4.3; number of skeleton nodes in 4.3; number of carries in 5.6), `l` (leaf count and the labels `l_1..l_p` in 5.4), `a` (leaf counts `a_i`, vector entries `a_c`, the constant in `f(u) = a + bu`), `b`, `T` (a tree and the count `T(a)`), `t` and `t(.)`. `Z_p` for Z/pZ in a paper about p-adic valuations.
7. Section 7 preamble announces the notation `K_j^{(i)}`; the figures use primes.
8. Example 7.3, figure: the depth labels are placed at y = -0.85 and y = -1.75 while the tree has level distance 14 mm (nodes at y = -1.4 and y = -2.8). In the PDF, "depth 2" sits beside the depth-1 internal node. Use y = -1.4 and y = -2.8.
9. Remark 2.5, first sentence ("The generators in (R1)-(R2) are the action of an iterated wreath product") is loose: the acting group is the group of rotation automorphisms of the infinite p-ary tree, acting on finite subtrees.
10. Introduction: "the full symmetric symmetry group".

## 4. The ten requested attacks, in order

1. Equivalence relation and normal form. Well defined (F5 supplies the missing sentence). Lemma 2.6 is proved; the order of steps is sound (table row 2.6). Computation: classes computed as orbits of single-node rotations, without Lemma 2.6, coincide with the classes predicted by the normal form in all 27 cases.
2. Class size. Primality is used once, in Lemma 2.10, correctly. The product sets are disjoint by the argument in row 2.11. Computation: `|[T]| = p^{d(T)}` for every class in all 27 cases; for arity 4 the script finds classes of size 2, so the check can fail.
3. Digit lemma. Correct for r summands, both directions of "equality iff no carries" (row 3.1). Brute force for p in {2,3,5}, r in {2,3,4}.
4. Lower bound. Both cases redone by hand (row 3.2). Computation: `d >= t` for every p-ary tree with m leaves (not only blocked ones) in all 27 cases, and `d = 0` iff complete.
5. Minimal classes and skeletons. Mathematics correct; presentation gaps in F2.
6. Freeness. Lemma 5.1 (i), (ii) correct; used correctly in 5.2 (row 5.2). Computation: automorphism groups of all cyclic tree shapes with at most 9 leaves (p=2), 11 (p=3), 13 (p=5) have order a power of p and only the identity fixes all leaves; `#labelled = prod m_j! * #unlabelled` in all 16 cases.
7. Carry proposition. Correct, including the wrap-around (row 5.4).
8. Termination. Correct under the hypothesis `m = 1 (mod q-1)`, which is missing from the statement (F3).
9. Numerical claims. All correct; see Section 5. One false descriptive sentence (F1).
10. Hidden valuations, circularity. None found; see F8 and F6.

## 5. Computations I ran

Scripts (all under `paper/reviews/scratch_fresh/`, run with `uv run python`, Python 3.13):

- `check_trees.py` - enumerates all plane p-ary trees with m leaves; checks Lemma 2.3 by substituting `K_k` into every q-ary tree and comparing with the set of k-blocked trees; computes `~`-classes by union-find over single-node rotations (independent of Lemma 2.6) and compares with normal-form canonical classes; checks class invariance of `d` and of the leaf-depth multiset, `|[T]| = p^d`, `d >= t`, `d = 0` iff complete, `sum p^d = C`, and `C/p^t = N_min = (-1)^t / prod m_j! (mod p)`. 27 triples (p,k,n), all pass.
- `check_skeletons.py` - digit lemma by brute force; `T(a)` by brute-force enumeration of canonical labelled cyclic trees and by an independent recurrence (they agree on 183 vectors); carry congruence on 1475 pairs (a, c) across (p,k) in {(2,1),(2,2),(2,3),(3,1),(3,2),(3,3),(5,1),(5,2),(7,1)}, of which 215 have `T(a)` nonzero mod p (in the rest both sides vanish, so only those 215 are informative); exact fixed-point count `|Fix(sigma)| = (p-1) T(a')` and "the chosen labels form a cherry" by brute force on 37 pairs (a, c), including wrap-around c = k-1 for k = 2; carry process for 11 pairs (p,k), n = 0..399, all orders of carries; `N_min` = number of unlabelled skeleton classes = `T(a)/prod m_j!` and (S1) automatic, 16 triples; exact formula of Corollary 6.1 for the k = 1 triples; automorphism groups and the moving-leaf lemma (348 automorphisms with `alpha^p = 1` moving exactly p leaves, all sibling sets); composite-arity sanity check.
- `check_examples.py` - every number in Examples 7.1-7.3, the decomposition of the ten skeletons of Example 7.2, the seven requested triples, a sweep of the theorem's statement from the closed formula, and the Wilson check of Corollary 6.1.

Results for the seven requested triples and the three examples (classes are classes of k-blocked trees with m leaves, listed as `d: number of classes`):

| (p,k,n) | m (base p) | t | C | classes by d | N_min | a | T(a) | C/p^t mod p | predicted |
|---|---|---|---|---|---|---|---|---|---|
| (2,1,3) | 4 = 100 | 0 | 5 | 0:1, 2:1 | 1 | (1) | 1 | 1 | 1 |
| (2,1,6) | 7 = 111 | 2 | 132 | 2:3, 3:3, 4:4, 5:1 | 3 | (3) | 3 | 1 | 1 |
| (3,1,2) | 5 = 12 | 1 | 3 | 1:1 | 1 | (3) | 2 | 1 | 1 |
| (3,1,3) | 7 = 21 | 1 | 12 | 1:1, 2:1 | 1 | (3) | 2 | 1 | 1 |
| (2,2,2) | 7 = 111 | 2 | 4 | 2:1 | 1 | (2,1) | 1 | 1 | 1 |
| (2,2,3) | 10 = 1010 | 1 | 22 | 1:1, 2:1, 4:1 | 1 | (0,2) | 1 | 1 | 1 |
| (3,2,2) | 17 = 122 | 2 | 9 | 2:1 | 1 | (3,2) | 4 | 1 | 1 |
| (3,1,8) | 17 = 122 | 2 | 43263 | 2:10, 3:18, 4:68, 5:81, 6:21, 7:1 | 10 | (5) | 40 | 1 | 1 |
| (2,2,4) | 13 = 1101 | 2 | 140 | 2:1, 3:1, 4:2, 5:1, 6:1 | 1 | (2,1) | 1 | 1 | 1 |

Each row satisfies `sum (number of classes) * p^d = C` (e.g. 3*4 + 3*8 + 4*16 + 32 = 132; 10*9 + 18*27 + 68*81 + 81*243 + 21*729 + 2187 = 43263; 4 + 8 + 32 + 32 + 64 = 140).

Worked-example numbers recomputed: `binom(24,8) = 735471`, `735471/17 = 43263`, `43263/9 = 4807`, `4807 = 1 (mod 3)`; `6!/(2! * 9 * 4) = 10`; `T(5) = 40`, `T(3) = 2`, `T(1) = 1`, `40 = -2 = 1 (mod 3)`; `binom(16,4) = 1820`, `1820/13 = 140`, `140/4 = 35`; `T(2,1) = T(0,2) = T(1,0) = 1` for (p,k) = (2,2); `4!/(2! * 4) = 3`.

Other values of `T` found: p=2,k=1: T(2..6) = 1, 3, 15, 105, 945; p=3,k=1: T(3), T(5), T(7) = 2, 40, 2240; p=5: T(5) = 24; (p,k)=(3,2): T(6,1) = 80; (p,k)=(5,2): T(5,4) = 576.

Statement sweep: `v_p(C) = t` and the unit congruence hold for p in {2,3,5,7,11}, k in {1,2,3}, n < 300 (n < 60 when q >= 50); 0 counterexamples. This tests the statement, not the proof.

## 6. What I did not check

- The literature. I did not open [Konvalinka], [DeutschSagan] or [PostnikovSagan]. The paper's description of Konvalinka's argument, the bibliographic data, and the novelty of the result and of the method are unverified (F9).
- The identity `C = (1/m) binom(qn, n)` was taken as known; I only confirmed it numerically for the cases enumerated.
- Remark 2.5 (wreath product, Sylow subgroup) was not checked beyond recognising it as standard; it is unused.
- I did not compile the LaTeX. I looked at pages 10-12 of the existing PDF only; pages 1-9 were read in source form, so typesetting problems there (overfull boxes, figure placement) would be missed. All `\ref` targets exist in the source.
- The computations cover small cases only (at most 208012 trees per case, at most 7 labels in brute-force enumerations of `T(a)`). The general statements rest on my reading of the proofs, not on the scripts.
- No formal verification was attempted.
- By instruction I did not read the earlier reviews, the adjudication, or the change log, so I cannot say whether any finding above repeats or contradicts them.
