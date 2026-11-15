# W016 — Verify the cross-field links: OEIS, chemistry, phylogenetics, sandpiles, tree automorphisms

Read first: `notes/2026-11-13_new_ideas.md` (Ideas 2, 3, 5), `notes/briefing_grad_student/briefing.tex`, `experiments/E000_first_sanity_check/output.txt`.

The ideas file contains leads written from an AI's memory. Some may be wrong. Your job is to confirm or refute each with data from public APIs, never from memory. Tools: `curl` against the OEIS (`https://oeis.org/search?q=<terms>&fmt=json`, `https://oeis.org/search?q=id:A000625&fmt=json`), Crossref, OpenAlex, Semantic Scholar Graph API. Generic User-Agent, no personal information, at most one request per second. **Do not download paper PDFs** in this task: titles, abstracts and OEIS entries only.

## Part 1 — OEIS reconnaissance (`notes/oeis_recon.md`, `experiments/E006_oeis/run.py`)

Compute (your own code, or reuse `experiments/E000_first_sanity_check/check.py`'s class `Orbits`) and look up in the OEIS:

- number of rotation classes of q-ary trees by n, for (p,k) = (2,1), (3,1), (5,1), (7,1), (2,2), (3,2), (2,3);
- number of minimal classes N_min by n for the same cases;
- for p = 2 and p = 3: the triangle N_d (classes by number of asymmetric nodes), row sums and columns; the number of classes with d = 0, 1, 2;
- labelled counts: T for k = 1, i.e. (pt)!/(t!·p^t), for p = 2, 3, 5;
- anything else natural (classes by number of leaves m for p-ary trees not required to be blocked).

For each hit give the A-number, the exact name, and any comment or reference in the entry that mentions chemistry, biology, physics or computer science. For each sequence with no hit, say so.

## Part 2 — Verify the named leads (`references/cross_field_refs.md`)

For each lead: find the paper through the APIs, record the citation exactly as returned, a short abstract excerpt, and say precisely what in it relates to our objects. Mark every assessment "from title and abstract only". If you cannot find it, say so; do not guess.

1. Pólya's enumeration of chemical compounds (1937): the counting series for alkyl radicals with stereoisomers. Using only what the OEIS entry A000625 states (formulas, comments), confirm numerically that its recursion matches our class count for p = 3, and write the precise dictionary (carbon ↔ node, etc.), including the indexing shift.
2. Wedderburn–Etherington numbers (A001190) and their use for shapes of phylogenetic trees.
3. A tree-balance index in phylogenetics based on "symmetry nodes" (search OpenAlex for: symmetry nodes tree balance index). Does the abstract state the minimum of the index, and is it related to the binary weight of the number of leaves? This would correspond to our lower bound d(T) ≥ s_2(m) − 1 for p = 2.
4. A correspondence between perfect matchings and phylogenetic (rooted binary leaf-labelled) trees (search: matchings phylogenetic trees). Who, where, what exactly?
5. The abelian sandpile model / chip-firing: one or two standard references establishing the abelian property and the sandpile group; and whether "chip-firing and carries / base-p arithmetic" appears in the literature (search and report).
6. The "adding machine" or odometer as an automorphism of the rooted p-ary tree, and the Sylow p-subgroup of the symmetric group S_(p^h) as an iterated wreath product of cyclic groups (Kaloujnine). Find verified citations.

## Part 3 — Two exact checks (`experiments/E006_oeis/run.py`, reported in `notes/oeis_recon.md`)

- The odometer: for p in {2, 3} and h ≤ 4, write "add 1 mod p^h" on the leaves of the complete p-ary tree (leaves indexed by base-p digits) as a product of rotations at nodes; confirm it lies in the rotation group and describe which nodes rotate (carry pattern). Confirm the rotation group of the complete tree of height h has order p^((p^h − 1)/(p − 1)).
- Idea 5: for p = 2 (s ≤ 6 leaves) and p = 3 (s ≤ 7), enumerate labelled cyclic p-ary trees, apply the proposed map to permutations with t cycles of length p, and test whether it is a bijection. If the proposed canonical labelling fails, try the obvious variants and report which, if any, works.

Touch only `notes/oeis_recon.md`, `references/cross_field_refs.md`, `references/raw/` and `experiments/E006_oeis/`.
