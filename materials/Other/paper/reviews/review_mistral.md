# Adversarial review of `paper/main.tex` (reviewer: mistral)

Written by `mistralai/mistral-large-4-0` (Open Math OS worker, delegation `20261113-223908_W006_review_mistral`), 2026-11-13, per the brief in `logs/delegations/20261113-223908_W006_review_mistral/brief.md`.
I read `paper/main.tex` in full line by line, plus `notes/briefing_grad_student/briefing.tex` and `experiments/E000_first_sanity_check/output.txt`. I did not read anything in `paper/reviews/`.

## Summary verdict

**Yes modulo the listed gaps.** Theorem 1 (`thm:main`) is proved correctly in substance: I re-did the asymmetric/symmetric lower-bound arithmetic, the class-size induction, the digit lemma for r summands, the fixed-point count (p-1 cyclic label orders), the wrap-around carry at c = k-1, the terminal-vector analysis, and the mod-(q-1) invariant, and all of them check out. No proof of the main theorem uses Legendre's formula, Kummer's theorem, or any factorial/binomial/multinomial valuation; the only use of the Fuss-Catalan formula is in Corollary 3 (`cor:exact-count`), which is explicitly marked as separate and is not used to prove Theorem 1, so there is no circularity. All worked examples recompute correctly and agree with E000.

However, there is **one mis-stated lemma** (Lemma 2, Normal form: the displayed equivalence is false as literally written; its proof actually proves the correct statement, and all downstream uses rely on the correct version) and **one real proof gap** (Proposition 4, freeness of the labelling action: the written argument does not establish that the witnessing automorphism fixes every leaf; the claim is true but needs the p-group order argument). Plus three small expository gaps listed below. None of these change the truth of the theorem; each is a one-paragraph fix.

## Table of verdicts

| Item (paper location) | Verdict |
|---|---|
| Def. p-ary tree, K_h, eq. (1) leaves | CORRECT |
| Lemma 1 (Blocked form) | CORRECT |
| Def. of rot and ~ (well-definedness) | CORRECT |
| Lemma 2 (Normal form) | **WRONG as stated** (statement typo; proof proves the correct version) — Finding F1 |
| Lemma 3 (depth invariant) | CORRECT |
| d constant on classes (prose after Def. of asymmetric) | CORRECT (informal, no proof environment — F5) |
| eq. (2) recursion for d | CORRECT |
| eq. (3) \|X\| ≡ \|Fix\| mod p | CORRECT |
| Lemma 4 (tuple rotation, primality of p) | CORRECT |
| Lemma 5 (class size p^{d(T)}) | CORRECT, given corrected Lemma 2 |
| Lemma 6 (digit lemma, r summands, equality iff no carries) | CORRECT |
| Proposition 1 (lower bound, incl. symmetric/asymmetric arithmetic) | CORRECT |
| Proposition 2 (minimal local characterization) | CORRECT |
| Def. skeleton + Proposition 3 (minimal classes = skeleton trees) | CORRECT modulo expository gaps — F5 |
| Proposition 4 (removing labelling; freeness; ∏ m_j! prime to p) | **GAP in freeness proof** — F2; formula and coprimality CORRECT |
| Lemma 7 (moving-leaf lemma) | CORRECT |
| Proposition 5 (carry collapses a cherry; count p-1; class c+1; wrap-around) | CORRECT; minor gap: α^p=1 asserted — F3 |
| Lemma 8 (terminal vectors) | CORRECT |
| Proposition 6 (iterated carries; invariant mod q-1; q=2, q=3; r=t) | CORRECT; q=2 justification vacuous — F4 |
| Proof of Theorem 1 | CORRECT |
| Corollary 3 (exact count k=1; uses FC formula, marked separate) | CORRECT; not circular for Theorem 1 |
| Examples 1-3 (all numbers) | CORRECT (recomputed, see Hand computations) |

## Detailed findings (ordered by severity)

### F1 — Lemma 2 (Normal form), displayed statement is false as written. Severity: high (statement), low (impact).

Location: Lemma `lem:normal-form`, the displayed equivalence:
> "If $T=(T_1,\ldots,T_p)$ and $T'$ is not a leaf, then $T\sim T'$ if and only if $T'=(T_{1+r}',\ldots,T_{p+r}')$ for some $r\in\Z_p$, $T_i\sim T_i'\ (1\le i\le p)$."

As literally written, the first clause says $T'$ is a fixed point of $\rot_r$ (or is vacuous for $r=0$). Counterexample: $p=2$, $T=(\bullet,(\bullet,\bullet))$, $T'=\rot_1(T)=((\bullet,\bullet),\bullet)$. Then $T\sim T'$ by (R1), but for $r=0$ the clause $T_i\sim T_i'$ fails ($\bullet\not\sim(\bullet,\bullet)$), and for $r=1$ the clause $T'=(T_2',T_1')=(\bullet,(\bullet,\bullet))=T\ne T'$ fails. So the right-hand side is false while $T\sim T'$ holds.

The *proof* of the lemma, however, proves the correct statement, namely: $T\sim T'$ iff there exist $r\in\Z_p$ and $U_i\sim T_i$ with $T'=\rot_r(U_1,\ldots,U_p)$, equivalently $T_i'\sim T_{i+r}$ for all $i$ (the proof's transitivity step "addition of the two rotations" and its last sentence "(R2) followed by (R1)" only work with this reading). Every downstream use (Lemma 5, class size) uses the correct version: "a rotation $r$ and then a tuple $(U_1,\ldots,U_p)$ with $U_i\in B_{i+r}$".

Proposed fix: replace the displayed formula by
> $T\sim T'$ iff for some $r\in\Z_p$, $T_i'\sim T_{i+r}$ for all $1\le i\le p$ (indices mod $p$),

equivalently "$T'$ is obtained from $T$ by replacing each $T_i$ by an equivalent tree and then rotating once". No change needed anywhere else.

### F2 — Proposition 4 (Removing labelling), freeness of the $H=\prod_j S_{m_j}$ action: proof gap. Severity: high (the claim is true, the written proof is incomplete).

Location: `prop:free`, the sentence:
> "An automorphism witnessing the equality sends each leaf to a leaf with the same distinct label; since there is only one leaf with any given label, it fixes every leaf."

This is not justified as written. If $\sigma(T)=T$ as cyclic labelled trees, the witnessing automorphism $\varphi$ of the underlying cyclic tree satisfies $\lambda(\varphi(\ell))=\sigma(\lambda(\ell))$ on leaves $\ell$; it sends $\ell$ to the leaf labelled $\sigma(\lambda(\ell))$, which need not be $\ell$ itself. The conclusion "fixes every leaf" does not follow from distinctness of labels alone.

The claim is nevertheless true, and the fix is short: an automorphism of a cyclic $p$-ary tree is an element of the iterated wreath product of copies of $\Z_p$ (at each node only a cyclic rotation is allowed), hence has $p$-power order — prove this by induction on depth (root rotation in $\Z_p$, recursively on children). The induced permutation $\sigma$ of the labels is conjugate to the leaf action of $\varphi$, so $\sigma$ also has $p$-power order. But $\sigma\in H=\prod_j S_{m_j}$ and $|H|=\prod_j m_j!$ is prime to $p$ (each $m_j<p$), so $\sigma$ has order prime to $p$. Hence $\sigma=1$, the action is free, and every $H$-orbit has $|H|$ elements. (This is the argument used in the briefing, Step 4(a); the paper should carry it.) The rest of Proposition 4 — the surjection onto unlabelled skeletons, the orbit/counting formula $N_{\min}=T(\mathbf a)/\prod_j m_j!$, and the coprimality — is CORRECT.

### F3 — Proposition 5 (carry), "$\alpha^p=1$" asserted without proof. Severity: low (one-line fill).

Location: `prop:carry`, "It moves exactly the $p$ leaves bearing the chosen labels and satisfies $\alpha^p=1$." The first clause is proved (leaf $\ell$ moves iff $\sigma$ moves its label, by distinctness); the second is not. Fill: $\alpha^p$ fixes every leaf, since $\lambda(\alpha^p(\ell))=\sigma^p(\lambda(\ell))=\lambda(\ell)$ and labels are distinct; an automorphism of a cyclic tree that fixes every leaf fixes every node (at maximum depth all child pointers are fixed, then induct upward), so $\alpha^p=1$. Everything else in Proposition 5 — application of Lemma 7, the cherry collapse, the depth bookkeeping "old leaf at depth $r-1\equiv-(c+1)$, children at $r\equiv-c$", including the wrap-around $c=k-1$ (new class $0$, depth $r-1\equiv 0$, children $r\equiv 1\equiv -c$) — I checked and it is CORRECT. The count of fixed cyclic label orders is also CORRECT: writing the label at position $u$ as $\ell_{a+bu}$, the condition that rotation by $r\ne0$ applies $\sigma$ gives $br=1$; for each of the $p-1$ choices of $b\ne0$ there is exactly one $r$, and $a$ is removed by rotating positions; distinct $b$ give distinct cyclic orders because the $\ell_i$ are distinct. Hence $|\Fix|=(p-1)T(\mathbf a')$.

### F4 — Proposition 6 (termination), the $q=2$ justification is vacuous as written. Severity: low (conclusion correct).

Location: `prop:carry-termination`, "since the number of labels remains congruent to $1\pmod{p-1}$ and $p-1=1$". Modulo 1 every integer is congruent, so this says nothing. The actual reason the process ends at $a_0=1$: for $q=2$ ($p=2,k=1$) a carry sends $a_0\mapsto a_0-2+1=a_0-1$, and the process stops as soon as $a_0<2$; starting from $a_0=s_2(m)\ge1$ and decrementing by 1, it lands on $a_0=1$, i.e. $\mathbf b=e_0$. For $q=3$ ($p=3,k=1$, modulus $q-1=2$): terminal $a_0<3$, total labels $\equiv1\pmod2$ forces $a_0=1$; also covered by the general $q>2$ argument. The general argument ($q>2$): $W(\mathbf b)=\sum p^c b_c$ is invariant mod $q-1$ under carries (change is $0$ for $c<k-1$, $-(q-1)$ for $c=k-1$), $W\equiv m\equiv1\pmod{q-1}$ initially, $0<W\le q-1$ at the end, and $W=q-1$ would force all $b_c=p-1$ hence $\sum b_c=k(p-1)\equiv0\not\equiv1\pmod{p-1}$; so $W=1$ and $\mathbf b=e_0$. Each carry lowers $\sum b_c$ by $p-1$, so the number of carries is $(s_p(m)-1)/(p-1)=t$. All CORRECT.

### F5 — Expository gaps (no truth impact). Severity: low.

- The class-invariance of $d$ (prose after the definition of asymmetric, before eq. (2)) is argued correctly but sits outside any lemma/proof environment; make it a lemma.
- In Proposition 3 (skeleton), the well-definedness of contraction under $\sim$ ("equivalent minimal trees give equivalent cyclic skeletons") and the uniqueness of the atom multiplicities ("carry-free addition gives the union of the children's multiplicities", hence exactly $m_j$ atoms of height $j$) are sketched, not fully written; both follow from the normal-form lemma and uniqueness of base-$p$ expansion. The direction checks I was asked to attack all hold: the depth condition $r+j\equiv0\pmod k$ is correctly derived both ways; the bijection is with classes, not trees (cyclic quotient); equal atoms are handled as a multiset here and by distinct labelling in Proposition 4.
- Lemma 5's disjointness of the $p$ product sets in the asymmetric case ("Different such specifications give different ordered trees") is asserted; it follows because distinct rotations $r\ne s$ give distinct class words $(B_{i+r})\ne(B_{i+s})$ since $p$ is prime (Lemma 4), so $\rot_r(U)=\rot_s(V)$ would force $B_{i+r}=B_{i+s}$ for all $i$, contradiction.

## Hand computations

All six requested cases, done by hand (and cross-checked against `experiments/E000_first_sanity_check/output.txt`, whose brute force agrees in every row). $m=(q-1)n+1$, $C_n^{(q)}=\frac1m\binom{qn}{n}$, $t=(s_p(m)-1)/(p-1)$, predicted unit residue $(-1)^t/\prod_j m_j! \bmod p$.

1. **(p,k,n)=(2,1,3):** $q=2$, $m=4=100_2$, $s_2=1$, $t=0$. $C_3=\frac15\binom62=5$, $v_2=0=t$ ✓. Unit $5\equiv1$, prediction $1/0!=1$ ✓. Binary trees with 4 leaves: 5. Classes: $\{K_2\}$ (size $1$, $d=0$, minimal, $N_{\min}=1$) and one class of the other 4 trees (size $2^2=4$, $d=2$); $1+4=5$ ✓. E000: #orbits 2, N_min 1 ✓.
2. **(2,1,6):** $m=7=111_2$, $s_2=3$, $t=2$. $C_6=132=2^2\cdot33$, $v_2=2$ ✓. $33\equiv1\pmod2$, prediction $(-1)^2/(1!1!1!)=1$ ✓. Classes (E000: 11): 3 minimal of size 4, one of size 8, seven of size 16: $3\cdot4+8+7\cdot16=132$ ✓. $N_{\min}=3$, the three skeletons drawn in Example 1 ✓; Corollary 3: $4!/(2!\,2^2\,1!1!1!)=3$ ✓.
3. **(3,1,2):** $q=3$, $m=5=12_3$, $s_3=3$, $t=1$. $C_2^{(3)}=\frac15\binom62=3$, $v_3=1$ ✓. Unit $1$; prediction $(-1)/(2!\,1!)=-1/2\equiv-2\equiv1\pmod3$ ✓. All 3 trees (root with one internal child in one of 3 positions) form one rotation class of size 3, $d=1=t$, $N_{\min}=1$ ✓.
4. **(3,1,3):** $m=7=21_3$, $s_3=3$, $t=1$. $C_3^{(3)}=\frac17\binom93=12=3\cdot4$, $v_3=1$ ✓. $4\equiv1$; prediction $-1/(1!2!)=-1/2\equiv1\pmod3$ ✓. Classes: one of size 3 ($d=1$, minimal), one of size 9 ($d=2$); $3+9=12$ ✓ (E000: #orbits 2, N_min 1 ✓).
5. **(2,2,2):** $q=4$, $m=7=111_2$, $s_2=3$, $t=2$. $C_2^{(4)}=\frac17\binom82=4$, $v_2=2$ ✓. Unit $1\equiv1$; prediction $1$ ✓. The 4 even-depth binary trees with 7 leaves form one class of size $2^2=4$, $N_{\min}=1$ ✓ (E000 ✓).
6. **(2,2,3):** $q=4$, $m=10=1010_2$, $s_2=2$, $t=1$. $C_3^{(4)}=\frac1{10}\binom{12}{3}=22=2\cdot11$, $v_2=1$ ✓. $11\equiv1\pmod2$; prediction $(-1)/(1!1!)=-1\equiv1\pmod2$ ✓. Classes (E000: 3): sizes $2,4,16$ ($d=1,2,3$), $2+4+16=22$ ✓, $N_{\min}=1$ ✓.

The paper's three examples also recompute correctly:

- Example 1, (2,1,6): all numbers above; $132/4=33\equiv1\pmod2$; Corollary 3 gives 3 ✓.
- Example 2, (3,1,8): $m=17=122_3$, $s_3=5$, $t=2$. $C_8^{(3)}=\frac1{17}\binom{24}{8}=43263=3^2\cdot4807$ ($43263/9=4807$, digit sum 19, so $v_3=2$) ✓. $4807\equiv1\pmod3$; prediction $(-1)^2/(2!2!1!)=1/4\equiv1\pmod3$ ✓. Corollary 3: $N_{\min}=6!/(2!\cdot3^2\cdot(2!2!1!))=720/72=10$ ✓. Carry chain $T(5)\equiv-T(3)\equiv T(1)=1\pmod3$; the paper states $T(5)=40$ (from $p^tT(\mathbf a)=(pt)!/t!$: $3^2T(5)=6!/2!=360$, so $T(5)=40$) and $40\equiv1\pmod3$ ✓.
- Example 3, (2,2,4): $q=4$, $m=13=1101_2$, $s_2=3$, $t=2$, atoms $K_0,K_2,K_3$ of classes $0,0,1$, $\mathbf a=(2,1)$. $C_4^{(4)}=\frac1{13}\binom{16}{4}=140=2^2\cdot35$, $35\equiv1\pmod2$, prediction $1$ ✓. Depth condition: $K_0,K_2$ need depth $\equiv0$, $K_3$ depth $\equiv1\pmod2$; with 2 skeleton nodes the leaves are at depths 1 (one) and 2 (two), so $K_3$ is the depth-1 leaf and $K_0,K_2$ the cherry — exactly one skeleton, $N_{\min}=1$ ✓. Carries $(2,1)\to(0,2)\to(1,0)=e_0$, two carries, sign $+1$; paper states all $T$-values are 1 ✓ (E000: n=4, q=4, N_min 1 ✓).

Answers to the brief's targeted questions: (1) ~ is well defined (smallest equivalence relation containing (R1),(R2)); d is shown constant on classes (prose, F5); the normal-form lemma is proved but mis-stated (F1). (2) Primality of p is used correctly in Lemma 4 (order of r in Z_p); the product sets are disjoint (F5 note). (3) The digit lemma is proved for r summands via the merging argument, equality iff no merges/carries. (4) Lower-bound arithmetic re-done, both root cases correct. (5) Skeleton correspondence checked in both directions; depth condition correct; bijection is with classes; equal atoms handled by multisets + labelling. (6) Freeness needs the p-group argument (F2); the p-1 count and class c+1 including wrap-around are correct (F3); terminal vectors correct; invariant mod q-1, termination, q=2 and q=3, and carries = t all correct (F4). (8) No Legendre/Kummer/factorial valuation anywhere in the proof of Theorem 1; the k=1 exact count is separate and not circular. (9) All example numbers recompute. (10) "Clearly/it follows" items: the distinct-labels ⇒ (S1) remark is justified by disjoint label sets; the only substantive unproved assertions are F1-F4.

## What I did not check

- The contents of `paper/reviews/` (per the brief), so I cannot say whether the other reviewers found the same or different issues.
- The bibliography against the original sources; I only confirmed the three entries in `main.tex` match `references/README.md` (Konvalinka JCT A 114 (2007) 1089-1100, DOI 10.1016/j.jcta.2006.11.003; Deutsch-Sagan JNT 117 (2006) 191-215; Postnikov-Sagan JCT A 114 (2007) 970-977), which is where project rules say bibliographic data must come from. The paper's characterization of Konvalinka's argument is plausible and matches the briefing's reading, but I did not re-read the paper itself.
- The Remark after the rotation definition (that the induced group on the q bottom branches of K_k is a Sylow p-subgroup of S_q): true (order p^{(q-1)/(p-1)}), and explicitly unused in all proofs, so I did not scrutinize it further.
- That the LaTeX compiles and the tikz pictures render (I reviewed the math, not the build).
- The numerical claims beyond the cases above; E000's 47 brute-force cases (q in {2,3,5,7,4,9,8}) all passed and I spot-checked the rows quoted in the paper.
- Whether the fixed-point congruence |X| ≡ |Fix| mod p is "in the spirit of" the problem — a judgment call for the humans, flagged in the briefing's risk section.

**Bottom line:** fix F1 (restate Lemma 2) and F2 (supply the p-group order argument in Proposition 4); fill F3, F4, F5 for hygiene. After those edits the paper proves Theorem 1 as claimed, without factorial valuations.
