# guests/andrei-claude

Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.
Nothing here is part of the team's record (see `AGENTS.md`).

## Asked to do

Andrei asked, in chat: the Fuss–Catalan numbers also count lattice paths (paths under a line; all paths from (0, (q−1)n+1) to (n, 0) up to cyclic shift). Find a combinatorial/symmetry proof of the theorem in terms of such paths, write it in a PDF with graphic examples like those in the slides, and open a pull request.

## Done

- **A proof on paths**, `notes/2026-11-14_path_proof/path_proof.pdf` (9 pages, 5 figures; source `path_proof.tex`, figures from `gen_figs.py`).
  Cut a path of N = qn+1 steps into segments of p-power length (the base-p digits of N) and rotate the p sub-segments of any segment. Classes have size p^d, d ≥ (number of carries of n + m in base p) = t, a minimal path has exactly one mixed segment for each carry, and the minimal classes are counted by an explicit product, which Wilson's theorem evaluates modulo p. This gives C6 and C7 of `CLAIMS.md`. No cherry collapse is used.
- **Checks**, `experiments/path_segments/` (three scripts, standard library only, output in `output.txt`): every step of the proof by brute force, 456 binomial cases (N ≤ 16; p = 2, 3, 5) and 34 Fuss–Catalan cases (q ∈ {2, 3, 4, 5, 7, 8, 9}, N ≤ 28).
- Proposed claims in `CLAIMS_PROPOSED.md`, two proposals in `PROPOSALS.md`.

## Not done, not verified

- **No review.** The proof is `ai-proved` at most. No other model and no fresh agent has tried to break it. No person has signed it.
- **The group acts on the N·C paths, not on the C trees or on the C classes of cyclic shifts.** The step from binom(qn+1, n) to C uses the free cyclic shift and N ≡ 1 (mod p). The argument is a proof of Kummer's theorem and of the Anton–Stickelberger–Hensel congruence for all binomial coefficients, specialised to binom(qn+1, n). Whether that answers Problem 137 ("tree symmetries") is for the team to judge; the note says so in its Remarks.
- **Novelty not established.** Two web searches found no group-action proof of Kummer's theorem with nested rotations. That is not a literature search.
- **Sources.** Granville's survey: only the introduction of the online version was read; its bibliographic data was taken from a Wikipedia page. Kaloujnine and Giannelli–Law are quoted from `references/README.md` (entries 43, 44) and were not opened by me.
- **Not read at this commit (487bdaf):** `paper/main.tex`, `paper/accounting_proof.tex`, `paper/frobenius_proof.tex`, `lean/README.md`. The comparison table in the note rests on the talk slides and on `main.pdf` and `accounting_proof.pdf` as Andrei attached them earlier in the chat. I did not check whether the path proof overlaps with the accounting or the Frobenius proof.
- The cycle lemma (paths under the line) is quoted without proof and without a source; it is not used in the proof, and was checked by script for 8 pairs (q, n).
