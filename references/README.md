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

## Added on 2026-11-14 (cross-field links and the Frobenius note)

Every field below is copied from `notes/2026-11-14_crossfield_literature.md`, written by a Claude subagent that looked each item up through Crossref, OpenAlex, arXiv or the publisher's page on 2026-11-14. That file says, item by item, which source gave which field and what was actually read (in most cases an abstract or an arXiv HTML rendering, not the published article). **None of these has been read by a human on the team.** Fields the check could not confirm are marked.

6. Manuel Kauers, Christian Krattenthaler and Thomas W. Müller, "A Method for Determining the Mod-2^k Behaviour of Recursive Sequences, with Applications to Subgroup Counting", *The Electronic Journal of Combinatorics* 18 (2) (2012), Article P37. DOI: 10.37236/2433. arXiv: 1107.2015. Read (arXiv HTML): introduction, Proposition 2, Theorem 13. *Why it matters:* together with reference 5 it already contains the relation Φ^p − Φ + z ≡ 0 (mod p) for Φ = Σ z^(p^n) and its use for Fuss–Catalan generating functions. The "modulo p" starting point of our Frobenius note is therefore known and is credited to these two papers there.
7. Bhargav Bhatt and Peter Scholze, "Prisms and prismatic cohomology", *Annals of Mathematics* 196 (3) (2022), 1135–1275. DOI: 10.4007/annals.2022.196.3.5. arXiv: 1905.08229. Read (arXiv HTML): Definition 2.1, Remarks 1.2, 2.2, 2.4, 2.7, Example 2.6. *Used for:* the definition of a δ-ring with its sign convention, φ(x) = x^p + p·δ(x). They attribute the notion to A. Joyal, "δ-anneaux et vecteurs de Witt", C. R. Math. Rep. Acad. Sci. Canada 7 (1985), no. 3, 177–182 (this citation rests on their reference list only; no Crossref or OpenAlex record was found), and the name "p-derivation" to reference 8.
8. Alexandru Buium, "Arithmetic Analogues of Derivations", *Journal of Algebra* 198 (1) (1997), 290–299. DOI: 10.1006/jabr.1997.7177. Bibliographic data only; content not read.
9. Jean Vuillemin, "A data structure for manipulating priority queues", *Communications of the ACM* 21 (4) (1978), 309–315. DOI: 10.1145/359460.359478. Abstract only. The two facts we use about binomial heaps (one tree per binary digit 1; merging works like binary addition, a link being a carry) were found stated explicitly only in course notes and on Wikipedia, not in an opened primary source.
10. Ralf Hinze, "Explaining binomial heaps", *Journal of Functional Programming* 9 (1) (1999), 93–104. DOI: 10.1017/S0956796899003317. Abstract only: derives binomial heaps from the metaphor of a tennis tournament.
11. Michael K. Gilson and Karl K. Irikura, "Symmetry Numbers for Rigid, Flexible, and Fluxional Molecules: Theory and Applications", *The Journal of Physical Chemistry B* 114 (49) (2010), 16304–16317. DOI: 10.1021/jp110434s. Author manuscript read in full by the subagent. A correction exists (J. Phys. Chem. B 117 (10) (2013), 3061, DOI 10.1021/jp401194k), not read. *Used for:* the symmetry number is the order of a group of atom permutations; it lowers the entropy by R·ln σ; a freely rotating methyl group contributes a factor 3; the number is a product over rotors only when the rotors are independent.
12. Antonio Fernández-Ramos, Benjamin A. Ellingson, Rubén Meana-Pañeda, Jorge M. C. Marques and Donald G. Truhlar, "Symmetry numbers and chemical reaction rates", *Theoretical Chemistry Accounts* 118 (4) (2007), 813–826. DOI: 10.1007/s00214-007-0328-0. Abstract only; it does not state the three facts of reference 11.
13. Anatoly N. Kochubei, "Dwork–Carlitz exponential and overconvergence for additive functions in positive characteristic", *International Journal of Number Theory* 4 (3) (2008), 453–460. DOI: 10.1142/S1793042108001444. arXiv: math/0607760. Introduction read. *Used for:* π is a root of z^(p−1) + p = 0; the power series of exp(π(t − t^p)) converges for |t| < p^((p−1)/p²), which is larger than 1; its value at 1 is a primitive p-th root of unity; the closed formula must not be used by substitution outside the unit disc. The standard textbook sources (Koblitz, GTM 58; Robert, GTM 198) were not opened.
14. Régis Blache, "A Stickelberger theorem for p-adic Gauss sums", *Acta Arithmetica* 118 (1) (2005), 11–26. DOI: 10.4064/aa118-1-2. arXiv: math/0303226. Introduction and Section 1 read. *Used for:* the form in which it quotes Stickelberger's congruence for Gauss sums (leading term −π^(digit sum)/∏ digit factorials, with π = ζ_p − 1), which has the shape of our residue formula.
15. R. Rammal, G. Toulouse and M. A. Virasoro, "Ultrametricity for physicists", *Reviews of Modern Physics* 58 (3) (1986), 765–788. DOI: 10.1103/RevModPhys.58.765. Abstract only.
16. É. Yu. Lerner and M. D. Missarov, "Scalar models of p-adic quantum field theory and hierarchical models", *Theoretical and Mathematical Physics* 78 (2) (1989), 177–184. DOI: 10.1007/BF01018683. Abstract only: establishes a connection between scalar field models on the p-adic line and hierarchical models. (That the hierarchical model goes back to F. J. Dyson, *Communications in Mathematical Physics* 12 (2) (1969), 91–107, DOI 10.1007/BF01645907, was confirmed only through a later review; Dyson's abstract does not use the word.)

OEIS entries read on 2026-11-14 (same file, item 3): A001190 has no comment about knockout tournaments; A096351 and A268289 record, for the balanced bracket, that the number of labelled brackets is n!/2^(number of nodes with two equal halves).
