# Round 3 referee report (fresh reviewer)

Reviewer: Claude Fable 5.2, 2026-11-14. Input read: `paper/main.tex` only (545 lines, all of it). Not read: `paper/main.pdf`, anything else in `paper/reviews/`, `notes/`, `briefs/`, the status and claims files, `paper/CHANGES_round1.md`. Statement numbers below are inferred from the source (shared theorem counter, numbered within sections); line numbers are those of `paper/main.tex`.

## 1. Summary verdict

**Is the main theorem fully proved? Yes, modulo listed gaps.**

- No definition, lemma, proposition, theorem or corollary states something false. I found no counterexample to any statement, by reasoning or by computation.
- **GAP: 6.** Three sit on the proof chain of Theorem 1.1 (two in Proposition 4.5, one in Lemma 4.3); each is a true assertion made without proof, or a step taken out of logical order, and each is closed by one to three lines given below. Three are definition or attribution defects.
- **WRONG: 2**, both at the level of a single sentence, neither affecting a proof: the sentence justifying equation `eq:leaves` is false as written (the equation is true), and Example 7.2 writes `C_8 = 43263` (the value is that of `C_8^{(3)}`; in the paper's own notation `C_8` is the Catalan number 1430).
- 11 further consistency notes (leftover text, unused statements, overloaded symbols, one imprecise sentence in the Introduction).

Nothing in the proof of Theorem 1.1 uses the p-adic valuation of a factorial, binomial or multinomial coefficient. The only arithmetic input on factorials is that `prod m_j!` is prime to p because every factor is below p (Proposition 5.2), plus Lagrange's theorem for the group `H`. Remark 2.5 asserts a Sylow property, which does rest on `v_p(q!)`, but the remark is declared unused and is unused.

## 2. Table of verdicts

| # | Item (label) | Verdict | Reason |
|---|---|---|---|
| 1 | Theorem 1.1 (`thm:main`), statement | CORRECT | Follows from Lemma 2.3, Lemma 2.7, Lemma 2.11, Prop. 3.2, Prop. 5.2, Prop. 5.6 exactly as assembled in Section 6; every hypothesis of a cited result holds where cited. Checked against the closed formula on 17800 triples (p,k,n). |
| 2 | Definition 2.1 (p-ary tree, depth, `K_h`) | CORRECT | Standard recursive definition. It declares "node" to mean internal node; later text breaks this convention (finding G4). |
| 3 | Equation `eq:leaves` | equation CORRECT; justifying sentence WRONG as written (W1) | `l = sum l(T_i)` and `#int = 1 + sum #int(T_i)` give the identity by induction. The sentence offered as proof names the wrong object. |
| 4 | Definition 2.2 (k-blocked) | CORRECT | Plain condition on leaf depths. |
| 5 | Lemma 2.3 (`lem:blocked`) | CORRECT | Substituting `K_k` for each q-ary node multiplies every depth by k and keeps the leaves; conversely no leaf of a k-blocked tree lies strictly between levels `rk` and `(r+1)k`, so every internal node at level `rk` heads a full `K_k`. The explicit map was verified to be a bijection onto the directly generated k-blocked trees in 54 cases. |
| 6 | Definition 2.4 (rotation equivalence) | CORRECT | (R1) is unconditional and (R2) is a closure rule, so intersections of equivalence relations satisfying them satisfy them; the smallest one exists. |
| 7 | Remark 2.5 | not part of any proof | See note N6. |
| 8 | Lemma 2.6 (`lem:normal-form`) | CORRECT | `R` is defined from `~` on immediate subtrees; `R` is an equivalence relation, `R` implies `~` by (R2) then (R1), hence `R` satisfies (R1) and (R2), hence `~` implies `R` by minimality. The order of these four steps is sound and not circular. |
| 9 | Lemma 2.7 (`lem:depth-invariant`) | CORRECT | "Same multiset of leaf depths" is an equivalence relation satisfying (R1) and (R2); minimality. |
| 10 | Definition 2.8 (asymmetric node, `d`) | CORRECT | Well defined; asymmetry of a node depends only on the subtree below it. |
| 11 | Lemma 2.9 (`lem:d-invariant`) | CORRECT | Normal form makes the class word of `T'` a rotation of that of `T`, so root symmetry agrees, and induction handles the subtrees. Uses `eq:d-recursion`, which is stated after the lemma (note N1). |
| 12 | Equation `eq:d-recursion` | CORRECT | Immediate from Definition 2.8. |
| 13 | Equation `eq:fixed-points`, Lemma 2.10 (`lem:tuple-rotation`) | CORRECT | Orbit sizes divide p; a nonzero `r` generates `Z_p`. |
| 14 | Lemma 2.11 (`lem:class-size`) | CORRECT | `[T]` is the union over `r` of the product sets `prod B_{i+r}`; these coincide when all `B_i` are equal and are pairwise disjoint otherwise, because a common element forces the class word to be fixed by rotation `r-s`. Verified on every class of 58 full enumerations. |
| 15 | Lemma 3.1 (`lem:digit`) | CORRECT | Summing the column recurrence gives `sum s_p(a_i) - s_p(sum a_i) = (p-1) sum c_j`; all carries vanish iff every column sum is below p. |
| 16 | Proposition 3.2 (`prop:lower-bound`) | CORRECT | Asymmetric root: induction plus subadditivity. Symmetric root: `d(T) = p d(T_1) >= p t(b) >= t(b) = t(pb)`. `d = 0` forces all roots symmetric, hence completeness by induction and equal leaf counts. |
| 17 | Definition of "minimal", Proposition 4.1 (`prop:minimal-local`) | CORRECT | Equality in the two inequalities of Prop. 3.2 is exactly "children minimal and carry-free"; a minimal tree with symmetric root has `(p-1) t(b) <= 0`, so `d = 0`. Verified on every generated tree and subtree. |
| 18 | Definition 4.2 (`def:skeleton`) | GAP (G4) | The isomorphism is declared a bijection "on the set of nodes", which by Definition 2.1 excludes leaves. Intended meaning is clear. |
| 19 | Lemma 4.3 (`lem:plane-cyclic`) | GAP (G3) | "With the same proofs" is not literally true for Lemma 2.6. The "Moreover" assertion and its proof are correct. |
| 20 | Lemma 4.4 (`lem:skeleton-asym`) | CORRECT | Equivalent child subtrees carry equal label multisets, so `b_j = p b_j'` with `b_j < p` forces no atoms; distinct labels give disjoint non-empty label sets. Its first application is never used (note N2). |
| 21 | Proposition 4.5 (`prop:skeleton`) | GAP (G1, G2) | Statement true (verified: contraction constant on classes, injective, image equal to an independent enumeration of skeleton trees, expansion inverse both ways). Two steps of the converse direction are asserted or out of order. |
| 22 | Definition of `T(a)` (Section 5.1) | CORRECT | Consistent with condition (S): class `c` at depth `-c` mod k. The extension to arbitrary vectors is what Prop. 5.4 needs. |
| 23 | Lemma 5.1 (`lem:aut-order`) | CORRECT | (i) every vertex is the unique ancestor at its depth of a fixed leaf. (ii) the root rotation has order dividing p and the order of `alpha`, hence is trivial; induct on child subtrees. |
| 24 | Proposition 5.2 (`prop:free`) | GAP (G5) | Freeness argument correct: `phi` and `h` have equal order, the order is prime to p, so `phi = 1` by Lemma 5.1(ii), so `h = 1`. The surrounding orbit bookkeeping cites the wrong source and leaves one equivalence unproved. |
| 25 | Lemma 5.3 (`lem:moving-leaves`) | CORRECT | If the parent `v` of a moved leaf is fixed, `alpha` rotates the children of `v` without fixed position, so all leaves below `v` move and there are `p` times the common leaf count of them; if `v` moves, its `p` images have disjoint leaf sets with at least p leaves each. |
| 26 | Proposition 5.4 (`prop:carry`) | GAP (G6) | Fixed trees are those in which the chosen labels form a cherry with `f(u) = a + bu`, `b != 0`; modulo rotation this is `p-1` orders; the parent sits at depth `-(c+1)` mod k including the wrap `c = k-1`. The final bijection is stated on isomorphism classes without the one-line check. Verified exactly, `#Fix = (p-1) T(a')`, in 221 instances. |
| 27 | Lemma 5.5 (`lem:terminal`) | CORRECT | A deepest internal node has p leaf children at one depth, hence p labels of one class. Verified on 68 terminal vectors. |
| 28 | Proposition 5.6 (`prop:carry-termination`) | CORRECT | `W` is invariant modulo `q-1`, positive, at most `q-1` on a terminal vector, and congruent to 1; for `q > 2` this forces `W = 1`, `b = e_0`. `q = 2` is treated separately and correctly. Every `=` and `≡` in `eq:weight-start` is the right sign. The hypothesis `m ≡ 1 (mod q-1)` is present and necessary. One leftover justification (note N3). |
| 29 | Proof of Theorem 1.1 (Section 6) | CORRECT | `C = sum p^{d}` over classes, `d >= t`, so `C/p^t ≡ N_min`; then Prop. 5.2 and Prop. 5.6. |
| 30 | Corollary 6.1 (`cor:exact-count`) | CORRECT | Each labelled cyclic tree has exactly `p^t` plane representatives (Lemmas 4.3, 4.4, 2.11), so `p^t T(a) = s! (1/s) binom(pt,t) = (pt)!/t!`. Verified for p = 2, 3, 5, 7. |
| 31 | Example 7.1 (`ex:binary`) | CORRECT | All numbers and all descriptive sentences recomputed. |
| 32 | Example 7.2 (`ex:ternary`) | numbers and breakdown CORRECT; notation WRONG as written (W2) | The breakdown 1+1+2+2+4 = 10 by root atoms was recomputed by enumeration and matches. |
| 33 | Example 7.3 (`ex:quaternary`) | CORRECT | All numbers, the depth analysis and the carry chain recomputed. |
| 34 | Introduction, paragraph on p = q = 2 | no false claim about this paper; one imprecise sentence (note N5) | The claims about the cited papers were not checked. |

## 3. Detailed findings by severity

Severity 1 (would invalidate Theorem 1.1): **none**.

### Severity 2: steps on the proof chain of Theorem 1.1 asserted without proof or out of order

**G1. Proposition 4.5 (`prop:skeleton`), converse direction, line 294.**
Quoted: "replacing equal atom labels by equal complete trees turns rotation-equivalent labelled trees into rotation-equivalent trees."
Missing: this is the well-definedness of expansion on classes, and it is only asserted. Rotation equivalence is defined as a smallest relation, so the claim needs an argument.
Fix: define expansion `E` on plane labelled trees by `E(leaf labelled j) = K_j`, `E((S_1,...,S_p)) = (E(S_1),...,E(S_p))`. The relation `S ≈ S'` iff `E(S) ~ E(S')` is an equivalence relation on plane labelled trees; it satisfies (R1) because `E(rot_r S) = rot_r E(S)`, and (R2) because `E` commutes with forming p-tuples and `~` satisfies (R2). By minimality of the labelled `~` (Lemma 4.3), `S ~ S'` implies `E(S) ~ E(S')`.

**G2. Proposition 4.5 (`prop:skeleton`), last paragraph, lines 296 to 300.**
Quoted: "so the maximal complete subtrees of the expansion are exactly the expanded atoms, and contraction recovers the skeleton. Thus, if there are r skeleton nodes, then d(T)=r. [...] Hence r=t(m), so T is minimal. Expansion reverses contraction, and the correspondence is bijective."
Missing: (a) `kappa` was defined only on minimal trees ("Define the contraction kappa(T) of a plane minimal tree recursively"), yet it is applied to the expansion two sentences before the expansion is shown to be minimal. (b) "Expansion reverses contraction" has no argument. (c) The symbol `T` now denotes the expansion of a skeleton, having denoted a given minimal tree since the first line of the proof, and `r` now counts skeleton nodes, having been a depth and a rotation earlier in the same proof.
Fix: reorder so that `d(E(S)) = t(m)` comes first, then add: "For a plane labelled skeleton `S`, `kappa(E(S)) = S` by induction on `S`: if `S` is a leaf labelled `j` then `kappa(K_j) = S`; otherwise the root of `E(S)` is asymmetric, so `E(S)` is not complete, its immediate subtrees `E(S_i)` are minimal by Proposition 4.1, and `kappa(E(S)) = (kappa(E(S_i)))_i = S`. Conversely `E(kappa(T)) = T` for every plane minimal tree `T`, by the same induction on `T`. Both are equalities of plane trees, so the two maps on classes are mutually inverse." Rename the expansion (say `E(S)`) and the node count (say `u`).

**G3. Lemma 4.3 (`lem:plane-cyclic`), lines 269 and 272.**
Quoted: "Then Lemmas 2.6, 2.9 and 2.11 hold for these trees with the same proofs" and "The proofs of the three lemmas never use that leaves are indistinguishable."
Missing: the proof of Lemma 2.6 begins "let R(leaf, leaf) hold". Read verbatim for labelled leaves this makes `R` hold between leaves with different labels, and then the step "R implies ~" fails, as does (R2) for `R`. The proof needs `R` to hold between two leaves exactly when their labels agree. Also unstated: that "asymmetric" and `d` are to be read with labelled classes, and that a labelled class consists of trees with the same multiset of labels (used in Corollary 6.1, where the class of a distinctly labelled tree must consist of distinctly labelled trees on the same label set).
Fix: replace by "hold for these trees, with `R` in the proof of Lemma 2.6 declared to hold between two leaves exactly when their labels agree, and with asymmetry and `d` defined through labelled classes"; add "rotation equivalent labelled trees have the same multiset of leaf labels (the relation 'same multiset of labels' satisfies (R1) and (R2))".

### Severity 3: definition, attribution and wording defects

**G4. Definition 4.2 (`def:skeleton`), line 266; also line 318 (Lemma 5.1) and line 362 (Prop. 5.4).**
Quoted: "a root-preserving bijection on the set of nodes that preserves the parent--child relation".
Missing: Definition 2.1 says "Nodes that are not leaves are called internal nodes, or simply nodes", so "the set of nodes" is the set of internal nodes and the map is not defined on leaves; "preserves leaf labels", "fixes every leaf" and "moves exactly p leaves" then have no meaning. Lemma 5.1 writes "A node of maximal depth is a leaf", which contradicts Definition 2.1 outright.
Fix: either drop "or simply nodes" from Definition 2.1, or write "bijection on the set of all vertices (internal nodes and leaves)" in Definition 4.2 and Proposition 5.4 and "A vertex of maximal depth" in Lemma 5.1.

**G5. Proposition 5.2 (`prop:free`), lines 330, 332, 336.**
Quoted: "Proposition 4.5 gives a surjection from the resulting labelled cyclic trees to skeleton trees with indistinguishable atoms: forget the labels for each height separately." and "two labelled trees have the same unlabelled skeleton exactly when they are in one H-orbit."
Missing: the surjection is the forgetful map and owes nothing to Proposition 4.5. What Proposition 4.5 does supply, that `N_min` equals the number of equivalence classes of cyclic skeleton trees for `m`, is used silently in "Division by this orbit size gives the formula". The orbit characterisation is asserted.
Fix: "Forgetting labels maps the `T(a)` classes onto the classes of cyclic skeleton trees for `m`, of which there are `N_min` by Proposition 4.5. If `alpha` is an isomorphism between the height-labelled skeletons of two distinctly labelled trees with labellings `lambda`, `lambda'`, define `h` by `h(lambda(x)) = lambda'(alpha(x))`; `h` lies in `H` because `alpha` preserves heights, and `alpha` is an isomorphism from `h·tau` to `tau'`. The converse is clear."

**G6. Proposition 5.4 (`prop:carry`), line 366.**
Quoted: "Conversely, a tree counted by T(a') and one of the p-1 cyclic arrangements of the chosen labels reconstruct a unique fixed tree. Hence |Fix| = (p-1)T(a')."
Missing: both sides are sets of isomorphism classes; that collapsing is well defined on classes and that different pairs (class, `b`) give non-isomorphic trees is not said.
Fix: "An isomorphism of labelled cyclic trees preserves labels, so it maps the parent of the chosen labels to the parent of the chosen labels and preserves the cyclic order of the labels there. Hence the class of the collapsed tree and the slope `b` are invariants of the class of a fixed tree, and reconstruction is inverse to collapsing."

**W1. Section 2.1, sentence before `eq:leaves`, line 79. WRONG as written.**
Quoted: "Replacing an internal node of a plane q-ary tree by a root with q new leaves increases the leaf count by q-1."
False inference: the operation that raises the leaf count by `q-1` replaces a leaf, not an internal node. Counterexample to the sentence as written: in the tree with one internal node, replacing that internal node by a root with q new leaves returns the same tree; the leaf count changes by 0.
Fix: "Replacing a leaf of a plane r-ary tree by an internal node with r new leaves increases the leaf count by r-1; every r-ary tree arises from a single leaf by such steps." State the identity for arbitrary arity `r`: it is used with `q` in Lemma 2.3 and with `q = p` in Propositions 3.2 and 4.5 and Corollary 6.1.

**W2. Example 7.2 (`ex:ternary`), line 498. WRONG as written.**
Quoted: "Here C_8=43263".
The paper uses `C_n` without superscript for the Catalan number (Introduction: "v_2(C_n)=s_2(n+1)-1"; Example 7.1: "C_6=132"). In that notation `C_8 = 1430`. The number 43263 is `C_8^{(3)} = binom(24,8)/17`.
Fix: write `C_8^{(3)}=43263`, as Example 7.3 does with `C_4^{(4)}=140`.

### Severity 4: consistency notes (not counted above)

**N1. Lemma 2.9 (`lem:d-invariant`), line 139.** The proof cites `eq:d-recursion` "below". Move the display and its one-line justification (asymmetry of a node depends only on the subtree below it) before the lemma.

**N2. Lemma 4.4 (`lem:skeleton-asym`), line 275, and its uses.** The sentence "This applies to every cyclic p-ary tree whose leaves bear the atom multiset of m" is never invoked. Proposition 4.5 proves asymmetry of skeleton nodes inline ("Every skeleton node v is asymmetric in the expanded tree"), and correctly so: what is needed there is that the expanded plane child subtrees are not all rotation equivalent, which is a different statement from non-isomorphism of labelled child skeletons and does not follow from Lemma 4.4 without injectivity of expansion. The only uses of Lemma 4.4 are for distinct labels: line 309 and Corollary 6.1. The sentence at line 309 ("By Lemma 4.4, at no internal node of such a tree are the p child subtrees all equivalent") is itself not used anywhere in Section 5. In Corollary 6.1, line 432, "Because all leaves are distinctly labelled in T(a), its p child cyclic subtrees at each node are never all equivalent" repeats the next sentence and "its" has no antecedent (`T(a)` is a number). Delete the unused sentence of the lemma or say where it is used; delete the duplicate in the corollary.

**N3. Proposition 5.6 (`prop:carry-termination`), lines 387 and 392.** "and the last because m=(q-1)n+1": the proposition now assumes `m ≡ 1 (mod q-1)`; the proof should say "by hypothesis". "Then W(b) ≡ 1 (mod q-1) by `eq:weight-start`" should add "and the invariance of W under carries".

**N4. Proposition 4.5, lines 292 and 294.** "while the depths of the other leaves are unchanged by the contraction" and "every other leaf is unchanged": there are no other leaves. Every leaf of `T` lies in a maximal complete subtree (a single leaf is `K_0`), and every leaf of a skeleton bears an atom. Delete both phrases.

**N5. Introduction, paragraph on p = q = 2, line 70.** "Proposition 5.4 replaces the explicit double factorial by a fixed-point count that works for all p and k." What the paper delivers for all p and k is the count modulo p (Propositions 5.4 and 5.6). An exact count is given only for k = 1 (Corollary 6.1), by a different argument that uses the Fuss-Catalan formula. Insert "modulo p" and, if desired, point to Corollary 6.1, which for p = 2 gives `(2t)!/(t! 2^t) = (2s-3)!!`. Second point: "Propositions 3.2 and 4.5 extend that description" speaks of the trees with the fewest asymmetric nodes; that the minimum `t` is attained among k-blocked trees with `m` leaves is nowhere stated. For k = 1 it is immediate (a p-ary tree with `s_p(m)` leaves exists); for k >= 2 it follows only from `N_min ≢ 0 (mod p)` in the proof of Theorem 1.1. Add a one-line corollary. Nothing else in the paragraph claims more than the paper proves.

**N6. Remark 2.5 and the word "orbit".** The remark's first sentence is not a precise statement (no group is shown to act on a set of trees), and "a Sylow p-subgroup of the symmetric group S_q" depends on `v_p(q!)`, the kind of fact the paper advertises not using. The remark is unused, so there is no logical dependency, but drop the Sylow clause or mark it as outside the proof. The Abstract and Introduction speak of "orbits"; the body defines classes of a generated equivalence relation and never a group action. Say "classes", or define the action (the group generated by rotations at the nodes of a complete p-ary tree of sufficient height, acting on finite p-ary trees regarded as subtrees).

**N7. Overloaded symbols.** `T` is a tree and `T(a)` a number; `r` is a rotation, a depth, a number of summands (Lemma 3.1), a number of skeleton nodes and a number of carries; `a` is a leaf count, a vector and an element of `Z_p` in `f(u) = a + bu`; `b` is a leaf count, a slope, a vector and a column digit; `l` is the leaf count and `l_1,...,l_p` are labels; `n` is the number of internal nodes and an exponent in `phi^n` (Prop. 5.2).

**N8. Hard-coded and unused items.** "Section 7" is typed by hand at line 54 (currently correct). The macros `\GAP`, `\Atom`, `\dep`, `\leaf` are defined and never used; there is no outstanding `\GAP` marker. The labels `eq:merges`, `ex:binary`, `ex:ternary`, `ex:quaternary` are never referenced.

**N9. Lemma 5.1(i), line 318.** "Induct on decreasing depth" and the step about rotating the children are superfluous: all leaves are fixed by hypothesis, and every vertex is the unique ancestor at its depth of some leaf. Not an error.

**N10. Lemma 2.6, line 120.** Symmetry and transitivity of `R` are checked for non-leaves only; the cases involving a leaf are trivial but unmentioned.

**N11. Text.** Line 68: "the full symmetric symmetry group". Lines 35 to 37: author "Working proof draft". Bibliography: the Kersting-Fischer entry has no volume or article number.

### Answers to the nine points of the brief

1. **Lemma 4.3 and its uses.** The identification of isomorphism of labelled cyclic trees with rotation equivalence of plane labelled trees is correctly proved by induction through Lemma 2.6. It is used in Definition 4.2 (forward pointer), in Proposition 4.5 (isomorphic skeletons have rotation-equivalent plane representatives) and in Corollary 6.1 (plane representatives form one labelled class); each use needs exactly the direction that the lemma provides. Defect: G3.
2. **Lemma 4.4 and its uses.** Correct. Both actual uses are for distinct labels. The atom-multiset case is stated and not used (N2); Proposition 4.5 rightly proves its own, different, asymmetry statement.
3. **Proposition 4.5.** The recursive definition of `kappa` is well founded (subtrees of minimal trees are minimal; a non-complete minimal tree has an asymmetric root). Well-definedness on classes is correctly proved (a complete tree is alone in its class; otherwise Lemma 2.6 and induction). The induction identifying atoms with base-p digits is correct. The converse direction has gaps G1 and G2. With those filled the two maps are mutually inverse on classes, since `E(kappa(T)) = T` and `kappa(E(S)) = S` hold as equalities of plane trees.
4. **Proposition 5.6.** Hypothesis present and necessary: for p = 2, k = 2, m = 2 one has `a = (0,1)`, `t = 0`, `T(a) = 0 ≠ 1`. All signs in `eq:weight-start` are right: `=`, `≡`, `=`, `≡`. `q = 2`: handled without any congruence, ends at `e_0` after `s_2(m)-1` carries. `q = 3`: `0 < b_0 <= 2`, `b_0` odd, so `b_0 = 1`. `p = 2, k = 2`: `0 < b_0 + 2 b_1 <= 3` and `≡ 1 (mod 3)` force `(1,0)`. Leftover wording: N3.
5. **Cross-references.** Every `\ref`, `\eqref` and `\cite` has a target (script). Each cited statement is the one needed, with two exceptions of attribution, not of substance: G5 (Proposition 4.5 cited for the forgetful surjection) and N3 (`m=(q-1)n+1` cited where the hypothesis is meant). Hypotheses at the point of citation: Prop. 5.6 is applied in Section 6 with `m = (q-1)n+1`; Prop. 5.2 needs only `m_j < p`; Lemma 2.11 "for labelled trees" in Corollary 6.1 is covered by Lemma 4.3; `eq:leaves` "with q = p" is a harmless change of arity (W1). Leftovers: N2, N3, N4; no reference to a condition other than (S) survives.
6. **Lemmas 2.6, 2.7, 2.9.** Correct; see table. The logical order in Lemma 2.6 is sound.
7. **Lemma 5.1 and Proposition 5.4.** Correct. The count is `p-1` (slopes `b ≠ 0` of `f(u) = a + bu`, the intercept removed by rotating positions). The shift `c -> c+1` with wrap-around is right: the cherry's parent is at depth `≡ -c-1`, which for `c = k-1` is `≡ 0`. Defect: G6.
8. **Worked examples.** All numbers recomputed: 132, 33, 3; 17 = 122_3, 10, 40, `T(3) = 2`, 43263, 4807, `4^{-1} ≡ 1`; 13 = 1101_2, 140, 35, `T(2,1) = T(0,2) = T(1,0) = 1`. Ternary breakdown by the two atoms at the root: `{K_0,K_0}`: 1, `{K_1,K_1}`: 1, `{K_0,K_2}`: 2, `{K_1,K_2}`: 2, `{K_0,K_1}`: 4, total 10, as stated. The two pictured choices are of types `{K_1,K_2}` and `{K_0,K_2}` and give two skeletons each, as stated. Quaternary: `K_3` at depth 1, `K_0` and `K_2` at depth 2; expansion has one leaf at depth 2 and twelve at depth 4. Defect: W2.
9. **Introduction, p = q = 2.** See N5. The statement `v_2(C_n) = s_2(n+1)-1` is the case `p = q = 2` of Theorem 1.1, and `(2s-3)!!` agrees with Corollary 6.1 for p = 2 (checked for `s <= 7`).

## 4. Computations I ran

All scripts are in `paper/reviews/scratch_round3/`, run with `uv run python`; each has a `.out` log beside it. Every assertion passed.

**`verify_classes.py`: full enumeration of plane trees, 58 triples (p,k,n).**
Range: (2,1,1..12), (3,1,1..8), (5,1,1..6), (7,1,1..5), (2,2,1..7), (3,2,1..5), (5,2,1..3), (2,3,1..5), (3,3,1..3), (2,4,1..4); up to 208012 trees per case. Checked in every case:
- number of k-blocked p-ary trees with `m` leaves equals `binom(qn,n)/m`; in 54 cases also that the explicit blocked-form map from q-ary trees is a bijection onto them;
- classes computed by a canonical form; in the 45 cases with at most 3000 trees, also recomputed by union-find over single-node rotations (the generators (R1), (R2)) with identical result;
- every class has size `p^d`, `d` and the multiset of leaf depths are constant on it, `d >= t`, and `min d = t`;
- on every generated tree and subtree (all depth phases): `d >= t(l)`, `d = 0` iff complete, and the equivalence of Proposition 4.1, including the column criterion for carry-freeness;
- on every minimal tree: atom multiset of `kappa(T)` equals the digits of `m`, condition (S), `E(kappa(T)) = T`, `kappa` constant on classes and injective on classes, image equal to an independently enumerated set of cyclic skeleton trees (generated from the atom multiset and (S), without reference to trees), and `kappa(E(S)) = S` for every such skeleton;
- `N_min ≡ (-1)^t / prod m_j! (mod p)`, `C/p^t` congruent to the same, and for k = 1 `N_min = (pt)!/(t! p^t prod m_j!)`.

**`verify_classes_big.py`, `verify_classes_big_ext.py`: class-level enumeration, 84 + 25 cases.**
Classes are enumerated as necklaces of child classes (this presupposes Lemma 2.6, cross-checked above). Range: (2,1,1..18), (2,2,1..15), (2,3,1..12), (2,4,1..9), (3,1,1..14), (3,2,1..10), (3,3,1..6), (5,1,1..11), (5,2,1..8), (7,1,1..6); up to 1128561 classes. Checked: `sum p^d` over classes equals the Fuss-Catalan number, `min d = t`, number of classes with `d = t` equals the independent skeleton count, and the congruence. This reaches k >= 2 cases with several minimal classes: (2,2,10) `N_min = 9`; (2,2,14) and (2,2,15) `N_min = 3`; (5,2,7) `N_min = 4`; (5,2,8) `N_min = 8`; (3,2,5), (3,2,6), (3,3,5), (3,3,6), (5,2,3), (5,2,4) `N_min = 2`.

**`verify_carry.py`: labelled cyclic trees.**
- Explicit enumeration of `T(a)` for all vectors with total at most 7 for (p,k) = (2,1), (2,2), (3,1), (3,2), at most 6 for (2,3), at most 5 for (3,3), (5,1), (5,2).
- Lemma 5.5 on 68 terminal vectors.
- Proposition 5.4 on 221 instances (a, c) with `a_c >= p`, including wrap-around instances `c = k-1` for every (p,k) in the range: `#Fix(sigma) = (p-1) T(a')` exactly, the chosen labels form a cherry in every fixed tree, `T(a) ≡ -T(a') (mod p)`.
- Proposition 5.2 on 375 values of `m`: every `H`-orbit has `prod m_j!` elements and the number of orbits equals the number of unlabelled skeletons.
- A count-only recursion for `T(a)`, validated against the explicit enumeration, then: `T(a) ≡ (-1)^t (mod p)` and termination of the carry chain at `e_0` after exactly `t` carries on 1687 values of `m ≡ 1 (mod q-1)` for (p,k) in (2,1..4), (3,1..3), (5,1..2), (7,1); and `T(a) = 0` on 4359 values of `m ≢ 1 (mod q-1)`, which shows the hypothesis of Proposition 5.6 cannot be dropped.

**`verify_formula_examples.py`.**
- Theorem 1.1 against `binom(qn,n)/m` (valuation and unit residue) on 17800 triples: p in {2,3,5,7,11,13}, k <= 5 with `q <= 130`, `n <= 1500` for `q <= 16` and `n <= 400` otherwise.
- Independent skeleton count against the predicted residue, against `C/p^t mod p`, against `T(a)/prod m_j!`, and for k = 1 against the exact formula (for p = 2 also `(2s-3)!!`), on 3735 values of `m`, k up to 4.
- Every number and every descriptive sentence of Examples 7.1 to 7.3.

**`aux_refs_and_scan.py`.** All `\ref`, `\eqref`, `\cite` targets exist; no duplicate labels; unused labels and macros as in N8.

## 5. What I did not check

- The cited papers (Konvalinka; Deutsch and Sagan; Postnikov and Sagan; Kersting and Fischer): what they prove, whether the Introduction describes them accurately, the bibliographic data and DOIs, and any question of priority or novelty.
- The compiled `paper/main.pdf`: I did not open it. Statement numbers are inferred from the source, the TikZ pictures were read as source and not viewed, and I did not compile the file.
- Remark 2.5 beyond recognising its content as standard.
- Anything by formal proof assistant. The verdicts CORRECT rest on my reading plus the finite computations above; the computations cover small parameters only (k <= 5 for the closed formula, k <= 4 for enumeration, p <= 13).
- Earlier reviews, adjudications and change logs, by instruction; I therefore cannot say whether any finding above repeats or contradicts an earlier one.
