# STATE — where we are and what is next

_Last updated: 2026-11-13 23:55 PT by Claude Fable 5.2 (orchestrator)._

## Status in one paragraph

We have a candidate proof of the full problem (exact valuation for every q = p^k from tree symmetries, no factorial valuations). Evidence: brute force (E000), a no-assumption stress test on 1067 values of m up to 400 leaves, p up to 13, k up to 4 (E003, all checks pass), and three adversarial AI reviews that found no counterexample but 14 write-up defects (`paper/reviews/ADJUDICATION_round1.md`). A worker has revised `paper/main.tex` (`paper/CHANGES_round1.md`); **the revision is not yet checked**. **No human has signed anything.** The ranked digest for humans is `FINDINGS.md`.

## Operating mode since 2026-11-13 23:35 (Syoma's instructions)

- **Open Math OS is being phased out.** About 36% of its allowance was left. No new workers. One worker (W014, accounting proof) was still running at 23:55 and is allowed to finish. By Saturday morning all work is done by Claude.
- **Claude does everything:** code, numerics, LaTeX, reviews (use a fresh-context Claude subagent via the Agent tool when an independent read is needed), documents.
- **Overnight:** the orchestrator works through the queue below without waiting for humans. A recurring in-session cron job re-triggers the session every 30 minutes if it is idle, so work resumes after a Claude usage-limit reset. A small background process asks Windows not to idle-sleep while the app is open. Both are listed under "Overnight machinery".
- Commit and push after every queue item. Journal every item.

## Overnight queue (do in order; mark each DONE with the time when finished)

- [x] **Q1 — Verify the repaired paper.** DONE 23:42 (all 14 repairs confirmed; four further defects found and fixed; see paper/reviews/round2_orchestrator.md). For each item A1–A14 of `paper/reviews/ADJUDICATION_round1.md`, read the repaired passage of `paper/main.tex` and decide fixed / not fixed. Fix remaining defects directly in the `.tex`. Compile (`cd paper && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex`), copy `build/main.pdf` to `paper/main.pdf`. Write the result to `paper/reviews/round2_orchestrator.md`.
- [ ] **Q2 — Independent second review.** (fresh-context Claude subagent launched 23:43; when it reports, adjudicate.) Launch one fresh-context Claude subagent (Agent tool) with the brief `briefs/_held/W022_round2_kimi.md`, report to `paper/reviews/round2_claude_fresh.md`. Adjudicate, fix, recompile. When no GAP or WRONG remains, set C1–C8 to `ai-reviewed` in `CLAIMS.md`.
- [x] **Q3 — Study guide and Q&A.** DONE 23:45 (written by the orchestrator; notes/study_guide.md with 16 exercises, talk/QA.md with 49 questions, check script runs in under a second). Write `notes/study_guide.md` and `talk/QA.md` as specified in `briefs/W011_qa_and_study_guide.md` and `briefs/W011b_qa_study_guide_finish.md`. Make `notes/study_guide_check.py` run in under 30 seconds and agree with the guide.
- [ ] **Q4 — Fold in finished worker output.** (E002, E005, Muse blind search folded into CLAIMS and FINDINGS at 23:55; still to do: W014 accounting proof when it finishes.) Review and record in `CLAIMS.md`/`FINDINGS.md`: E004 + `paper/alt_proof_accounting.tex` (W014; if the worker died, finish the write-up from `notes/2026-11-13_new_ideas.md`), E005 + `paper/alt_proof_frobenius.tex` (W015), `notes/blind_proof_search_muse.md` (W018), `experiments/E002_extensions/README.md` (C9, C10, C11).
- [x] **Q5 — Slides.** DONE 23:51 (18 slides, no overfull boxes; hook slide and a two-more-ways slide added; speaker notes extended). `talk/slides.pdf` compiles (two overfull boxes). Read every page, fix layout, add the chemistry/biology hook (Finding 3) and, if C12/C13 hold up, one slide "every node is worth −p". Keep the `\claimstatus` tags until humans sign.
- [x] **Q6 — Cross-field verification with curl** DONE 23:51 (notes/oeis_recon.md, references/cross_field_refs.md). (no PDFs): OEIS lookups for the class-count and N_min sequences printed in `experiments/E003_stress_test/output.txt`; Crossref/OpenAlex checks of the leads in Part 2 of `briefs/W016_crossfield_verify.md`. Write `notes/oeis_recon.md` and `references/cross_field_refs.md`.
- [x] **Q7 — Refinements numerics.** DONE 23:52 (experiments/E007_refinements: five statistics, all checks pass; part B, non-prime-power q, not done). Part A of `briefs/W017_refinements_and_general_q.md` with an own script in `experiments/E007_refinements/`; update C10, C11.
- [x] **Q8 — Explainer (optional).** DONE 23:53 (the stopped worker had already repaired it: selftest passes; page opened in the built-in browser and all five sections render; the bar chart in section 2 should be looked at once in a normal browser). Make `node explainer/selftest.mjs` pass following `briefs/W005c_explainer_reduced.md`.
- [ ] **Q9 — Morning brief.** (draft written 23:55 in MORNING_BRIEF.md, AI_USAGE.md written; to finish: update both after Q2 and Q4, refresh FINDINGS.md, add the p = 2 prior-work remark and citations to paper/main.tex once the referee is done, then delete the cron job.) Write `MORNING_BRIEF.md` for the humans: what happened overnight, what to read first (in order), exactly what needs a signature. Refresh `FINDINGS.md`. Write `AI_USAGE.md` (which tool did what) from `JOURNAL.md`, `CLAIMS.md` and `logs/delegations/INDEX.md`. Then delete the cron job.

## Event and team facts

- Submit by **Sunday 2026-11-15 12:00 PT**. 20-minute talk. Criteria: motivation, correctness, interest, clarity.
- Presenters: Syoma (first-year undergraduate) and the grad student (combinatorics). Professor (combinatorics) is remote.
- A human must sign each claim before it is presented as proved. The grad student has the briefing PDF (`notes/briefing_grad_student/`); the professor was sent the link.
- AI disclosure: a summary, able to say which tool produced what. Sources: `JOURNAL.md`, `CLAIMS.md`, `logs/delegations/`.
- Repo is public; Syoma approved pushing.
- Syoma approved downloading open-access copies of four papers only (Gao–Gu, Krattenthaler–Müller, Deutsch–Sagan, Postnikov–Sagan); they are in `references/raw/fulltext/` (not tracked).

## Human gates (Saturday)

1. Morning: grad student reads the briefing and then `paper/main.pdf`; signs C1–C3 or reports the break. Professor: is it correct, has he seen it?
2. Midday: C4–C6 signed or repaired; decide which extras go in the talk (see `FINDINGS.md`).
3. Evening: rehearsal with `talk/slides.pdf`, `talk/QA.md`, `notes/study_guide.md`.
4. Sunday: rehearse, freeze 10:30, submit by 11:30.

## Overnight machinery

- Cron job `e7eb20ef` in this Claude session (session-only): fires at minutes 13 and 43 while the session is idle. Delete it with CronDelete when the queue is done.
- Keep-awake: background task `b7ckcr8lj` in this session, a PowerShell process holding a Windows "system required" execution state. It changes no settings and ends when stopped or when the app closes. A closed lid still sleeps.
- If the Claude app is closed or the laptop sleeps, nothing runs. To resume by hand: open this folder in Claude and say "read CLAUDE.md and STATE.md and continue the overnight queue".

## Notes for whoever resumes

- **Shell gotcha:** in commands sent through this harness a doubled backslash can arrive as a single one, so `sed`/inline Python edits of LaTeX silently fail. Edit `.tex` files with the Edit tool, or build backslashes with `chr(92)` in Python.
- MiKTeX works with plain `latexmk`; TikZ shapes need `\usetikzlibrary{shapes.geometric}`.
- Worker launcher `tools/delegate.sh` still works (default 2 attempts) but is not to be used without a human asking.
- `problem137/orbits.py` is of unknown origin (see JOURNAL 21:10); ask Syoma.
