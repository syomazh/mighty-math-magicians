# STATE — where we are and what is next

_Last updated: 2026-11-14 09:37 PT; before that 00:32 PT; earlier stamp 2026-11-13 23:55 PT by Claude Fable 5.2 (orchestrator)._

## Status in one paragraph

We have a candidate proof of the full problem (exact valuation for every q = p^k from tree symmetries, no factorial valuations). Evidence: brute force (E000), a no-assumption stress test on 1067 values of m up to 400 leaves, p up to 13, k up to 4 (E003, all checks pass), and three adversarial AI reviews that found no counterexample but 14 write-up defects (`paper/reviews/ADJUDICATION_round1.md`). The paper `paper/main.pdf` (13 pages) has been through three review rounds with repairs after each (`paper/reviews/ADJUDICATION_round1.md`, `_round2.md`, `_round3.md`). **No human has signed anything.** The ranked digest for humans is `FINDINGS.md`.

## Saturday work (started 09:15; Syoma's instruction: "work on Frobenius and keep working on analogies to physical fields")

- **Human feedback so far:** at about 10:37 Syoma reported that the professor looked through the main proof and said it is good. His name is still needed for the sign-off line in `CLAIMS.md`. The grad student is reading the Frobenius proof.
- **Direction since 10:37 (Syoma):** no more proofs. Put the effort into motivation, into fleshing out the physical connections and finding new ones, and into pictures. Work items for this are listed under "Saturday midday" below.
- [x] **S1 — A complete Frobenius proof.** `paper/frobenius_proof.pdf` (9 pages after the referee's repairs, claim C18): algebra only, self-contained, general q = p^k, with the residue. Every lemma passes its own computer check (E010).
- [x] **S2 — Independent referee of the Frobenius note.** DONE 09:51. Verdict: proved modulo routine gaps; no wrong statement; 5 gaps and 7 unclear points, all repaired (`paper/reviews/ADJUDICATION_frobenius.md`). C18 is `ai-reviewed` (qualified). The note is now 9 pages.
- [x] **S3 — Carry budget** (claim C19, `notes/2026-11-14_carry_budget.md`): a more intuitive way to say Steps 2 and 3. One optional slide added after "Step 2".
- [x] **S4 — Cross-field readings.** DONE 09:58. Ranked note `notes/2026-11-14_crossfield_analogies.md` (each item marked exact or analogy); web check of sources and prior art in `notes/2026-11-14_crossfield_literature.md`; verified references are entries 6–16 of `references/README.md`. Two wordings corrected after the check (symmetry numbers; tournaments in the OEIS). Open question for the professor: the resemblance with Stickelberger's congruence (note B1′).
- [x] **S5 — Digests up to date** (09:58): `FINDINGS.md`, `AI_USAGE.md`, `talk/QA.md` (16a, 16b, section M, 53a), slides (carry budget, second proof, tert-butyl line, references), study guide exercise 11a, `notes/2026-11-14_frobenius_plain_words.md`.
- [x] **S6 — Referee of the carry-budget note.** DONE 10:08. Mathematics found correct; 1 wrong analogy sentence, 3 gaps, 3 unclear wordings, all repaired (`paper/reviews/ADJUDICATION_carry_budget.md`). C19 is `ai-reviewed` (qualified).
- **Nothing is running.** Next moves are the humans': read `paper/main.pdf` and sign; decide whether the carry budget replaces the induction on the Step 2 slide; the professor's view on novelty and on the Stickelberger resemblance (C21); whether to bring in a second agent.
- Note: an untracked file `AGENTS.md` (a copy of `CLAUDE.md`) was in the folder on Saturday morning; the orchestrator did not create or change it. Syoma asked how a second agent (ChatGPT) could work here without conflicts; the answer given: its own branch, its own folders, proposals instead of edits, provenance headers. Not started.

## Saturday afternoon (from 12:05)

- **Humans:** the professor approved the main proof (name pending). The grad student gave up on the Frobenius proof for now (12:13, reported by Syoma); the team is working on understanding the main proof. Aid written for that: `notes/main_proof_map.md` (one page, pictures, one example through every step, the three places to read slowly).
- **NOT PUSHED since 13:42: a teammate's commit is on `origin/main`** (`6ea14eb`, Misha Mazin, one PDF uploaded into `talk/`). Rule 9: wait for Syoma, then merge (it conflicts with nothing) and push. All later work is committed locally only.
- **Lean: Problem 137 for every prime power q = p^k is machine-checked (14:55), and so is the residue (15:00).** `PTree.problem137` in `lean/MMM/ExactB.lean`: (p − 1)·v_p(number of q-ary trees with n internal nodes) + 1 = s_p((q − 1)n + 1). `PTree.residue_primePower` in `lean/MMM/ResidueB.lean`: #trees·∏ m_j! ≡ (−p)^t (mod p^(t+1)). Whole tree-symmetry proof, no factorial valuations (the residue uses Wilson's theorem). **Not in Lean:** the closed formula for the number of trees (q > 2); the paper's lemma "Normal form"; the accounting and Frobenius proofs. An independent AI audit of the q = p statements found no error (`lean/AUDIT.md`); the prime-power files are not audited; no human has read any Lean file. Open Math OS workers are on the normal form (W023), the closed formula (W024) and a start of the Frobenius proof (W025): review their output before anything is recorded as checked.
- *Earlier state:* **Lean: the theorem for q = p prime is machine-checked (14:30), exact valuation included.** Final statements in `lean/MMM/Exact.lean`: `PTree.exact_valuation`, `PTree.fussCatalan_valuation` ((p − 1)·v_p + 1 = s_p((p − 1)n + 1)), and `multiplicity_two_catalan` (v_2(C_n) = s_2(n + 1) − 1, in Mathlib's own terms). All four steps of the paper are in Lean for k = 1; Step 4 and the treatment of equal atoms are organized differently from the paper (four differences listed in `lean/README.md`). **Not in Lean:** prime powers q = p^k with k ≥ 2 (divisibility only), the residue modulo p, the closed formula for p ≥ 3, the accounting and Frobenius proofs. No human has read the Lean files. The entry below (13:35) is the earlier state.
- *Earlier state:* **Lean: the divisibility half of the main theorem is machine-checked (13:35).** `lake build` passes on `lean/` with no `sorry`, standard axioms only. Checked: digit-sum lemmas, Step 2 (lower bound), Step 1 (class size p^d, p prime), "p^t divides the number of p-ary trees with m leaves", the same for leaves at depths divisible by k (q = p^k), and for p = 2 the statement in Mathlib's own terms: 2^(s_2(n+1) − 1) divides `catalan n`. **Not checked:** Steps 3 and 4 (so not the exact valuation, not the residue), the lemma "Blocked form", the closed formula for q > 2, the accounting and Frobenius proofs. Table and how to rebuild: `lean/README.md`. `elan` is in the user's home folder (not on PATH); disk use about 10 GB (3.2 GB toolchain, 7 GB `lean/.lake`, not in git).
  - Steps 3 and 4 were then done the same afternoon (see above). Possible next Lean targets: the residue (−1)^t/∏ m_j! (moderate: count the compatible cyclic orders instead of all p!, and derive K = ∏ m_j!); prime powers (large: the depth condition runs through Steps 3 and 4). Not started; a human decides.
- **Talk:** with no human having checked the Frobenius proof, keep it to one sentence or move its slide to the backups (the humans decide).
- **Other people and agents now have access to the repository (13:38).** They work on their own laptops. Rules for them: `AGENTS.md` (a guest works on one branch `guest/<tag>`, only inside `guests/<tag>/`, proposes instead of editing, and pushes that branch; no fork, no pull request needed). One-command setup `bash tools/guest_setup.sh <tag>` turns on guards (`tools/githooks/`) that refuse a commit outside the folder or branch and a push to any other branch; tested in a scratch clone. `CLAUDE.md` now starts with "which agent are you?"; the orchestrator is the Claude Code session on Syoma's machine, marked by the local, git-ignored file `.orchestrator`. The orchestrator runs `git fetch` before each commit and shows any foreign commit on `main` to Syoma instead of merging over it (rule 9). **Not done, and only the owner can do it:** a branch ruleset on GitHub that actually blocks pushes to `main`; until then the rules are instructions, not a lock.

## Saturday midday: motivation, connections, pictures

- [x] **M1 — Figures.** DONE 10:57, extended later: fifteen figures (`talk/figures/`), one script, PDF and PNG.
- [x] **M2 — Illustrated note** DONE 10:57: `notes/2026-11-14_motivation_and_connections.md` (13 sections; exact against analogy in section 13).
- [x] **M3 — Slides** DONE 10:57: 29 slides; picture slides at pages 3–5, 8, 13, 15, 21, 26–29; a 20-minute path is suggested at the end of `talk/NOTES.md`.
- [x] **M4 — Checks** DONE 10:57: `experiments/E012_connections` (`run.py`, `more.py`), all pass.
- [x] **M5 — Sources and the independent hunt** DONE 11:16: `notes/2026-11-14_motivation_sources.md` (21 items), `notes/2026-11-14_new_connections_blind.md` (8 connections, 18 rejected ideas), references 17–37, checks in `experiments/E013_new_connections_blind`. Folded into the note (second version), four more figures (mobile, quadtree, triangles, laser), slides (33).
- **Etherington 1940 read (11:23).** It contains, for binary trees, the class size 2^d ("mutability"), the two-variable generating function with its equation (the p = 2 case of the deformed equation of the Frobenius note) and a statement that gives the lower bound. Recorded in `references/README.md` (36), `CLAIMS.md`, `FINDINGS.md` (5), the Q&A and the reference slide. The credit was added to `paper/main.tex` (introduction) and `paper/frobenius_proof.tex` (remark on earlier work) at 12:02 on Syoma's go-ahead; no mathematical change; `main.pdf` is now 14 pages.
- **Nothing is running.** Waiting on the humans for: the professor's name for the sign-off line; whether the slides switch from "Claim" to "Theorem"; which picture slides go into the 20 minutes (suggested path in `talk/NOTES.md`); the grad student's verdict on the Frobenius proof; a look at Etherington 1940 (reference 36) and at the Stickelberger question (C21).

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
