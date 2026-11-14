# Cross-field readings of the theorem, ranked

- **Date:** 2026-11-14 (Saturday morning); revised about 10:05 PT after the web check of sources.
- **Author:** Claude Fable 5.2 (AI, orchestrator), in answer to "keep working on analogies to physical fields".
- **Status:** each item says what is **exact** (a mathematical statement, with its evidence) and what is **analogy** (a way of speaking). Exact statements are checked in `experiments/E011_crossfield_checks` and `experiments/E010_frobenius_complete`. Statements about other fields were checked against sources by a Claude subagent; its record, with what was actually read, is `notes/2026-11-14_crossfield_literature.md`, and the bibliographic data is in `references/README.md` (entries 6–16). Nothing here is human-verified.
- **How to use it:** Tier A items are candidates for the talk. Tier B items are one-line answers for the question session. Tier C is parked.

Notation: p prime, q = p^k, m leaves, s_p(m) the base-p digit sum, N = (m−1)/(p−1) nodes, ν(m) = (m − s_p(m))/(p−1), t = N − ν(m) = (s_p(m) − 1)/(p−1). d(T) = number of asymmetric nodes; a rotation class with d asymmetric nodes has p^d trees.

---

## Tier A — worth a slide

### A1. The carry budget (computer science: counters and heaps)

**Exact (claim C19; proof in `notes/2026-11-14_carry_budget.md`; checked on all 1,978 classes with up to 13–19 leaves).** Add the leaf counts of a tree node by node in base p. Whatever the shape of the tree, exactly ν(m) carries are made. A symmetric node adds p equal numbers and therefore makes at least one carry. So a tree has at most ν(m) symmetric nodes, hence at least N − ν(m) = t asymmetric ones. A tree is minimal exactly when it wastes no carry.

**Analogy.** A base-p counter. Counting from 0 to m also makes ν(m) carries (E011, part B). In the standard amortized analysis of a binary counter the potential is the number of ones, that is, the digit sum; the total number of bit flips in counting to n is 2n − s_2(n), which is the same identity (our computation; the opened course notes state the bound "at most 2n"). In those words: **t is the potential gained between one leaf and m leaves, measured in carries** (the m − 1 increments supply (m−1)/(p−1) units, ν(m) are spent on carries, t remain). Here a carry is one trade of p units for one unit in the next column; when p numbers are added a column can make several. For p = 2 the same bookkeeping describes a binomial heap (introduced by Vuillemin in 1978 as "binomial queues"): it holds one tree for each binary digit 1 of the number of items, merging works like binary addition, and linking two equal trees is a carry. After m insertions it has made ν(m) links, and s_2(m) − 1 more would be needed to make it a single tree. That last number is the power of 2 in the Catalan number.

*Sources.* The two facts about binomial heaps were found stated explicitly only in course notes and on Wikipedia (literature file, item 1); they are elementary. A 1999 paper by Hinze derives binomial heaps from a tennis tournament (abstract only), which ties this item to B4.

**Why it matters for us.** It is the shortest honest explanation of Step 2, and it never mentions a factorial: ν(m) is a number of carries. (It equals v_p(m!) by Legendre's formula, which is why the accounting proof works, but that is not used.)

### A2. One series, three numbers; and why the smallest term wins (statistical physics)

**Exact (claim C18, `paper/frobenius_proof.pdf`; coefficients confirmed by listing all classes, check "TREE" of E010).** Let Z_m(y) = Σ over rotation classes with m leaves of y^(d). Then

| y | Z_m(y) is |
|---|---|
| 0 | 1 if m is a power of p, else 0 (only the complete trees have d = 0) |
| 1 | the number of rotation classes: tree shapes for p = 2, stereo-isomers of alkyl radicals for p = 3 |
| p | the Fuss–Catalan number (number of plane trees) |

and the generating series F(x, y) = Σ Z_m(y) x^m satisfies F = x + F(x^p, y^p) + y·(F^p − F(x^p, y^p))/p. Examples: Z_8(y) = 1 + y² + 7y³ + 7y⁴ + 6y⁵ + y⁶ for binary trees, so 429 = 1 + 4 + 56 + 112 + 192 + 64; Z_9(y) = 1 + 3y² + y³ for ternary trees, so 55 = 1 + 27 + 27.

The theorem says: the lowest power of y in Z_m is y^t, and its coefficient is ≡ (−1)^t/∏ m_j! modulo p, in particular not divisible by p.

**Analogy.** Z_m is a partition function: a tree shape is a state, its energy is the number of asymmetric nodes ("broken symmetries"), and y is the weight of one unit of energy. Measured p-adically, the weight y = p is *small* (|p|_p = 1/p), and the p-adic size of a sum is the size of its largest term unless there is cancellation. So the p-adic size of the Fuss–Catalan number is decided by the ground states alone: **the valuation is the ground-state energy, and the residue is the number of ground states modulo p.** That is exactly the three-part shape of both proofs (lower bound; which states are minimal; count them modulo p). The Frobenius proof is first-order perturbation theory in the coupling y around y = 0, where the equation is linear.

Seen with ordinary absolute values the same sum reads the other way: p^d is the number of plane trees over a shape, its logarithm is an entropy, and the sum is dominated by the least symmetric shapes. The valuation looks at the crystals, the size at the gas.

### A3. Symmetry numbers: the chemistry made quantitative (p = 3)

**Exact (E011, part C and table E1; follows from C1–C3).** The symmetries of a tree (rotate the children of a node whenever that maps the tree to itself) form a group of order p^σ, σ = number of symmetric nodes. (Induction on the tree: a symmetric root contributes a factor p, an asymmetric root none, because p is prime.) It acts faithfully on the m leaves (Lemma "Automorphisms of cyclic trees" (i) of the main paper). Over all trees with m leaves the largest such group has order p^(ν(m)), and it is attained exactly by the minimal trees. So

    v_p(number of plane trees) = N − log_p(order of the largest symmetry group).

For ternary trees with n nodes (m = 2n+1 leaves):

| n | radical | m = hydrogens | plane trees | v_3 | largest symmetry group (in our model) |
|---|---|---|---|---|---|
| 1 | methyl CH3 | 3 | 1 | 0 | 3 |
| 2 | ethyl | 5 | 3 | 1 | 3 |
| 4 | tert-butyl C(CH3)3 | 9 | 55 | 0 | 81 |
| 13 | the next perfectly branched one | 27 | 300,830,572 | 0 | 3^13 |

The number of ternary trees is prime to 3 exactly for n = 1, 4, 13, 40, …: the sizes of the perfectly branched radicals.

**Analogy, with a real counterpart in chemistry.** Chemists attach to a molecule a *symmetry number* σ: the order of the group of rearrangements of identical atoms that its motions can realise. It lowers the entropy of the molecule by R·ln σ. A freely rotating methyl group contributes a factor 3, and for *independent* internal rotors the factors multiply (Gilson and Irikura 2010, reference 11; their example: acetone has 18 with two free methyl groups but 6 if the two are geared together). Our tree model is the case where every symmetric node is an independent rotor: tert-butyl has a factor 3 for each of its three methyl groups and 3 for the central carbon, 81 in all. The theorem then reads: *the power of 3 in the number of ternary trees measures how far the most symmetric radical with n carbons falls short of perfect branching.* Two cautions: the 81 is the number in our model, which keeps only the rotations of the three bonds and ignores the overall rotation and everything else about a real molecule; and no source we found connects symmetry numbers with p-adic valuations.

---

## Tier B — one line each, for questions

### B1. Dwork's constant (p-adic analysis)

**Exact (claim C20; E011 part A, 565 cases; a restatement of lemmas L1, L2 of the accounting proof).** Let π be a number with π^(p−1) = −p. Then for every prime power q,

    C_n^(q) = (π^(m−1) / m!) · u,   u an integer, u ≡ 1 (mod p).

So term by term the Fuss–Catalan numbers have the valuation and the leading residue of the Taylor coefficients of exp(πx)/π. For q = 2 this is the classical expansion √(1+2z) − 1 = Σ (−1)^(m−1) (2m−3)!! z^m/m!, all of whose coefficients are odd. This is where "every node is worth −p" comes from: one node is one factor π^(p−1).

**Analogy.** π is the constant of Dwork's exponential θ(t) = exp(π(t − t^p)). As recalled in Kochubei 2008 (reference 13): π is a root of z^(p−1) + p = 0; the power series of θ converges on a disc of radius p^((p−1)/p²), larger than 1, although exp(πt) alone converges only for |t| < 1; and θ(1) is a primitive p-th root of unity, so θ is a p-adic stand-in for the wave e^(2πi x/p). (The value θ(1) is the sum of the series; one may not substitute t = 1 in the closed formula.) And our G is the inverse function of x − x^q.

### B1′. The same shape as Stickelberger's congruence (a question for the professor)

**Exact part.** Since (−p)^t = π^(s_p(m)−1), the theorem reads C_n^(q) ≡ π^(s_p(m)−1) / ∏ m_j! modulo the next power of π.

**Resemblance, not verified by us.** Stickelberger's congruence for Gauss sums, as quoted by Blache 2005 (reference 14), has leading term −π^(s(a)) / ∏ a_i!, with s(a) the digit sum of the exponent a and a_i its digits. So the Fuss–Catalan number with m leaves has the leading term of −1/π times the Gauss sum with exponent m. A plausible reason is that both are governed, to first order, by the same factorial structure (the Gross–Koblitz formula on one side, the factorial formula for C_n^(q) on the other). **We have not checked this against a primary source and found no paper that states it.** If it is right, our theorem is a tree-symmetry proof of a Stickelberger-type congruence, which would be worth one sentence. Ask the professor before saying it.

### B2. Cutting the p-adic integers into balls (p-adic geometry, hierarchical models)

**Exact (a direct bijection).** A partition of Z_p into finitely many balls is either Z_p itself or consists of partitions of the p residue classes modulo p, each of which is a copy of Z_p. So partitions of Z_p into m balls are the p-ary trees with m leaves, and **C_n^(p) is the number of ways to cut Z_p into (p−1)n+1 balls**; for q = p^k use the balls whose radius is a power of q (or the integers of the unramified extension with residue field of q elements). The leaf depths D_i satisfy Σ p^(−D_i) = 1: replacing a leaf at depth D by p leaves at depth D+1 does not change the sum, and it starts at 1. This is the additivity of the Haar measure; in coding theory it is Kraft's inequality with equality, for a complete prefix code. Read modulo q − 1, this equality is the invariant Σ a_c p^c ≡ 1 that drives the last step of the proof (see the remark "Where the hypothesis comes from" in the Frobenius note).

**Analogy.** Our rotations are isometries of Z_p (they form a Sylow pro-p subgroup of its isometry group). So the theorem is a statement about the p-adic size of the number of ways to cut the p-adic integers into balls, proved by letting p-adic isometries act on the cuts. In physics the same nested balls are the blocks of hierarchical models: a 1989 paper of Lerner and Missarov (reference 16, abstract only) connects scalar field models on the p-adic line with Dyson's hierarchical model, and ultrametric trees of this kind are reviewed for physicists by Rammal, Toulouse and Virasoro (reference 15, abstract only). We use none of that; it says where a physicist has met these trees.

### B3. Sylow (group theory)

**Exact (same evidence as A3).** A tree with m leaves is minimal exactly when its symmetry group is a Sylow p-subgroup of the symmetric group on its leaves. The atoms are the orbits of that subgroup: a Sylow p-subgroup of S_m is a product of iterated wreath products of Z_p, namely m_j copies of the j-fold one for each base-p digit m_j of m. (This description is classical; Kaloujnine's 1948 paper on these groups is reference 5 of `references/cross_field_refs.md`, of which we checked only the abstract.)

### B4. The lower bound in everyday terms (sport, biology)

**Exact for p = 2 (Kersting–Fischer's theorem, and our Step 2).** In a binary tree with m leaves at least s_2(m) − 1 nodes have two differently shaped subtrees.
- *Knockout tournament with m entrants:* at least s_2(m) − 1 matches are between differently shaped halves of the draw. 64 entrants: 0. 48 entrants: 1. 100 entrants: 2.
- *Cell lineage:* to produce exactly m cells by divisions, at least s_2(m) − 1 divisions must be asymmetric in this sense.
The 2-adic valuation of the Catalan number C_(m−1) is this minimum.

*Sources.* The OEIS entry A001190 does **not** describe these numbers as tournament brackets (checked; an earlier guess of ours was wrong); state the equivalence ourselves. The OEIS entries A096351 and A268289 do record, for the balanced bracket, that the number of labelled brackets is n!/2^(number of nodes with two equal halves): the labelled form of "class size = p^d".

---

## Tier C — parked

- **Renormalisation.** The equation F = x + F(x^p, y^p) + y·θ(F) reads like a block recursion: p identical sub-blocks pass through the substitution x → x^p unchanged, and only non-identical ones interact. Suggestive, not a statement. (Hierarchical models are the natural physical setting; see B2.)
- **δ-rings.** With δ = −θ the Frobenius proof lives in what algebraists call a δ-ring (Bhatt and Scholze 2022, Definition 2.1; they attribute the notion to Joyal and the name "p-derivation" to Buium, whose programme treats this operator as a derivative for numbers). The Frobenius note has a remark on this. It names the structure; we use no theorem about it.
- **Necklaces.** θ(F) = (F^p − F(x^p, y^p))/p counts non-constant necklaces of p classes; f^p = f(x^p) + p·θ(f) is the decomposition of a p-th tensor power under the cyclic group. Not developed.
- **Creation and annihilation.** The carry rule of the Frobenius proof says that removing p atoms of class c is the same, modulo p, as removing one atom of class c+1 with a minus sign: (∂_c^p + ∂_(c+1))H ≡ 0. A way to say "a carry is a collapsing cherry" in operator language. Not developed.

---

## What the web check found about prior work

Keyword searches of OpenAlex, arXiv, the OEIS and the web on 2026-11-14 (queries listed in the literature file, item 8; Semantic Scholar could not be reached). **A search of this kind cannot establish novelty.**

- Nothing found that links the 2-adic valuation of Catalan numbers with binomial heaps, binary counters or tournament brackets.
- Nothing found that proves the valuation formula with a Frobenius lift, δ-rings or Witt vectors. **But** the modulo-p starting point is in print: Kauers–Krattenthaler–Müller (2012) and Krattenthaler–Müller (2025) work with Φ = Σ z^(p^n), state Φ^p − Φ + z ≡ 0 (mod p), and use it for Fuss–Catalan generating functions modulo prime powers. The Frobenius note now credits them.
- Nothing found that reads a sum over tree classes weighted by 1/|Aut| p-adically, or that relates valuations of tree counts to symmetry numbers or entropy. Nearest: two 2011 master's theses (University of Akron) counting orbits of p-ary trees under dihedral groups by Burnside's lemma, with no divisibility statements in their abstracts.

## Corrections made after the web check

1. Symmetry numbers (A3): now stated as the order of a group, a product only for independent rotors.
2. Tournaments (B4): the OEIS entry A001190 has no such comment; the claim is ours.
3. Dwork (B1): the radius and the caution about substituting t = 1 added.
4. Credit for the modulo-p equation: added to the Frobenius note and to `references/README.md`.

---

## What I would put in the talk

1. Replace or follow the Step 2 slide with **A1** (the carry budget): it is the most intuitive single argument we have.
2. On the hook slide, add the **tert-butyl row of A3** next to the chemistry sequence: "55 ternary trees with 4 nodes, not divisible by 3, because tert-butyl is perfectly symmetric".
3. On the "more ways to see it" slide, show **A2** as the one-line picture: 429 = 1 + 4 + 56 + 112 + 192 + 64, "the first term decides".
4. Keep **B1–B4** for questions, and ask the professor about **B1′** before mentioning it.
