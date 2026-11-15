# Referee report on `report/report.tex` (mathematics: correctness and clarity)

Written by Claude Fable 5.2 (AI; a fresh-context referee, brief `briefs/W052_report_review_referee.md`), 2026-11-15. Not human-reviewed. I did not see the orchestrator's reasoning, and I did not read `report/reviews/PANEL.md`. I read the ledgers and `report/NOTES.md` only after forming my view of each section.

**Version reviewed.** `report.tex` changed while I was reading: commits `adb1d59`, `05ee4ef`, `b0f095f` added the item C28 (weights) to Section 4.5 and two table rows. I re-read everything those commits changed. **All line numbers below are those of `report.tex` at commit `b0f095f` (4010 lines).** Statement numbers are the printed ones (Lemma 3.8 = `main:lem:depth-invariant`, and so on).

## Verdict

1. **The main theorem is proved by the text of Section 3.** I followed every lemma line by line and found no false statement and no step that needs a new idea. What is proved is the valuation and the residue of the *number of q-ary trees*; that this number is `binom(qn,n)/((q-1)n+1)` is cited as standard (line 630; it is proved in Lean, not in the text).
2. **One sentence of the report is false** (Section 2.2, line 383: the leaf depths in the example for q = 4), and **three passages are out of date and contradict other parts of the report** (Section 7.3 line 1647; Section 8.3 lines 1866–1869; Section 4.5 lines 1265–1268). No theorem, lemma or numerical value of a theorem is wrong.
3. **Section 4.5: the three new statements are true** (I tested the level-profile statement on 2,354,228 profiles and the weighted one with random weights), **but both corollaries skip one step** (that rotations keep the depths of the *internal* nodes; Lemma 3.8 is about leaves only), and "closed under rotation" is not defined for q = p^k, where it does not mean cyclic shifts of the q children.
4. **Appendices A, B, C:** I found no error (which proofs I read in full is listed at the end).
5. **Clarity:** the four merged write-ups use `N`, `c`, `m`, `π`, `d`, "class" and "skeleton" in different senses without saying so; the places are listed below with replacement text. None of these affects correctness.

## Findings, most serious first

Replacement texts (LaTeX, ready to paste) are in the next section under the same number.

| # | Severity | Place | What is wrong |
|---|---|---|---|
| 1 | WRONG | §2.2, line 383 | "binary trees with m = 10 leaves, all at depth 2 or 4" is false. Of the 22 blocked trees, 6 have leaves at depths 2 and 4 only; the other 16 (the 4-ary chains root, child, grandchild) have leaves at depths 2, 4 and 6. The numbers 22 = 2 + 4 + 16, t = 1 and "one class of size 2" are right. |
| 2 | WRONG (out of date) | §7.3, lines 1646–1648 | The row says the congruence with the number of minimal classes "is formal only for the family of all trees with m leaves". The row at lines 1691–1696 and the status table (line 558) say it is formal for every closed family (`PTree.card_closed_modEq_classes`; I confirmed the declaration in `lean/MMM/Closed.lean`). The two rows contradict each other. |
| 3 | WRONG (out of date) | §8.3, lines 1866–1869 | "Next steps" lists as still to do: the move of the Lean project to the required versions (done, lines 96–107), the exactness half of the lattice-path proof in Lean (done, lines 112–119), and written proofs of the level-profile statement and of the congruence for closed families (given in Section 4.5). |
| 4 | WRONG (out of date) | §4.5, lines 1265–1268 | "The first three items below are proved … and *both* statements are checked by Lean" (there are three). "The remaining items are conjectures": C27 (lines 1318–1320) is not a conjecture, it is checked by Lean and has no written proof. |
| 5 | GAP | §4.5, lines 1284–1287 (proof of the corollary on level profiles) | "In the blocked form a rotation does not change the depth of any node" is used without proof. Lemma 3.8 says only that rotation equivalence preserves the multiset of *leaf* depths; with `~` defined as a smallest equivalence relation, the statement for internal nodes needs the same minimality argument (or a deduction from the leaf depths). Also not said: that the internal nodes of the q-ary tree at depth i are the internal nodes of the blocked tree at depth ik, so that the family is a set of k-blocked p-ary trees to which the proposition applies; and what happens when some n_i = 0 < n_{i+1} (no tree, product 0). The statement is true. |
| 6 | GAP (small) | §4.5, lines 1295–1305 (corollary on weights, C28) | Same missing step: "depends only on the level profile, which rotations do not change" rests on the unproved sentence of finding 5. In the statement, `m` and `t` are not tied together (t must be (s_p(m) − 1)/(p − 1) for the m of the family; for the first sentence m need not be ≡ 1 mod q − 1), and "depth(v)" in the display is the depth in the q-ary tree, not in the blocked tree. |
| 7 | UNCLEAR | §4.5, lines 1270–1278 | "Closed under rotation" is not defined, and the last sentence ("for q = p^k the trees are taken in their blocked form, where rotations keep the blocked trees") does not say what a rotation-invariant statistic of q-ary trees is. A reader will take it to mean cyclic shifts of the q children of a node. For k ≥ 2 that is a different group: the group of the proof at a q-ary node is the iterated wreath product of order p^((q−1)/(p−1)) and does not contain the cyclic shift (1 2 … q) (for q = 4 it is generated by (12), (34), (13)(24)). Section 5, item 4 says this about mobiles; Section 4.5 should say it where the proposition is stated. Also: the proposition should state t = (s_p(m) − 1)/(p − 1) and allow F empty. |
| 8 | UNCLEAR (abstract against body) | Abstract, line 150 | "a formalization in Lean 4 of the main proof and of the algebraic proof" omits the lattice-path proof, which the body says is formalized in full (lines 112–119, 516–519; "three proofs checked by Lean", line 1832). |
| 9 | UNCLEAR | §2.3 lines 571–575; §4.5 lines 1312–1314 (C9) | The conjecture is never stated. "Konvalinka's Theorem 5 holds with the rotation group in place of the full symmetric group" is not a statement: Theorem 5 is a congruence between numbers (line 203) and contains no group. What was computed (according to `experiments/E002_extensions/README.md`) is about the orbit sums in the *proof* of that theorem. The new sentence at lines 1306–1308 (Konvalinka's weight is changed by rotations) makes this harder to follow: the reader is told in one item that rotations change the weight and in the next that the rotation group "should" suffice. |
| 10 | UNCLEAR | §4.1 line 1137 against §4.3 line 1183 and §4.4 line 1214; status table rows C24 (512–522) against C13, C20 (532, 541) | `N` is n + m (length of the word) in the lattice-path proof and (m − 1)/(p − 1) (number of internal nodes) in the accounting proof and the carry budget, inside one section and one table. Appendix C writes N(m); Sections 4.3, 4.4 and the table write N. |
| 11 | UNCLEAR | Lemma 3.13, line 776, against Lemma A.9, lines 2692 and 2705 | In the main proof `c_j` is the carry *out of* column j (c_{−1} = 0); in Appendix A `c_i` is the carry *into* digit i (c_0 = 0). So c_{j+1} of the appendix is c_j of the main proof. The same letter is also the depth class c ∈ Z_k (Section 3.5), the number of carries (Appendix A, Section 1.2), c(v) (Section 4.4), a coefficient (Appendix B) and a p-cycle (Lemma C.5). |
| 12 | UNCLEAR | §3.5, from line 896 | "Class" has two senses in the same paragraphs: the depth class c ∈ Z_k of a label ("label of class c", "class-c leaf") and the equivalence class of a tree ("the class of the collapsed tree … depend only on the class of the fixed tree", line 953). Section 2.1, Step 4 says "depth class"; Section 3 does not. |
| 13 | UNCLEAR | §1.2, line 223 | In the congruence for binom(N,n)/p^c the digits `m_i` are used but `m` is not defined there (it is N − n); everywhere else in Sections 1 and 2 `m` is the number of leaves and `m_j` its digits. `c` is also not said to be the number of carries of the previous sentence. |
| 14 | UNCLEAR | §4.3 line 1195 against §2.3 line 596 and §5 line 1454 | `π` is a root of z^(p−1) + p = 0 in Section 4.3 and ζ_p − 1 in the row C21 and in Section 5, item 12. These are different numbers. |
| 15 | UNCLEAR | §1.2, lines 212–213 | `d` denotes Deutsch and Sagan's exponent s_2(n+1) − 1, which is the report's `t`; from Section 2 on, `d` is the number of asymmetric nodes of a tree. |
| 16 | UNCLEAR | Appendix A, line 3201 | The comparison table uses the symbol S(m,k) (a calligraphic S between bars, for the number of its elements), which is defined nowhere in the report. It is the number N_min of Section 3. |
| 17 | UNCLEAR | §4.5, lines 1290–1291 | "(the Lean proof refers to no declaration of Mathlib about factorials or valuations at all, Section 7)": Section 7 does not say this. The evidence is a search by name in `lean/MMM/AxiomsExtra.lean` (line 57 of that file); the claim should be stated as what that search shows. |
| 18 | UNCLEAR | §2.1, lines 331–333 against Definition 3.16, lines 842–849 | "Skeleton" is the expanded tree in Step 3 ("the classes with d = t are the skeletons: trees with t asymmetric nodes whose leaves are replaced by complete trees") and the contracted cyclic tree whose leaves bear atoms in Section 3. |
| 19 | UNCLEAR | §5 item 1, lines 1341–1344 | `n` is the number of leaves and `s` the number of symmetric nodes; in the rest of the report these are m, and s = s_p(m) (the number of symmetric nodes is σ in Section 4.4). Item 2, line 1361 ("explicit groups for p = 2, n ≤ 9") does not say whether n counts leaves or nodes. |
| 20 | UNCLEAR (minor) | Proof of Proposition 3.23, lines 936–951; proof of Lemma 3.4, lines 674–676; Appendix B, line 3722 | Letters reused inside one proof: `ℓ_1,…,ℓ_p` are labels (ℓ(T) is the number of leaves); `r` is first a depth, then a rotation; `a` is a scalar in f(u) = a + bu next to the vector **a**. In the proof of Lemma 3.4 "original tree" and "original leaf" mean the q-ary tree in the first paragraph and the blocked p-ary tree in the second. In Appendix B `δ` is the index in Z/k and, in the remark on δ-rings, the p-derivation. |
| 21 | UNCLEAR (minor) | §2.3 line 592–593, §4.5 line 1310; §6 line 1520 | The computation quoted for C28 has no row in Section 6 and, according to `CLAIMS.md`, its script is not in the repository. "E017" names two folders (`E017_newfields_checks`, `E017_path_slot_count`). |
| 22 | TYPO | §3.5, lines 938 and 956 | `e_c` (unit vector) is used in Proposition 3.23 and Lemma 3.24 and defined only in Appendix B (line 3480). |
| 23 | TYPO | Lemma 3.13, line 767; lines 169 and 631 | s_p is defined for positive integers; the lemma allows a_i = 0. Say s_p(0) = 0 (Appendix B does). |
| 24 | TYPO | §2.3 line 519; §6 lines 1521–1522; Appendix A line 3212 | "all 0 ≤ n ≤ N ≤ 16, p in {2,3,5} (456 cases)": that range has 459 cases. The script (`check_paths.py`, `for N in range(1, 17)`) starts at N = 1, which gives 456. |
| 25 | TYPO | §1.1, lines 186–187 | The statement of the known theorem omits k ≥ 1 and n ≥ 1 (given in Section 2.1 and in Theorem 3.1). |
| 26 | TYPO | §4.5, lines 1275, 1287, 1305 | The end-of-proof box is followed on the same line by running commentary ("□ So every statistic…", "□ With all b_i = 1…"); in the PDF (page 30) the box sits in the middle of a paragraph. |

## Replacement texts

**1** (line 382–384; replace the sentence):

```latex
\emph{A prime power.} For $q=4$, $p=2$, $k=2$, $n=3$: the $4$-ary trees with $3$ nodes become binary trees with
$m=10$ leaves, all at even depths (depths $2$ and $4$ for six of them, depths $2$, $4$ and $6$ for the other
sixteen). There are $22$ of them, in classes of sizes $2$, $4$ and $16$
($22=2+4+16$); $m=10=1010_2$, $t=1$, and there is one class of size $2$.
```

**2** (lines 1647–1648; replace the third cell of the row):

```latex
 & In these three declarations the congruence with the number of minimal \emph{classes} is stated only for the
 family of all trees with $m$ leaves; for an arbitrary closed family they give the divisibility and the
 congruence with the number of minimal \emph{trees}. The congruence with the number of minimal classes for an
 arbitrary closed family is \lean{PTree.card_closed_modEq_classes} (listed below, with C11).\\\addlinespace[3pt]
```

**3** (lines 1866–1869; replace the first three sentences of Section 8.3, keep the rest):

```latex
A human reading of the algebraic proof and of the definitions and final statements in Lean. A human reading of
the three statements of Section~\ref{sec:extensions} (closed families, level profiles, invariant weights),
whose written proofs and Lean proofs date from the last night. A precise statement of the weighted claim C9
for the rotation group, and then a proof or a refutation of it.
```

**4** (lines 1265–1268):

```latex
The problem statement suggests weighted numbers and other statistics. The first three items below are proved:
the proofs are a few lines from Steps~1 and~2, and all three statements are checked by Lean
(Section~\ref{sec:lean}). They were written on the last night of the event, and no human has read them. Of the
remaining items, C9 and C17 are conjectures supported by the computations listed in
Section~\ref{sec:computations}, and C27 is checked by Lean but has no written proof here.
```

**5** (lines 1284–1287; replace the proof of the corollary):

```latex
 \emph{Proof.} The product is the number of $q$-ary trees that have exactly $n_i$ internal nodes at depth $i$
 for every $i\le L$ (and so none at depth $\ge L$): the $n_i$ nodes at depth $i$ have $q\,n_i$ children, and
 $n_{i+1}$ of these are chosen to be internal nodes; if some $n_i=0<n_{i+1}$ there is no such tree and the
 product is $0$. In the blocked form (Lemma~\ref{main:lem:blocked}) the internal nodes of the $q$-ary tree at
 depth $i$ are the internal nodes of the $p$-ary tree at depth $ik$. So the family becomes the set $F$ of
 $k$-blocked $p$-ary trees with $(q-1)n+1$ leaves and with exactly $n_i$ internal nodes at depth $ik$ for
 every $i\le L$. Rotation-equivalent trees have the same multiset of depths of internal nodes; the proof is
 that of Lemma~\ref{main:lem:depth-invariant}: ``same multiset of depths of internal nodes'' is an
 equivalence relation, and it satisfies (R1) and (R2) because the depths of the internal nodes of
 $(U_1,\dots,U_p)$ are $0$ and those of the $U_i$, each increased by $1$. Together with
 Lemma~\ref{main:lem:depth-invariant} this shows that $F$ is closed under rotation, and the proposition
 applies. \qed
```

**6** (lines 1295–1305; statement and proof of the corollary on weights):

```latex
\item \emph{Weights that rotations do not change} (C28). \textbf{Corollary.} \emph{Let $m\equiv1\pmod{p-1}$,
 $t=(s_p(m)-1)/(p-1)$, let $F$ be a set of $p$-ary trees with $m$ leaves that is closed under rotation, and
 let $w$ be an integer-valued function on $F$ with $w(S)=w(T)$ whenever $S\sim T$. Then $p^t$ divides
 $\sum_{T\in F}w(T)$. In particular, for $q=p^k$, $n\ge1$ and arbitrary integers $b_0,b_1,\dots$,}
 \[
  p^t\ \Big|\ \sum_{T}\ \prod_{v}b_{\operatorname{depth}(v)},\qquad t=\frac{s_p((q-1)n+1)-1}{p-1},
 \]
 \emph{the sum over the $q$-ary trees $T$ with $n$ internal nodes, the product over the internal nodes $v$
 of $T$, and $\operatorname{depth}(v)$ the depth of $v$ in the $q$-ary tree.} \emph{Proof.} $F$ is a union of
 rotation classes; the sum of $w$ over a class of $p^d$ trees is $p^d$ times the value of $w$ on the class,
 and $d\ge t$. For the second statement take for $F$ all $k$-blocked $p$-ary trees with $m=(q-1)n+1$ leaves
 (closed under rotation by Lemma~\ref{main:lem:depth-invariant}); the weight is
 $\prod_ib_i^{\,n_i}$, where $n_i$ is the number of internal nodes of the blocked tree at depth $ik$, and
 rotations do not change the $n_i$ (proof of the previous corollary). \qed
```

**7** (lines 1270–1278; the proposition on closed families and the sentences after it):

```latex
\item \emph{Closed families} (C11). A set $F$ of $p$-ary trees is \emph{closed under rotation} if $T\in F$
 and $T'\sim T$ imply $T'\in F$, with $\sim$ as in Section~\ref{sec:mainproof}. \textbf{Proposition.}
 \emph{Let $m\equiv1\pmod{p-1}$ and $t=(s_p(m)-1)/(p-1)$, and let $F$ be a set of $p$-ary trees with $m$
 leaves that is closed under rotation ($F$ may be empty). Then $p^t$ divides $|F|$, and
 $|F|\equiv p^t\cdot\#\{\text{rotation classes in }F\text{ with }d=t\}\pmod{p^{t+1}}$.}
 \emph{Proof.} $F$ is a union of rotation classes. A class has $p^{d}$ members
 (Lemma~\ref{main:lem:class-size}) and $d\ge t$ (Proposition~\ref{main:prop:lower-bound}). The classes with
 $d>t$ contribute multiples of $p^{t+1}$, and each class with $d=t$ contributes $p^t$. \qed

 So every statistic of $p$-ary trees that rotations do not change refines the divisibility of the theorem:
 the number of trees with $m$ leaves and a prescribed value of the statistic is divisible by $p^t$. For
 $q=p^k$ with $k\ge2$ the statement is about the blocked form: a set of $q$-ary trees is closed if the set of
 the corresponding $k$-blocked $p$-ary trees is closed (rotations map $k$-blocked trees to $k$-blocked trees,
 Lemma~\ref{main:lem:depth-invariant}). In terms of the $q$-ary tree, the $q$ children of a node may be
 permuted by the group generated by the rotations at the $k$ levels of its block, a group of order
 $p^{(q-1)/(p-1)}$ (the remark after the definition of $\sim$). This is not the group of cyclic shifts of the
 $q$ children: for $q=4$ it is generated by $(12)$, $(34)$ and $(13)(24)$ and does not contain $(1234)$. A
 statistic that is invariant only under cyclic shifts of the $q$ children is not covered.
```

**8** (line 150):

```latex
labelled trees); the computations; a formalization in Lean~4 of the main proof, of the lattice-path proof and
of the algebraic proof; and,
```

**9** (lines 571–572 and 1312–1314). I can give the wording only as far as the repository's own description of the experiment goes (`experiments/E002_extensions/README.md`, lines 12 and 25); it must be checked against the reading notes on Konvalinka's paper before it is used:

```latex
\item \emph{Weighted Fuss--Catalan numbers} (C9). \emph{Conjecture:} the statements about sums of weights
 over orbits on which the proof of \cite[Theorem~5]{Konvalinka} rests (integrality of the mean of the weight
 over an orbit, and the recurrence at the root) hold for the orbits of the rotation group as well. The reason
 to expect this is that the proof appears to use only that the group is transitive on the $q$ branches of a
 node, and the rotation group is. If so, that proof would no longer need a valuation of a factorial. This is
 a statement about orbit sums of a weight that rotations do change; it is not the corollary above. Supported
 numerically (Section~\ref{sec:computations}); not proved.
```

and in the status table: `\textbf{C9. Weighted numbers:} the orbit-sum statements in the proof of Konvalinka's Theorem~5 hold for the rotation group in place of the full symmetric group.`

**10** (line 1183, and the same change of `N` to `N(m)` in lines 1185, 1190, 1214, 1238, 1246, 532–533 and 541):

```latex
\emph{What it is.} Label all $m$ leaves. A $p$-ary tree with $m$ leaves has $N(m)=(m-1)/(p-1)$ internal nodes
(this is not the $N=n+m$ of the lattice-path proof);
```

**11 and 12** (two marked additions, since the sources are reproduced unchanged). After the sentence that ends "and $c$ is the number of carries." (in line 2706):

```latex
\assembler{in Lemma~\ref{main:lem:digit} of the main proof $c_j$ is the carry \emph{out of} column $j$; that is
$c_{j+1}$ in the notation used here. In Section~\ref{sec:mainproof} the letter $c$ also denotes a depth class
in $\Z_k$.}
```

After the sentence ending "…apart from their class." (line 896):

```latex
\assembler{from here on ``class'' has two senses: the \emph{depth class} $c\in\Z_k$ of a label or of a leaf
(``label of class $c$'', ``class-$c$ leaf''), and the equivalence class of a tree; and $e_c$ denotes the
vector with $1$ in position $c$ and $0$ elsewhere.}
```

(The second addition also settles finding 22.)

**13** (lines 222–225):

```latex
$\binom Nn$ is the number $c$ of carries when $n$ and $N-n$ are added in base $p$. The congruence
$\binom Nn/p^c\equiv(-1)^c\prod_iN_i!/(n_i!\,r_i!)\pmod p$ for the quotient, where $N_i$, $n_i$, $r_i$ are the
base-$p$ digits of $N$, $n$ and $r=N-n$, which according to the introduction
```

**14** (lines 1195–1196):

```latex
Appendix~\ref{app:acc}). With $\varpi$ a root of $z^{p-1}+p=0$ (the constant of Dwork's
exponential, see \cite{Kochubei}; not the $\pi=\zeta_p-1$ of Section~\ref{sec:connections}),
Lemma~\ref{acc:L1} reads $C_n^{(q)}=(\varpi^{m-1}/m!)\cdot u$ with $u$ an
```

**15** (lines 212–213; same content, the letter changed):

```latex
trees: the size of every orbit is divisible by $2^{t}$, $t=s_2(n+1)-1$, and the number of orbits whose size is
not divisible by $2^{t+1}$ is odd, $(2t-1)(2t-3)\cdots1$. Postnikov and Sagan \cite{PostnikovSagan} treat
weighted Catalan numbers. Gao and Gu
```

**16** (line 3201): replace `$|\mathcal S(m,k)|$` by `$N_{\min}$ (Section~\ref{sec:mainproof})`.

**17** (lines 1290–1291):

```latex
 valuation of a factorial (according to a listing produced by Lean in the file
 \file{lean/MMM/AxiomsExtra.lean}, the formal proof refers to no declaration of Mathlib whose name contains
 \texttt{factorial}, \texttt{multiplicity}, \texttt{padicVal}, \texttt{factorization}, \texttt{legendre},
 \texttt{kummer}, \texttt{lucas} or \texttt{wilson}). It was computed beforehand for every profile in the ranges of
```

(I did not run Lean; the list of names is copied from line 57 of that file.)

**18** (lines 331–333):

```latex
\item[Step 3] (Propositions~\ref{main:prop:minimal-local} and~\ref{main:prop:skeleton}). The classes with $d=t$
 come from \emph{skeletons}: a skeleton is a $p$-ary tree with $t$ nodes, taken up to rotation, whose leaves
 carry complete trees (``atoms''), exactly $m_j$ of them of height $j$, an atom of height $j$ hanging at a
 depth $\equiv-j\pmod k$. Replacing every leaf by its atom gives a tree with $d=t$, and every class with $d=t$
 arises from exactly one skeleton.
```

**19** (line 1341–1342): write "with $m$ leaves and $\sigma$ ``symmetry nodes'' … has $m!/2^{\sigma}$ labellings by $m$ species", "its minimum over trees with $m$ leaves is $s_2(m)-1$ … $(2s_2(m)-3)!!$", and "$m_v$" for "$n_v$" (as in Section 4.4), keeping Steel's formula "in its notation".

**23** (line 767): `For integers $a,a_1,\ldots,a_r\ge0$ (with $s_p(0)=0$),`

**24** (line 3212, and likewise lines 519 and 1521): `for all $1\le N\le16$, $0\le n\le N$ and $p=2,3,5$ ($456$ cases)`.

**25** (line 187): `\emph{If $p$ is prime, $k\ge1$, $q=p^k$, $n\ge1$ and $m=(q-1)n+1$, then $v_p(C_n^{(q)})=(s_p(m)-1)/(p-1)$.}`

**26**: replace `\qed\ ` by `\qed\par` at lines 1275, 1287 and 1305 (replacements 5 to 7 already do this).

No replacement is offered for 20 and 21 (renaming letters inside the approved proof is the team's decision; for 21 add a row to Section 6 or the words "a scratch program, not kept in the repository").

## What I tried to break and could not

- **Section 3, each lemma.** Normal form (the relation R is an equivalence relation with (R1), (R2); minimality used in the right direction); class size (disjointness of the p product sets in the asymmetric case); the lower bound and the local characterization (the symmetric case, p·t(b) ≤ t(b) forces t(b) = 0); Proposition 3.19 (contraction and expansion are inverse on plane trees; every skeleton node is asymmetric after expansion because b_j < p); the free action in Proposition 3.21 (orders of φ and h agree; Lemma 3.20 (ii)); the moving-leaf lemma for p = 2 and for p odd; the count of p − 1 cyclic orders in Proposition 3.23; termination at e_0 including q = 2 (Proposition 3.25); the zero vector in Lemma 3.24; Corollary 3.27.
- **The depth condition for k ≥ 2**: classes c + 1 wrapping around from k − 1 to 0, labels of one depth class with different heights, and the claim of Section 2.2 that T(a) = 0 unless Σ a_c p^c ≡ 1 (mod q − 1) (stated without proof in the report; true in all 104 vectors I enumerated).
- **Section 4.5**: the empty family (0 ≡ 0); profiles with a zero in the middle (product 0); n_0 = 1 is needed (with n_0 = 2 or 3 the divisibility fails, for example n = (2,0,0), q = 2: product 1, t = 1); n_L = 0 only makes the last factor 1; q not a prime power (fails, as it should: the statement is not made for it); a weight that is not rotation-invariant (fails already for binary trees with 2 nodes).
- **Section 4.4**: Facts 1 to 3 on every tree, including the remark that they hold for composite arity.
- **Appendix A**: the equality cases of Lemma A.11 and Proposition A.12, the slot count of Proposition A.16 (injectivity of "choices → word", and that a slot chosen as mixed is mixed), both examples.
- **Appendix B**: the weight inequalities, Lemma B.8 (ii) (constant tuples are never carry-free), Lemma B.11 (iv) for p = 2, the iteration EH ≡ Π^r·EH in Proposition B.12.
- **Appendix C**: the stabilizer order in Lemma C.4 and both congruences in Lemma C.5.

## What I checked numerically, and how

Four programs of my own, written from the definitions in the report, sharing no code with the project (run with `uv run python`; kept outside the repository in
`C:\Users\semyo\AppData\Local\Temp\claude\5f2d4d8d00e2c2d1\70dc9b11-3c1f-4588-b314-f2bd5410f768\scratchpad\ref\check1.py`, `…\ref\check2.py`, `…\ref\check3.py`, `…\ref\check4.py` in the same folder; the scratchpad may be cleared). Trees are nested tuples; a rotation class is found by a canonical form (the least rotation of the canonical forms of the children); d is counted from the definition.

- **Section 1.1**: the table of Catalan numbers, binary expansions and valuations for n = 1,…,8. Correct.
- **Section 2.2, every number**: classes and class sizes for binary trees with 4, 5, 6, 7, 8 leaves (5 = 1+4; 14 = 2+4+8; 132 = 3·4+3·8+4·16+32, 11 classes; 429 = 1+4+56+112+192+64 by d = 0,2,3,4,5,6); the d of each tree named in the text; ternary trees with 4 nodes (1, 9, 9, 9, 27); q = 4, n = 3 (22 = 2+4+16; **leaf depths {2,4} for 6 trees and {2,4,6} for 16**, finding 1); the five rows of the table of values; T(5) = 40 with 36 moved and 4 fixed by a 3-cycle, T(3) = 2; T(3,2) = 4, T(0,3) = 2, T(1,0) = 1 for p = 3, k = 2. All correct except finding 1.
- **Main theorem and "Dwork form"**: v_p, the residue in the compact form, for 1920 pairs (q, n) with p ≤ 13, k ≤ 4, n < 80; C·m! ≡ (−p)^N mod p^(N+1) in the 1123 of these with m ≤ 2500.
- **Steps of the main proof**: class size p^d and d ≥ t on all enumerated classes; the carry congruence T(a) ≡ −T(a′), T(a) ≡ ±1 and the converse on 104 vectors a (p = 2, k = 1,2,3; p = 3, k = 1,2; up to 7 labels), by listing labelled cyclic trees; N_min = 3, 10, 1 in the three worked examples; Corollary 3.27 for p = 2 (m ≤ 11), p = 3 (m ≤ 15), p = 5 (m ≤ 21).
- **Section 4.2**: the polynomials y + y² + y³ and y + 2y² + 2y³ + y⁴. **Appendix B**: the system of Lemma B.3 solved by iteration; the coefficient of x^m y^d in F_0 equals the number of classes of k-blocked trees with m leaves and d asymmetric nodes, and F_0(x,p) = G, for (p,k) = (2,1), (3,1), (5,1), (2,2) up to x-degree 10 to 13.
- **Section 4.4**: Facts 1, 2, 3 on 36,323 trees (p = 2, 3, 5 and arities 4 and 6); the two numerical examples.
- **Section 4.5, level profiles**: p^t divides the product for all 2,354,228 profiles without interior zero with n ≤ 26 (q = 2), 17 (3), 15 (4), 14 (5), 12 (7, 8, 9), 10 (16), 9 (25, 27), 8 (32, 49); the sums over profiles equal the Fuss–Catalan numbers. By enumeration of blocked trees (153 profile families; p = 2 up to 10 leaves, p = 3 up to 13, q = 4 up to 13, q = 8 up to 15): the number of trees with a profile is the product; each rotation class lies in one family; the congruence of the proposition modulo p^(t+1) holds. **Weights (C28)**: 415 cases with random integer weights in [−50, 50], q in {2,3,4,5,8,9,16,27}.
- **Appendix A**: class sizes in Example A (one of 3, one of 9, four of 27) and Example B (four of 9, two of 27, one of 81); Theorem A.17 and the carries of Lemma A.9 for all 0 ≤ n ≤ N ≤ 16, p = 2, 3, 5; the number of minimal words against Proposition A.16 for N ≤ 12.
- **Appendix C**: m! = p^ν ∏ m_j! · |F(m)| with |F(m)| ≡ (−1)^ν for p ≤ 7, m < 400.
- **Section 5** (numbers only): 55 = 1+9+18+27 under all permutations; class size × 3^(symmetric nodes) = 81; 12 = 3+9; 33/16; the Yule probabilities 2^d/∏(n_v − 1) sum to 1 for 2 to 10 leaves.

## What I read, and what I did not

**Read in full:** the abstract; Sections 1, 2, 3 (line by line), 4 (4.5 twice, the second time after the report changed); Section 7 (for consistency; in `lean/MMM/` I opened only `Closed.lean`, `Profile.lean`, `ReductionB.lean` and the head of `Weighted.lean`, to compare statements; nothing was compiled); Sections 5, 6, 8, 9 once, for numbers and consistency.

**Appendices.** A: all statements and all proofs (Lemma A.2 to Theorem A.17, Section A.7, both examples). B: all statements; the proofs of Lemmas B.2, B.3, B.5, B.8, B.10, B.11, Propositions B.12, B.13 and of the theorem in full; the remarks at the end once. C: all statements and all proofs.

**Not read or not checked:**
- No paper of the reference list was opened; statements about what a paper contains (Section 1.2, 1.4, the remarks in the appendices, Section 5) are not checked, and the bibliographic data are not checked.
- The TikZ code of the pictures; of the PDF I looked only at pages 30 and 31.
- The Lean sources other than the four files named; whether each declaration named in Section 7 exists and says what the table says.
- The experiments of Section 6 were not rerun and their ranges are not checked, except the count 456 (finding 24).
- The statements about other fields in Section 5 beyond their numbers.
- `report/reviews/PANEL.md`, the slides, `JOURNAL.md`, `STATE.md`.
