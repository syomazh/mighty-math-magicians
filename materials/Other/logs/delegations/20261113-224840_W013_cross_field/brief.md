# W013 — Cross-field lenses on the argument (biology, computer science, physics, number theory)

The team wants intuition from other fields, for the motivation and interest of a 20-minute talk. The danger is vague analogy. Your job is to separate what is **exactly true** from what is only suggestive, and to back the exact parts with computation.

Read first: `notes/briefing_grad_student/briefing.tex` (the argument), `CLAIMS.md`.

Write `notes/cross_field_angles.md` and a script `notes/cross_field_check.py` (run with `uv run python notes/cross_field_check.py`) that verifies every numerical or structural statement you label "exact".

For each lens give: a dictionary table (our object ↔ their object); statements that are exact, each with a proof sketch or a check in the script; statements that are only analogies, labelled as such; one picture idea for a slide; one sentence a speaker could say.

Lenses to develop:

1. **Phylogenetics.** Minimal classes are rooted trees whose "species" are the base-p digits of m. For p = 2 they are rooted binary trees on labelled leaves, counted by (2s−3)!!. A pair of sibling leaves is called a cherry; our carry step collapses a cherry. Work out exactly what a "cherry reduction sequence" of a skeleton tree corresponds to in the carry process, and what the multifurcating (p-ary) version is.
2. **Computer arithmetic.** A tree adds up its leaves: each node adds the leaf counts of its p subtrees. Test and, if true, state precisely this "excess = carries" identity: for a tree T with m leaves, define e(T) = d(T) − t(m). At an asymmetric root, e(T) = Σ e(T_i) + (number of carries when adding m_1,…,m_p in base p, i.e. (Σ s_p(m_i) − s_p(m))/(p−1)). At a symmetric root with subtree T_1 having m_1 leaves, e(T) = p·e(T_1) + (p−1)·t(m_1). So minimal trees are exactly the carry-free adder trees. Verify by enumeration for p in {2, 3, 5} and small sizes.
3. **Data compression / information.** A class has p^d trees, so d is the number of base-p digits needed to name a tree within its class; a symmetric node carries no information (its children can be shared, as in a hash-consed DAG). Make exact whatever is exact (for example: d(T) versus the number of distinct subtree classes) and test it.
4. **Statistical physics.** Z(y) = Σ over classes y^d is a partition function with energy d; C_n^(q) = Z(p). The p-adic valuation is the ground-state energy and exactness says the ground-state degeneracy N_min is a unit mod p. The carry step is a coarse-graining move that ends at a single leaf. State what is exact (the identities) and what is analogy (temperature, renormalization). Compute Z(y) explicitly for p = 2, n ≤ 8 and p = 3, n ≤ 5.
5. **Number theory.** Kummer's theorem says the valuation of a binomial coefficient counts carries. Explain precisely in what sense "a carry is a collapsing cherry" is a combinatorial counterpart, and where the analogy stops. Note that our carries happen modulo q − 1.

Rules: no literature citations and no claims about what is known or new (we cannot verify them here). Label every analogy as an analogy. Report honestly if a proposed "exact" statement fails in the check. End with a ranked recommendation: which two lenses are strongest for the talk and why. Touch only `notes/cross_field_angles.md` and `notes/cross_field_check.py`.
