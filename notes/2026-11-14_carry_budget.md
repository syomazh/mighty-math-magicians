# The carry budget: Step 2 and Step 3 of the main proof from one identity

- **Date:** 2026-11-14, about 09:35 PT
- **Author:** Claude Fable 5.2 (AI, orchestrator). Found while looking for a "counter" reading of the proof.
- **Status:** `ai-proved` (the proof below) and `computed` (`experiments/E011_crossfield_checks/excess.py`: all 1,978 rotation classes of p-ary trees with up to 13–19 leaves, p = 2, 3, 5, 7). Not reviewed by another reader. Not human-verified.
- **What it is for:** a more intuitive way to *say* Step 2 (the lower bound) and Step 3 (which trees are minimal). It proves the same statements as Propositions "Lower bound" and "Local characterization" of `paper/main.tex`. The paper is not changed; this is a second way to see them, for the talk and for the oral questions.

## Setting

p prime. T a p-ary tree with m leaves. For a node v, m_v is the number of leaves below it. N = (m−1)/(p−1) is the number of nodes (internal vertices). s_p is the base-p digit sum, t = (s_p(m)−1)/(p−1). A node is *symmetric* if its p subtrees are rotation-equivalent, *asymmetric* otherwise; d(T) is the number of asymmetric nodes.

**Carries at a node.** At a node v with children v_1, …, v_p, add the numbers m_(v_1), …, m_(v_p) in base p. The number of carries made is

    c(v) = ( s_p(m_(v_1)) + … + s_p(m_(v_p)) − s_p(m_v) ) / (p−1)  ≥ 0,

because each carry replaces p units in one column by 1 unit in the next, which lowers the digit sum by p−1 (the digit lemma of the paper).

## The three facts

**Fact 1 (the budget is fixed).** For every tree with m leaves,

    Σ_v c(v) = (m − s_p(m)) / (p−1) =: ν(m).

*Proof.* In Σ_v [Σ_i s_p(m_(v_i)) − s_p(m_v)] every vertex other than the root appears once with a plus sign (as a child), and every node appears once with a minus sign (as a parent). So everything cancels except the leaves, each contributing s_p(1) = 1, and the root, contributing −s_p(m). ∎

In words: computing m = 1 + 1 + … + 1 along the tree always makes exactly ν(m) carries, whatever the shape of the tree.

**Fact 2 (a symmetric node always carries).** If v is symmetric, its children all have the same number b of leaves, and

    c(v) = ( p·s_p(b) − s_p(pb) ) / (p−1) = s_p(b) ≥ 1.

(Adding p equal numbers shifts the number one place to the left: every unit of every digit is carried once.)

**Fact 3 (the excess formula).** Let σ be the number of symmetric nodes, so d(T) = N − σ. Since t = N − ν(m),

    d(T) − t = ν(m) − σ = Σ_(v symmetric) ( s_p(b_v) − 1 ) + Σ_(v asymmetric) c(v).

Every term on the right is ≥ 0.

## Consequences

1. **Lower bound (Step 2).** d(T) ≥ t. Said directly: *there are only ν(m) carries to go round, every symmetric node uses at least one, so at most ν(m) nodes are symmetric and at least N − ν(m) = t are asymmetric.*

2. **Minimal trees (Step 3).** d(T) = t exactly when every term vanishes:
   - every asymmetric node adds the leaf counts of its children **without a carry**;
   - every symmetric node has children whose number of leaves is a **power of p**.

   In that case the subtree below a child w of a symmetric node is complete. (Induction on j, where m_w = p^j: if j = 0 it is a leaf. Otherwise w is a node with s_p(m_w) = 1; it cannot be asymmetric, because a carry-free sum of p positive numbers has digit sum at least p > 1; so it is symmetric with children of p^(j−1) leaves, complete by induction and equivalent to each other.) So a minimal tree is a skeleton of carry-free asymmetric nodes whose leaves are complete trees, the "atoms". This is the Local characterization of the paper.

3. **No factorial is involved.** ν(m) is defined here as (m − s_p(m))/(p−1), the number of carries. It happens to equal v_p(m!) (Legendre), which is why the bound σ ≤ ν(m) can also be read as: the symmetry group of a tree, a p-group of order p^σ acting faithfully on the m leaves, is no larger than a Sylow p-subgroup of S_m. Minimal trees are exactly the trees whose symmetry group *is* a Sylow p-subgroup. Neither statement is needed for the proof.

## How to say it in the talk (30 seconds)

"Add up the leaves of the tree in base p, node by node. However the tree is shaped, you make the same number of carries in total: (m minus its digit sum) over (p minus 1). A symmetric node adds p equal numbers, and that always carries. So the carries limit how many symmetric nodes a tree can have, and what is left over, t nodes, must be asymmetric. The trees that waste no carry are the ones built from the digits of m."

## Relation to the other pictures

- **Counter (computer science).** Counting from 0 to m in base p also makes ν(m) carries; the digit sum is the potential function of the amortized analysis of a counter. t is the potential still stored in the digits of m, in units of one carry.
- **Sand (Finding 4).** A carry is a toppling. Fact 1 is the statement that the number of topplings does not depend on their order.
- **Accounting proof.** "m! can absorb only ν(m) nodes" is Fact 3 in the labelled world.
