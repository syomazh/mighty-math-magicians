# W018 — Blind search for a different, more elegant proof

**Stay blind.** The team already has one candidate proof. We want proofs found independently of it. Do **not** open `notes/`, `paper/`, `talk/`, `explainer/`, `CLAIMS.md`, `STATE.md`, `JOURNAL.md`, `logs/`, other files in `briefs/`, or any existing folder in `experiments/`. You may read `mathathon_problems.txt` (search "PROBLEM 137") and `references/README.md`.

## The theorem

p prime, k ≥ 1, q = p^k. C_n^(q) = binom(qn, n)/((q−1)n+1) is the number of q-ary trees with n nodes (every node has q ordered branches, each empty or a q-ary tree). Let m = (q−1)n+1 and let s_p(m) be the sum of the base-p digits of m. Then

    v_p(C_n^(q)) = (s_p(m) − 1)/(p − 1).

The known proof computes valuations of factorials (Legendre). **Wanted:** a proof from the combinatorics of the trees (or of any other objects counted by C_n^(q): lattice paths, polygon dissections, non-crossing partitions, parking functions, …) that does not use the p-adic valuation of factorials or binomial coefficients, and that makes it *intuitively clear* why base-p digits of m appear. Elegance and intuition matter more than generality: a beautiful proof for q = p, or even for p = 2, is valuable.

## What to do

Find up to three genuinely different strategies. Some lenses, to use or ignore: a p-group acting on trees and a count of orbits by size; a recursive decomposition driven by the digits of m; the functional equation G = x + G^q read modulo powers of p; the cycle lemma and necklaces; rotations of a polygon dissected into (q+1)-gons; a sign-reversing or fixed-point argument showing a quotient is not divisible by p; an explicit p^t-to-1 map onto a set whose size is visibly prime to p; a physical or algorithmic process whose number of steps is the valuation.

For each strategy write:

1. the key idea in at most five lines, in plain language;
2. the precise lemmas, each with a proof or an honest "GAP: …";
3. a computational check of every lemma on small cases (write and run code in `experiments/E008_blind_muse/`, using `uv run python`);
4. a self-assessment: complete / complete modulo listed gaps / heuristic only; and what a first-year student would find hardest.

Finish with a ranking of your strategies by elegance, and one paragraph: "the most intuitive explanation I found for why digit sums appear".

Write the report to `notes/blind_proof_search_muse.md` (first line: your model name). Be honest: a clearly marked gap is far better than a wrong proof. Do not cite literature. Touch only `notes/blind_proof_search_muse.md` and `experiments/E008_blind_muse/`.
