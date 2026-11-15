# W053 — Review the report as the competition's AI panel will

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". You are a **reviewer on the scoring panel**: score honestly and say what costs points.

## The setting

The report `report/report.tex` (PDF: `report/report.pdf`) will be scored by a panel of AI models. Each reads: the problem statement and its references (`mathathon_problems.txt`, search "PROBLEM 137"), the report **without its title block**, the supplementary materials (this repository), and the result of an automated Lean build. The panel does not see the slides. The rules and the rubric are summarised in `SUBMISSION_RULES.md`; read it first.

Six dimensions, each scored 1 to 5 (5 = going above and beyond what a team can do in 40 hours; 4 = few flaws and some creative elements; 3 = only a few minor issues; 2 = a major issue or several minor ones; 1 = many major issues):

- **Correctness**: claims and arguments correct and precisely stated; objects defined; the status of every claim exact; uncertainty conveyed truthfully.
- **Clarity**: well organized; rigorous and heuristic arguments distinguished; accessible beyond the subfield.
- **Motivation**: the contribution sharply stated, with a case for why it matters; "it is an open problem" is not a reason; say what is unsatisfying about the old proof.
- **Interest**: substantial, creative work done during the event, yielding real insight.
- **Attribution**: every source and form of help credited precisely; known results not presented as new; AI use fully disclosed and consistent with the rest of the report.
- **Novelty**: how the proof, exposition or connection differs from known work.

Not rewarded by themselves: length, using Lean, using AI. Honestly labelled partial results are not penalized. Overstating a claim is.

## What to do

1. Read the report from the first line of the abstract to the end of the AI section as the panel would (the appendices: skim the statements). Then give **a score for each dimension with a justification of five to ten lines**, quoting the places that earn or cost points.
2. **Compliance check** against the hard requirements in `SUBMISSION_RULES.md`: one self-contained file; names and repository link only in the title block (search the whole `.tex`, comments included, and the PDF text); every key figure described in words; work done during the event made clear; status of every main claim; AI use; sources; the Lean list with differences. List every violation with its line.
3. **Attribution and novelty, adversarially.** For each item the report claims as its contribution (Section 1.4 and wherever else "new", "first", "as far as we know" or similar words appear): is the claim worded so that it survives a reader who knows the literature? Compare with `references/README.md` and `notes/2026-11-14_path_proof_literature.md`. Flag any sentence in the whole report that could be read as claiming known work, and any place where a known result is used without a citation. Flag also the opposite: places where the report undersells something that the repository supports.
4. **Consistency of the AI disclosure** with the rest: does Section 9 match what the status table, the Lean section and the comments in the `.tex` say about who wrote and who checked what? Is there any sentence a judge could read as hiding that the proofs were found by AI, or as claiming human verification that did not happen?
5. **Economy.** The report is long. Which parts would you cut or move to an appendix so that a reader reaches the main idea within two pages? Is there a one-page path through the result (statement, the four steps in one paragraph each, what is new, what supports it)? If not, write that page as LaTeX ready to paste (no new mathematical claims; use only what the report says).
6. **The ten changes that would raise the scores most**, in order, each with the place and replacement text where possible.

## What you write

One new file, `report/reviews/PANEL.md` (create the folder if it does not exist), with a header naming Claude Fable 5.2 (a fresh-context reviewer; brief W053), 2026-11-15, not human-reviewed. Sections as the six points above. Change nothing else: not the report, not any other file. No git command that changes anything.

## Report (to the orchestrator)

The six scores, the compliance violations, and the three changes that matter most.
