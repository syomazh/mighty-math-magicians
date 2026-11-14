# Adversarial review of `paper/main.tex`

**Reviewer:** `moonshotai/kimi-k3.1-pro` (Open Math OS worker), 2026-11-13.  
**Scope:** the argument in `paper/main.tex`, compared with the independently written `notes/briefing_grad_student/briefing.tex`. Checked by mathematical rereading, hand enumeration of the requested small cases, and short in-memory enumeration scripts. No file in `paper/reviews/` other than this report was read.

## Summary verdict

**Yes modulo the listed gaps.** I found no counterexample to Theorem 2.1 (the main theorem), and the overall proof route is sound. The rotation-class size, lower bound, skeleton description, carry count, and all the numerical claims checked agree with explicit enumeration.

Two inferential steps in the proof of Proposition 6.4 (iterated carries) are false as written:

* when equality of the upper bound for terminal weight occurs, the claimed congruence modulo \(p-1\) gives no contradiction for \(p=2\);
* when \(q=2\), the argument that congruence modulo \(p-1\) forces the terminal vector to be \(e_0\) uses a vacuous congruence.

Both have elementary repairs (Findings 1 and 2), so they do not overturn the proposition or theorem. There are also compressed inductions and an undefined identification of cyclic trees that should be repaired before calling the write-up complete (Findings 3–6). The exact-count corollary is separate from the main proof and is not circular.

## Table of verdicts

The numbering is from the theorem environments as they appear in `main.tex`; labels are included to remove ambiguity.

| Item | Verdict | Reason |
|---|---|---|
| Theorem 2.1 (`thm:main`) | **CORRECT modulo Findings 1–6** | The class-size partition gives the valuation and residue once the minimal-class count is established. No factorial valuation is used. |
| Basic definition of \(p\)-ary trees and \(K_h\) | **CORRECT** | Every internal node has exactly \(p\) ordered children; \(K_h\) has \(p^h\) leaves and is uniquely determined by \(h\). |
| Leaf-count identity (2.1) | **CORRECT** | Attaching \(q\) leaves in place of one leaf adds \(q-1\) leaves; starting from one leaf gives \(1+(q-1)n\). |
| \(k\)-blocked definition | **CORRECT** | It is exactly the depth condition induced by expanding each \(q\)-ary node to \(K_k\). |
| Lemma 2.2, blocked form | **CORRECT** | At a multiple of \(k\), no leaf can interrupt the next \(k\) levels, so the inverse contraction is well-defined. Leaf counts agree by (2.1). |
| Rotation relation (R1)–(R2) | **CORRECT** | These specify a well-defined smallest equivalence relation. Every generating operation preserves the tree's leaf count and depth structure. |
| Wreath-product remark, unnumbered | **GAP (very minor)** | The permutation group induced on the \(q\) bottom branches is the iterated wreath product of the \(k\) levels, not the full group generated independently at every internal node of \(K_k\). The wording should say “the induced permutation group is an iterated wreath product”. This formulation is explicitly not used later. |
| Lemma 2.3, normal form | **CORRECT** | The displayed relation is an equivalence relation satisfying (R1)–(R2), and conversely the two generators yield it. That is exactly minimality of \(\sim\). |
| Lemma 2.4, depth invariant | **CORRECT** | Each root generator permutes its subtrees and adds the same one to every leaf depth; recursive generators preserve each subtree's depth multiset. |
| Definition of asymmetric nodes and \(d(T)\) | **CORRECT** | Symmetry depends only on the multiset of child rotation classes, and Lemma 2.3 identifies corresponding nodes under equivalence. Hence \(d\) is class-invariant and satisfies the displayed recursion. |
| Fixed-point observation (2.4) | **CORRECT** | A \(\mathbb Z_p\)-orbit has one or \(p\) elements; the non-fixed elements therefore contribute a multiple of \(p\). |
| Lemma 2.5, tuple rotation | **CORRECT** | For nonzero \(r\) modulo prime \(p\), the sequence \(i,i+r,\ldots,i+(p-1)r\) visits every position. Thus a nonzero fixed rotation requires equal entries in every position. |
| Lemma 2.6, class size | **CORRECT** | Normal form makes the product sets disjoint: the rotation is recovered from the cyclically rotated tuple of child classes. There are \(p\) products in the asymmetric case and one in the symmetric case. |
| Lemma 3.1, digit lemma | **CORRECT, with minor Finding 6** | Addition of a digit sum is counted by initially collecting \(s_p(a_i)\) powers of \(p\); every merge reduces the term count by \(p-1\). Carry-free addition needs no merge, and any carry needs one. |
| Proposition 3.2, lower bound | **CORRECT** | At an asymmetric root, \(d=1+\sum d_i\) and \(1+(\sum s_p(a_i)-p)/(p-1)=(\sum s_p(a_i)-1)/(p-1)\). At a symmetric root, all children are rotation-equivalent, so \(a=pb\) and \(d=p\,d(T_1)\). |
| Proposition 4.1, local characterization | **CORRECT** | Equality at an asymmetric root is precisely minimality of all children plus carry-free addition. At a symmetric root equality gives \(p\,t(b)\le t(b)\), forcing \(t(b)=0\) and completeness. |
| Definition 4.2, atoms and cyclic skeleton trees | **GAP (minor, Finding 5)** | “Equivalence of cyclic trees” needs a map-on-nodes definition, particularly for its later use in the fixed-point argument. The intended independent cyclic rotations give the right notion. |
| Automatic (S1) for distinct labels | **CORRECT** | Equivalent sibling subtrees would have identical relation-invariant shapes and label multisets. If all children were equivalent, their disjoint label sets would force a single label to appear twice. |
| Proposition 4.3, skeleton bijection | **CORRECT after Finding 3 is filled** | Both directions are right, including atom depths and the fact that the bijection is with **classes**. Contraction records maximal complete subtrees; expansion is inverse to it. |
| Definition of \(a_c\) and \(T(\mathbf a)\) | **CORRECT** | A label of height \(j\) at depth \(r\) has \(r+j\equiv0\pmod k\), hence class \(c=j\bmod k\) requires \(r\equiv-c\pmod k\). |
| Proposition 5.1, removing labelling | **CORRECT after Finding 4 is stated** | Once “fixed labelled cyclic tree” means an equality induced by a cyclic-tree automorphism, distinct labels force every leaf, then every node, to be fixed. Equal atoms of different heights never get mixed because their permutation factors are separate. |
| Lemma 5.2, moving-leaf lemma | **CORRECT** | At a fixed parent, a nontrivial \(p\)-cycle permutes every child position; more than one leaf per child would move more than \(p\) leaves. A moved parent would have \(p\) disjoint images and force at least \(p^2\) moved leaves. |
| Proposition 5.3, a carry collapses a cherry | **CORRECT, subject to the definition in Finding 5** | The \(p-1\) count is exactly the nonzero slopes \(b\), with \(br=1\) and cyclic quotienting eliminating \(a\). Expansion of a class-(c+1) leaf produces children of class \(c\), including at wrap-around. |
| Lemma 5.4, terminal vectors | **CORRECT** | A deepest internal node has \(p\) sibling leaves, all of the same class, contradicting \(a_c<p\). The remaining possibility is the single depth-zero leaf, giving \(T(e_0)=1\). |
| Proposition 6.4, iterated carries | **GAP (Findings 1 and 2)** | The conclusion \(T(\mathbf a)\equiv(-1)^t\) is right, but two claimed contradictions are invalid for \(p=2\). They can be replaced by direct inequalities and the strict decrease \(a_0\mapsto a_0-1\) for \(q=2\). |
| Proof of Theorem 2.1 | **CORRECT modulo the preceding gaps** | The sum of \(p^{d(T)}\) is \(p^t\) times an integer; modulo \(p\), only the \(N_{\min}\) minimal classes survive. The denominator in the residue formula is prime to \(p\). |
| Corollary 7.1, exact count for \(k=1\) | **CORRECT** | Independent ordering at the \(t\) cyclic nodes multiplies \(T(\mathbf a)\) by \(p^t\), and the standard count of unlabelled plane trees then gives \(p^tT(\mathbf a)=(pt)!/t!\). |
| Example 7.2, binary \((2,1,6)\) | **CORRECT** | \(C_6=132=2^2\cdot33\); there are 11 classes, three of size \(2^2\), and the exact-count formula gives \(4!/(2!\,2^2)=3\). |
| Example 7.3, ternary \((3,1,8)\) | **CORRECT** | \(C_8^{(3)}=43263=3^2\cdot4807\), \(N_{\min}=720/(2\cdot9\cdot4)=10\), and the distinctly labelled count is \(T(5)=40\). |
| Example 7.4, quaternary \((2,2,4)\) | **CORRECT** | \(m=13\), the only permitted skeleton has cherry \((K_0,K_2)\) and sibling \(K_3\), and \(C_4^{(4)}=140=2^2\cdot35\). |

## Detailed findings

### 1. The claimed contradiction in the terminal-weight bound fails for \(p=2\)

**Location:** Proposition 6.4 (`prop:carry-termination`), the sentence:

> “Equality would require \(b_c=p-1\) for every \(c\), making \(\sum_cb_c=k(p-1)\equiv0\pmod{p-1}\), contrary to the preceding congruence.”

**Problem.** For \(p=2\), the preceding congruence is \(0\equiv0\pmod1\), which is no contradiction. (For even \(k\) it also fails directly, since \(k(p-1)\equiv0\pmod{p-1}\) notwithstanding the claimed preceding congruence \(1\).) The inference is therefore invalid for every \(p=2\) terminal vector of maximal weight, including the important binary case.

**Fix.** Use the weight congruence itself. Equality in the displayed upper bound gives
\[
W(\mathbf b)=q-1\equiv0\pmod{q-1},
\]
whereas \(W(\mathbf b)\equiv1\pmod{q-1}\). Since \(q-1>1\), this is a direct contradiction. No digit-total congruence is needed here. For \(q=2\), handle termination as in Finding 2.

### 2. The \(q=2\) proof invokes the wrong invariant to force one terminal label

**Location:** Proposition 6.4, the paragraph:

> “For \(q=2\) … The terminal condition \(a_0<2\) is \(a_0=1\), since the number of labels remains congruent to \(1\pmod{p-1}\) and \(p-1=1\).”

**Problem.** Every integer is congruent to \(1\pmod1\). This premise alone permits terminal \((a_0)=(0)\), for which \(T=0\), so the stated reason does not prove the claim.

**Fix.** Start with \(a_0=s_2(m)\ge1\). Here \(a_0\mapsto a_0-p\cdot1+a_0=a_0-1\) is the sole carry operation, because \(k=1\) and \(c+1=c\). Hence every carry decreases \(a_0\) by exactly one, preserving nonnegativity, until \(a_0=1\). This proves the terminal vector is \(e_0\), and directly shows that the number of carries is \(s_2(m)-1=t\). The paper's final label-count calculation also gives \(t\) once the terminal vector is established.

### 3. The atom-uniqueness induction in the skeleton bijection is not stated precisely enough to be checked as written

**Location:** Proposition 4.3 (`prop:skeleton`), the sentence:

> “Since \(\ell\) is additive at each root, an induction using Lemma 3.1 and Proposition 4.1 proves that the total atom weight at the root is \(m\). It also proves that, when a tree is constructed from these atoms with carry-free addition at every internal node, all atom multiplicities are uniquely prescribed: a single atom \(K_j\) gives the single nonzero digit \(m_j=1\), and carry-free addition gives the union of the children's multiplicities.”

**Problem.** It is not explicitly stated what is being inducted over, nor is the invariant for a subtree related to the fixed global \(m\). It is also not said why a complete subtree whose parent is asymmetric is maximal. These are exactly the details needed to conclude that “maximal complete” contraction produces the digit multiset of \(m\) rather than some other carry-free partition.

**Fix.** Define \(w(U)=\sum_{A\text{ an atom of }U}p^{h(A)}\). Prove by rooted induction on a minimal tree \(U\) that \(w(U)=\ell(U)\), and that if \(m_j(U)\) denotes the number of atoms of height \(j\) in \(U\), then
\[
\ell(U)=\sum_jm_j(U)p^j,\qquad 0\le m_j(U)<p.
\]
The atom base case is \(w(K_h)=p^h=\ell(K_h)\). At an asymmetric root, additivity of leaves and Proposition 4.1 give carry-free addition, so the coefficients \(m_j(U)\) are just the sums of the children's coefficients and remain below \(p\). Hence they are the **base-\(p\) digits**, not merely some digit vector. At the original \(k\)-blocked tree, \(w(T)=\ell(T)=m\), so its atom multiset is the atom multiset of \(m\). A non-root atom cannot contain its asymmetric parent inside a complete tree, so each atom used above is maximal.

For the converse direction, one sentence should also note that (S1) is inherited after expansion by Lemma 2.3: cyclic equivalence of expanded children is exactly the cyclic equivalence used in (S1), since complete atoms admit no nontrivial rotation.

The depth statement is correct: an atom \(K_j\) beginning at depth \(r\) has all its leaves at depth \(r+j\), so \(k\)-blockedness gives \(r\equiv-j\pmod k\). The correspondence is with rotation classes, not individual ordered trees, and rotations at internal skeleton nodes produce the expected quotient. Equal-height atoms are handled correctly later as a labelled-tree quotient.

### 4. Freeness should expressly state what an equality of labelled cyclic trees is

**Location:** Proposition 5.1 (`prop:free`), beginning:

> “The action is free. Indeed, suppose a label permutation fixes a labelled cyclic tree.”

**Problem.** A permutation acts on a set of trees, while equality is an equality of isomorphism classes. The next sentence correctly invokes “an automorphism witnessing the equality”, but this essential unpacking is implicit. In particular, “fixes a labelled tree” does **not** mean a permutation that leaves every labelled leaf of a fixed plane representative pointwise fixed; an automorphism can rotate nodes.

**Fix.** Say: if \(h\tau=\tau\), choose a cyclic-tree isomorphism \(\alpha:\tau\to\tau\) such that relabelling by \(h\) applied to \(\tau\) equals the relabelled tree obtained by transferring its labels through \(\alpha\). Since the labels are distinct, \(\alpha\) must fix each leaf. A tree isomorphism fixing every leaf fixes every internal node by induction on decreasing depth. Therefore \(h\) is identity. This makes the rest of the proof valid. Note that a whole symmetric group \(\prod S_{m_j}\) need not be a \(p\)-group; the proof rightly uses free-ness pointwise, not a \(p\)-group cardinality argument.

### 5. Cyclic-tree equivalence and automorphisms need a map-based definition for the carry argument

**Location:** Definition 4.2 (`def:skeleton`):

> “Equivalence of cyclic trees allows independent cyclic rotations at every node and preserves leaf labels and depths.”

and Proposition 5.3 (`prop:carry`):

> “For a fixed tree, let \(\alpha\) be the automorphism of the unlabelled cyclic tree induced by \(\sigma\).”

**Problem.** As a definition, “allows independent cyclic rotations” is understandable for ordered representatives but does not formally define the objects witnessing an equality of cyclic trees. The moving-leaf and cherry arguments depend on precisely these witnesses being root-preserving, child-permuting maps. The induced \(\alpha\) must also be shown to satisfy \(\alpha^p=1\) and to move the correct leaves, not merely asserted.

**Fix.** Define an isomorphism \(\alpha:S\to S'\) as a root-preserving bijection on nodes, preserving the parent relation, satisfying \(\deg\alpha(v)=\deg v\), and for every internal \(v\) either mapping the set of leaves \(\{v_1,\ldots,v_p\}\) to the children of \(\alpha(v)\) by a cyclic shift or, in the purely cyclic formulation, identifying corresponding incident child edges by a cyclic permutation. Require that leaf labels and atom heights are preserved for labelled isomorphisms. Composition, inverses, and restriction to subtrees are then available.

For a \(\sigma\)-fixed labelled class, choose an underlying-tree automorphism \(\alpha\) satisfying \(\operatorname{lab}(\alpha(x))=\sigma(\operatorname{lab}(x))\) for every leaf \(x\) (up to the chosen label-transfer convention). Since \(\sigma^p=1\), the automorphisms \(\alpha^p\) and \(1\) induce the same identity relabelling; labels are distinct, so \(\alpha^p=1\). It fixes a leaf iff its label is outside the chosen \(p\)-cycle, and moves every chosen label. Lemma 5.2 now applies verbatim.

The arithmetic is correct: each cherry fixed by the cyclic relabelling gives a nonzero slope \(b\) and a positive rotation \(r\) with \(br=1\). The rotation quotient removes the additive phase \(a\), leaving \(p-1\) labelled cyclic orders. At a depth-\((r-1)\) leaf of class \(c+1\), \(r-1\equiv-(c+1)\pmod k\); the new children have depth \(r\equiv-c\pmod k\). At wrap-around \(c=k-1\), the collapsed leaf has class \(0\), which is the same statement modulo \(k\).

### 6. Minor: the merging description in the digit lemma leaves termination/canonicality implicit

**Location:** Lemma 3.1 (`lem:digit`):

> “merging equal powers until no merge is possible ends at the unique base-\(p\) expansion”

The phrase is plausible and the conclusion correct, but the proof has not said why the same procedure applies independently of choices. This is a one-line expository gap, not an independence problem.

**Fix.** Start with the collection obtained by concatenating the base-\(p\) expansions of the summands. At a given position, whenever there are at least \(p\) tokens \(p^j\), merge any \(p\) of them, increasing the total exponent weight in the token multiset in a way compatible with ordinary addition, and repeat at successively higher positions. Stop with fewer than \(p\) tokens at every position. Then the surviving token multiplicities are exactly the coefficients produced by base-\(p\) addition. Reads in this local form, the proof also covers \(r\) summands, not just two, and the equality characterization is correct.

Alternatively, prove the inequality and carry characterization by ordinary column addition: if \(c_j\) is the carry into column \(j\), then \(s_p(\sum a_i)=\sum_i s_p(a_i)-(p-1)\sum_j c_j\). No valuation formula is involved.

### 7. Very minor: the wreath-product sentence describes the wrong group if read literally

**Location:** unnumbered remark after the definition of rotation equivalence:

> “On the \(q\) bottom branches of a copy of \(K_k\), they induce a Sylow \(p\)-subgroup of the symmetric group \(S_q\).”

The antecedent “they” is the generators with independent rotations **at every node**. Those also rotate branches strictly below an internal node of \(K_k\), so they do not induce a permutation solely of its \(q\) bottom-level slots. The induced bottom-slot permutation group is instead the iterated wreath product
\[
\mathbb Z_p\wr\mathbb Z_p\wr\cdots\wr\mathbb Z_p\quad(k\text{ factors}),
\]
which has the stated Sylow property. Replace “they” by “the rotations on the paths from its root to its \(q\) bottom slots”, or say “the induced permutation group on those slots”. This remark is unused and has no effect on the theorem.

### 8. Circularity check

The main proof uses no Legendre formula, no Kummer statement, and no valuation of any factorial, binomial, or multinomial coefficient. Equation (2.1) merely counts leaves. The integer in the proof of Theorem 2.1 is obtained from the finite class-size sum, not inferred from the closed Fuss–Catalan formula.

Corollary 7.1 uses the standard **tree count** \(C_t^{(p)}=\frac1s\binom{pt}{t}\), which is a different assertion from its \(p\)-adic valuation. Its proof explicitly occurs after the main theorem and does not feed back into it. I found no circularity. The Wilson-type residue comparison mentioned in the separate briefing is not part of the paper's proof.

## Hand computations

Notation: \(K_h\) is the complete \(p\)-ary atom; \(S\) denotes an ordinary leaf atom \(K_0\) when the label is clear. Brackets \([\,]_p\) denote the totality of a rotation class; class sizes below were also cross-checked by generating the ordered trees and their independent root/subtree rotations. A dot `.` denotes a leaf and parentheses denote ordered children.

### 1. \((p,k,n)=(2,1,3)\)

Here \(m=4=100_2\), \(s_2(m)=1\), \(t=0\). The only atom is \(K_2\), with four leaves, so the sole minimal class is \(K_2=((.\ .)(.\ .))\), of size \(1\). The five Catalan trees split as
\[
[K_2]\quad(1\text{ tree},d=0),\qquad
[(((.\ .).\ ).)]\quad(4\text{ trees},d=2).
\]
The second class consists of one left comb and its three right/deeper rotations; its root and the non-cherry internal node are asymmetric. Hence
\[
C_3=1+4=5,\qquad v_2(C_3)=0,\qquad N_{\min}=1.
\]
The residue is \((-1)^0/(0!0!1!)=1\pmod2\).

### 2. \((p,k,n)=(2,1,6)\)

Here \(m=7=111_2\), \(s_2(m)=3\), \(t=2\), and the atoms are \(K_0,K_1,K_2\). A minimal binary skeleton has two internal nodes, and its three atoms can be put into three cyclic rooted binary trees:
\[
[K_2,(K_0,K_1)],\qquad
[K_1,(K_0,K_2)],\qquad
[K_0,(K_1,K_2)].
\]
Each has \(d=2\) and class size \(4\). Thus \(N_{\min}=3\), and
\[
C_6=\binom{12}{6}/7=924/7=132=2^2\cdot33,
\qquad132/4=33\equiv1\pmod2.
\]
Corollary 7.1 gives \((2\cdot2)!/(2!\,2^2\,1!1!1!)=24/8=3\).

For all classes, the counts by \(d\) are
\[
\begin{array}{c|rrrr|r}
d&2&3&4&5&\text{total}\\ \hline
\#classes&3&3&4&1&11\\
\#trees&12&24&64&32&132.
\end{array}
\]
This also confirms \(3+3+4+1=11\) and \(3N_{\min}\)'s contribution \(3\cdot4=12\) modulo larger powers.

The explicit \(d=2\) representatives, with `.` a binary leaf, are
```
((((. .) (. .)) (. .)) .)
((((. .) (. .)) .) (. .))
(((. .) (. .)) ((. .) .))
```
They respectively contract to the three atom skeletons above.

### 3. \((p,k,n)=(3,1,2)\)

Here \(m=5=12_3\), \(t=(2+1-1)/(3-1)=1\), atoms \(K_0,K_0,K_1\). They form one unordered/cyclic cherry, with \(p=3\) cyclic arrangements, and its root is asymmetric because a leaf atom differs from \(K_1\). The expanded representative is
\[
((.\ .\ .)\ .\ .).
\]
It has \(d=1\) and class size \(3\). Those three ordered trees are all the ternary trees with two internal nodes:
\[
C_2^{(3)}=\binom63/5=20/5=3,\qquad v_3(3)=1.
\]
The residue is \(-1/(2!\,1!)=-1/2\equiv1\pmod3\). The exact count is \(3!/(1!\,3\,(2!1!))=1\).

### 4. \((p,k,n)=(3,1,3)\)

Here \(m=7=21_3\), \(s_3(m)=3\), \(t=1\), atoms \(K_0,K_1,K_1\). There is one minimal cherry: \(K_1,K_1\) are equivalent ternary symmetric nodes, but the \(K_0\) sibling differs. Its representative is
\[
((.\ .\ .)(.\ .\ .)\ .),
\]
with \(d=1\), class size \(3\), hence all its cyclic rotations. There is also one \(d=2\) class of size \(9\), represented by
\[
(((.\ .\ .)\ .\ .)\ .\ .).
\]
This is the one-cherry, one-leaf chain; both nodes are asymmetric. Therefore
\[
C_3^{(3)}=\binom93/7=84/7=12=3+9,
\]
and \(v_3(12)=1\), \(N_{\min}=1\), and \(12/3=4\equiv1\pmod3\). The residue is also \(-1/(1!\,2!)\equiv1\pmod3\).

### 5. \((p,k,n)=(2,2,2)\), so \(q=4\)

Here \(m=7=111_2\), \(t=2\), atoms \(K_0,K_1,K_2\). The depth conditions are
\[
\dep(K_0)\equiv0,\qquad\dep(K_1)\equiv1,\qquad\dep(K_2)\equiv0\pmod2.
\]
Among the three binary atom skeletons, only \([K_1,(K_0,K_2)]\) works: \(K_1\) has depth \(1\), and the other two have depth \(2\). In full binary notation this class has representative
\[
((((.\ .)(.\ .))\ .)\ (.\ .)),
\]
which is \((\text{expanded }(K_0,K_2),K_1)\). Its root rotation and its cherry rotation yield four ordered trees. There are no other quaternary trees with two internal nodes. Hence
\[
C_2^{(4)}=\binom82/7=28/7=4,\qquad v_2(4)=2=t,\qquad N_{\min}=1.
\]

The depth-class vector is \((a_0,a_1)=(2,1)\): \(K_0,K_2\) are in class \(0\) and \(K_1\) in class \(1\). There is exactly one labelled cyclic tree, so \(T(2,1)=1\). The carry chain is
\[
(2,1)\to(0,2)\to(1,0)=e_0,
\]
and \(T(0,2)=1\): the only tree on two class-1 labels is a binary cherry at depth \(1\). Modulo \(2\), each carry congruence is \(-1\equiv1\), so all three values agree with \(1\).

### 6. \((p,k,n)=(2,2,3)\), so \(q=4\)

Here \(m=10=1010_2\), \(s_2(m)=2\), \(t=1\), with atoms \(K_1,K_3\). Both must start at odd depth because their heights are odd. They must be siblings in a cherry at depth \(1\), and the expanded representative is
\[
((((.\ .)(.\ .))((.\ .)(.\ .)))\ ((.\ .)(.\ .))),
\]
i.e. the root's two subtrees are \(K_3\) and \(K_2\). It has \(d=1\), and its root rotation gives two ordered trees. This is the sole minimal class. The other two rotation classes have one class of size \(4\) with \(d=2\), and one of size \(16\) with \(d=4\). Their representatives are respectively
```
((((. .) (. .)) .) (((. .) (. .)) .))
(((((. .) (. .)) .) (. .)) .) (. .))
```
with the displayed placement of parentheses understood as full ordered binary trees. Consequently
\[
C_3^{(4)}=\binom{12}{3}/10=220/10=22=2+4+16,
\qquad v_2(22)=1.
\]
The residue is \(11\equiv1\pmod2\), matching \(-1/(0!1!0!1!)\equiv1\pmod2\). For this case \((a_0,a_1)=(0,2)\), so the carry chain is just \((0,2)\to(1,0)\), one step, agreeing with \(t=1\).

### 7. Recomputed numbers in the three worked examples

**Example 7.2.** As above: \(m=7\), \(t=2\), \(N_{\min}=3\), \(4!/(2!\,2^2)=3\), \(132/4=33\equiv1\pmod2\). The picture's three skeletons are exactly the three listed atom skeletons.

**Example 7.3.** \(m=(3-1)8+1=17=9+2\cdot3+2=122_3\), so \(s_3(17)=5\) and \(t=(5-1)/2=2\). Then
\[
\frac{6!}{2!\,3^2\,(2!\,2!\,1!)}=\frac{720}{2\cdot9\cdot4}=10.
\]
Thus \(T(5)=10\cdot2!\cdot2!\cdot1!=40\equiv1\pmod3\). The carry chain is \((5)\to(3)\to(1)\), two signs, giving \(T(5)\equiv1\pmod3\). Also
\[
C_8^{(3)}=\frac{\binom{24}{8}}{17}=\frac{735471}{17}=43263,
\qquad43263/9=4807,
\]
and \(4807=3\cdot1602+1\). The displayed value and residue are correct. The exact count independently agrees with \(N_{\min}=10\).

**Example 7.4.** \(m=(4-1)4+1=13=1101_2\), \(s_2(m)=3\), \(t=2\), atoms \(K_0,K_2,K_3\). At a two-node binary skeleton, the depths are \(2,2,1\). Therefore the depth \(1\) leaf must be \(K_3\), because \(1+3\equiv0\pmod2\), while \(K_0,K_2\) must occupy depth \(2\), because \(2+0\equiv2+2\equiv0\pmod2\). There is exactly one minimal class. Its class-0 count is two and class-1 count is one, giving
\[
(2,1)\to(0,2)\to(1,0).
\]
Finally \(C_4^{(4)}=\binom{16}{4}/13=1820/13=140=2^2\cdot35\), and \(35\equiv1\pmod2\). I also independently enumerated the broader case: there are six classes, with exactly one minimal class, so the statement “There is one minimal class” does not confuse it with the total number of classes.

## What you did not check

* I did not read the existing reviews in `paper/reviews/`, as required.
* I did not perform a formal/computer-assisted proof verification. The “checked” verdicts mean mathematical rereading plus the hand and scripted enumerations described above, not human sign-off.
* I did not run LaTeX or check compilation, diagrams, TikZ layout, line references, or bibliography metadata against the references ledger. The oddly printed control sequence in the symmetric-root sentence of Proposition 3.2 (`Lemma~ef`) may be a rendering/display artifact in the source as read; it is mathematical content only insofar as the intended citations are Lemmas 2.4 and 3.1.
* I did not independently derive the standard Fuss–Catalan tree-count formula used only in Corollary 7.1, nor verify Konvalinka's actual paper or any claim about the novelty of the argument. I did check that no step of the main proof depends on the corollary.
* The short enumeration scripts used to cross-check hand work were run in memory and are not reproducible artifacts in `experiments/`. The explicit class-size and leaf-depth bookkeeping for the six requested cases is included above.
* I did not exhaustively enumerate arbitrarily large tree families or test all carry vectors. The largest supplied Fuss–Catalan value was checked arithmetically, while existing computational output was used only as secondary corroboration, not as proof.
