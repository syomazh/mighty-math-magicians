# STATE — where we are and what is next

_Last updated: 2026-11-14 09:37 PT; before that 00:32 PT; earlier stamp 2026-11-13 23:55 PT by Claude Fable 5.2 (orchestrator)._

## Status in one paragraph

We have a candidate proof of the full problem (exact valuation for every q = p^k from tree symmetries, no factorial valuations). Evidence: brute force (E000), a no-assumption stress test on 1067 values of m up to 400 leaves, p up to 13, k up to 4 (E003, all checks pass), and three adversarial AI reviews that found no counterexample but 14 write-up defects (`paper/reviews/ADJUDICATION_round1.md`). The paper `paper/main.pdf` (13 pages) has been through three review rounds with repairs after each (`paper/reviews/ADJUDICATION_round1.md`, `_round2.md`, `_round3.md`). **No human has signed anything.** The ranked digest for humans is `FINDINGS.md`.

## Saturday work (started 09:15; Syoma's instruction: "work on Frobenius and keep working on analogies to physical fields")

- **Human feedback so far:** the professor has found nothing wrong so far (reported by Syoma, Saturday morning). This is not a sign-off; sign-off comes later.
- [x] **S1 — A complete Frobenius proof.** `paper/frobenius_proof.pdf` (9 pages after the referee's repairs, claim C18): algebra only, self-contained, general q = p^k, with the residue. Every lemma passes its own computer check (E010).
- [x] **S2 — Independent referee of the Frobenius note.** DONE 09:51. Verdict: proved modulo routine gaps; no wrong statement; 5 gaps and 7 unclear points, all repaired (`paper/reviews/ADJUDICATION_frobenius.md`). C18 is `ai-reviewed` (qualified). The note is now 9 pages.
- [x] **S3 — Carry budget** (claim C19, `notes/2026-11-14_carry_budget.md`): a more intuitive way to say Steps 2 and 3. One optional slide added after "Step 2".
- [x] **S4 — Cross-field readings.** DONE 09:58. Ranked note `notes/2026-11-14_crossfield_analogies.md` (each item marked exact or analogy); web check of sources and prior art in `notes/2026-11-14_crossfield_literature.md`; verified references are entries 6–16 of `references/README.md`. Two wordings corrected after the check (symmetry numbers; tournaments in the OEIS). Open question for the professor: the resemblance with Stickelberger's congruence (note B1′).
- [x] **S5 — Digests up to date** (09:58): `FINDINGS.md`, `AI_USAGE.md`, `talk/QA.md` (16a, 16b, section M, 53a), slides (carry budget, second proof, tert-butyl line, references), study guide exercise 11a, `notes/2026-11-14_frobenius_plain_words.md`.
- [ ] **S6 — Referee of the carry-budget note.** A fresh-context Claude subagent is reading only `notes/2026-11-14_carry_budget.md`; report to `paper/reviews/carry_budget_review_claude_fresh.md`. When it arrives: repair the note, regrade C19.
- Note: an untracked file `AGENTS.md` (a copy of `CLAUDE.md`) was in the folder on Saturday morning; the orchestrator did not create or change it. Syoma asked how a second agent (ChatGPT) could work here without conflicts; the answer given: its own branch, its own folders, proposals instead of edits, provenance headers. Not started.

## Operating mode since 2026-11-13 23:35 (Syoma's instructions)

- **Open Math OS is phased out.** About 36% of its allowance was left on Friday 23:35. The last worker (W014) hit its time limit at 00:48 on Saturday and was stopped. No worker is running and none is to be launched unless a human asks.
- **Claude does everything:** code, numerics, LaTeX, reviews (use a fresh-context Claude subagent via the Agent tool when an independent read is needed), documents.
- **Overnight:** the orchestrator works through the queue below without waiting for humans. A recurring in-session cron job re-triggers the session every 30 minutes if it is idle, so work resumes after a Claude usage-limit reset. A small background process asks Windows not to idle-sleep while the app is open. Both are listed under "Overnight machinery".
- Commit and push after every queue item. Journal every item.

## Overnight queue (do in order; mark each DONE with the time when finished)

- [x] **Q1 — Verify the repaired paper.** DONE 23:42 (all 14 repairs confirmed; four further defects found and fixed; see paper/reviews/round2_orchestrator.md). For each item A1–A14 of `paper/reviews/ADJUDICATION_round1.md`, read the repaired passage of `paper/main.tex` and decide fixed / not fixed. Fix remaining defects directly in the `.tex`. Compile (`cd paper && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex`), copy `build/main.pdf` to `paper/main.pdf`. Write the result to `paper/reviews/round2_orchestrator.md`.
- [x] **Q2 — Independent second review.** DONE. Round 2 (fresh Claude referee): proved modulo gaps; repaired (paper/reviews/ADJUDICATION_round2.md). Round 3 (another fresh referee, on the repaired text): proved modulo gaps, 2 wrong sentences and 6 small gaps; repaired at 00:28 (ADJUDICATION_round3.md). C1-C8 set to ai-reviewed with a qualification in CLAIMS.md. No further machine review planned; the human check is next.
- [x] **Q3 — Study guide and Q&A.** DONE 23:45 (written by the orchestrator; notes/study_guide.md with 16 exercises, talk/QA.md with 49 questions, check script runs in under a second). Write `notes/study_guide.md` and `talk/QA.md` as specified in `briefs/W011_qa_and_study_guide.md` and `briefs/W011b_qa_study_guide_finish.md`. Make `notes/study_guide_check.py` run in under 30 seconds and agree with the guide.
- [x] **Q4 — Fold in finished worker output.** DONE 00:30. E002, E005 and the Muse blind search were folded into CLAIMS and FINDINGS. Accounting proof: the three lemmas pass an independent check (experiments/E004_accounting_proof/claude_check.py); the worker draft (paper/alt_proof_accounting.tex) has a muddled proof of the forest recursion, so the orchestrator wrote a clean note: paper/accounting_proof.pdf (3 pages, not reviewed by anyone else). Worker W014 was still running at 00:30 and stops by itself at 00:48 at the latest; nothing further is needed from it.
- [x] **Q5 — Slides.** DONE 23:51 (18 slides, no overfull boxes; hook slide and a two-more-ways slide added; speaker notes extended). `talk/slides.pdf` compiles (two overfull boxes). Read every page, fix layout, add the chemistry/biology hook (Finding 3) and, if C12/C13 hold up, one slide "every node is worth −p". Keep the `\claimstatus` tags until humans sign.
- [x] **Q6 — Cross-field verification with curl** DONE 23:51 (notes/oeis_recon.md, references/cross_field_refs.md). (no PDFs): OEIS lookups for the class-count and N_min sequences printed in `experiments/E003_stress_test/output.txt`; Crossref/OpenAlex checks of the leads in Part 2 of `briefs/W016_crossfield_verify.md`. Write `notes/oeis_recon.md` and `references/cross_field_refs.md`.
- [x] **Q7 — Refinements numerics.** DONE 23:52 (experiments/E007_refinements: five statistics, all checks pass; part B, non-prime-power q, not done). Part A of `briefs/W017_refinements_and_general_q.md` with an own script in `experiments/E007_refinements/`; update C10, C11.
- [x] **Q8 — Explainer (optional).** DONE 23:53 (the stopped worker had already repaired it: selftest passes; page opened in the built-in browser and all five sections render; the bar chart in section 2 should be looked at once in a normal browser). Make `node explainer/selftest.mjs` pass following `briefs/W005c_explainer_reduced.md`.
- [x] **Q9 — Morning brief.** DONE 00:32. MORNING_BRIEF.md, FINDINGS.md and AI_USAGE.md are current as of 00:32.
- [x] **Q10 — Referee the second proof.** DONE 00:51. Verdict: theorem and lemmas correct; 1 wrong remark and 7 gaps of statement or citation, all repaired (paper/reviews/ADJUDICATION_accounting.md). The cron job was deleted. **The overnight queue is complete. Nothing is running: no worker, no subagent. The next move is the humans' (sign-off).**

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

- The cron job `e7eb20ef` was deleted at 00:51 on Saturday when the queue was finished. If more unattended work is wanted, create a new one.
- Keep-awake: background task `b7ckcr8lj` in this session, a PowerShell process holding a Windows "system required" execution state. It changes no settings and ends when stopped or when the app closes. A closed lid still sleeps.
- If the Claude app is closed or the laptop sleeps, nothing runs. To resume by hand: open this folder in Claude and say "read CLAUDE.md and STATE.md and continue the overnight queue".

## Notes for whoever resumes

- **Shell gotcha:** in commands sent through this harness a doubled backslash can arrive as a single one, so `sed`/inline Python edits of LaTeX silently fail. Edit `.tex` files with the Edit tool, or build backslashes with `chr(92)` in Python.
- MiKTeX works with plain `latexmk`; TikZ shapes need `\usetikzlibrary{shapes.geometric}`.
- Worker launcher `tools/delegate.sh` still works (default 2 attempts) but is not to be used without a human asking.
- `problem137/orbits.py` is of unknown origin (see JOURNAL 21:10); ask Syoma.
