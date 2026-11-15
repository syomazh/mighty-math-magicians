# W001 — Write the full proof (LaTeX)

You are a careful combinatorialist writing a complete, rigorous, elementary proof. Another model and then human mathematicians will check every line, so honesty about gaps matters more than polish.

## Read first

- `notes/2026-11-13_candidate_proof_sketch.md` — the strategy you must turn into a full proof.
- `CLAIMS.md` — claims C1–C8 and the notation.
- `references/README.md` — what the prior paper (Konvalinka) does, and the only bibliographic data you may cite.
- `experiments/E000_first_sanity_check/output.txt` — numerical values to sanity-check statements against.

## Write

`paper/main.tex` (article or amsart with amsthm; self-contained; pictures in TikZ). First line a comment: `% Drafted by <your model name> (Open Math OS worker), 2026-11-13, from a sketch by Claude Fable 5.2. Not yet human-verified.`

Notation is fixed: p prime, k ≥ 1, q = p^k, m = (q−1)n+1, s_p = base-p digit sum, t(m) = (s_p(m) − 1)/(p − 1), d(T) = number of asymmetric nodes.

Required content, in this order:

1. **Introduction.** The theorem. One paragraph on the difference from Konvalinka: he acts with the full symmetric group at each node, orbit sizes are products of multinomials, his argument gives divisibility and he invokes the factorial formula for exactness; we act with a p-group. Say "we give a proof"; make no novelty claims.
2. **Definitions.** A p-ary tree is a leaf or an ordered p-tuple of p-ary trees. Number of leaves ℓ(T), depth, complete tree of height h. "k-blocked": every leaf has depth ≡ 0 (mod k). Lemma: q-ary trees with n internal nodes correspond bijectively to k-blocked p-ary trees with (q−1)n+1 leaves (replace each q-ary node by a complete p-ary tree of height k whose p^k bottom positions, left to right, are the q branches).
   Rotation equivalence `~`: the smallest equivalence relation with (T_1,…,T_p) ~ (T_2,…,T_p,T_1), and (T_1,…,T_p) ~ (T'_1,…,T'_p) whenever T_i ~ T'_i for all i. Remark without proof that this is the orbit relation of an iterated wreath product of Z_p, which on a q-ary node is a Sylow p-subgroup of S_q. Lemma (normal form): T ~ T' iff T' is a rotation of some (T'_1,…,T'_p) with T'_i ~ T_i. Lemma: `~` preserves the multiset of leaf depths, hence ℓ and k-blockedness. Define asymmetric node and d(T); show d is constant on classes.
3. **Lemma A (class size).** |[T]| = p^{d(T)}. Use that p is prime: a sequence of length p fixed by a non-trivial rotation is constant.
4. **Digit lemma.** s_p(pm) = s_p(m). s_p(a_1+…+a_r) ≤ Σ s_p(a_i), with equality iff the addition is carry-free (in every position the digits add up to less than p); the difference is a multiple of p−1. Elementary proof without factorials (for instance: s_p(m) is the least number of powers of p summing to m; merge p equal powers into one).
5. **Proposition B (lower bound).** ℓ(T) ≡ 1 (mod p−1), so t(ℓ(T)) is an integer, and d(T) ≥ t(ℓ(T)). Also: d(T) = 0 iff T is complete.
6. **Proposition C (minimal classes).** T is minimal (d(T) = t(ℓ(T))) iff T is complete, or the root is asymmetric, all p subtrees are minimal and their leaf counts add without carries. Deduce the skeleton/atom description: the maximal complete subtrees ("atoms") correspond to the base-p digits of m (exactly m_j atoms of height j), and in a k-blocked tree an atom of height j hangs at depth ≡ −j (mod k). Define precisely the set of "cyclic skeleton trees" (children of each node known up to rotation, leaves labelled by the multiset of atoms, depth condition) and prove that minimal classes of k-blocked trees with m leaves are in bijection with it.
7. **Proposition D (counting mod p).** Labelled version: leaves carry distinct labels, each label has a class in Z/k, a class-c leaf sits at depth ≡ −c (mod k); T(a) = number of such cyclic trees with a_c labels of class c.
   (i) Freeness: the stabilizer of a labelled cyclic tree inside the group of label permutations has p-power order (induction on the tree), while ∏ m_j! is prime to p because digits are < p; hence N_min = T(a)/∏ m_j!.
   (ii) Carry: let Z_p cyclically permute p labels ℓ_1,…,ℓ_p of one class c. The fixed trees are exactly those in which ℓ_1,…,ℓ_p are the p children of one node, in one of the p−1 cyclic arrangements compatible with the permutation. Collapsing that node to a leaf (one level higher, so class c+1) gives T(a) ≡ (p−1)·T(a − p·e_c + e_{c+1}) ≡ −T(a − p·e_c + e_{c+1}) (mod p), indices mod k.
   (iii) If every a_c < p then T(a) = 0 unless a = e_0 (a tree with an internal node has an internal node all of whose children are leaves).
   (iv) Σ a_c p^c mod (p^k − 1) is invariant under carrying and is ≡ m ≡ 1 (mod q−1) at the start; each carry removes p−1 labels; conclude T(a) ≡ (−1)^t (mod p). Treat q = 2 (modulus 1) explicitly.
8. **Main theorem.** C_n^(q) = Σ over classes of p^{d}. Conclude v_p(C_n^(q)) = t and C_n^(q)/p^t ≡ (−1)^t/∏ m_j! (mod p). For k = 1 also prove the exact count N_min = (pt)!/(t!·p^t·∏ m_j!) (count plane p-ary trees with t internal nodes and s distinctly labelled leaves, divide by the p^t rotations and by ∏ m_j!; here you may use the Fuss–Catalan formula for the number of p-ary trees, and must say so).
9. **Worked examples with pictures.** (p,k,n) = (2,1,6): m = 7 = 111 in base 2, the three minimal classes are the three rooted binary trees on the bits {0,1,2}. (3,1,8): m = 17 = 122 in base 3, ten minimal classes (give the count by the formula, draw two). (2,2,4): q = 4, m = 13 = 1101 in base 2, one minimal class, show the depth condition at work. Then follow the carry reduction T(a) → … → T(e_0) for one of them.

## Rules

- Do **not** use Legendre's formula, Kummer's theorem, or any valuation of a factorial or binomial coefficient in any proof. Allowed: elementary counting, base-p digits, and "if Z_p acts on a finite set X then |X| ≡ |Fix| (mod p)" (prove it in one line).
- Full proofs. No "clearly" or "it is easy to see" for anything longer than one line.
- If you cannot fully justify a step, or you think a step of the sketch is wrong, mark the spot in red with a macro `\GAP{...}` and list it in `paper/GAPS.md` (create the file even if it ends up saying "no gaps found"). Do not paper over a gap and do not silently change a statement.
- Cite only the three references in `references/README.md`, with exactly that bibliographic data.
- Length: whatever full rigor needs; expect 8–12 pages.
- Compile with `cd paper && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex` and fix all errors; `paper/build/main.pdf` must exist at the end.
- Touch only files under `paper/`.
