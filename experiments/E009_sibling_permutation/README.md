# E009 — Labelled cyclic p-ary trees and permutations made of p-cycles

Written and run by Claude Fable 5.2 (orchestrator), 2026-11-13/14. Not human-reviewed.

- **Goal.** Test Idea 5 of `notes/2026-11-13_new_ideas.md`: a bijection between cyclic p-ary trees with s = (p−1)t + 1 labelled leaves and permutations of {1, …, pt} all of whose cycles have length p.
- **The map.** Label the internal nodes other than the root with s+1, …, pt: repeatedly take, among the internal nodes whose children are all labelled, the one whose smallest child label is least, and give it the next label. Each internal node then yields a p-cycle, the cyclic order of its children's labels. The inverse reads the cycles in the same order: at each step take, among the unused cycles all of whose entries already exist, the one with the smallest entry.
- **Why the inverse always works (argument, not yet checked by a human).** Before step i the labels 1, …, s+i−1 exist; the t−i+1 unused cycles contain only t−i labels that do not exist yet, so at least one unused cycle is ready.
- **Method.** `run.py` enumerates all trees, applies the map, checks the images are distinct and of the right cycle type, compares the count with (pt)!/(p^t·t!), and runs the inverse on every permutation of the type. Run: `uv run python experiments/E009_sibling_permutation/run.py`.
- **Results.** `output.txt`. p = 2 for t ≤ 5 (up to 945 trees), p = 3 for t ≤ 3 (up to 2240 trees), p = 5 for t ≤ 2 (72576 trees; inverse not run for t = 2, forward map injective and counts equal). **All checks pass.**
- **Analysis.** For p = 2 this is the known correspondence between rooted binary leaf-labelled trees and perfect matchings (Diaconis–Holmes 1998, per its abstract). For general p it gives the number of labelled skeleton trees as (pt)!/(p^t·t!) with no use of the Fuss–Catalan formula, hence a bijective proof of the exact count of minimal classes for q = p (claim C8).
- **Next steps.** Write the two-paragraph proof into the paper's corollary in place of the appeal to the Fuss–Catalan formula, after human review. Look for the version with the depth condition (k > 1).
