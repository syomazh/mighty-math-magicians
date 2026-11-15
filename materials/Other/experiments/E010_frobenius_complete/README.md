# E010 — checks for every lemma of the Frobenius proof

- **Date:** 2026-11-14, by Claude Fable 5.2 (orchestrator). Not human-reviewed.
- **Belongs to:** `paper/frobenius_proof.tex` (the third proof, purely algebraic).

## Goal

The note `paper/frobenius_proof.tex` proves C_n^(q)·∏ m_j! ≡ (−p)^t (mod p^(t+1)) from the equation G = x + G^q alone, in six steps. This experiment tests each step separately, so that a failure would point at one lemma.

## Hypothesis

Every numbered statement of the note holds in the tested range.

## Method

`uv run python experiments/E010_frobenius_complete/run.py` (output in `output.txt`). Exact integer and rational arithmetic.

| Check | Statement of the note | How it is tested |
|---|---|---|
| L2 | Lemma "system": the deformed system F_δ = [δ=0]x + φ(F_(δ+1)) + y·θ(F_(δ+1)) has integer coefficients and F_0(x, p) = G | the system is solved with the full polynomial in y kept for every coefficient; every division by p is checked to be exact; the value at y = p is compared with binom(qn, n)/((q−1)n+1) |
| L3 | Lemma "lower bound": every monomial x^m y^d of every F_δ has (p−1)d − s_p(m) ≥ −1 | all monomials listed |
| L4a | F_δ(x, 0) = Σ x^(p^j), j ≡ −δ (mod k) | compared coefficient by coefficient |
| L4b | the weight −1 coefficients satisfy ℓ_δ = α_δ + (1/p)·(carry-free p-th power of ℓ_(δ+1)) | the carry-free product is computed literally (pairs with no carry) |
| H | the labelled system H_δ = z_(−δ) + H_(δ+1)^p / p has integer Hurwitz coefficients T_δ(a) | solved over Q in k variables |
| L5 | ℓ_δ(m)·∏ m_j! = T_δ(a(m)) | every m in range, every δ |
| P7 | carry operator: T_δ(b + p·e_c) + T_δ(b + e_(c+1)) ≡ 0 (mod p) | every b, c, δ in range |
| P8 | T_0(a) ≡ (−1)^t (mod p) if Σ a_c p^c ≡ 1 (mod q−1), and T_0(a) = 0 otherwise | every a in range |
| H4 | f^p/p is a Hurwitz series; ∂^p(f^p/p) ≡ f^(p−1)∂^p f − (∂f)^p; g^p ≡ g_0 (mod p) | random integer Hurwitz polynomials in two variables, p = 2, 3, 5, 7 |
| THM | the theorem | every admissible m in range |
| TREE | (meaning only, not used by the proof) the coefficient of x^m y^d in F_0 is the number of rotation classes with d asymmetric nodes | brute-force enumeration of classes with E000's `Orbits` |

The recursion for F is the code of E003 (same author) with the divisibility test made coefficientwise; everything else is new code.

## Results

All checks pass (`OVERALL: ALL CHECKS PASSED`): 11 parameter pairs (p, k) with p ≤ 11 and k ≤ 4, up to 100 leaves, labelled system up to degree 8–31 depending on p and k. The carry operator was tested on 6,814 triples (b, c, δ) in total, and the Hurwitz identities on about 100 random series.

## Analysis

- The check L4b is the one that could have exposed a mistake in the treatment of constant tuples or of the y-exponents; it passes for every δ, including the cases k ≥ 2 where the system couples different F_δ.
- "T_0(a) = 0 otherwise" in P8 is slightly more than the note states (the note needs only the congruence when the hypothesis holds); it is the generating-function form of the invariant Σ a_c p^c mod (q−1).
- A computer check supports the statements. It says nothing about whether the written proofs are complete; that is the job of the referee report `paper/reviews/frobenius_review_claude_fresh.md` and of the humans.

## Next steps

- Independent referee read of the note (started 2026-11-14).
- Human reading; the claim is graded in `CLAIMS.md` as C18.
