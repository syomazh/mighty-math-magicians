# Referee report on `paper/accounting_proof.tex` ("Every node is worth -p")

Written by Claude Fable 5.2 (fresh-context referee subagent), 2026-11-14. Not human-verified.
Read: `paper/accounting_proof.tex` in full (and the compiled PDF, which has 4 pages, not 3);
`paper/main.tex` lines 1-440 only. Not read: anything in `paper/reviews/` (other reviews), `notes/`,
`briefs/`, `experiments/`, `CLAIMS.md`, `STATE.md`, `JOURNAL.md`, `FINDINGS.md`, `MORNING_BRIEF.md`,
`paper/alt_proof_accounting.tex`. No `.tex` file was edited; nothing was committed.
Line numbers below refer to `paper/accounting_proof.tex` unless prefixed with `main.tex`.

## 1. Summary verdict

The proof of Theorem 1 is correct. I found no mathematical error in Lemma 1, Lemma 2, Lemma 3, the
Corollary, or Section 4, and no circularity. The quoted statements (A), (B), (C) are true and are
supported by the main paper, including the application of (C) to the vector `m e_0`.

Findings: **1 WRONG** (a remark after the sand proposition, false for q = 2; outside every proof) and
**7 GAP** (2 moderate, 5 minor). All gaps are missing statements, missing citations or missing
hypotheses; each closes in one to six lines and none changes a result. Recommendation: minor revision.

The two moderate gaps:

- (C) is not a statement of the main paper. The note asks the reader to re-read the proof of
  Proposition "Iterated carries" under a different hypothesis. I did that line by line and it works,
  but a note that "quotes" must quote a statement.
- The note says it "reuses three statements". It directly uses at least six results of the main paper
  (Blocked form, Class size, Plane representatives, Skeleton nodes are asymmetric, the fixed-point
  congruence, the carry proposition) plus the proof under (C). One clause of (A) is attributed to the
  wrong lemma.

## 2. Table of verdicts

| Item | Verdict | Finding |
|---|---|---|
| (A) as a statement | CORRECT | - |
| (A) attribution ("Class size", "Plane representatives") | GAP (moderate) | G2 |
| (B) quoted correctly; holds for arbitrary vectors | CORRECT | - |
| (C) as a statement, including q = 2 and the number of carries | CORRECT | - |
| (C) as a citation ("the proof ... uses only this congruence") | GAP (moderate) | G1 |
| Lemma 1, identity `m! C = p^N(m) L(m)` | CORRECT; unstated dependencies | G2 |
| Lemma 1, `L(m) = T(m e_0)` with the depth condition | CORRECT | - |
| Lemma 1, `L(m) = (-1)^N(m) mod p` | CORRECT (rests on (C)) | G1 |
| Lemma 2 (transitivity, stabilizer, automorphism count, exponent nu(m)) | CORRECT; two implicit steps | G4 |
| Lemma 3, recursion (1) as a bijection (incl. a = 0, m_0 = 0, m < p) | CORRECT; scope of m not stated | G3 |
| Lemma 3, `binom(pa+m_0, m_0) = 1 mod p` | CORRECT | G2(d), G5 |
| Lemma 3, `K(a) = (-1)^a mod p` | CORRECT; three small unstated steps | G5 |
| Lemma 3, `a + nu(a) = nu(m)` | CORRECT | - |
| Corollary 1 | CORRECT; no proof, no attribution | G7 |
| Proof of Theorem 1 (Section 4), passage to `mod p^(t+1)` | CORRECT | - |
| Sand proposition (a) | CORRECT | - |
| Sand proposition (b) | CORRECT for m >= 1; hypothesis missing | G6 |
| Remark after the sand proposition (`p^k - 1` divides `m`) | WRONG for q = 2 (minor) | W1 |
| Circularity | none found | - |
| Legendre / Kummer / Lucas / Wilson used without proof | none; but see | G2(d), R1 |

## 3. Findings

### WRONG

**W1 (minor; in a remark, used nowhere). Lines 202-203.**
Quote: "If $p^k-1$ divides $m$ the ring ends instead in the full configuration $(p-1,\dots,p-1)$;
this case does not occur for $m=(q-1)n+1$."

For q = 2 we have `p^k - 1 = 1`, which divides every m, in particular every `m = (q-1)n+1 = n+1`. So
the case occurs for every n, and the "full configuration" is `(1)`, which is exactly the single grain
of part (b); "instead" and "does not occur" are both false. The sentence is also false for m = 0
(divisible by `p^k - 1`, ring ends empty). For q > 2 and m >= 1 the claim is right (simulated,
Section 5).
Fix: "If q > 2 and m >= 1 is divisible by q - 1, the ring ends in the full configuration
(p-1,...,p-1), after (m - k(p-1))/(p-1) topplings; for q > 2 this does not happen when m = (q-1)n+1.
For q = 2 the full configuration is the single grain."

### GAP, moderate

**G1. (C) is borrowed by inspecting a proof, not by quoting a statement. Lines 65-69 and 88-89.**
Quote: "The proof in the paper is written for the vector of digits of $m$ but uses only this
congruence."

Proposition "Iterated carries" (`main.tex` l. 378-383) is stated only "for $\mathbf a$ obtained from
the digits of $m$". Lemma 1 needs it for `a = m e_0`, which is never a digit vector once m >= p. I
checked the proof (`main.tex` l. 384-409) line by line against the hypothesis of (C):

| Proof line (`main.tex`) | Uses the digit origin of a? | Under the hypothesis of (C) |
|---|---|---|
| l. 386-391, eq. (weight-start): `W(a) = 1 mod q-1` | yes, this is where the digits enter | this is the hypothesis |
| l. 392: W invariant mod q-1 under a carry; a carry removes p-1 labels; no infinite sequence | no ("for any vector b") | unchanged |
| l. 394: "it starts at $s_p(m)\ge1$", so the label count stays >= 1 and W > 0 | yes: needs `sum a_c >= 1` | follows from the hypothesis: for q > 2, `a = 0` has W = 0, not 1 mod q-1, because q-1 > 1. Not "the congruence only" verbatim; one extra sentence is needed |
| l. 396-400: terminal b has `0 < W(b) <= q-1`, so W(b) = 1, so b = e_0 | no | unchanged |
| l. 402, q = 2: "Starting from $a_0=s_2(m)\ge1$ ... after exactly $s_2(m)-1$ carries" | yes | replace by `a_0 >= 1`, `a_0 - 1` carries; this is the parenthesis "(for q=2: if a_0>=1)" in (C) |
| l. 404-408: `T(a) = (-1)^r T(e_0)`; "The initial vector has ... $s_p(m)$ labels", so r = t | yes | `r = (sum a_c - 1)/(p-1)`; an integer because it is a number of carries |

Also needed and true: Proposition "A carry collapses a cherry" (`main.tex` l. 352-371) and Lemma
"Terminal vectors" (l. 372-377) carry no restriction to digit vectors, and `T(a)` is defined for "an
arbitrary vector" at `main.tex` l. 313. Nothing in the proof of the carry proposition (fixed points of
the relabelling, Moving-leaf lemma, count of the p-1 cyclic arrangements, depth shift r-1 = -(c+1))
uses a bound on `a_c`.

For `a = m e_0`: `W = m = 1 mod q-1`; for q = 2, `a_0 = m = n+1 >= 1`; number of carries
`(m-1)/(p-1) = N(m)`. So (C) applies and Lemma 1 is correct.

Fix: replace (C) by a lemma with its own proof (six lines), or generalize the proposition in the main
paper. Suggested statement: "Let a be a vector of nonnegative integers with
`sum_c a_c p^c = 1 (mod q-1)` if q > 2, or `a_0 >= 1` if q = 2. Then every maximal sequence of carries
starting at a has exactly `r = (sum_c a_c - 1)/(p-1)` steps and ends at `e_0`, and
`T(a) = (-1)^r (mod p)`."

**G2. The list of borrowed results is incomplete, and one clause of (A) is misattributed.
Lines 29-30, 37-39, 56-60, 82-85, 132-142.**

(a) Quote (l. 56-60): "(Lemma ``Class size'', in its version for trees with labelled leaves, Lemma
``Plane representatives''): ... with distinct labels every internal node is asymmetric." The last
clause is in neither lemma. It is the second sentence of Lemma "Skeleton nodes are asymmetric"
(`main.tex` l. 274-279). That lemma speaks of cyclic trees ("at no internal node ... are the p child
subtrees all equivalent"), while the class-size formula needs asymmetry of a node of a plane labelled
tree "defined through labelled classes"; the bridge is the last sentence of Lemma "Plane
representatives" (rotation equivalent iff the cyclic trees are isomorphic). True, but three lemmas are
used, not two.

(b) Quote (l. 82): "There are $m!\cdot C$ plane $k$-blocked trees with leaves labelled $1,\dots,m$."
This uses Lemma "Blocked form" (`main.tex` l. 87-94), which appears in the note only as the word
"equivalently" (l. 38) and is not in the list (A)-(C).

(c) Quote (l. 82-83): "By (A) they fall into rotation classes". This needs that the k-blocked labelled
plane trees form a union of rotation classes. Lemma "Plane representatives" transfers Normal form,
d-invariance and Class size to labelled trees, but not Lemma "depth-invariant" (`main.tex` l. 126).
The statement follows from the sentence "an isomorphism preserves depths" in the definition of cyclic
isomorphism (`main.tex` l. 266) together with the last sentence of Lemma "Plane representatives". One
sentence is missing.

(d) Lines 135 and 142 pass from a count of fixed points to a congruence
("So $\binom{pa+m_0}{m_0}\equiv\binom{p(a-1)+m_0}{m_0}$", "So $K(a)\equiv(p-1)K(a-1)$"). This is the
congruence `|X| = |Fix X| (mod p)` for an action of Z_p (`main.tex` eq. (fixed-points), l. 151-154).
The note neither states nor cites it.

Fix: replace "three statements" by an honest list: Blocked form; Class size for labelled trees with
Plane representatives and Skeleton nodes are asymmetric; depth invariance; the carry; the
termination lemma of G1; the fixed-point congruence.

### GAP, minor

**G3. Scope of m in Section 3. Lines 38-47, 94-97, 119-130, 144.**
Section 1 fixes `m = (q-1)n+1` and defines `m_j`, `s`, `N(m)`, `nu(m)` for that m. Lemmas 2 and 3 are
needed for every integer m >= 0: the induction (l. 144, "By \eqref{rec} and induction") applies Lemma
3 to `a = floor(m/p)`, which is not of the form `(q-1)n+1`. The note never says that m is arbitrary in
Section 3. Likewise a digit-forest structure is defined only "on {1,...,m}" (l. 94) but (1) uses one
"on the set of the a cherries" (l. 122-123). The base case (`|F(0)| = 1 = (-1)^nu(0)`) and the fact
that `a < m` for m >= 1 are not stated.
The decomposition itself is a bijection, including the edge cases: for a = 0 (that is, m < p) it reads
`1 = 1 * K(0) * |F(0)| = 1`; for `m_0 = 0`, R is empty and the binomial is 1. Confirmed by enumeration
(Section 5).
Fix: open Section 3 with "In this section m >= 0 is an arbitrary integer, with base-p digits m_j,
digit sum s and nu(m) = (m-s)/(p-1); structures are defined on any finite set X with |X| = m", and
state the base case.

**G4. Lemma 2, stabilizer. Lines 105-111.**
Quote: "a cyclic complete tree of height $j$ has $p^{(p^j-1)/(p-1)}$ automorphisms: an automorphism
is a free choice of a rotation at each of its ... internal nodes".
The orbit-stabilizer count needs the number of permutations of the leaves that preserve the structure,
not the number of tree automorphisms. The two agree only because an automorphism that fixes every leaf
is the identity (`main.tex` Lemma "Automorphisms of cyclic trees"(i), l. 314-322; not cited). Also not
said: when two "arrangements" of a block are the same structure (isomorphism of labelled cyclic
trees), and that the stabilizer maps onto `prod_j S_(m_j)` (any two cyclic complete trees of equal
height are isomorphic). The induction "a rotation at the root, then an automorphism of each of the p
subtrees" is correct: `|Aut_j| = p |Aut_(j-1)|^p`, so the exponent is `1 + p e_(j-1) = (p^j-1)/(p-1)`.
Transitivity is correct. The exponent `sum_j m_j (p^j-1)/(p-1) = (m-s)/(p-1)` is correct.
Fix: define equality of structures; add "distinct choices of rotations induce distinct permutations of
the leaves, since an automorphism fixing all leaves is the identity".

**G5. Lemma 3, the two Z_p-actions. Lines 132-142.**
Both are actions on the stated sets and the fixed points are as claimed, for a >= 1. Missing:
(i) the actions exist only when a >= 1 (the cycle (1 2 ... p) must lie in the ground set); the text is
an induction on a but does not say so, with base cases `binom(m_0, m_0) = 1` and `K(0) = 1`;
(ii) quote (l. 139-140): "A fixed permutation $\pi$ commutes with $c$, hence preserves
$\{1,\dots,p\}$ and acts there as a power $c^u$" assumes that the centralizer of a p-cycle in
Sym({1..p}) is generated by it; one line: `pi c pi^-1 = (pi(1) ... pi(p)) = c` gives
`pi(c(i)) = c(pi(i))`, so pi is determined on {1..p} by `pi(1) = c^u(1)` and equals `c^u` there;
(iii) the count `(p-1) K(a-1)` also needs the converse: each `c^u`, u != 0, is a single p-cycle, so
`c^u` joined with any admissible permutation of the other points is admissible. This is where p prime
is used; the text does not say it;
(iv) the fixed-point congruence, see G2(d).

**G6. Sand proposition (b). Lines 185-189 and 195-198.**
(i) m >= 1 is needed. For q = 2 the hypothesis "m = 1 (mod p^k - 1)" is empty, and m = 0 is a
counterexample to the statement as written (no grain; N(0) = -1).
(ii) Quote (l. 196): "a final configuration has $0<\sum_cg_cp^c\le p^k-1$". The inequality "0 <" is
not justified. Needed: a toppling consumes p grains and creates one, so the number of grains never
drops to 0 when m >= 1.
(iii) The last sentence of the statement ("Consequently $v_p(C)=t$ is the number of topplings on the
ring minus the number on the line") does not follow from (a) and (b); it is `N(m) - nu(m) = t`
together with Theorem 1. The proof does not mention it.
(iv) "every sequence of topplings ends" should read "every sequence of topplings is finite, and a
maximal one ends ...".
With m >= 1 the rest is correct: termination by the grain count; the final state by the invariant
`sum g_j p^j` on the line and by the invariant mod `p^k - 1` plus the bound on the ring; the number of
topplings by the grain count, so both are independent of the order. For q = 2 the general argument
already works (`0 < W <= 1`), so the parenthesis in l. 196-197 is redundant but right.

**G7. Corollary 1. Lines 150-152.**
No proof is given. It needs "`prod_j m_j!` is prime to p", which the note states only later (l. 163).
No attribution: the first half is Legendre's formula and the second half is the classical residue of
`m!/p^(v_p(m!))`. From memory, not checked against a source and therefore not to be added without
checking (repository rule 4): this residue is attributed to Anton (1869), Stickelberger (1890) and
Hensel (1902) in Granville's survey on binomial coefficients modulo prime powers.
The note should also say what follows from the Corollary: with the closed formula
`C = (qn)!/(n! m!)`, Corollary 1 applied to `qn`, `n` and `m` gives Theorem 1 in two lines, because
`nu(qn) - nu(n) = N(m)` and the digits of `qn` are those of `n`. So the content of the note beyond the
classical statement is exactly Lemma 1 (obtained without the closed formula).

### Remarks on scope (no verdict attached)

**R1. Factorial valuations.** No use of Legendre, Kummer, Lucas or Wilson as an unproved input. The
special cases needed are proved by fixed points: `binom(pa+m_0, m_0) = 1` (a case of Lucas) and
`K(a) = (-1)^a` (for a = 1 this is Wilson). But Section 4 does use the p-adic valuation of m!: Lemma 2
with Lemma 3 is the statement `m! = p^nu(m) * (unit)`, that is, Legendre's formula with a proof. The
status box (l. 31-33) says this. Under a strict reading of "without factorial valuations" the note
does not qualify; the main paper's proof does.

**R2. Independence from the main proof.** The note replaces the lower bound, minimal classes,
skeletons and the free action of the main paper, but keeps its hardest step, the carry proposition
(with Lemma "Automorphisms of cyclic trees" and the Moving-leaf lemma behind it). An error in (B)
would break both proofs. "Second proof" should be read with that limit.

**R3. An identity not in the note.** `L(m) = prod_{i=0}^{k-1} K(p^i n)` (both sides equal
`(qn)!/(n! p^N(m))`; checked for all 732 triples of Section 5). With the note's own sub-claim
`K(a) = (-1)^a` this gives `L(m) = (-1)^N(m)` without (B) or (C), if the closed formula is allowed.
For k = 1 it says `L(m) = K(n)`.

**Cosmetic.** The letter c denotes a class in (B), (C), a p-cycle in Lemma 3 and a site in the
proposition; a is a vector in Section 1 and an integer in Section 3; K(a) clashes with the complete
tree K_h of the main paper. Source labels are L1, L3, L4 for Lemmas 1, 2, 3. "Divide the identity of
Lemma 1 by that of Lemma 2" (l. 156) is a substitution followed by cancelling `p^nu(m)`; it needs
`N(m) >= nu(m)`, true because s >= 1.

## 4. The seven attack points

1. **(C) against the proof.** True; see the table in G1. Both the q = 2 case and the count of carries
   survive the change of vector. One step (positivity of the label count) uses more than the bare
   congruence text, but it follows from the congruence when q > 2 and from `a_0 >= 1` when q = 2.
2. **Lemma 1.** "all N(m) internal nodes are asymmetric" is true and is in the main paper, but in
   Lemma "Skeleton nodes are asymmetric", which (A) does not name (G2a). `L(m) = T(m e_0)` is correct:
   class 0 means depth = 0 mod k, and T is defined for arbitrary vectors (`main.tex` l. 313).
   Confirmed by brute force for (p,k,m) = (2,1,2..7), (2,2,4), (2,2,7), (2,3,8), (3,1,3), (3,1,5),
   (3,1,7), (3,2,9), (5,1,5), (5,1,9), (7,1,7), and m = 1.
3. **Lemma 2.** Correct. Transitivity, stabilizer order, `p^((p^j-1)/(p-1))` automorphisms and the
   exponent nu(m) all check out by hand and by enumeration. Two implicit steps (G4).
4. **Lemma 3.** The decomposition is a bijection, including a = 0, m_0 = 0 and m < p. Both Z_p-actions
   are actions on the stated sets when a >= 1, with exactly the claimed fixed points.
   `a + nu(a) = nu(m)` is correct. Missing sentences: G3, G5.
5. **Theorem.** Correct. From `C P |F| = p^t L` and `p` not dividing `|F|`: `p^t | C P`; with
   `C P = p^t x`, `x |F| = L` gives `x = (-1)^(N-nu) = (-1)^t (mod p)`, hence
   `C P = (-1)^t p^t (mod p^(t+1))`. `P = prod m_j!` is prime to p, which gives the valuation and the
   residue.
6. **Sand.** Correct for m >= 1. Missing hypothesis and one unjustified inequality (G6). The remark on
   `p^k - 1 | m` is false for q = 2 (W1).
7. **Circularity and classical theorems.** None of (A), (B), (C), Lemma "Terminal vectors", Lemma
   "Blocked form" uses the valuation formula, a factorial or a binomial coefficient. Lemmas 2 and 3 do
   not use Theorem 1. Corollary 1 is not used in Section 4. No circularity. For the classical
   theorems see R1 and G2(d).

## 5. Computations

Scripts and outputs are in `paper/reviews/scratch_accounting/` (pure standard library; run each with
`uv run python <script>`). All four scripts end with ALL PASS. Checks were not edited after a
failure; none failed. After the first run of `check_trees.py` I enlarged three brute-force ranges and
added a counter of non-trivial instances.

`check_theorem.py` (output `out_theorem.txt`):
- Theorem 1, `v_p(C) = t`, both parts of Lemma 1 as number statements, Lemma 2 integrality, Lemma 3,
  the identity of Section 4, and R3: 732 triples, p in {2,3,5,7}, k in {1,2,3}, 0 <= n <= 60; 0
  failures. C was computed from the closed formula and, independently, from `T = 1 + x T^q`; the two
  agree.
- Corollary 1, `binom(m, m_0) = 1`, `K(a) = (-1)^a` (m <= 600), `a + nu(a) = nu(m)`: p in
  {2,3,5,7,11,13}, 0 <= m <= 3000; 0 failures.
- Number of k-blocked p-ary trees with m leaves, counted from a depth-indexed functional equation,
  equals the q-ary count (and is 0 when m is not 1 mod q-1): 195 cases; 0 failures.

`check_trees.py` (output `out_trees.txt`):
- Part 1, brute force over all plane p-ary trees with distinctly labelled leaves, reduced modulo
  rotations by a canonical form, for (p, k, max labels) = (2,1,7), (2,2,7), (2,3,8), (3,1,7), (3,2,9),
  (3,3,7), (5,1,9), (5,2,9), (7,1,7), all class vectors a. Every rotation class has exactly `p^N`
  members (A). `L(m) = T(m e_0) = m! C / p^N` and `L(m) = (-1)^N` in the 25 cases with
  m = 1 (mod q-1) (9 of them the trivial m = 1). (B) at the level of its proof: the number of classes fixed by the cyclic
  relabelling of p labels of class c equals `(p-1) T(a - p e_c + e_(c+1))` in all 502 instances (76
  with a non-zero side). Lemma "Terminal vectors" in all cases. (C) in 68 instances.
- Part 2, `T(a)` from plane counts by depth class divided by `p^N`, for all vectors with |a| up to 40-43
  (k = 1), 18-21 (k = 2), 13 (k = 3), each for p in {2,3,5,7}: (B) in 3949 instances (434 with a non-zero side); (C) in 299
  instances; 897 random carry orders, each ending at `e_0` after exactly `(|a|-1)/(p-1)` carries.

`check_forest.py` (output `out_forest.txt`):
- Digit-forest structures enumerated constructively (no group action) for p = 2, m <= 12; p = 3,
  m <= 11; p = 5, m <= 11; p = 7, m <= 11. `|F(m)| = m!/(p^nu prod m_j!)` and `|F(m)| = (-1)^nu`
  in all 49 cases.
- For 1 <= m <= 9 and each p: the orbit of one structure under all of S_m is all of F(m); the
  stabilizer, counted by brute force, has order `p^nu prod m_j!`, the same at a second base point, and
  maps each tree to a tree of the same height.
- Recursion (1): for every enumerated structure the triple (R, cherries with cyclic orders, contracted
  structure) was computed; the map is injective, lands in the product set, and the counts satisfy
  `|F(m)| = binom(m, m_0) K(a) |F(a)|`, with K(a) also counted by enumeration. So it is a bijection in
  all 49 cases, including a = 0 and m_0 = 0.
- Automorphisms: all choices of one rotation per internal node give `p^((p^j-1)/(p-1))` distinct leaf
  permutations, all structure-preserving, for (p,j) = (2,1..4), (3,1), (3,2), (5,1), (5,2), (7,1); for
  p^j <= 9 a brute-force search of S_(p^j) finds no others.
- Action on subsets: 67 cases (p, a, m_0); well defined, orbits of size 1 or p, fixed subsets are
  exactly those avoiding 1..p. Action by conjugation: p = 2, a <= 6; p = 3, a <= 4; p = 5, a <= 2;
  p = 7, a = 1; fixed permutations are exactly those acting on {1..p} as `c^u`, u != 0; their number
  is `(p-1) K(a-1)`.

`check_sand.py` (output `out_sand.txt`):
- (a): 15840 runs with random and three deterministic toppling orders (p in {2,3,5,7}; m in 0..399
  and 40 random m < 20000); exhaustive search over all toppling sequences for 163 pairs (p, m). Final
  state = digits of m, nu(m) topplings.
- (b): 6588 runs (p in {2,3,5,7}, k in {1,2,3}, m = (q-1)n+1, 0 <= n <= 60); exhaustive for 98
  triples. Final state = one grain on site 0, N(m) topplings. Also 3600 runs from general
  configurations satisfying the hypothesis of (C).
- Remark: for m = j(q-1), 1 <= j <= 39, the ring ends in (p-1,...,p-1); for q = 2 this is the single
  grain (W1). m = 0 with q = 2 is the degenerate counterexample of G6(i).

## 6. What I did not check

- `main.tex` beyond line 440 (rest of the exact count for k = 1, examples, bibliography), and the
  proofs of Propositions "Lower bound", "Local characterization", "Minimal classes are skeleton
  trees", "Removing labelling", which the note does not use.
- In `main.tex` I checked in detail: Blocked form, Skeleton nodes are asymmetric, Moving-leaf lemma,
  the carry proposition, Terminal vectors, Iterated carries. I read once, without attacking line by
  line: Normal form, d-invariance, Class size, Plane representatives, Automorphisms of cyclic trees.
  Class size for distinctly labelled trees is confirmed only by brute force in the ranges above.
- No brute-force check of Lemma 1 for k >= 2 beyond (p,k,m) = (2,2,4), (2,2,7), (2,3,8), (3,2,9); no
  enumeration of F(m) beyond m = 12; no prime above 7 for Theorem 1 (above 13 for Corollary 1).
- The script `experiments/E004_accounting_proof/claude_check.py` named in the header of the note, and
  `paper/alt_proof_accounting.tex`.
- I did not recompile the PDF; I compared its text with the source by reading. It matches.
- The attribution in G7 is from memory.
- During my run `git status` showed uncommitted changes in
  `experiments/E004_accounting_proof/forest_final.txt`, `experiments/E004_accounting_proof/run.py` and
  `paper/alt_proof_accounting.tex`. They are not mine; I wrote only this report and
  `paper/reviews/scratch_accounting/`.
