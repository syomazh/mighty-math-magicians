# Round-1 repairs of `paper/main.tex`

Written by `moonshotai/kimi-k3.1-pro` (Open Math OS worker, W021), 2026-11-13, executing the accepted
repairs A1–A14 of `paper/reviews/ADJUDICATION_round1.md` exactly, and nothing else. Not human-verified.

| # | Item touched | Change |
|---|---|---|
| A1 | Lemma `lem:normal-form` | Restated: $T\sim T'$ iff there is $r\in\Z_p$ with $T_i'\sim T_{i+r}$ for all $i$ (indices mod $p$); the old display (which asserted $T'$ equals a rotation of its own subtree tuple) is gone. Proof rewritten to verify reflexivity/symmetry/transitivity of the condition explicitly, using symmetry and transitivity of $\sim$ on the strictly smaller immediate subtrees. |
| A2 | New Lemma `lem:aut-order` + Proposition `prop:free` | Added a lemma with the two order facts: (i) an automorphism of a cyclic $p$-ary tree fixing every leaf is the identity (induction on decreasing depth), (ii) an automorphism of finite order prime to $p$ is the identity (trivial root rotation since its order divides $p$ and is coprime to $p$; then induct on child subtrees). Freeness of $H=\prod_jS_{m_j}$ now uses the order argument: if $h\cdot\tau=\tau$ witnessed by $\varphi$, then $\lambda(\varphi^n(x))=h^n(\lambda(x))$ and (i) give $\operatorname{ord}(\varphi)=\operatorname{ord}(h)$; $|H|=\prod_jm_j!$ is prime to $p$ since each $m_j<p$ (item iii), so (ii) forces $\varphi=1$, hence $h=1$. The rejected "fixes every leaf because labels are distinct" step is not used. |
| A3 | Definition `def:skeleton` + Proposition `prop:carry` | Definition now includes a map-based notion: an isomorphism of (labelled) cyclic trees is a root-preserving bijection of nodes preserving parent–child and cyclic child order (and labels/heights); equivalence and automorphism are defined from it. In `prop:carry`, the induced $\alpha$ is described in these terms; $\alpha^p=1$ is proved: $\alpha^p$ fixes every leaf since $\sigma^p=1$ and labels are distinct, so Lemma `lem:aut-order`(i) applies. |
| A4 | Proposition `prop:carry-termination` | The false mod-$(p-1)$ digit-total contradiction is deleted. For $q>2$: $W(\mathbf b)\equiv1\pmod{q-1}$ and $0<W(\mathbf b)\le q-1$ with $q-1>1$ force $W(\mathbf b)=1$ (write $W=1+N(q-1)$, bound gives $N=0$), hence $\mathbf b=e_0$. No congruence modulo $p-1$ is used for this step. |
| A5 | Proposition `prop:carry-termination`, $q=2$ case | Replaced the vacuous mod-1 argument: for $q=2$ a carry sends $a_0\mapsto a_0-1$ and is possible exactly while $a_0\ge2$; starting from $a_0=s_2(m)\ge1$ the process ends at $a_0=1$ after $s_2(m)-1$ carries. |
| A6 | Proposition `prop:carry-termination` ($W>0$) | Added: the label count starts at $s_p(m)\ge1$ and each carry needs $p$ labels and leaves one, so $\sum_cb_c\ge1$ at every stage, hence $W(\mathbf b)\ge\sum_cb_c\ge1>0$. |
| A7 | Proposition `prop:skeleton` | The atom-digit induction is now stated and proved: for minimal $U$, $\ell(U)=\sum_jm_j(U)p^j$ with $0\le m_j(U)<p$ (atom base case; carry-free componentwise digit addition at an asymmetric root via Lemma `lem:digit`). Maximality of atoms below asymmetric nodes argued (parent of a complete subtree in a minimal tree would be symmetric). "(2.1) with $q=p$" now said explicitly. Well-definedness of contraction on $\sim$-classes stated via `lem:normal-form`. |
| A8 | Lemma `lem:digit` | Replaced the merge-process argument by column addition: with $c_j$ the carry out of column $j$, $\sum_is_p(a_i)-s_p(\sum_ia_i)=(p-1)\sum_jc_j$ follows by summing the column recurrence; equality iff all $c_j=0$ iff carry-free. |
| A9 | Lemma `lem:class-size` | Disjointness of the $p$ product sets now proved: $\rot_r(U)=\rot_s(V)$ with $U_i,V_i\in B_i$ forces $B_{i+r}=B_{i+s}$ for all $i$, so the class word is fixed by rotation $r-s$, hence $r=s$ by `lem:tuple-rotation` when the $B_i$ are not all equal. |
| A10 | New Lemma `lem:d-invariant` | The prose "d is constant on classes" is now a lemma with proof from the corrected normal form (child class tuple unchanged up to permutation, recursively at every node). |
| A11 | Lemma `lem:depth-invariant` | Added the leaf base case ($\bullet\sim\bullet$, multiset $\{0\}$) and the (R2) step (equal depth multisets in each subtree, add 1 to every entry). |
| A12 | Lemma `lem:terminal` | Added "by maximality": a deepest internal node has only leaf children, all at the same depth, hence all of one class, giving $p$ distinct labels of that class. |
| A13 | Wreath-product remark | Fixed the antecedent: the permutation group induced on the $q$ bottom slots of one block $K_k$ by the rotations at the nodes of that block is $\Z_p\wr\cdots\wr\Z_p$ ($k$ factors), a Sylow $p$-subgroup of $S_q$. |
| A14 | Proposition `prop:lower-bound` source | Repaired two occurrences of `Lemma~`<CR>`ef{...}` (byte 0x0D in place of the backslash of `\ref`) on the `lem:depth-invariant` and `lem:digit` citations. Scanned the whole file: no other control characters beyond CRLF line endings. |

## Extra defects found and fixed while repairing

- `main.tex` header: added a provenance line recording this repair (rule 5). No other extra defects found.

## Verification

- Compiled with `latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex` (MiKTeX env overrides as in `GAPS.md`): success, 12 pages, `paper/build/main.pdf` copied to `paper/main.pdf`.
- `build/main.log` contains no "undefined" and no "multiply defined"; no `??` references.
- No theorem statement was weakened; no Legendre/Kummer/factorial valuation introduced. Worked examples unchanged.
- The mathematical content of the new proofs was checked by the worker against the adjudication text only; no independent reviewer has attacked the repaired draft yet (round 2 is a separate task).
