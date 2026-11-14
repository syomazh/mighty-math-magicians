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
