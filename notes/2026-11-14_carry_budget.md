# The carry budget: Step 2 and Step 3 of the main proof from one identity

- **Date:** 2026-11-14, about 09:35 PT; revised about 10:15 PT after an independent referee read.
- **Author:** Claude Fable 5.2 (AI, orchestrator). Found while looking for a "counter" reading of the proof.
- **Status:** `ai-reviewed`, qualified (claim C19). A fresh-context Claude referee who read only this note found the mathematics correct and could not break it: about 1.36 million rotation classes checked exhaustively (p = 2 up to 20 leaves, p = 3 up to 29, p = 5 up to 49, p = 7 up to 61) and random trees with up to 4.8 million leaves for p ≤ 13, with no violation (`paper/reviews/carry_budget_review_claude_fresh.md`). It found one wrong sentence in an analogy, three gaps of statement and three unclear wordings; all are repaired in this version (`paper/reviews/ADJUDICATION_carry_budget.md`), and the repairs are not re-reviewed. Our own check: `experiments/E011_crossfield_checks/excess.py`, 1,978 classes (1,833 with up to 13 leaves for p = 2; 123 up to 15 leaves for p = 3; 15 up to 17 for p = 5; 7 up to 19 for p = 7). Not human-verified.
- **What it is for:** a more intuitive way to *say* Step 2 (the lower bound) and Step 3 (which trees are minimal). It proves the same statements as Propositions "Lower bound" and "Local characterization" of `paper/main.tex`. The paper is not changed; this is a second way to see them, for the talk and for the oral questions.

## Setting

p prime. T a p-ary tree with m leaves. For a node v, m_v is the number of leaves below it. N = (m−1)/(p−1) is the number of nodes (internal vertices). s_p is the base-p digit sum, t = (s_p(m)−1)/(p−1). A node is *symmetric* if its p subtrees are rotation-equivalent, *asymmetric* otherwise; d(T) is the number of asymmetric nodes. Rotation-equivalent trees have the same number of leaves (by induction on the definition).

**What a carry is.** One carry is one trade of p units in a column for 1 unit in the next column. It lowers the sum of the digits by p − 1. When p numbers are added, one column may need several such trades (up to p − 1); each counts. For example in base 3, 12 + 12 + 12 = 120: the units column holds 6 and makes two trades, the next column then holds 3 + 2 = 5 and makes one. Three carries.

**Carries at a node.** At a node v with children v_1, …, v_p, add the numbers m_(v_1), …, m_(v_p) in base p. The number of carries made, in the sense above, is

    c(v) = ( s_p(m_(v_1)) + … + s_p(m_(v_p)) − s_p(m_v) ) / (p−1)  ≥ 0

(the digit lemma of the paper). For p = 2 this is the usual number of carries in adding two binary numbers.

## The three facts

**Fact 1 (the budget is fixed).** For every tree with m leaves,

    Σ_v c(v) = (m − s_p(m)) / (p−1) =: ν(m).

*Proof.* In Σ_v [Σ_i s_p(m_(v_i)) − s_p(m_v)] every vertex other than the root appears once with a plus sign (as a child), and every node appears once with a minus sign (as a parent). So everything cancels except the leaves, each contributing s_p(1) = 1, and the root, contributing −s_p(m). (For m = 1 there is no node and both sides are 0.) ∎

In words: computing m = 1 + 1 + … + 1 along the tree always makes exactly ν(m) carries, whatever the shape of the tree.

**Fact 2 (a symmetric node always carries).** If v is symmetric, its children all have the same number b of leaves, and

    c(v) = ( p·s_p(b) − s_p(pb) ) / (p−1) = s_p(b) ≥ 1.

(Adding p equal numbers shifts the number one place to the left: every unit of every digit is carried once.) Consequently a node that makes no carry is asymmetric.

**Fact 3 (the excess formula).** Let σ be the number of symmetric nodes, so d(T) = N − σ. Since t = N − ν(m),

    d(T) − t = ν(m) − σ = Σ_(v symmetric) ( s_p(b_v) − 1 ) + Σ_(v asymmetric) c(v).

Every term on the right is ≥ 0.

## Consequences

**1. Lower bound (Step 2).** d(T) ≥ t. Said directly: *there are only ν(m) carries to go round, every symmetric node uses at least one, so at most ν(m) nodes are symmetric and at least N − ν(m) = t are asymmetric.*

**2. Minimal trees (Step 3).** A sum of non-negative terms vanishes exactly when every term does. So d(T) = t **if and only if**

- (a) every asymmetric node adds the leaf counts of its children **without a carry**, and
- (b) every symmetric node has children whose number of leaves is a **power of p**.

From this one gets the description by digits. Write m = Σ_j a_j p^j in base p, so s_p(m) = Σ_j a_j.

> **Claim.** T is minimal (d = t) if and only if T is obtained from a p-ary tree S with s_p(m) leaves by replacing the leaves of S by complete trees ("atoms"), exactly a_j of them of height j. Every such S and every placement of the atoms works, and the nodes of S are then exactly the asymmetric nodes of T. In particular minimal trees exist for every m.

*Proof.* (⇒) Let T be minimal, so (a) and (b) hold.
*A child of a symmetric node is complete.* Let w be such a child, with m_w = p^j by (b); induction on j. If j = 0 it is a leaf. Otherwise w is a node with s_p(m_w) = 1. It cannot be asymmetric: by (a) it would add without a carry, so s_p(m_w) would be the sum of the digit sums of its p children, at least p > 1. So w is symmetric, its children have p^(j−1) leaves, and they are complete by induction, of the same height.
*Hence a symmetric node is itself complete* (its children are complete of equal height), and since every node of a complete tree is symmetric, no asymmetric node lies below a symmetric one. So the asymmetric nodes form a top part S of the tree, and what hangs below S are complete trees (single leaves included, as height 0).
*Which atoms.* By (a), at every node of S the j-th digit of m_v is the sum of the j-th digits of its children's leaf counts. An atom of height j has p^j leaves: digit 1 in position j. Descending from the root, the j-th digit of m is the number of atoms of height j.

(⇐) Let T be built from S and the atoms as in the claim. For a node v of S let n_j(v) be the number of atoms of height j below v. Then n_j(v) ≤ a_j ≤ p − 1, so Σ_j n_j(v) p^j is the base-p expansion of m_v; and n_j(v) is the sum of the n_j over the children of v. So the digits add column by column without a carry: c(v) = 0, and v is asymmetric by Fact 2. Inside an atom every node is symmetric with children of p^i leaves. So (a) and (b) hold and d = t. Finally a p-ary tree S with s_p(m) leaves exists, because s_p(m) ≡ m ≡ 1 (mod p−1). ∎

This is the Local characterization of the paper, and the skeleton description of its next section.

**3. A remark on symmetry groups (not needed for anything above).** Define the *symmetry group* Aut(T): the only symmetry of a leaf is the identity; a rotation isomorphism T → T′ between nodes is a shift r together with rotation isomorphisms T_(i+r) → T′_i for all i; Aut(T) is the group of rotation isomorphisms T → T. Then:

- |Aut(T)| = p^σ. (With shift 0 there are Π|Aut(T_i)| symmetries. A shift r ≠ 0 is possible only if T_(i+r) ~ T_i for all i, and as p is prime r generates Z/p, so this happens exactly when the root is symmetric; each shift then contributes Π|Aut(T_i)| again. So |Aut(T)| = p^[root symmetric]·Π|Aut(T_i)|, and induction gives p^σ.)
- Aut(T) acts faithfully on the m leaves. (A vertex is determined by the set of leaves below it, so a symmetry fixing every leaf fixes every vertex.)
- Hence Aut(T) is a p-subgroup of S_m of order p^σ, so σ ≤ v_p(m!), with equality exactly when Aut(T) is a Sylow p-subgroup of S_m. By Legendre's formula v_p(m!) = (m − s_p(m))/(p−1) = ν(m) (stated for instance in Remark 5 of reference 5 of `references/README.md`), and σ = ν(m) exactly when d = t by Fact 3. So **minimal trees are exactly the trees whose symmetry group is a Sylow p-subgroup of the symmetric group on their leaves.**

This remark is the only place in the note where a factorial appears, and it is not used: ν(m) is defined above as a number of carries.

**4. Where primality is used.** Facts 1–3 and Consequences 1–2 hold word for word for trees of any arity r ≥ 2 with base-r digits (the referee confirmed this for arity 4 and 6). That p is prime is needed only for the group order in Consequence 3 and for "a class with d asymmetric nodes has p^d trees", which is Step 1 of the paper and not part of this note.

## How to say it in the talk (30 seconds)

"Add up the leaves of the tree in base p, node by node. A carry is one trade of p units for one unit in the next column. However the tree is shaped, you make the same number of carries in total: (m minus its digit sum) over (p minus 1). A symmetric node adds p equal numbers, and that always carries. So the carries limit how many symmetric nodes a tree can have, and at least t nodes are left over; those must be asymmetric. The trees with exactly t are the ones that waste no carry, and they are the trees built from the digits of m."

## Relation to the other pictures

- **Counter (computer science).** Counting from 0 to m in base p also makes ν(m) carries; the digit sum is the potential function in the amortized analysis of a counter. Each increment adds 1 to the potential and each carry removes p − 1. Counting from 1 (a single leaf) to m, the m − 1 increments supply N = (m−1)/(p−1) units of one carry; ν(m) of them are spent on carries and t = (s_p(m) − s_p(1))/(p−1) remain stored. So **t is the potential gained between one leaf and m leaves, in units of one carry.**
- **Sand (Finding 4).** A carry is a toppling. Fact 1 is the statement that the number of topplings does not depend on their order.
- **Accounting proof.** "m! can absorb only ν(m) nodes" is Fact 3 in the labelled world.
