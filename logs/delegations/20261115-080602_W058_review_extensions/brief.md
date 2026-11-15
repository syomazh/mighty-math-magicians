# W058 — Independent review of four short proofs in the report (written last night, read by no person)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15 about 08:10. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". You only read; your final answer is the review. **Time limit: 25 minutes.**

## Why

The report `report/report.tex` is scored today by a panel of AI models and read by judges. Four short proofs in it were written during the night by one model (Claude) and have been read by no person and by no other model. Our own rules ask that a proof is read by a *different* model that tries to break it before it is called reviewed. You are that model. Try to break them.

## What to read

`report/report.tex` (LaTeX source, one file):

1. Section "Extensions: other statistics": lines 1533 to 1656. It contains three statements with proofs: a congruence for rotation-closed families of trees, the divisibility of a product of binomial coefficients given by the level profile (`p^t` divides `∏ binom(q n_i, n_(i+1))`), and the divisibility of weighted sums for rotation-invariant weights (with the depth-weighted example).
2. Section "Small examples, in words": lines 548 to 627. Somewhere in it (search for "converse" and for "if and only if") is a proof of the direction that was missing from an "if and only if" about when the valuation of the Fuss–Catalan number is zero or when p does not divide it.
3. What these proofs use, which you may take as proved but must check that it is quoted correctly: Section "The main proof" (lines 859 to 1392), in particular the definition of rotation equivalence, the lemma on the size of a rotation class (a power of p, the exponent being the number of asymmetric nodes), the lower bound on the number of asymmetric nodes by the digit sum, and the theorem itself (lines 510 to 547).

## What to do, for each of the four proofs

- Restate the claim in one sentence with all its hypotheses (which p, q, k, n; what is a family; what is a weight). Say if a hypothesis is missing or a quantifier is unclear.
- Go through the proof step by step. For every step say: follows / follows only with an extra argument (give it) / does not follow (say why). Quote the line number.
- Check every use of an earlier result against the statement of that result in Section 3: same hypotheses? same conclusion?
- Try at least two small cases by hand against the statement (for example p = 2, q = 2 or 4, and p = 3, q = 3, small n) and write the numbers down. If a case contradicts the statement, that is the most important thing in your answer.
- Edge cases: n = 0, a level with no node, t = 0, p = 2, k = 1, the empty family, a weight that is zero.

## Form of the answer

For each of the four: a verdict (**correct as written** / **correct, with gaps** / **wrong**), then the list of findings, each with the line number, a short quotation and what is wrong or missing, ordered by importance. Then one paragraph: what you did not check. No summary of the paper, no praise. If you find nothing wrong, say exactly what you verified. Do not edit any file.
