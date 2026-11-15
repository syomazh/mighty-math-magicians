# W030 — Open search: new places where our method occurs (second round)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Your one output file

`notes/2026-11-14_physical_search_newfields_W030.md` (new). Write to it early and keep appending, so that nothing is lost if you are cut off. First line: which model wrote it, the date, "not human-reviewed". Edit no other file. Scripts of yours, if any, go into `experiments/E017_newfields_checks/` (new folder, with a `README.md`).

## How to search without a browser

You have no web-search tool. Use `curl` from Bash against public interfaces, with `-A "Mozilla/5.0 (research script)"`: Wikipedia (`https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=QUERY&format=json`, and `...?action=query&prop=extracts&explaintext=1&titles=TITLE&format=json`), arXiv (`https://export.arxiv.org/api/query?search_query=all:QUERY&max_results=10`), Crossref (`https://api.crossref.org/works?query=QUERY&rows=5`), OpenAlex (`https://api.openalex.org/works?search=QUERY`), Semantic Scholar (`https://api.semanticscholar.org/graph/v1/paper/search?query=QUERY&fields=title,year,venue,externalIds,abstract`), OEIS (`https://oeis.org/search?q=QUERY&fmt=json`), the Stack Exchange API (`https://api.stackexchange.com/2.3/search/advanced?q=QUERY&site=mathoverflow&filter=withbody`, add `--compressed`), Europe PMC, and plain `curl` of open pages and PDFs (use `pdftotext` if it exists; keep downloads in `experiments/E017_newfields_checks/tmp/` and delete them before you finish). Wait a second between requests; if a site answers 429 or a bot check, do not try to get around it: note it as blocked and move on. Never put a person's name from this project or the repository name into a query.

**Nothing from memory.** A statement about a field counts only if you opened a source for it in this task; say for each source whether you read the full text, an abstract, or only a record. What you recall but could not open goes into a section "leads not verified". Paraphrase; at most one short verbatim quotation in the whole report. Ideas of your own are welcome if you label them as yours and check them by a small script where a count is involved.

## The method whose echoes we are looking for

Theorem (proved by the team): for a prime p and q = p^k, the number of q-ary trees with n internal nodes (the Fuss-Catalan number binom(qn, n)/((q-1)n+1)) is divisible by p exactly to the power t = (s_p(m) - 1)/(p - 1), where m = (q-1)n+1 is the number of leaves and s_p the base-p digit sum. The proof:

- Step 0: a node with q = p^k branches is read as k levels of nodes with p branches. The group used at such a node is the iterated wreath product of cyclic groups of order p (a Sylow p-subgroup of the permutations of the q branches), not all q! permutations and not one cyclic rotation of the q branches.
- Step 1: rotating the p branches at any node sorts the trees into classes of size p^d, d being the number of asymmetric nodes (whose p branches are not all equivalent).
- Step 2: d >= t always, by subadditivity of base-p digit sums (a "carry budget").
- Step 3: the classes with d = t are built from atoms (complete trees with p^j leaves), m_j atoms of size p^j for the base-p digits m_j of m, on a skeleton of t asymmetric nodes; for q = p^k an atom of size p^j sits at a depth congruent to -j modulo k.
- Step 4: the number of such classes is not divisible by p. Proof: label the atoms, let a cyclic permutation of p labels act, count fixed points; the fixed configurations are those in which the p labelled atoms are the p branches of one node (a "cherry"), which is collapsed into one atom of the next size (a carry). Result: (number of trees)/p^t is congruent to (-1)^t / prod(m_j!) modulo p.

## Already considered: do NOT report these again

Read `notes/2026-11-14_connections_ranked.md`, section 2 (a table of 43 candidates) before you start. In short: alkyl groups, stereoisomers, symmetry numbers, conformers; phylogenetic tree balance, symmetry nodes, cherries; Sylow subgroups, wreath products, adding machine; Feynman symmetry factors; mobiles; quadtrees; stacked triangulations; binomial queues and heaps; Merkle trees; LSM trees, buddy allocator; sandpiles; Kraft; knockout tournaments; dendrimers; binary powering; laser harmonics; cell lineages; Internet checksum; McEliece; Stickelberger; Dwork; PPA-p; Horton-Strahler; Huffman; Exploding Dots; p-adic balls; Fenwick trees; Butcher trees; DNA tiles, Rule 90, Tower of Hanoi; popcount; Stockmayer; rhythm trees; hierarchical models; UTF-8; chord classes; AVL rotations.

## What to look for, in order of interest

- **A. A cyclic group of ODD prime order acting at the branch points of a tree-like object,** so that a count changes by a factor p at an asymmetric branch point. Examples for p = 2 abound; odd primes are where the theorem is new. Places to look: hierarchically assembled threefold or fivefold units (crystallography, quasicrystals, self-assembly, virus capsids, clathrin), botany (whorls), ornament and textile, music (ternary metre), puzzles, p-ary Merkle and verkle trees and tries, polar codes with p x p kernels, Reed-Muller codes and their automorphism groups, fat-tree networks, radix-p FFT flow graphs, qutrit circuits, tree tensor networks, hierarchical lattices in renormalisation, the Sierpinski gasket and its automorphisms, spin models on Cayley trees.
- **B. Prime powers q = 4, 8, 9, 16, 25, 27:** an object with q-fold branching whose natural symmetry group is the iterated wreath product (order 8 for q = 4, 81 for q = 9, 128 for q = 8), or where a condition "depth modulo k" appears. Candidates to check: Sudoku and Latin-square symmetries (bands and stacks), the Sierpinski carpet, octrees against the symmetries of the cube (known to fail: 48 against 128), bytes and nibbles, the Sylvester construction of Hadamard matrices, Walsh functions, Gray codes, self-similar groups acting on p-ary trees (Grigorchuk, Gupta-Sidki) and any counting of orbits there.
- **C. The exactness mechanism in another field:** a count decided modulo p by its most symmetric objects because all others come in families of size divisible by p. To verify with sources: necklace proofs of Fermat's little theorem and of Wilson's theorem (find the actual references often given as Petersen 1872 and Golomb 1956); Smith theory (the Euler characteristic of the fixed-point set of a Z_p action is congruent to that of the space modulo p) and any use of it in physics or chemistry; Lucas' theorem as Pascal's triangle modulo p (Sierpinski patterns) with a physical realisation; Burnside counting where the answer modulo p is read off the fully symmetric configurations.
- **D. Carries with a physical meaning for odd p or a general base:** the carry mechanism of mechanical calculators and odometers, the abacus, balanced ternary computers, molecular counters, base 60 and base 20, carry-save adders; above all any place where the NUMBER of carries is a measured cost or a conserved quantity.
- **E. Two names.** A teammate's slide credits "Petersen" and "Touchard" for the idea "count the fixed points of a p-cycle, collapse the fixed block". Find the actual sources (authors, titles, journals, years) and what they prove.

## For each new candidate

The field's own statement with the source you opened; which step (0 to 4) it contains and how literally; whether the power of p or the exactness means anything in the field; exact statement or analogy; whether practitioners would recognise it; whether one picture shows it in thirty seconds; whether a link to the divisibility of Catalan, Fuss-Catalan or binomial numbers already exists in the literature; the strongest objection.

## Shape of the report

1. The best five, ranked by: step contained (divisibility or exactness first), exactness, recognisability with a real source, picture, novelty. Two sentences each on why.
2. Everything examined, including what you rejected and why (one line each). A candidate that only shares numbers or a word is to be reported as such and ranked last.
3. Answer to E.
4. Queries that found nothing; what was blocked; leads not verified.

Finish with the honest summary that `CLAUDE.md` asks of a worker.
