# E005 — Frobenius / recursion proof: numerical verification

- **Date:** 2026-11-13, worker W015, `moonshotai/kimi-k3.1-pro` (Open Math OS).
- **Brief:** `briefs/W015_frobenius_proof.md`, Part 1.
- **Status:** computed evidence only; not human-verified.

## Goal and hypothesis

Idea 4 of `notes/2026-11-13_new_ideas.md` proposes a proof of
`v_p(C_n^(q)) = (s_p((q-1)n+1)-1)/(p-1)` by induction from the functional
equation of the generating function. This experiment checks every identity the
proof uses, for p in {2, 3, 5, 7}, and explores the k ≥ 2 analogue.

## Method

`run.py`, exact integer/rational arithmetic (`uv run python
experiments/E005_frobenius_proof/run.py`; output in `output.txt`).

Notation: `c_m` = number of p-ary trees with m leaves, `G = sum c_m x^m = x + G^p`;
`t(m) = (s_p(m)-1)/(p-1)`; `N(m)` the leading coefficient defined by
`N(p^h) = 1` and `N(m) = (1/p) * sum_{carry-free ordered p-tuples (m_i) of
positive integers with sum m} prod N(m_i)`.

## Results (2584 checks, 0 failures)

1. **G mod p.** For all m up to 150 (p=2), 90 (p=3), 45 (p=5), 40 (p=7):
   `c_m ≡ 1 (mod p)` if m is a power of p, `c_m ≡ 0 (mod p)` otherwise.
   I.e. `G ≡ x + x^p + x^(p^2) + ... (mod p)`.
2. **Necklace recursion.** For all m up to 45 (p=2), 33 (p=3), 25 (p=5),
   22 (p=7): `c_m = [p|m] c_{m/p}^p + p * (sum over rotation classes of
   non-constant p-tuples of prod c_{m_i})`, verified by literally grouping
   tuples into rotation classes (each non-constant class has exactly p members).
3. **Leading coefficients.** For all admissible m (m ≡ 1 mod (p-1)) in the same
   ranges as item 1: the recursion for N(m) yields an **integer**;
   `c_m / p^t(m) ≡ N(m) (mod p)` (including exact divisibility by `p^t`);
   `N(m) = (pt)!/(t! p^t prod_j m_j!)` where `m = sum m_j p^j`; and
   `p ∤ N(m)`.
4. **Atom ring.** In `Q[u_0..u_J]/(u_j^p)` (J = 5, 3, 2, 2; truncated at total
   degree 25, 15, 13, 13), with `U = sum u_j` and
   `A = sum_t (C_t^(p)/p^t) U^((p-1)t+1)`:
   - `A = U + A^p/p` holds exactly as a truncated polynomial identity;
   - the coefficient of `prod u_j^{m_j}` in A equals `N(m)` for
     `m = sum m_j p^j`;
   - **one-variable self-similarity**: `c_s = C_t^(p)` for `s = (p-1)t+1`, so
     `A(U) = lam^{-1} G(lam U)` with `lam^{p-1} = 1/p` holds coefficientwise as a
     one-variable identity.
   - **Multivariate caveat (found by this experiment, not in the sketch):** the
     multivariate comparison `N(m) = c_m/p^t` is *exact* in only 3/63 monomials
     for p=2 (3/40 for p=3, 22/31 for p=5, 53/57 for p=7); in general it holds
     only **mod p** (checked: `c_m/p^t - N(m)` always has denominator prime to
     p). So self-similarity is an exact identity only after setting all
     `u_j = u`; at the multivariate level it is a congruence modulo p.
5. **k = 2 (p = 2, 3).** The system `F_delta = [delta=0] x + F_{delta+1}^p`
   (delta in Z/2) was solved to the same m-ranges. Checked:
   - `f_0[(p^2-1)n+1] = C_n^(p^2)` exactly;
   - mod p, `F_delta ≡ sum_{h ≡ -delta (mod 2)} x^(p^h)` (the Frobenius recursion);
   - no valuation anomalies: `v_p(f_0[m]) = t(m)` for every m with `f_0[m] > 0`;
   - the leading residue `f_0[m]/p^t(m) mod p` equals `N(m) mod p` in **all 50
     cases (p=2)** and **all 12 cases (p=3)**. For p=2 this agrees trivially
     (everything is 1 mod 2); for p=3 it is a nontrivial coincidence with the
     k=1 formula. Whether `f_0[m]/p^t ≡ N(m) (mod p)` for all k is **open**;
     only k=2 was tested.
6. **Next coefficient (data only).** `output.txt` tabulates, for small m,
   `(m, t, N(m) mod p^2, c_m/p^t mod p^2)`. The two columns usually differ
   already at p=2 (e.g. m=5: N=1, actual 3 mod 4). No closed description of the
   second coefficient was identified; nothing further is claimed.

## Analysis

Items 1–3 confirm every computational ingredient of the induction proof for
k = 1 written up in `paper/alt_proof_frobenius.tex`. Item 4 confirms the
atom-ring packaging and corrects an implicit overstatement in the Idea-4
sketch: its self-similarity `A = lam^{-1} G(lam U)` is exact only in the
one-variable reading; multivariately it is the mod-p congruence of item 3.
Item 5 says the recursion and Frobenius structure extend verbatim to k ≥ 2 and
that the valuation statement is unchanged, but the only evidence for a clean
*k-independent* residue formula is the k=2 data above.

## Next steps

- Human verification of the induction proof in the note.
- Decide whether the k=2 residue coincidence is worth a conjecture entry.
- No second-coefficient structure pursued (item 6 reported as data only).
