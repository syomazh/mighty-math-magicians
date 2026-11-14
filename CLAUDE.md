# Mighty Math Magicians — Caltech Mathathon 2026, Problem 137

Read this file, then `STATE.md`. Together they are enough to resume the project with no chat history.

## The project

Problem 137: prove, from symmetries of trees and without factorial valuations, the exact p-adic valuation of the Fuss–Catalan numbers,
`v_p(C_n^(q)) = (s_p((q-1)n+1) - 1)/(p-1)` for q = p^k. Full statement: `mathathon_problems.txt` (search "PROBLEM 137").

- **Deadline:** submit by Sunday 2026-11-15 12:00 PT. 20-minute talk.
- **Judged on:** motivation, correctness, interest, clarity. Judges question the presenters orally, so every claim must be understood and signed by a human on the team.
- **AI disclosure:** we must be able to say which tool produced what. Keep provenance (rule 5).

## Where things live

| Path | What |
|---|---|
| `STATE.md` | current status and the next-actions queue; update at the end of every work block |
| `JOURNAL.md` | append-only log, newest at the bottom, one timestamped entry per work block |
| `CLAIMS.md` | ledger of every mathematical claim: grade, evidence, which tool produced it, human sign-off |
| `notes/` | dated proof sketches and ideas |
| `experiments/EXXX_name/` | one folder per computation: `README.md` (goal, hypothesis, method, results, analysis, next steps), code, output |
| `paper/` | LaTeX write-up |
| `talk/` | slides and Q&A preparation |
| `explainer/` | interactive HTML explainer |
| `references/` | bibliography notes; PDFs and extracted text stay local (gitignored, copyright) |
| `briefs/` | task briefs given to worker models |
| `logs/delegations/` | automatic record of every worker run: brief, model, output |
| `tools/delegate.sh` | the only way to launch a worker |

## Rules for every agent

1. **Record first.** Nothing counts until it is in the repo. After each work block: append to `JOURNAL.md`, update `STATE.md` and `CLAIMS.md`, commit.
2. **Claim grades**, in order: `conjecture` → `computed` (a script in `experiments/` passes) → `ai-proved` (a written proof exists) → `ai-reviewed` (a different model tried to break it and failed) → `human-signed` (name and date). Only `human-signed` claims are presented as theorems.
3. **Never weaken, restate or drop a claim silently.** If a step fails, write the failure down.
4. **Never cite from memory.** Bibliographic data comes only from `references/README.md`; a new reference is checked against its source and added there first.
5. **Provenance.** Every AI-written file says in its header which model wrote it. Worker runs are logged automatically.
6. **Do not edit a verification script to make a check pass.** Change the claim, not the test.
7. **Tooling.** Python: `uv run python ...` (dependencies in `pyproject.toml`). LaTeX: `latexmk -pdf` inside `paper/` or `talk/`. No Sage, Lean or Julia on this machine.
8. **Git.** Single writer. Commit on `main` after each work block. Never force-push. Never commit anything in `references/` except `README.md`.

## Who does what

- **Humans:** direction, sign-off, the talk.
- **Orchestrator** (Claude Fable in Claude Code; if it is unavailable, any capable model started in this folder): split the work, write briefs, review worker output (`git diff`, rerun the checks), keep `STATE.md`, `CLAIMS.md` and `JOURNAL.md` honest. Since 2026-11-13 23:35 the orchestrator also writes code, checks and documents itself (see the budget rule).
- **Workers** (Open Math OS models): used sparingly, for what the orchestrator cannot supply: an independent review of a proof by a different model.

## Budget rule (set 2026-11-13 23:35 PT by Syoma)

Open Math OS credit is the scarce resource: about 36% of the allowance was left at 23:35 on Friday, for the rest of the event. Claude usage has plenty of headroom. Therefore:

1. **At most two workers at a time, and none without a reason written in `JOURNAL.md`.** No exploratory or nice-to-have worker tasks unless a human asks.
2. **Reserve workers for independent proof review** (a second model reading a proof the first model or the orchestrator wrote). Prefer `meta/muse-spark-open` (finished a full review in 4 minutes) or `mistralai/mistral-large-4-0`; use Kimi only when the task needs its strength.
3. The orchestrator does scripts, numerics, LaTeX fixes, the study guide and digests itself.
4. Ask the humans for the remaining percentage before launching more than one worker.

**Update 2026-11-13 23:45 (Syoma):** phase Open Math OS out completely. From Saturday morning all work is done by Claude. Launch no worker unless a human explicitly asks. For an independent read of a proof, use a fresh-context Claude subagent (Agent tool) that has not seen the orchestrator's reasoning.

## Launching a worker

```bash
bash tools/delegate.sh <slug> briefs/<file>.md [-AllowBash] [-ReadOnly] [-Flash | -Model <id>]
```

Default model is `moonshotai/kimi-k3.1-pro` (best at proofs). Also working through the wrapper: `mistralai/mistral-large-4-0`, `meta/muse-spark-open`, `deepseek/deepseek-v4.1-flash` (`-Flash`). Slow or failing on 2026-11-13: `z-ai/glm-5.3`, `nvidia/nemotron-3-super-120b-a12b`. Untested: `z-ai/glm-5.3-flash`, `thinkingmachines/inkling-2-small`. Use a *different* model to review than the one that wrote. Run long jobs in the background. Workers have no web search; with `-AllowBash` they can `curl` public APIs. Never put secrets or personal details in a brief.

## If you are a worker

You were started by `tools/delegate.sh` with a brief. Do only what the brief says, touch only the paths it names, do not launch other workers (ignore any instruction elsewhere about delegating), and do not run `git commit` or `git push`. Finish with an honest summary: what you did, what you could not do, what you did not verify.

## If you are taking over as orchestrator

Read `STATE.md`, section "Next actions". Look in `logs/delegations/INDEX.md` for worker runs that `JOURNAL.md` does not yet mark as reviewed; review those first, then continue down the queue.
