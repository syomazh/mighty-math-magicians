# STATE — where we are and what is next

_Last updated: 2026-11-13 22:50 PT by Claude Fable 5.2 (orchestrator)._

## Status in one paragraph

We have a candidate proof of the full problem (exact valuation for every q = p^k, from tree symmetries, no factorial valuations) and it has passed brute-force checks, but **no human has verified it and nothing is signed**. The idea: act with rotations (Z_p) on the p-ary refinement of a q-ary tree instead of Konvalinka's full symmetric group; then every class has p^d trees, the minimal classes are trees built on the base-p digits of m, and "a carry is a collapsing cherry" shows their number is a unit mod p. Sketch: `notes/2026-11-13_candidate_proof_sketch.md`. Claims and grades: `CLAIMS.md`.

## Event and team facts

- Submit by **Sunday 2026-11-15 12:00 PT**. 20-minute talk. Criteria: motivation, correctness, interest, clarity. No written rubric.
- Presenters: Syoma (first-year undergraduate) and the grad student (combinatorics). Professor (combinatorics) is remote and may join by Zoom.
- A human must sign each claim before it is presented as proved.
- AI disclosure: a summary, able to say which tool produced what. Sources: `JOURNAL.md`, `CLAIMS.md` (Origin column), `logs/delegations/`.
- Compute: about $15k on Open Math OS (use freely); Claude budget is small (protect it: orchestration and judgment only).
- Repo is public on GitHub. Syoma approved pushing (2026-11-13 21:15); push after each work block.

## Worker runs in flight (wave 2, launched 2026-11-13 22:39)

Wave 1 outcome: W004 literature scan finished and is reviewed (see JOURNAL 22:45). W001 produced `paper/main.tex` and an 11-page `paper/build/main.pdf` before dying on a connection error; the draft is complete by its author's account and **unreviewed**. W002, W003, W005 died mid-task and are resumed below.

| Run | Output | What "done" looks like |
|---|---|---|
| W006_review_mistral / _muse / _kimi (`briefs/W006_review_*.md`) | `paper/reviews/review_{mistral,muse,kimi}.md` | a verdict (correct / gap / wrong) on every lemma of `paper/main.tex` |
| W002c (`briefs/W002b_replication_resume.md`) | `experiments/E001_independent_replication/output.txt`, `README.md` | independent code agrees with E000 on C1-C5, C7, C8 |
| W003b (`briefs/W003b_extensions_resume.md`) | `experiments/E002_extensions/output.txt`, `README.md` | C9, C10, C11 each marked supported / refuted / not tested |
| W005b (`briefs/W005b_explainer_resume.md`) | `explainer/index.html` | `node explainer/selftest.mjs` passes; five sections work |

`tools/delegate.sh` relaunches a worker that dies (up to 4 attempts), so these should survive gateway timeouts. They do **not** survive the laptop sleeping. Each run logs to `logs/delegations/<time>_<slug>/`. A run is **not trusted until reviewed**: read `output.md`, look at `git status`/`git diff`, rerun its script, then note the review in `JOURNAL.md`.

## Next actions (in order)

1. Read the three reviews in `paper/reviews/`. Adjudicate every GAP/WRONG finding (is it real?), then give a Kimi worker a repair brief for `paper/main.tex` listing the accepted findings; re-review until clean. Review W002c, W003b, W005b as they finish. Update `CLAIMS.md` grades (`computed` needs E001 agreement; `ai-proved` needs `paper/` with an empty or resolved `GAPS.md`).
2. When the reviews come back clean, grade C1–C8 `ai-reviewed` in `CLAIMS.md`, copy the PDF to `paper/main.pdf` (tracked) and send it to the grad student. Also needed: a full-text overlap check of Gao–Gu 2021, Krattenthaler–Müller 2025, Deutsch–Sagan 2006, Postnikov–Sagan 2007 (by the humans, or by a worker once Syoma allows it to download the open-access PDFs).
3. **Human gate 1** (Saturday morning): grad student reads `paper/build/main.pdf` and signs C1–C3 or reports the break. Professor is asked two questions: is the argument correct, and does he know this proof in the literature?
4. **Human gate 2** (Saturday midday): C4–C6 signed or repaired.
5. Decide extensions from E002 and the literature scan: weighted numbers (C9), level profiles (C10), master statement (C11). Each one accepted gets a section in `paper/` by a worker, then review, then sign-off.
6. Talk: worker drafts Beamer slides in `talk/` from the signed paper (outline below) and a Q&A sheet `talk/QA.md` (30 likely questions with short answers). Rehearse Saturday evening and Sunday morning.
7. AI-usage summary `AI_USAGE.md` generated from `JOURNAL.md` and `logs/delegations/INDEX.md` by a Flash worker; humans check it.
8. Freeze Sunday 10:30, submit by 11:30.

## Talk outline (proposal, 20 minutes)

1. (2 min) Why care: C_n is odd exactly when n+1 is a power of 2; in general the power of p is a digit sum. A counting fact deserves a counting proof.
2. (3 min) The existing proof and where it stops: full symmetric group, three pages of minimal-orbit lemmas, divisibility only, exactness borrowed from factorials.
3. (4 min) Rotate, don't permute: the p-ary refinement and the Z_p rotations. Every class has p^(number of asymmetric nodes) trees. Live example.
4. (4 min) Minimal trees are built from the digits of m (atoms). For p = 2: evolutionary trees whose species are the 1-bits of n+1.
5. (4 min) A carry is a collapsing cherry. Exactness, and the residue formula.
6. (2 min) What else falls out: weighted numbers, level profiles (whatever is signed by then).
7. (1 min) How AI was used and what humans verified.

## Human to-do

- **Syoma:** read the sketch; work the case p = 2, n = 6 (m = 7) by hand; decide about pushing to the public repo; ask the organizers who proposed problem 137 and whether a mentor can say if a "count fixed points of a Z_p action" argument counts as combinatorial.
- **Grad student:** read the sketch tonight or first thing Saturday; try to break Steps 3 and 4; sign or report in `CLAIMS.md`.
- **Professor:** read the sketch; opinion on correctness and on prior literature.

## Notes for whoever resumes

- Models that pass the wrapper smoke test: Kimi K3.1 Pro (default), Mistral Large 4.0, Muse Spark Open, DeepSeek Flash. GLM 5.3 is very slow; Nemotron timed out.
- Workers load `CLAUDE.md` automatically and are told there not to delegate further.
- `references/konvalinka_wcatalan.{pdf,txt}` exist only on this machine (gitignored). Re-download from the URL in `references/README.md` if missing.
