# Morning brief — Saturday 14 November 2026

Written by the orchestrator (Claude Fable 5.2) during the night. Last updated Saturday 00:04 PT. **If this says "pending" somewhere, check `STATE.md` and the end of `JOURNAL.md` for what happened after.**

## Where we stand, in five lines

1. We have a complete written proof of the full problem: `paper/main.pdf` (13 pages).
2. The statements have passed every computer test, including one on 1067 cases up to 400 leaves and primes up to 13.
3. Three AI reviewers found no counterexample but 14 defects in the write-up; all were repaired, and a line-by-line read found and fixed 4 more. An independent referee (a second Claude that had seen none of our notes) then judged the theorem proved modulo gaps: one wrong sentence in an example and six gaps, all needing only a missing justification or hypothesis; all repaired (`paper/reviews/ADJUDICATION_round2.md`). A third pass by another fresh reader gave the same verdict with smaller findings (two wrong sentences, six small gaps), also repaired (`ADJUDICATION_round3.md`). In three rounds nobody found a counterexample or a step needing a new idea.
4. **No human has signed anything.** That is today's job and it is the only thing that makes the result presentable.
5. Open Math OS is switched off (about a third of the allowance was left); everything since Friday 23:35 was done by Claude.

## What happened overnight

- Paper repaired and re-checked (see line 3).
- Stress test written and run by Claude: no failures (`experiments/E003_stress_test/`).
- Study guide with 16 worked exercises and a 49-question Q&A sheet written (`notes/study_guide.md`, `talk/QA.md`).
- Slides: 19 slides, compiling, with a chemistry and biology opening and a references slide (`talk/slides.pdf`, speaker notes in `talk/NOTES.md`).
- The classes of trees in our proof turn out to be known objects: stereoisomers of alkyl radicals for p = 3, shapes of evolutionary trees for p = 2 (checked in the OEIS).
- **Prior work found for p = 2 in a biology journal.** Kersting and Fischer (2021) characterise the most balanced evolutionary trees as exactly our minimal trees and count them by the same formula, without mentioning Catalan numbers. Together with Deutsch–Sagan (2006), the case p = 2 is known. We must cite both. What is ours is every prime, prime powers, and the carry–cherry count.
- Extensions checked by computer, not proved: the weighted theorem with our group; divisibility for every level profile, height, and three more statistics.
- Two further ways to see the theorem were worked out: "every node is worth −p" (a clean proof is in `paper/accounting_proof.pdf`; its lemmas pass a computer check, and an independent Claude referee found it correct apart from small gaps, now repaired) and the Frobenius view. Ranked in `FINDINGS.md`.
- A bijection between labelled skeleton trees and permutations made of p-cycles holds in every tested case (`experiments/E009_sibling_permutation/`).
- The interactive explainer works (`explainer/index.html`, open by double-click).

## What to do first

**Syoma**
1. Read "The whole proof in ten sentences" at the top of `notes/study_guide.md` (3 minutes).
2. Do exercises 2, 4, 7 and 14 on paper. These are the ones you may be asked to reproduce.
3. Flip through `talk/slides.pdf` with `talk/NOTES.md` next to it.
4. Open `explainer/index.html` and play with n; it shows the same objects.

**Grad student**
1. Read `paper/main.pdf`. Sections 2–4 are claims C1–C3; Section 5 is C4–C5; Section 6 is the theorem.
2. For each claim tell Syoma "signed" or "breaks at …"; Claude records it in `CLAIMS.md`.
3. The steps the machines got wrong at some point deserve the hardest look: the freeness of the label action (Proposition "Removing labelling"), the termination of the carries, and above all the most recently rewritten text: the lemma "Plane representatives" and the converse half of "Minimal classes are skeleton trees". The three adjudication files in `paper/reviews/` list every defect found and how it was repaired.
4. Read Theorems 3.5 and 3.9 of Kersting–Fischer (arXiv 2105.00719) and Section 2 of Deutsch–Sagan, and judge how to phrase what is new.

**Professor** (two questions)
1. Is the argument correct?
2. Have you seen the p-group action for q = p^k, or the carry–cherry count, before?

## Decisions the team needs to make today

1. **Which second viewpoint goes in the talk**, if any: the accounting one-liner C·∏m_j! ≡ (−p)^t (mod p^(t+1)), or the Frobenius remark G ≡ x + x^p + x^(p²) + … (mod p). Both are on slide 16 for now, marked as ideas.
2. **Does the accounting proof meet "without factorial valuations"?** It derives v_p(m!) from symmetry on the way. The main proof does not have this issue.
3. **How to state novelty.** Suggested wording is on the last slide and in Q&A 30–32.
4. **`problem137/orbits.py`**: who or what wrote it? It needs a line in the AI disclosure.
5. Whether to spend any remaining Open Math OS credit on one last independent review of the final paper by a non-Claude model.

## Risks

- The proof is two days old and unsigned. If the grad student finds a real hole, the fallback is honest and still good: claims C1–C2 alone give a short new proof of divisibility, and everything else becomes "verified by computer in 1067 cases".
- Novelty is not established. Do not say "new" without "as far as we could check".
- The slides have 19 pages for 20 minutes; two are optional (16 and 19).

## What Claude does next unless told otherwise

1. Nothing is running. Waiting for the humans; see the decisions above.
