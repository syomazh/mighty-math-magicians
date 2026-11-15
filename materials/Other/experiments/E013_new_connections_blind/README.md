# E013 — checks of the "blind" hunt for new connections

- **Date:** 2026-11-14. Scripts and outputs by a Claude subagent (Claude Fable 5.2, fresh context, given only a brief with our definitions and results); this README by the orchestrator (Claude Fable 5.2), who re-ran `c12_subdivisions.py`, `c3_feynman.py` and `c4_harmonics.py` and saw them pass. Not human-reviewed.
- **Belongs to:** `notes/2026-11-14_new_connections_blind.md` (the subagent's report) and `notes/2026-11-14_motivation_and_connections.md`.

## Goal

Find connections with other fields that the orchestrator had not thought of, each with an exact statement that can be tested, and test it.

## Hypothesis

Each of the eight proposed statements follows from the facts of the main proof (class size p^d, the lower bound, the description of minimal trees, the count modulo p).

## Method

Standard library only; `uv run python experiments/E013_new_connections_blind/<script>` from the repository root; each script asserts its claims and its output is saved next to it.

| Script | Checks |
|---|---|
| `trees.py`, `classpoly.py` | helpers: enumeration of ordered p-ary trees, canonical forms, the recursion for the class-counting polynomials |
| `c12_subdivisions.py` | quadtree subdivisions of a square (q = 4) and stacked triangulations (p = 3) in a purely geometric model: orbits under "turn or mirror a block" equal our classes; sizes p^d; smallest size p^t; the valuation |
| `c1b_qary_classes.py` | the same for quadtrees up to N = 60 from a recursion; octrees and 9-ary trees |
| `c3_feynman.py` | tree diagrams of a cubic field theory: symmetry factor 2^σ, the sum of 1/S, the largest symmetry factor is the 2-part of m! and is attained an odd number of times |
| `c4_harmonics.py` | laser harmonics: the minimum number of mixing steps in a photon's history is popcount(m) − 1, for two ways of counting |
| `c5_double_and_add.py` | doubling and adding: the binary method is minimal; the bound fails with reuse of intermediate results from m = 15; in floating point a symmetric node never rounds |
| `c6_merkle_mergesort.py` | the Merkle tree of RFC 6962 is a minimal tree; merge sort (rejected) |
| `c7_lineages.py` | cell lineages: all divisions symmetric only for powers of two; otherwise at least popcount(m) − 1 |
| `c8_mobiles_necklaces.py` | the classes are the OEIS "mobiles"; Fermat's little theorem for trees; the main facts from the recursion alone for p = 2, 3, 5, 7 |
| `c9_merge_games.py` | 2048-type games (rejected: the carry budget again) |

## Results

All checks pass. One statement has a limit, found by the check itself: with reuse of intermediate results (addition chains) the bound popcount(m) − 1 fails first at m = 15.

## Analysis

The quadtree and triangle checks are the valuable ones: they find the classes by moving pictures around, with no reference to trees, and get the same families. See the report for sources and for 18 ideas that were considered and rejected.

## Next steps

A human with library access should read Etherington's 1940 paper (reference 36 in `references/README.md`).
