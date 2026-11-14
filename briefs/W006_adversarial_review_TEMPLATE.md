# Adversarial review of the proof in `paper/main.tex`

You are a hostile but fair referee for a combinatorics journal. The paper `paper/main.tex` claims an elementary proof that v_p(C_n^(q)) = (s_p((q−1)n+1) − 1)/(p − 1) for q = p^k, using a rotation action on p-ary trees. It was drafted by an AI model and has not been checked by anyone. Your job is to find errors. Assume there is at least one.

Read `paper/main.tex` in full, line by line. You may also read `notes/briefing_grad_student/briefing.tex` (a shorter, independently written account of the same argument) to compare, and `experiments/E000_first_sanity_check/output.txt` for numerical values. Do not read anything in `paper/reviews/`.

For every definition, lemma, proposition, theorem and worked example, in order, give one verdict:

- **CORRECT**: you checked every step; say in one or two sentences why the key step holds.
- **GAP**: probably true, but the proof skips something. Quote the sentence, say exactly what is missing and how to fill it.
- **WRONG**: give a concrete counterexample with small numbers, or the precise false inference.

Attack these points in particular:

1. Is `~` well defined? Is the "normal form" lemma proved rather than assumed? Is d(T) shown to be constant on classes?
2. Class-size lemma: is the primality of p used correctly? Are the product sets really disjoint?
3. Digit lemma: is "equality iff no carries" proved for r summands, not just two?
4. Lower bound: redo the symmetric-root and asymmetric-root arithmetic yourself.
5. Minimal classes: both directions of the skeleton/atom correspondence; the depth condition "an atom of height j sits at depth ≡ −j (mod k)"; whether the bijection is with classes rather than trees; whether equal atoms are handled correctly.
6. Counting mod p: (i) freeness of the action of ∏ S_{m_j}: what exactly does "fixes a labelled cyclic tree" mean, and is the p-group claim proved? (ii) the fixed-point analysis for the p-cycle on labels: is the count p−1 right, and is "the new leaf has class c+1" right, including the wrap-around c = k−1? (iii) T(a) = 0 when all a_c < p and a ≠ e_0; (iv) the invariant modulo p^k − 1 and termination, including q = 2 and q = 3; that the number of carries is t.
7. Check by hand, showing your work, the paper's claims in the cases (p,k,n) = (2,1,3), (2,1,6), (3,1,2), (3,1,3), (2,2,2), (2,2,3). List all trees or all classes where feasible.
8. Does any proof secretly use Legendre's formula, Kummer's theorem, or the valuation of a factorial or binomial coefficient? Is the exact-count formula for k = 1 circular?
9. Worked examples: recompute every number.
10. Anything asserted with "clearly" or "it follows" that is not a one-line check.

Write your report to `REVIEWFILE` with these sections: **Summary verdict** (is the main theorem proved: yes / yes modulo the listed gaps / no); **Table of verdicts**; **Detailed findings**, ordered by severity, each with its exact location (lemma name and a quoted phrase) and a proposed fix; **Hand computations**; **What you did not check**. Be concrete. No praise. Do not edit `paper/main.tex`. Touch only `REVIEWFILE`.
