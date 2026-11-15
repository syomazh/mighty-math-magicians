# W014 — The accounting proof: verify every lemma by brute force, then write it up

Read first: `notes/2026-11-13_new_ideas.md` (Idea 1 in full, and Idea 2), `notes/briefing_grad_student/briefing.tex` (the original argument, notation, and the carry/cherry lemma in Step 4), `CLAIMS.md`.

Idea 1 is an alternative proof of v_p(C_n^(q)) = t by double counting leaf-labelled trees. It is a sketch by an AI and may contain errors. Your job has two parts.

## Part 1 — Brute force (`experiments/E004_accounting_proof/run.py`, `output.txt`, `README.md`)

Test each lemma separately with explicit objects, for p in {2, 3, 5}, k in {1, 2}, and m as large as is feasible (labelled objects grow fast; go as far as a few minutes allow).

- **L1.** Enumerate leaf-labelled k-blocked p-ary trees with m leaves, compute rotation classes explicitly, check every class has exactly p^N(m) members and that the number of labelled trees is m!·C_n^(q).
- **L2.** L(m) := number of classes. Check L(m) ≡ (−1)^N(m) (mod p). Also, for larger m, check it through the formula L(m) = m!·C_n^(q)/p^N(m). For small cases apply the label p-cycle explicitly and verify the fixed classes are exactly the cherry classes, (p−1) arrangements each.
- **L3.** Enumerate digit-forest structures on {1..m} explicitly for small m; check |𝔉(m)| = m!/(p^ν(m)·∏ m_j!), the recursion |𝔉(m)| = binom(m, m_0)·K(⌊m/p⌋)·|𝔉(⌊m/p⌋)|, K(a) = (pa)!/(p^a a!), K(a) ≡ (−1)^a, binom(p·m'+m_0, m_0) ≡ 1, and |𝔉(m)| ≡ (−1)^ν(m) (mod p). Check the stabilizer order claim on examples.
- **Theorem.** C_n^(q)·∏ m_j! ≡ (−p)^t (mod p^(t+1)) over a large range (p ≤ 13, k ≤ 4, n ≤ 200).
- **Idea 2.** Simulate the toppling rule on the half-line and on the ring Z/k from m grains at site 0: number of topplings ν(m) and N(m); independence of toppling order (try random orders); final states; the conserved quantity. Compute the cokernel of the toppling matrix on the ring (Smith normal form with sympy) for small p, k and compare with Z/(p^k − 1).

Report every failure verbatim. Do not alter a check to make it pass.

## Part 2 — Write-up (`paper/alt_proof_accounting.tex`, compiled to `paper/build/alt_proof_accounting.pdf`)

A self-contained 3–5 page note with full proofs of L1, L2, L3 and the theorem, for general k. First line a comment naming your model. Requirements:

- Define leaf-labelled cyclic trees and digit-forest structures precisely.
- L3: prove transitivity and the stabilizer order; prove the recursion; prove binom ≡ 1 and K(a) ≡ (−1)^a by explicit Z_p-actions (no Lucas, no Wilson quoted as a black box: prove what you use in a line or two).
- State clearly, in a remark, that this proof computes v_p(m!) along the way (by symmetry, not by Legendre's formula), and how it relates to the original proof (digit forest = atoms, the remaining t nodes = skeleton).
- A closing section "Sand on a ring and on a line" stating Idea 2 as a proposition with proof, including the abelian property.
- Mark any step you cannot fully justify with a red `\GAP{...}` and list it in `paper/GAPS_accounting.md`. Do not paper over gaps; do not silently change statements.
- Compile with `cd paper && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build alt_proof_accounting.tex` (see the tool notes in `paper/GAPS.md` if MiKTeX stalls).

Work in short steps and save often. Touch only `experiments/E004_accounting_proof/`, `paper/alt_proof_accounting.tex`, `paper/GAPS_accounting.md` and `paper/build/`.
