# Adjudication of the review of the third proof (`paper/frobenius_proof.tex`)

By Claude Fable 5.2 (orchestrator), 2026-11-14 about 09:55 PT. The review is `frobenius_review_claude_fresh.md`, by a fresh-context Claude instance that was told to read only the note (no other file of the repository) and to try to break it. It wrote its own test code from the note's definitions (`scratch_frobenius/`, seven scripts, all pass; wrong variants were confirmed to fail). Not human-verified.

**Its verdict.** "Yes, modulo gaps that are routine to fill." No statement found false and no step invalid, in Sections 1 to 7. Five GAP findings (one classical fact quoted without proof, four omitted routine justifications) and seven UNCLEAR (wording, notation, claims in the status box). It confirmed the cases p = 2, k = 1 and q = 2, and that the induction of the Evaluation proposition terminates with its hypotheses intact.

**Actions. Every finding was accepted and applied; none was contested.**

| # | Finding | Action in the note |
|---|---|---|
| 1 (GAP) | Section 1 says the coefficients of G "are the Fuss–Catalan numbers" without proof; with the binomial formula as definition this needs Lagrange inversion, and the sentence uses a tree although Section 8 said the note never does. | C_n^(q) is now *defined* as the coefficient of x^((q−1)n+1) in G; the root decomposition is given in one sentence as the reason it counts q-ary trees; the closed formula is called classical and unused. The status box and Section 8 now say that trees are used only to say what C_n^(q) counts. The unproved side remark about the support of G was dropped. |
| 2 (GAP) | Lemma "Leading part" (ii): three sentences missing — why the product of a carry-free tuple of weight −1 monomials is the monomial that defines ℓ_δ(m) (the y-exponents); why tuples of monomials match tuples of integers; the cases m = 0 and s_p(m) ≢ 1. | Two paragraphs added at the end of the proof, covering exactly these three points. |
| 3 (GAP) | Lemma "From the leading part to the labelled series": the homomorphism property asserted; the multinomial theorem applied to an infinite sum; uniqueness needs ℓ_δ(0) = 0. | Multiplicativity shown in one sentence; the infinite sum replaced by a finite one with the reason (a product at m sees its factors only on {0, …, m}, now stated once after the definition of the algebra); vanishing at 0 recalled, with a note on why it is needed. |
| 4 (GAP) | Lemma "system": Lemma θ was applied to the series under construction. | The proof now defines all F_δ together by recursion on the x-degree and applies Lemma θ to the polynomial truncation. |
| 5 (GAP) | Lemma θ: f may have infinitely many monomials. | The finiteness sentence added (finitely many monomials of each x-degree; shift-stable finite sets of tuples). |
| 6 | Uniqueness in "Leading part" (i) needs "without constant term". | Added. |
| 7 | (E1) stated for positive summands but used with zeros; the letter m_i clashes with the digits m_j. | (E1) is now stated for integers n_i ≥ 0; the same letters are used in the carry-free product. |
| 8 | Proposition "carry operator": silent steps (ideal property; simultaneous induction; integrality must come first). | All three stated. |
| 9 | Representatives of Z/k in the Evaluation proposition. | Stated in the proposition; the wrap-around c = k−1 → 0 pointed out in the proof. |
| 10 | Notation clashes (x_j against x; a, b; N). | The indicator functions are now ξ_j; exponents in that proof are β; N = {0, 1, 2, …} is stated in Section 1. |
| 11 | "Two consequences" of (E1): s_p(pm) = s_p(m) is not one. | Now "Two further facts", with the reason (digit shift). |
| 12 | Status-box claims: "only inputs", "no valuation of a factorial", "never uses a tree"; and claims the referee could not confirm (E010, "share no lemma", the reference). | "Only" dropped and the standard tools listed. "No valuation of a factorial" replaced by the precise statement: neither Legendre's nor Kummer's formula is used; the only divisibility facts about factorials are the trivial ones (p ∤ n! for n < p, p divides binom(pb, b), p divides p!/(n_1!…n_p!) when all n_i < p). The claims the referee could not check are ours to stand behind: E010 is in the repository; "share no lemma" is true by inspection of the two texts (the main paper has no generating function, this note has no tree argument); the reference is entry 5 of `references/README.md`, taken from an OpenAlex record. |
| Observation | H_δ is weighted-homogeneous, which explains the hypothesis of the Evaluation proposition. | Added as a remark ("Where the hypothesis comes from"), marked as not used. |

**State.** `paper/frobenius_proof.pdf` compiles (9 pages, no overfull lines). One review round by one reader; the repairs are not re-reviewed. Claim C18 is graded `ai-reviewed` with that qualification. Human sign-off: none.

**What the review does and does not establish.** A second reader with no access to our reasoning found the argument correct and reproduced every numbered statement numerically with its own code. Both the author and the referee are instances of the same model, which is weaker than a review by a different model or a human. The proof is short enough (the logical core is Sections 3 to 7, about five pages) for the grad student or the professor to check directly.
