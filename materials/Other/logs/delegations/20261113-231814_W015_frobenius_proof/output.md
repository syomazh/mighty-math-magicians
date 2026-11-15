Done. Summary of the W015 task:

## What I did

**Part 1 — Computation** (`experiments/E005_frobenius_proof/`): `run.py`, `output.txt`, `README.md`. **2584 exact checks, 0 failures**, for p ∈ {2,3,5,7}:
1. G ≡ x + x^p + x^{p²} + … (mod p) — verified.
2. Necklace recursion c_m = [p|m]c_{m/p}^p + p·Σ(rotation classes) — verified by literal rotation grouping.
3. N(m) recursion gives integers, c_m/p^t ≡ N(m) (mod p), N(m) = (pt)!/(t!p^t∏m_j!), p∤N(m) — all verified.
4. Atom ring: A = U + A^p/p exact; coefficient of ∏u_j^{m_j} = N(m); one-variable self-similarity exact. **Found a correction to the Idea-4 sketch:** multivariately N(m) = c_m/p^t holds only mod p, not as rationals — so self-similarity is exact only in the one-variable sense.
5. k=2 (p=2,3): F_δ system matches Fuss–Catalan exactly; Frobenius recursion verified; no valuation anomalies; the leading residue equals N(m) mod p in all 50 (p=2) and 12 (p=3) cases — the clean formulas survive in tested cases, k-independent residue formula left open.
6. Next-coefficient data tabulated only; no closed structure identified.

**Part 2 — Write-up** (`paper/alt_proof_frobenius.tex` → `paper/build/alt_proof_frobenius.pdf`, 6 pages, compiles cleanly): rotation grouping, digit-sum inequality with equality case, main induction (no factorial valuations), two proofs of p∤N(m) as requested, atom ring, Artin–Schreier/δ/self-similarity remarks separated, k≥2 section. `paper/GAPS_frobenius.md` lists everything.

## What I could not do / left as gaps (marked red in the note)
- Algebraic proof of the factorial identity behind the N(m) recursion — replaced by the bijective tree route.
- The K(t) tree↔p-cycle bijection (Idea 5) is asserted, not fully proved.
- Lemma "unit via explicit formula" fixed-point case (ii) unexecuted — the cherry-lemma proof is the complete one.
- k≥2 induction not translated (only k=2 numerics).

## Not verified
No independent reviewer attacked the proof; no human sign-off. Amendments to STATE/CLAIMS/JOURNAL left to the orchestrator (worker scope). Note: `paper/alt_proof_frobenius.tex` already existed in git before my run — I overwrote it as the brief directs; the earlier version is in HEAD if needed.
