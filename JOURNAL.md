# Journal (append-only, newest at the bottom)

Each entry: time (PT), who/which tool, what was done, what came out, where it is saved.

---

## 2026-11-13 ~20:15 — Claude Fable 5.2 (Claude Code), with Syoma

- Read the problem statement and `caltech_mathathon_ai_reference.md`.
- Checked the machine: Python 3.13, uv, MiKTeX/latexmk, Node, 8 cores. No Sage, Lean, Julia, gh.
- Smoke-tested the Open Math OS worker (`om.ps1`, Kimi K3.1 Pro): answered in 7 s.

## 2026-11-13 ~20:40 — Claude Fable 5.2

- While reading the problem, sketched a candidate proof of the exact valuation for all q = p^k: act with rotations (Z_p) at every p-ary node instead of the full symmetric group; minimal orbits are trees on the base-p digits of m; "a carry is a collapsing cherry" gives the count of minimal orbits mod p.
- Wrote and ran `experiments/E000_first_sanity_check/check.py`: 47 (q, n) cases and 307 carry cases, all checks pass.
- Saved the sketch: `notes/2026-11-13_candidate_proof_sketch.md`. Not human-verified.

## 2026-11-13 ~21:00 — Claude Fable 5.2

- Team answers received: 20-minute talk, submit by Sunday noon; presenters are Syoma (freshman) and the grad student; professor remote; humans sign off on claims; conserve Claude, use Open Math OS heavily; repo is public.
- Downloaded Konvalinka's paper from the author's page (link supplied by Syoma) to `references/` (local only) and read it in full.
- **Overlap assessment.** Konvalinka acts with the full symmetry group of the complete q-ary tree (S_q at each node). Orbit sizes are products of multinomial coefficients. His Lemmas 8–10 describe minimal orbits; his Proposition 7 gives divisibility by p^t and then calls on the factorial formula (Proposition 2) for exactness, and he says explicitly that the combinatorial argument proves only the divisibility. Our candidate differs in the group (a Sylow p-subgroup: Z_p rotations on the p-ary refinement), which makes all orbit sizes powers of p, shortens the lower bound to a short induction, and supplies the missing exactness step. Post-2007 literature not yet checked.
- **Weighted numbers (claim C9).** In his proof of Theorem 5 the recursion r_b(O)(x) = b(x)·(1/q)·Σ_i r_b(O_i)(x)·∏_{j≠i} r_b(O_j)(x+1) comes from summing over which branch lands in the right-most position. For any group acting transitively on the q positions each branch lands there equally often, so the same recursion holds for our p-group. Needs a numerical check and a careful write-up.
- New conjectured corollaries recorded as C10 (level-profile refinement) and C11 (master statement).

## 2026-11-13 ~21:05 — Claude Fable 5.2

- Built the project scaffolding: `CLAUDE.md` (operating manual and handoff), `STATE.md`, `CLAIMS.md`, this journal, `tools/delegate.sh` (logged worker launcher), `briefs/`, `pyproject.toml`.

## 2026-11-13 ~21:10 — Claude Fable 5.2

- Smoke-tested the wrapper on six gateway models. Working: Kimi K3.1 Pro (7–20 s), Mistral Large 4.0 (22 s), Muse Spark Open (15 s), DeepSeek Flash (12 s). GLM 5.3 took almost 7 minutes on a one-line task. Nemotron timed out at 150 s.
- First commit of the scaffolding (91626ce). Not pushed: waiting for Syoma's decision, because the repo is public.
- **File of unknown origin.** `problem137/orbits.py` (dated 20:31, 174 lines) was already in the working tree and went into that commit. Claude Fable did not write it and no logged worker did. It studies a different action (Z_q rotation of the q children of a q-ary node). Provenance to be supplied by the team.
- Launched wave 1 in the background (all Kimi K3.1 Pro, shell allowed): W001 proof draft, W002 independent replication, W003 extensions numerics, W004 literature scan, W005 explainer. Not yet reviewed.

## 2026-11-13 ~21:25 — Claude Fable 5.2

- Pushed the first three commits to GitHub at Syoma's instruction (main at 6cee453).
- Wrote a 7-page briefing for the grad student: `notes/briefing_grad_student/briefing_for_grad_student.pdf` (source `briefing.tex`). It contains the problem, what Konvalinka does, the candidate argument with proofs of each step, three worked examples, the steps most likely to be wrong, the claim table and the unexamined extensions. Written by Claude Fable 5.2; not human-verified.
- Checked Konvalinka's Remark 3 against the PDF (page 3): for q = p his residue is (−1)^{(Σa_i − 1)/(p−1) + Σ(a_i − 1)} ∏(p − a_i − 1)!, which equals our (−1)^t/∏ a_i! by Wilson's theorem (a!(p−1−a)! ≡ (−1)^{a+1}).

## 2026-11-13 ~21:55 — Claude Fable 5.2

- Worker status: W004 (literature scan) finished 21:29, not yet reviewed. W002 (independent replication) died at 21:48 with a gateway timeout (Cloudflare 524), not a mathematical failure; it left `run.py` and partial outputs but no final output or README. Relaunched as W002b with a brief to finish from the existing code. W001, W003, W005 still running.

## 2026-11-13 ~22:45 — Claude Fable 5.2

- Laptop was closed 22:00–22:30 for the move to the hotel. A snapshot of everything had been committed and pushed first (d1e51ba).
- Worker outcomes: W004 literature scan finished cleanly. W003 died at 21:56 (gateway timeout, Cloudflare 524). W001, W005 and W002b died at 22:29 on reconnect ("self-signed certificate": the hotel network intercepting the connection). All left usable files: `paper/main.tex` (487 lines) with `paper/build/main.pdf` (11 pages, compiled 21:58, the author reports no gaps), `explainer/index.html` (selftest currently crashes), `experiments/E001/run.py`, `experiments/E002/run.py` with a partial output.
- **Reviewed W004** (`references/literature_scan.md`, top sections). The three given references match Crossref exactly. No abstract found that states a tree-symmetry or p-group proof of the exact valuation for prime-power q. This is not a novelty proof: full texts were not read and arXiv search failed. Papers needing a full-text check: Gao–Gu 2021 (weighted Catalan arithmetic, strengthens Konvalinka; bears on C9), Krattenthaler–Müller 2025 (Fuss–Catalan numbers modulo prime powers; bears on C7), Kauers–Krattenthaler–Müller 2012, Bobrowski–He–Shiue 2019, and Deutsch–Sagan 2006 and Postnikov–Sagan 2007 themselves.
- `tools/delegate.sh` now relaunches a worker that dies, with an instruction to continue from its files (up to 4 attempts).
- Launched: three adversarial reviews of `paper/main.tex` (W006: Mistral Large 4.0, Muse Spark Open, and a fresh Kimi K3.1 Pro), reports to `paper/reviews/`; resumes W002c (replication), W003b (extensions), W005b (explainer).

## 2026-11-13 ~23:05 — Claude Fable 5.2

- Syoma approved downloading legal open-access copies of four papers for a full-text overlap check (Gao–Gu 2021, Krattenthaler–Müller 2025, Deutsch–Sagan 2006, Postnikov–Sagan 2007), and asked for more work in parallel since Open Math OS compute is plentiful. The app is holding the laptop awake (until the session is idle).
- Launched wave 3 (all Kimi K3.1 Pro): W009 full-text overlap check → `references/overlap_fulltext.md`; W010 Beamer slides draft → `talk/`; W011 study guide and Q&A sheet → `notes/study_guide.md`, `talk/QA.md`; W012 stress test with a class-counting generating function → `experiments/E003_stress_test/`; W013 cross-field lenses (phylogenetics, computer arithmetic, information, statistical physics, Kummer) → `notes/cross_field_angles.md`.
- New idea recorded for W012: F_δ(x,y) = [δ≡0]·x + F_{δ+1}(x^p,y^p) + y·(F_{δ+1}(x,y)^p − F_{δ+1}(x^p,y^p))/p counts classes by leaves and d; at y = p it collapses to G = x + G^p (for k = 1), the tree-counting equation. Origin: Claude Fable 5.2; unverified.
- New idea recorded for W013: "excess = carries": d(T) − t(m) equals the carries at an asymmetric root plus the children's excess, and p·e(T_1) + (p−1)·t(m_1) at a symmetric root. Origin: Claude Fable 5.2; follows from the proof of the lower bound; to be checked numerically.

## 2026-11-13 ~23:30 — Claude Fable 5.2

- Syoma asked for more parallel work: other, more elegant proofs; physical or cross-field meaning; anything giving an edge; and a prioritized digest. Claude budget confirmed ample.
- **New ideas (mine, recorded in `notes/2026-11-13_new_ideas.md`):** the accounting proof "every node is worth −p" with the compact statement C·∏m_j! ≡ (−p)^t mod p^(t+1) (checked numerically, 885 cases, 0 failures); sand on a ring versus a line; identification of the classes with stereoisomers (p = 3) and tree shapes (p = 2), confirmed by OEIS lookup (A000625, A001190); the Frobenius/δ view; a conjectured bijection with permutations made of p-cycles; refinements and non-prime-power q.
- **Reviewed the three round-1 reviews of the proof** in detail. Verdict of all three: proved modulo gaps. I accepted 14 repairs and rejected two reviewer opinions (see `paper/reviews/ADJUDICATION_round1.md`). Notable: Mistral alone caught that the freeness proof was false as written; Kimi alone caught that the termination argument fails for p = 2. Reviewer disagreement was what exposed both.
- **Reviewed W009** (full-text overlap, four arXiv texts): see the note added to `CLAIMS.md`. **Reviewed W002c** (replication): partial, k = 1 only; its two failures are its own bug (verified by hand and with E000 code). **W005b** (explainer) did not finish; **W011** (study guide, Q&A) stopped after writing only its check script.
- **Launched:** W014 accounting proof (verify + write-up), W015 Frobenius proof, W016 cross-field verification and OEIS reconnaissance, W017 refinements and non-prime-power q, W018 three blind proof searches (Kimi, Mistral, Muse), W021 repair of the paper followed automatically by W022 round-2 reviews (three models), W011b and W005c relaunches with tighter briefs.
- Created `FINDINGS.md`: the ranked one-page digest for the humans.

## 2026-11-13 ~23:55 — Claude Fable 5.2

- **Budget change (Syoma):** Open Math OS allowance down to about 36%. Instructions, in order: cut usage; then cut heavily; then phase it out entirely by morning and use Claude instead. Also: arrange for work to resume automatically if Claude hits its 5-hour limit.
- Stopped ten workers (process trees killed, runs marked "stopped" in their `meta.txt`): W018 blind Kimi, W018 blind Mistral, W017 refinements, W013 cross-field, W016 cross-field verification, W005c explainer, W012 stress test, W010 slides, W003b extensions, W011b study guide. W021 (paper repair) had written `paper/CHANGES_round1.md` and `paper/main.pdf` at 23:28; its launcher was hung and was cleaned up. The automatic second review round was blocked by moving its briefs to `briefs/_held/`. Only W014 (accounting proof) was left running.
- Finished earlier: W015 (Frobenius proof note and E005), W018 blind Muse (report in `notes/`). Not yet reviewed.
- **E003 stress test, written and run by me:** 1067 values of m, p up to 13, k up to 4, up to about 400 leaves, no truncation: 0 failures on every check (`experiments/E003_stress_test/`).
- **Slides:** the stopped worker's `talk/slides.tex` had three LaTeX errors (two missing braces, a missing TikZ library); fixed; `talk/slides.pdf` now builds. Content not yet reviewed.
- Rewrote `STATE.md` with the overnight queue Q1–Q9 (Claude only). `CLAUDE.md` now carries the budget rule.
- **Overnight machinery:** cron job `e7eb20ef` (fires at :13 and :43 while idle, tells the session to continue the queue); keep-awake background task `b7ckcr8lj` (a temporary Windows execution-state request; changes no settings).
- Harness quirk found: a doubled backslash in a shell command can arrive as a single one, so `sed` and inline-Python edits of LaTeX silently do nothing. Recorded in `STATE.md`.
