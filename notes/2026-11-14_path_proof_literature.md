# Is the path proof known? Report of the literature search

Report of a fresh-context Claude Fable 5.2 agent (AI), 2026-11-14, about 18:05 to 18:25 PT, copied here unedited except that headings are moved down one level and a list of temporary local file paths is removed. Not human-reviewed. It concerns claim C24, the proof on lattice paths in `guests/andrei-claude/notes/2026-11-14_path_proof/`. The agent was given the argument (blocks of p-power length, rotations of sub-blocks, orbit sizes, the bound by carries, the count of minimal orbits, Wilson's theorem) and asked whether it is in the literature.

**Checked by the orchestrator after the report (same evening):**

- The MathOverflow answer of item 2(a) was opened through the Stack Exchange API and read: question 233956 (asked 18 March 2016), answer 234272 by Mark Wildon (22 March 2016). It is as the report describes: a direct product of n_i copies of a Sylow p-subgroup of the symmetric group of degree p^i acts on the m-subsets; for three digits with carries into positions 1 and 2 all orbits have size at least p^2; the orbits of size p^2 are counted by a product of three multinomial coefficients divided by p^2; Wilson's theorem turns that into the product of n_i!/(m_i! r_i!). The count agrees with the formula of the path note for that carry pattern (checked by hand).
- The paper of item 2(b) exists as described: Crossref gives John Howard Smith, "Combinatorial congruences from p-subgroups of the symmetric group", Graphs and Combinatorics 9 (issue 2-4), 293-304, 1993, DOI 10.1007/BF02988317, with 18 references, among them Stickelberger (1890), Rota and Sagan (1980), Sagan (1985), and a paper on the normaliser of the Sylow p-group of a symmetric group. **Its text has not been read by anyone here.** The zbMATH page could not be opened by the orchestrator (the site asked for a browser check); what the review says is known from the agent only.

**What follows for C24:** the mechanism is not new; the general statement may or may not be in Smith's paper; nothing may be called new until someone has read it.

---

## Literature report: Kummer / Anton–Stickelberger–Hensel via orbits of a Sylow p-subgroup on subsets

Nothing in the repository was edited or created. Open-access PDFs I downloaded are temporary copies in the session scratchpad.

### 1. Verdict

- **Partly known.** I found no source that proves Kummer's theorem (both halves) or the Anton–Stickelberger–Hensel congruence in general from orbits of a Sylow p-subgroup of S_N on n-subsets.
- **The mechanism is not new.** Mark Wildon's 2016 MathOverflow answer does claims 3–5 for one carry pattern, with the same group, the same minimal-orbit count and Wilson's theorem. J. H. Smith (Graphs Combin. 1993) builds the same group and applies it to binomial congruences, but I could not read its full text.
- **What looks new** relative to what I could open: the general orbit-size statement (claim 1), d ≥ c with no factorial valuations (claim 2), and the general structure and count (claims 3–4). A search that finds nothing does not prove absence, and Smith's paper is the main unresolved risk.

### 2. Closest prior work, most relevant first

**(a) Mark Wildon, MathOverflow answer 234272 (22 March 2016)** to question 233956, "On a theorem of Hensel about congruence of binomial coefficient".
- URL: https://mathoverflow.net/questions/233956/on-a-theorem-of-hensel-about-congruence-of-binomial-coefficient
- Access: opened and read in full (raw text through the Stack Exchange API).
- Content: he offers what he calls a bijective proof of an equivalent identity, for three base-p digits with carries into positions 1 and 2.
  - The group is a direct product of n_i copies of a Sylow p-subgroup of S_{p^i} on disjoint blocks, acting on m-subsets.
  - He asserts all orbits have size at least p^2, so the binomial coefficient over p^2 is congruent mod p to the number of orbits of size p^2.
  - He counts those orbits as a product of three multinomials divided by p^2, then applies Wilson's theorem to get the product of n_i!/(m_i! r_i!).
- My own check: your claim-4 formula with c_1 = c_2 = 1, c_3 = 0 reduces exactly to his expression.
- Difference: one carry pattern only, sketch level. The orbit bound is justified in one line. There is no general orbit-size theorem, no general d ≥ c, no general structure theorem, and it is not presented as a proof of Kummer's theorem or as avoiding Legendre.
- The other two answers in the thread are arithmetic (Granville's hint, factorials).

**(b) John Howard Smith, "Combinatorial congruences from p-subgroups of the symmetric group", Graphs and Combinatorics 9 (1993), no. 3, 293–304.**
- Bibliographic data: MR1245584 (AMS MR Lookup); Zbl 0784.05010. Crossref gives issue "2-4". DOI 10.1007/BF02988317.
- URLs: https://doi.org/10.1007/BF02988317 and https://zbmath.org/436565
- Access: Springer landing page (abstract and reference list) and the zbMATH review, both opened. **Full text not read**: it is paywalled and the PDF download was blocked by the permission system.
- Abstract (paraphrase): p-subgroups of the symmetric group act on subsets and other structures; most orbits have size divisible by various powers of p; this gives congruences for binomial and multinomial coefficients, including alternate proofs and sharpenings of known results.
- zbMATH review: the construction is nested blocks of sizes p^i (the reviewer's term is wheel system) with cyclic rotations of the sub-blocks of a block (spinnings). This is the same construction as your blocks and moves.
  - The review says the spinnings generate the symmetric group; the title, the abstract and item (e) below indicate a p-subgroup.
  - Results the review names: a multinomial divisibility lemma (3.5), and congruences mod p^{n+1} for idempotent maps (5.1) and surjections (5.2).
- The reference list includes Stickelberger 1890, Kazandzidis, Jacobsthal, and Davis–Webb. It does not include Kummer, Anton or Hensel.
- Earlier trace: Sagan 1985 (item f) cites a Smith preprint titled "Combinatorial congruences derived from the action of Sylow subgroups of the symmetric group" and says Smith considered wreath products.
- Difference: unknown until read. Neither the abstract nor the review mentions Kummer's theorem or the congruence in claim 5, but the Stickelberger citation means it may treat that congruence. **Obtain it through a library before the talk.**

**(c) Matjaž Konvalinka, "Divisibility of generalized Catalan numbers", J. Combin. Theory Ser. A 114 (2007), no. 6, 1089–1100.**
- Bibliographic data: Crossref and MR2337239. DOI 10.1016/j.jcta.2006.11.003.
- URL: author-hosted version at https://users.fmf.uni-lj.si/konvalinka/wcatalan.pdf
- Access: opened and read in full (author's version).
- Proposition 2 is exactly the formula of Problem 137, proved with Legendre's formula.
- Remark 3 states, without proof, the residue of C_n^(q)/p^ξ for q = p as a signed product of (p − a_i − 1)!, where a_i are the base-p digits of (p−1)n+1. This is worth checking against your claim 5.
- Proposition 7: every orbit of the full symmetry group of the complete q-ary tree, acting on q-ary trees with n vertices, has size divisible by p^ξ. The proof goes through the structure of minimal orbits (Lemmas 8–10).
- He says explicitly that this is a combinatorial proof of only the divisibility half. His proof still uses ν_p(A_i!), and exactness is taken from Proposition 2.
- Difference: trees rather than subsets; the group is not a p-group; no exactness; no count of minimal orbits.

**(d) Emeric Deutsch and Bruce E. Sagan, "Congruences for Catalan and Motzkin numbers and related sequences", J. Number Theory 117 (2006), no. 1, 191–215.**
- Bibliographic data: Crossref. arXiv:math/0407326, https://arxiv.org/abs/math/0407326
- Access: arXiv PDF opened; Section 2 read.
- Theorem 2.1: ν_2(C_n) = s_2(n+1) − 1, proved with the automorphism group of the complete binary tree (an iterated wreath product of Z_2) acting on binary trees.
- Lemma 2.3: every orbit has 2-order at least d, and exactly (2d−1)!! orbits attain it, which is odd. They note Kummer would give the result directly but they want a combinatorial proof.
- Difference: this is the full template (lower bound plus counting minimal orbits modulo p), but only for p = 2, on trees, and with no congruence beyond oddness.
- Follow-ups:
  - Postnikov–Sagan, J. Combin. Theory Ser. A 114 (2007), 970–977, arXiv:math/0601339 (abstract only).
  - Gao–Gu, arXiv:1908.03914 (Sections 1–3 read). Their Theorem 2.5 describes minimal orbits for binary trees and credits Konvalinka for q-ary trees; their Theorem 3.1 restates the Fuss–Catalan valuation.

**(e) K. I. Pimenov, I. N. Faizov, I. B. Zhukov, "О сравнениях Гаусса и Якобшталя" (On Gauss and Jacobsthal congruences), Chebyshevskii Sbornik 26 (2025), no. 4, 174–182.**
- DOI 10.22405/2226-8383-2025-26-4-174-182. PDF: https://www.chebsbornik.ru/jour/article/download/2077/1354
- Access: opened and read in full (Russian). It is the only work OpenAlex lists as citing Smith.
- They credit Smith with proposing actions of Sylow p-subgroups on colourings.
- Proposition 3.2: for the Sylow p-subgroup of S_{p^k} acting on irreducible two-colourings with b points of one colour, orbit lengths are divisible by p^{k+v_p(b)+ε}. The printed statement omits the base p; the proof makes the meaning clear.
- They state that the minimal orbit length of an irreducible colouring is open.
- Difference: N = p^k only, lower bounds for non-minimal orbits, aimed at congruences mod p^2. No Kummer, no count of minimal orbits.

**(f) Bruce E. Sagan, "Congruences via Abelian groups", J. Number Theory 20 (1985), 210–237.**
- URL: https://users.math.msu.edu/users/sagan/Papers/Old/cag-pub.pdf
- Access: scan opened; all pages read.
- Method: Möbius inversion over subgroup lattices of C_p, C_p × C_p and C_p^r, generated by disjoint p-cycles (not nested).
- Results for binomial coefficients: a mod-p recurrence giving Lucas, then congruences mod p^2 and mod p^r.
- Kummer's carry rule is only cited (via Singmaster), not proved.

**(g) Gian-Carlo Rota and Bruce Sagan, "Congruences derived from group action", European J. Combin. 1 (1980), 67–76.**
- Bibliographic data: MR576769. URL: https://users.math.msu.edu/users/bsagan/Papers/Old/cdg-pub.pdf
- Access: scan opened; all pages read.
- The cyclic group C_{p^m} acts on functions. Corollary 4.3 gives p^{m−k} dividing the binomial coefficient of p^m over i, where p^k = gcd(i, p^m). Kummer is cited for sharpness.
- This is a group-action proof of the divisibility half for N = p^m only.

**(h) Group-action proofs of Lucas' theorem.**
- Wikipedia, "Lucas's theorem" (https://en.wikipedia.org/wiki/Lucas%27s_theorem), read through the fetch tool's summary: a direct product of cyclic groups C_{p^i} rotating m_i cycles of length p^i; fixed points counted. No reference is given for that proof.
- Read as raw text: Greg Kuperberg's answer to MathOverflow 80169, Qiaochu Yuan's answer to Math.SE 3876316, and the answers to Math.SE 1463758. All use the same product of cyclic groups.
- Meštrović's survey, arXiv:1409.3820 (opened), lists Hausner 1983 and Anderson–Benjamin–Rouse 2005 as combinatorial proofs.
- None of these uses nested groups or extends to Kummer.

**(i) Helmut Wielandt, "Ein Beweis für die Existenz der Sylowgruppen", Arch. Math. 10 (1959), 401–402.**
- Access: Crossref record only (DOI 10.1007/BF01240818); original not opened.
- Expositions opened: Kammüller–Paulson, https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-452.pdf (Section 2.1 read); Kayll, CMS Notes 55(5), 2023 (fetch-tool summary).
- The lemma: the power of p dividing the binomial coefficient of p^a·m over p^a equals the power dividing m. It is proved arithmetically, factor by factor.
- The action of G on its p^a-subsets is used to find the subgroup, not to compute the valuation. So the logic runs opposite to yours.

**(j) Donald E. Knuth and Herbert S. Wilf, "The power of a prime that divides a generalized binomial coefficient", J. reine angew. Math. 396 (1989), 212–219.**
- URL: https://gdz.sub.uni-goettingen.de/id/PPN243919689_0396 (article LOG_0011)
- Access: scan opened; first three pages read.
- Purely arithmetic: it counts indices j with p^k dividing C_j, for regularly divisible sequences. No group action.

### 3. Answers to B

**Bibliographic data.** Andrew Granville, "Arithmetic properties of binomial coefficients. I. Binomial coefficients modulo prime powers", in Organic mathematics (Burnaby, BC, 1995), CMS Conf. Proc. 20, Amer. Math. Soc., Providence, RI, 1997, **pp. 253–276**.

- Sources: AMS MR Lookup (MR1483922) and zbMATH Open (Zbl 0903.11005, https://zbmath.org/1114507) both give 253–276. zbMATH's listing of the volume has the next paper starting on p. 277.
- **The note's "253–275" should be corrected.** That variant appears in Wikipedia's Lucas article and in Meštrović's survey.
- Crossref has no record of the paper. I found no citation of it on the author's own site.

**Attribution of the claim-5 congruence.** In the Introduction, at equation (1.2) of the proceedings' online version (equation (2) in the preprint), the survey says the result was "discovered by each of Anton (1869), Stickelberger (1890) and Hensel (1902)" and by many others since.
- Section 2 repeats the three names without years, for the underlying factorial identity.
- The reference list has no entries for Anton, Stickelberger, Hensel or Kummer; the reader is sent to Dickson's History, Chapter XI.
- Versions read: https://www.cecm.sfu.ca/organics/papers/granville/paper/binomial/html/node2.html (and node3, node14, node15), the author's e-survey at https://dms.umontreal.ca/~andrew/Binomial/intro.html, and a preprint scan at https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/granville-ocr.pdf. I did not see the printed volume.

**Kummer's theorem.** The Introduction gives the year 1852. Section 2 proves it from Legendre's digit-sum formula (dated 1808 there).

**Caution.** The preprint scan also restates Kummer as the number of indices with n_i < m_i, which is false (25 choose 1 with p = 5). A Math.SE answer (question 609078) reports that the published version dropped this. Do not quote that sentence.

**Other attributions seen.** Meštrović credits the congruence to Anton 1869 alone, pp. 303–306 of Archiv Math. Physik 49 (1869), 241–308, and cites Kummer as J. Reine Angew. Math. 44 (1852), 93–146, pp. 115–116.

### 4. Searches with no relevant result

**Web search:**
- combinatorial proof of Kummer's theorem, group action, Sylow p-subgroup, orbits, subsets, carries
- "Kummer's theorem" with "wreath product" / "iterated wreath product" / "k-subsets" / minimal orbit
- combinatorial or group-action proof of the Anton–Stickelberger–Hensel congruence
- p-adic valuation of binomial coefficients with rooted tree automorphisms
- Fuss–Catalan p-adic valuation with complete p-ary tree and wreath product
- exact power of p "by a group action"
- Legendre's formula, group-theoretic proof, Sylow, wreath product
- "wheel system" / "spinning" with Smith
- Wildon's blog for a write-up of his answer

**arXiv API (abstract search), all with 0 relevant hits:**
- Kummer + Sylow + binomial
- Kummer + "group action" + binomial
- Sylow + "binomial coefficients" + orbits
- Kummer + wreath
- carries + orbits + binomial
- Kummer + "combinatorial proof"
- "Fuss-Catalan" + valuation
- Sylow + subsets + congruences + binomial

**Stack Exchange API (MathOverflow and Math.SE):** about 35 queries on Kummer, carries, Sylow, orbits, Lucas with group action, Stickelberger, wreath product, Wielandt. The only relevant thread is the one in 2(a).

mathoverflow.net is not reachable by the web-search tool, so MathOverflow coverage rests on the API's keyword search, which is weak.

### 5. Leads not verified

- **Smith 1993, full text** (see 2(b)). Highest priority.
- **Ira M. Gessel, "Combinatorial proofs of congruences"**, in Enumeration and Design (Waterloo, Ont., 1982), Academic Press, 1984, 157–197 (MR782313). Record only. Sagan says it concerns groups acting on graphs. A third-party transcript of his 2010 slides (fetch-tool summary) shows cyclic groups and products, Lucas mod p^2 and p^3, and nothing on Kummer.
- **M. Hausner**, Amer. Math. Monthly 90 (1983), 127–129 (MR691183), and **Anderson–Benjamin–Rouse**, Amer. Math. Monthly 112 (2005), 266–268. Known only from Meštrović's survey; not opened.
- **D. Singmaster**, J. London Math. Soc. (2) 8 (1974), 545–548. Cited by Sagan for the multinomial carry rule; not opened.
- **L. Stickelberger**, Math. Ann. 37 (1890), 321–367, and the original papers of Anton, Hensel and Kummer. Not opened; data from other papers' reference lists.
- **Wielandt's original note.** Not opened.
- **P. Stănică, arXiv:math/0010148.** Abstract only: arithmetic divisibility of F(p^q, n) and of the binomial coefficient of p^q·n+1 over n.
- **Diaconis et al., arXiv:2504.01149** (double cosets of Sylow subgroups of S_n) and **Bamberg et al., arXiv:2102.00448.** Abstracts only; neither mentions subsets or binomial coefficients.
- **From memory, not opened:**
  - N. Loehr's textbook Bijective Combinatorics may contain a group-action proof of Lucas.
  - The literature on Young modules and p-Kostka numbers (James, Erdmann, Henke) counts fixed points of Sylow subgroups of Young subgroups on subsets, and may contain the group-theoretic skeleton of claim 4.
