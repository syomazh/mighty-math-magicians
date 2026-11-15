# W004 — Literature scan: has the exact valuation been proved combinatorially since 2007?

We have a candidate tree-symmetry proof (`notes/2026-11-13_candidate_proof_sketch.md`) of the exact p-adic valuation of Fuss–Catalan numbers for q = p^k. Before claiming anything we must know what already exists.

You have no web-search tool. Use `curl` against public scholarly APIs: OpenAlex (`https://api.openalex.org`), Crossref (`https://api.crossref.org`), the arXiv API (`http://export.arxiv.org/api/query`), Semantic Scholar Graph API (`https://api.semanticscholar.org/graph/v1`). Send no personal information: no email, no `mailto` parameter, a generic User-Agent. At most one request per second; back off on HTTP 429.

Tasks:

1. Verify the bibliographic data of the three references in `references/README.md` against Crossref (title, authors, journal, volume, issue, pages, year, DOI). Report any discrepancy.
2. Collect every work citing each of the three (OpenAlex `filter=cites:<id>`, paging through all results). Save raw JSON under `references/raw/`.
3. Run keyword searches (OpenAlex `search=` and arXiv) for: Fuss–Catalan with p-adic / valuation / divisibility; "generalized Catalan numbers" divisibility prime power; Raney numbers p-adic; combinatorial proof of Kummer's theorem by group actions; 2-adic valuation of Catalan numbers by group actions on binary trees; Sylow subgroup or wreath product acting on trees with Catalan numbers; weighted Catalan numbers divisibility; Catalan numbers modulo prime powers.
4. Write `references/literature_scan.md` with:
   (a) the verification table for the three references;
   (b) a ranked shortlist, most relevant first, of works that could overlap with any of: a group-action proof of the exact p-adic valuation of Fuss–Catalan numbers; a p-group (Sylow, cyclic rotations) acting on q-ary or p-ary trees; the residue of C_n^(q)/p^ξ modulo p; weighted generalizations. For each: the full citation exactly as the API returned it, DOI or URL, a short abstract excerpt, and one or two sentences assessing overlap risk (high / medium / low), stating that the assessment is based on title and abstract only;
   (c) the full list of citing works as a table (title, authors, year, venue, DOI);
   (d) what you could not check.

Rules: every entry must come from an API response you actually received. Never fill in bibliographic data from memory. If no abstract is available, write "no abstract available". Touch only `references/literature_scan.md` and `references/raw/`.
