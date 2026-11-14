# W009 — Full-text overlap check of four papers

Read first: `references/literature_scan.md` (section 2), `notes/briefing_grad_student/briefing.tex` (our argument), `CLAIMS.md` (claims C1–C11), `references/README.md`.

Papers (bibliographic data as verified in `references/literature_scan.md`):

1. Yibo Gao, Andrew Gu, "Arithmetic of weighted Catalan numbers", Journal of Number Theory 226 (2021), DOI 10.1016/j.jnt.2021.03.007.
2. Christian Krattenthaler, Thomas W. Müller, "A method for determining the mod-p^k behaviour of recursive sequences", Aequationes Mathematicae 99 (2025), DOI 10.1007/s00010-025-01195-0.
3. Emeric Deutsch, Bruce E. Sagan, "Congruences for Catalan and Motzkin numbers and related sequences", Journal of Number Theory 117 (2006), DOI 10.1016/j.jnt.2005.06.005.
4. Alexander Postnikov, Bruce E. Sagan, "What power of two divides a weighted Catalan number?", JCTA 114 (2007), DOI 10.1016/j.jcta.2006.09.007.

The team has approved downloading **legal open-access copies** of these four papers only: arXiv, an author's or institution's page, or a publisher's open-access link. Find them through the Semantic Scholar Graph API (`paper/DOI:<doi>?fields=externalIds,openAccessPdf,title`) or OpenAlex (`open_access.oa_url`, `locations`). No other sites. Send no personal information, use a generic User-Agent, at most one request per second. Save PDFs under `references/raw/fulltext/` (not tracked by git) and extract text with `uv run python` and `pypdf`.

For each paper write, in `references/overlap_fulltext.md`:

- (a) where the full text came from (URL), or that no legal open copy was found;
- (b) the results that overlap our claims, with theorem/proposition numbers and at most two short quoted lines each;
- (c) the method: is a group acting on trees used? which group exactly? is the exactness of a valuation derived from an orbit count? is a residue of C_n^(q)/p^ξ modulo p given for general q = p^k?
- (d) a verdict for each of our claims C1–C11: already there / partly there / not in this paper.

Specific questions:
- Deutsch–Sagan: exactly how do they prove v_2(C_n) = s_2(n+1) − 1 combinatorially (group, orbit sizes, how minimal orbits are counted)? Does the number (2s−3)!! appear, and for what?
- Postnikov–Sagan: same questions for the weighted case; what is their analogue of our minimal classes?
- Gao–Gu: what do they prove about q-weighted or generalized Catalan numbers, and is their method orbit-based or algebraic?
- Krattenthaler–Müller: what exactly do they state about Fuss–Catalan numbers modulo prime powers? Does it contain or imply our residue formula C_n^(q)/p^t ≡ (−1)^t/∏ m_j! (mod p)?

Finish with a one-paragraph bottom line: which parts of our argument appear to be already known, which appear new **as far as these four papers go**, and what remains unchecked.

Rules: state nothing you did not read in the retrieved text. If text extraction garbles a formula, say so. Touch only `references/overlap_fulltext.md` and `references/raw/`.
