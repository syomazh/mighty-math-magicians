# References

PDFs and extracted text are kept locally in this folder and are **not committed** (copyright; the repo is public). Only this file is tracked.

## Given in the problem statement

Bibliographic data below is copied from the Mathathon problem statement. Status: **not yet independently verified** (worker W004 is checking it).

1. Matjaž Konvalinka, "Divisibility of generalized Catalan numbers", *Journal of Combinatorial Theory, Series A* 114 (2007), no. 6, 1089–1100. DOI: 10.1016/j.jcta.2006.11.003.
   Author's copy: https://users.fmf.uni-lj.si/konvalinka/wcatalan.pdf (local: `konvalinka_wcatalan.pdf`, text: `konvalinka_wcatalan.txt`). **Read in full, 2026-11-13.**
2. Emeric Deutsch and Bruce E. Sagan, "Congruences for Catalan and Motzkin numbers and related sequences", *Journal of Number Theory* 117 (2006), no. 1, 191–215. DOI: 10.1016/j.jnt.2005.06.005. **Not yet read.**
3. Alexander Postnikov and Bruce E. Sagan, "What power of two divides a weighted Catalan number?", *Journal of Combinatorial Theory, Series A* 114 (2007), no. 5, 970–977. DOI: 10.1016/j.jcta.2006.09.007. **Not yet read.**

## What Konvalinka's paper contains (our reading; page numbers are of the author's copy)

- **Proposition 2 (p. 2–3).** v_p(C_n^(q)) = (s_p((q−1)n+1) − 1)/(p−1) for q = p^k, proved with the factorial-valuation (Legendre) formula.
- **Remark 3 (p. 3).** For q = p he gives the residue of C_n^(q)/p^ξ in terms of the base-p digits; he says the general-q formula is much more complicated.
- **Weighted numbers (p. 3–4).** A vertex v of a q-ary tree gets weight b(i), i = number of non-right edges on the path from the root to v; C_n^(q)(b) = Σ_T Π_v b(i_v).
- **Theorem 5 (p. 5).** If b(0) ≡ 1 (mod q) and q^(n+1) divides Δ^n b(x) for all n ≥ 1 and x, then C_n^(q)(b) ≡ C_n^(q) (mod p^(ξ+k)).
- **Proposition 7 (p. 6).** Every orbit of G_n^(q), the full symmetry group of the complete q-ary tree of depth n, acting on q-ary trees has size divisible by p^ξ. He notes that this is a combinatorial proof of divisibility only, not of exactness.
- **Proof of Proposition 7 (p. 7–10).** Vertices are black (all branches equivalent) or white; the orbit size is a product of multinomial coefficients over white vertices; Lemmas 8, 9, 10 describe minimal orbits; the last step uses Proposition 2 to get exactness.
- **Section 4 (p. 10–12).** The conclusion of Theorem 5 fails when q is not a prime power (q = 6 examples); a conjecture for q = 2 with polynomial b.

## Literature scan

See `literature_scan.md` (produced by worker W004) once it exists.

## Added during the project (verified through public APIs)

4. Sophie Johanna Kersting and Mareike Fischer, "Measuring tree balance using symmetry nodes — A new balance index and its extremal properties", *Mathematical Biosciences* (2021). DOI: 10.1016/j.mbs.2021.108690. arXiv: 2105.00719. Title, authors, journal, year and DOI as returned by OpenAlex and Semantic Scholar on 2026-11-13; volume and pages not checked. **Read on 2026-11-13 as a web page (ar5iv), Theorems 3.5 and 3.9 and Definition 3.4.** For binary trees it contains our lower bound, our description of minimal trees and their count. See `cross_field_refs.md`.

5. Christian Krattenthaler and Thomas W. Müller, "A method for determining the mod-p^k behaviour of recursive sequences", *Aequationes Mathematicae* 99 (2025), no. 6, 2505–2547. DOI: 10.1007/s00010-025-01195-0. arXiv: 1508.02580. Fields as returned by OpenAlex on 2026-11-13 (recorded in `literature_scan.md`, section 2.3). The arXiv copy was read in full by worker W009 (`overlap_fulltext.md`, section 2); not read by a human. Cited in `paper/frobenius_proof.tex` for its "basic series" Σ z^(p^(nh)/(p^h−1)).

Other references that were verified to exist but only read in abstract are listed in `cross_field_refs.md`; they are not cited in the paper.
