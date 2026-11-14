# W015 — The Frobenius / recursion proof: verify and write up

Read first: `notes/2026-11-13_new_ideas.md` (Idea 4), `notes/briefing_grad_student/briefing.tex` (original argument and notation), `CLAIMS.md`.

Idea 4 sketches a short algebraic proof of v_p(C_n^(q)) = t from the equation G = x + G^p, and several structural remarks. It is an AI sketch and may contain errors.

## Part 1 — Computation (`experiments/E005_frobenius_proof/run.py`, `output.txt`, `README.md`)

For p in {2, 3, 5, 7} (and k in {1, 2} where the statement makes sense):

1. G = x + G^p as a truncated power series; check G ≡ x + x^p + x^(p²) + … (mod p).
2. The necklace recursion c_m = [p | m]·c_(m/p)^p + p·Σ over rotation classes of non-constant p-tuples (m_1,…,m_p) of ∏ c_(m_i): verify numerically.
3. Leading coefficients: define N(m) by N(p^h) = 1 and N(m) = (1/p)·Σ over carry-free ordered p-tuples of positive integers summing to m of ∏ N(m_i). Check N(m) is an integer, c_m/p^t(m) ≡ N(m) (mod p), and N(m) = (pt)!/(t!·p^t·∏ m_j!).
4. The atom ring: in Q[u_0,…,u_J]/(u_j^p), with U = Σ u_j, verify that A = Σ_t (C_t^(p)/p^t)·U^((p−1)t+1) satisfies A = U + A^p/p, and that the coefficient of ∏ u_j^(m_j) in A is N(m). Verify the self-similarity A = λ^(−1)·G(λU), λ^(p−1) = 1/p, coefficientwise.
5. For k ≥ 2: the system F_δ = [δ ≡ 0]·x + F_(δ+1)^p (δ in Z/k); work out and test the analogue of items 2–4 with atoms carrying a class in Z/k. Say honestly how far the clean formulas survive.
6. Explore: is there a closed description of the full p-adic expansion, for example the coefficient of p^(t+1)? Report data only.

## Part 2 — Write-up (`paper/alt_proof_frobenius.tex`, compiled to `paper/build/alt_proof_frobenius.pdf`)

A self-contained 3–4 page note, first line a comment naming your model:

- The induction proof for k = 1 with every step justified (rotation of p-tuples, digit-sum inequality with the equality case, the recursion for N(m), why N(m) is prime to p). For the last step give two proofs: via the explicit formula, and via the cherry lemma, and say which facts each uses.
- The extension to general k, or a precise statement of what is missing.
- Remarks, clearly separated from the proof: the Artin–Schreier inverse; f^p = f(x^p) + p·δ(f) and the dictionary "symmetric node = Frobenius, asymmetric node = p·δ"; the self-similarity.
- Mark gaps with a red `\GAP{...}` and list them in `paper/GAPS_frobenius.md`. No literature citations.
- Compile with latexmk as in `paper/` (see tool notes in `paper/GAPS.md`).

Work in short steps and save often. Touch only `experiments/E005_frobenius_proof/`, `paper/alt_proof_frobenius.tex`, `paper/GAPS_frobenius.md` and `paper/build/`.
