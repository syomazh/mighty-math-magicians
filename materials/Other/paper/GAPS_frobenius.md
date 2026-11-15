# Gaps in W015: Frobenius / recursion proof (paper/alt_proof_frobenius.tex)

Written by moonshotai/kimi-k3.1-pro (Open Math OS worker W015), 2026-11-13.
This is an unreviewed proof draft, not a human-verified theorem.

## Gaps marked in the note

1. **Lemma `lem:Nrec` (algebraic route).** The identity (ptsum),
   `sum over carry-free tuples of prod (p t_i)!/t_i! = (p t)!/t!`,
   has no completed algebraic proof in the note. It is *equivalent* to the
   N(m) recursion, which is checked numerically in E005 for every tested m,
   and the note instead proves the recursion bijectively (Prop. `prop:K`).
2. **Lemma `lem:trees` (the K(t) bijection).** The claim that distinctly
   leaf-labelled cyclic p-ary trees with t internal nodes correspond to
   products of t p-cycles on pt points (Idea 5 of the source notes) is
   asserted via a cherry-ordering record; well-definedness and bijectivity
   are not proved in full. Everything that depends on the *closed formula*
   for N(m) therefore inherits this gap; note that E005 (item 3) verifies
   the closed formula and the N(m) recursion numerically for all tested m,
   independent of this bijection.
3. **Lemma `lem:unit` (unit via the explicit formula).** The direct
   fixed-point count for `K(t) ≡ (-1)^t (mod p)` under conjugation by a
   p-cycle is left with case (ii) unexecuted. The lemma as a proof path is
   incomplete; Lemma `lem:cherry` is the complete proof and is what the main
   theorem uses.
4. **Section on general k.** The induction of Theorem `thm:main` has not
   been translated to the depth-graded system F_delta. The valuation formula
   for k >= 2 rests on the skeleton/carry proof of the companion note, not
   on this note. The observed k-independent residue formula is supported
   only by k=2 computations (p=2,3).

## Additional caveats not marked in-line

- The cherry lemma in this note is a special case (k=1) of the one in the
  main write-up; the fixed-point analysis was reproduced here, not
  independently re-derived.
- The residue `N(m) ≡ (-1)^t / prod m_j! (mod p)` agrees with C7.
- E005 item 4 found that the multivariate self-similarity in Idea 4 of the
  source notes is exact only in the one-variable reading; this correction is
  recorded in the note (Section "The atom ring", Caveat).

## Tool and verification notes

- Compiled with `latexmk -pdf -interaction=nonstopmode -halt-on-error
  -outdir=build alt_proof_frobenius.tex` inside `paper/`, using
  `MKTEXLSR=0 TEXMFDBS='C:/Users/semyo/AppData/Local/Programs/MiKTeX/tex/latex'
  MIKTEX_AUTOINSTALL=0` (as in `paper/GAPS.md`).
- Computation: `uv run python experiments/E005_frobenius_proof/run.py`;
  2584 checks, 0 failures; raw data in `output.txt`.
- No independent reviewer (human or AI) has attacked this proof.
