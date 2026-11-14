# How AI was used in this project

Maintained by the orchestrator (Claude Fable 5.2). Last updated 2026-11-13 23:55 PT. This is the summary required for disclosure; the full record is `JOURNAL.md` (chronological), `CLAIMS.md` (origin of every claim) and `logs/delegations/` (every worker run with its brief and output).

## Tools

| Tool | Role | Period |
|---|---|---|
| **Claude Fable 5.2** in Claude Code (desktop app) | Orchestrator. Had the proof idea; wrote the briefs for other models; reviewed and adjudicated their output; from Friday 23:35 also wrote code, checks and documents itself. | whole project |
| **Kimi K3.1 Pro** via Open Math OS (headless Claude Code worker) | Wrote the full LaTeX proof, repaired it after review, wrote experiments E001, E002, E005, the literature scans, the first slides draft, one of the three reviews. | Friday 21:10 – Saturday ~00:50 |
| **Mistral Large 4.0** via Open Math OS | One adversarial review of the proof (found the flaw in the freeness proof). | Friday 22:39 – 23:15 |
| **Muse Spark Open** via Open Math OS | One adversarial review of the proof; one blind search for alternative proofs. | Friday 22:39 – 23:22 |
| DeepSeek Flash, GLM 5.3, Nemotron via Open Math OS | Connectivity tests only. | Friday 21:00 – 21:07 |
| **A second Claude instance with no access to our notes** (subagent) | Independent referee of the repaired proof. | from Friday 23:43 |

Open Math OS use was stopped on Friday night at the team's instruction (budget); ten runs were cut short and are marked "stopped" in the log.

## Who produced what

| Item | Produced by | Checked by |
|---|---|---|
| Proof strategy (rotation classes, digit atoms, carry = cherry) | Claude Fable 5.2, Friday ~20:30, while reading the problem | brute force E000 (Claude); stress test E003 (Claude); reviews below; **humans: to be filled in** |
| Briefing for the grad student (`notes/briefing_grad_student/`) | Claude Fable 5.2 | — |
| Full proof `paper/main.tex` | Kimi K3.1 Pro (draft W001, repair W021), with later corrections by Claude Fable 5.2 | three adversarial reviews (Mistral, Muse, Kimi): 14 defects; Claude line-by-line: 4 more; independent Claude referee: see `paper/reviews/` |
| Brute-force check E000, stress test E003, refinements E007, study-guide checks | Claude Fable 5.2 | E001 (Kimi) replicates E000 for q = p, small n |
| Extensions numerics E002, Frobenius checks E005 | Kimi K3.1 Pro | read by Claude; not re-run independently |
| Literature scan and full-text overlap check (`references/`) | Kimi K3.1 Pro, from public APIs and four open-access papers | conclusions read by Claude; **a human expert has not confirmed novelty** |
| Cross-field links (chemistry, biology, sandpile, Frobenius, accounting proof) | ideas: Claude Fable 5.2; OEIS and citation checks: Claude via public APIs | — |
| Slides `talk/slides.tex` | Kimi K3.1 Pro (draft), revised by Claude Fable 5.2 | — |
| Study guide and Q&A sheet | Claude Fable 5.2 | numbers recomputed by script |

## What the humans did

- Chose the problem, set the priorities, decided what to spend on which tool, approved every push to the public repository and every download.
- **Verification and sign-off: to be filled in** (who read which part of the proof, what they found, what they signed, with dates).

## What we learned about using AI for mathematics

- The idea arrived in one step, but the first written proof contained two false steps and several gaps. They were found only because different models reviewed it: each of the two false steps was noticed by exactly one of three reviewers, and a false displayed equality was missed by all three and caught on a later reading.
- Numerical verification was cheap and decisive for the *statements*; it says nothing about the *proofs*.
- Open models were good at long mechanical work (writing and repairing LaTeX, enumeration code, API-based literature scans) and uneven at finishing tasks: several stopped early or reported failures that were bugs in their own checks.
