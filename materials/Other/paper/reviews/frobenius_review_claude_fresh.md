Written by a fresh-context Claude subagent (Claude Fable 5.2) on 2026-11-14, acting as referee, having read only `paper/frobenius_proof.tex` (no notes, no other paper, no experiment, no earlier review, no git history). Not human-verified.

# Referee report on `paper/frobenius_proof.tex` ("A proof by Frobenius")

Numbering below is inferred from the LaTeX source (I did not compile): Theorem 1; Lemma 2 (`lem:theta`); Lemma 3 (`lem:system`); Definition 4 (weight); Lemma 5 (`lem:lower`); Corollary 6 (`cor:div`); Definition 7 (the algebra A); Lemma 8 (`lem:lead`); Lemma 9 (`lem:H`); Lemma 10 (`lem:subst`); Lemma 11 (`lem:hur`); Proposition 12 (`prop:carry`); Proposition 13 (`prop:eval`). Labels are given so nothing depends on the numbers.

## Verdict

**Yes, modulo gaps that are routine to fill.** I read every sentence of Sections 1 to 7 and found no false statement and no invalid step. Every numbered statement also survived an independent re-implementation from the definitions in the note (seven scripts, every check passes; parameters at the end).

What is literally proved is the congruence for the coefficients of the series G defined by G = x + G^q. That these coefficients are "the Fuss-Catalan numbers" is quoted in Section 1, not proved (finding 1). So the note is self-contained only if C_n^(q) is *defined* as that coefficient or as the tree count; if it is defined by the binomial formula, one classical external theorem is used. All other findings are omitted routine justifications or wording.

## Findings, ranked by severity

**No finding is tagged WRONG.** Five GAPs (one external classical fact, four routine), seven UNCLEAR.

### 1. GAP (classical fact quoted, not proved). Section 1, the sentence "Its coefficients are the Fuss-Catalan numbers: G = sum C_n^(q) x^((q-1)n+1), where C_n^(q) is the number of q-ary trees with n internal nodes"

Sections 2 to 7 prove the congruence for c_m := [x^m]G with m = (q-1)n+1. The note never proves that c_m is C_n^(q). Two different statements are hidden in that sentence:

- (a) c_m = number of q-ary trees with n internal nodes. This is the root decomposition, one line, but it is not written as an argument. It is also the one place where the note uses a tree, which contradicts the last sentence of Section 8 ("this note never uses a tree").
- (b) c_m = binom(qn, n) / ((q-1)n+1). This is Lagrange inversion (or the cycle lemma): a real external theorem.

If Problem 137 or a judge takes the binomial formula as the definition, the claim "self-contained" fails at this point.

**Fix.** Add to Section 1: "Throughout, C_n^(q) denotes [x^((q-1)n+1)]G. By the root decomposition (a tree is a leaf or a root with q subtrees) this is the number of q-ary trees with n internal nodes. The closed formula binom(qn,n)/((q-1)n+1) is classical (Lagrange inversion) and is not used." Either prove or drop the implicit claim that G is supported on exponents congruent to 1 mod q-1 (one-line induction).

Numerically: G computed from the recursion alone agrees with the closed formula, and vanishes off m = (q-1)n+1, for every (q, n) I tried (script t4, Part A).

### 2. GAP (routine). Lemma 8 (`lem:lead`) (ii), last paragraph of the proof: "... and the first contributes 1/p times the sum of c_{i_1}...c_{i_p} over the carry-free p-tuples of monomials of weight -1. For a fixed total x-exponent m this is (1/p) l_{delta+1}^{cf p}(m)."

The identity is asserted in A, that is at every m >= 0. The proof does not say three things:

- (a) Why y times the product of a carry-free p-tuple of weight -1 monomials is exactly *the* monomial x^m y^((s_p(m)-1)/(p-1)) that defines l_delta(m). Reason: by the equality case of (wprod) the product has weight -1, and a monomial of weight -1 is determined by its x-exponent. In particular s_p(m) = 1 mod (p-1) holds automatically and the y-exponents take care of themselves.
- (b) Why a sum over tuples of *monomials* equals the sum over tuples of *integers* (a_1, ..., a_p) in the definition of the carry-free product. Same reason (one weight -1 monomial per x-exponent), plus: tuples with some a_i = 0, or with some a_i carrying no weight -1 monomial, contribute 0 because l_{delta+1}(a_i) = 0. This uses the convention l(0) = 0.
- (c) The cases m = 0 and s_p(m) not congruent to 1 mod (p-1), where the left side is 0 by convention. The right side is 0 because alpha_delta(m) = 0 and a carry-free p-tuple of exponents of weight -1 monomials has digit sum congruent to p = 1 mod (p-1).

All three are true and verified by computer at every m <= N for every delta. Each is one sentence. This lemma is the hinge of the proof and the obvious place for a judge to ask "what happened to the y-exponents?", so write them out.

### 3. GAP (routine). Lemma 10 (`lem:subst`), proof

- (a) First paragraph, "P -> P(u) is a ring homomorphism Q[[z]] -> A": multiplicativity is asserted, not shown. It is true: (PQ)(u)(m) and (P(u) cf Q(u))(m) are the same finite sum, because u^{cf a} cf u^{cf b} = u^{cf (a+b)} (associativity and commutativity of A) and only |a|+|b| <= m contributes. One sentence.
- (b) Second paragraph, "the multinomial theorem gives": it is applied to u_c = sum over j = c (mod k) of x_j, an infinite sum. The parenthesis "(only the j with p^j <= m matter at m)" is the right idea but the reason is missing: the value at m of a carry-free product depends only on the values of the factors on {0, ..., m}, so u_c may be replaced by the finite sum over p^j <= m.
- (c) First paragraph, "These equations determine the value at m from the values at smaller arguments": this needs both families to vanish at 0. h_delta(0) = 0 is stated; l_delta(0) = 0 holds by the convention of Section 5 but is not recalled. Without vanishing at 0 the claim is false, since the tuple (m, 0, ..., 0) is carry-free. For p = 2, k = 1 there is a second solution with value 2 at 0.

### 4. GAP (routine). Lemma 3 (`lem:system`), proof, "and they are in Z[y] by Lemma theta"

Lemma 2 is applied to F_{delta+1}, the object under construction. Correct order: define the coefficients of x^m of all F_delta (all delta at once) by recursion on m; the coefficient of x^m in theta(F_{delta+1}) equals that of theta(T), where T is the polynomial truncation of F_{delta+1} to x-degree < m; and theta(T) has integer coefficients by Lemma 2. Polynomiality in y follows by the same induction.

The recursion itself is well-founded: the coefficient of x^m uses x-degrees m/p and at most m-p+1 of F_{delta+1}, both < m, given that there are no terms of x-degree 0. That hypothesis is stated and is needed.

### 5. GAP (routine). Lemma 2 (`lem:theta`), proof, "Expand f^p as a sum over p-tuples of indices"

f may have infinitely many monomials (the lemma is applied to F_{delta+1}). Missing: each monomial of f^p receives contributions from finitely many tuples (finitely many monomials of each x-degree because coefficients are polynomials in y, and x-degrees are >= 0), and for a fixed monomial the set of non-constant tuples producing it is finite and stable under cyclic shifts, so (E2) applies monomial by monomial. The matching sentence exists in Lemma 11(ii) ("each coefficient of f^p receives finitely many contributions"); add it here.

### 6. UNCLEAR. Lemma 8 (`lem:lead`) (i), "The solution is unique (recursion on the degree)"

The system f_delta(x) = [delta=0] x + f_{delta+1}(x^p) has other solutions if constant terms are allowed (add the same constant to every f_delta). Uniqueness holds among series without constant term, which is what F_delta(x,0) and A_delta are. Add "among series without constant term".

The other recursions state their hypothesis and are well-founded; I checked each: (G) uses degrees <= m-q+1; Lemma 3 as in finding 4; Lemma 9 uses total degrees <= n-p+1, simultaneously in delta; Lemma 10 as in finding 3(c).

### 7. UNCLEAR. (E1) is stated for m_i >= 1 but used with zero summands; the letter m_i is overloaded

In A the sums a+b = m include a = 0 or b = 0, and the "carry-free r-tuples" in f^{cf r} include zeros; the associativity argument cites "the definition in (E1)". State (E1) for m_i >= 0 (the proof is unchanged). Also, in (E1) the summands are called m_1, ..., m_r, while everywhere else m_j is the j-th digit of m (Theorem 1, Lemma 10). Rename the summands.

### 8. UNCLEAR. Proposition 12 (`prop:carry`), proof

All correct, but three silent steps:

- "Applying this k times": multiplying a congruence mod p Hur by H_{delta+1}^{p-1} uses that p Hur is an ideal of Hur and that E H_{delta'} lies in Hur (Lemma 11(i)).
- Integrality: the induction is on n for all delta simultaneously, uses that truncations of elements of Hur lie in Hur, and applies Lemma 11(ii) to a truncation (which has no constant term). "agrees in degrees <= n+1" is correct (in fact <= n+p-1).
- Lemma 11(iv) needs H_{delta+1} in Hur, so integrality must come first. It does; say that the order matters.

### 9. UNCLEAR. Proposition 13 (`prop:eval`) and Section 7: representatives of Z/k

a is indexed by Z/k but the sum of a_c p^c needs the representatives 0, ..., k-1. In "a' = a - p e_c + e_{c+1} (indices modulo k)" the wrap-around c = k-1 to c+1 = 0 is exactly where q = 1 mod (q-1) is used. It is handled correctly; say once "we identify Z/k with {0, ..., k-1}".

I checked the induction: it is on |a|; the case "all a_c <= p-1" is the base; |a'| = |a| - (p-1) < |a|, a' >= 0, a' != 0, and the hypothesis is preserved, so it terminates with every hypothesis intact. For q = 2 the hypothesis is vacuous and the statement says every T_0(a) is odd, which is true; the base case "the only integer in [1, q-1] congruent to 1" degenerates correctly to {1}. For k = 1 (c+1 = c, delta+1 = delta) everything goes through.

### 10. UNCLEAR. Notation clashes

x_j in A (indicator of {p^j}) against the variable x; a, b are integers in the definition of the carry-free product, vectors in N^k from Section 6 on, and b is an exponent <= p-1 in Lemma 10 but a vector in Proposition 12; "N" is used without saying that it contains 0 (needed in Lemma 11(iv), where n_i = 0 occurs).

### 11. UNCLEAR. (E1), "Two consequences: s_p(pm) = s_p(m)"

Not a consequence of (E1), which only gives s_p(pm) < p s_p(m). It is the digit shift. Say "Two further facts".

### 12. UNCLEAR. Claims in the status box, the file header and Section 8 that the note itself does not support

- "The only inputs are ...": also used are (E2), integrality of multinomial coefficients, uniqueness of base-p expansions, the general Leibniz rule and the multinomial theorem. All standard; drop "only".
- "no valuation of a factorial": true in the sense "no Legendre or Kummer formula", but the proofs use p not dividing n! for n < p (Theorem 1, Lemma 11(iv)), p | binom(pb, b) (Lemma 11(ii), proved there) and p | p!/(n_1! ... n_p!). A judge may call these factorial valuations; be ready to say they are the trivial cases.
- "this note never uses a tree" against Section 1 (finding 1).
- "Every lemma is checked numerically in experiments/E010...", "The two proofs share no lemma", the description of [KM] and its bibliographic data: I opened none of these and cannot confirm them from the note. The bibliography entry in particular is unverified by me.

### Observation (not an error)

H_delta is weighted-homogeneous: with weight(z_c) = p^c, every monomial of H_delta has weight congruent to p^(-delta) mod (q-1), immediately from (H). So T_0(a) != 0 forces the hypothesis of Proposition 13, and T_0(a) = 0 when it fails (confirmed numerically). Likewise F_delta is supported on m congruent to p^(-delta) mod (q-1). A remark would explain where the hypothesis of Proposition 13 comes from.

## Statements checked and found correct

- Section 1: existence and uniqueness of G; t is a non-negative integer; each m_j! is prime to p; the "in particular" clause of Theorem 1.
- (E1) and its proof, including termination and the count of steps; the two further facts; (E2); (E3) (quoted, standard; p = 2 fine).
- Lemma 2: the formula for theta(f) and its integrality, including negative coefficients (subject to finding 5).
- Lemma 3: the recursion; the computation with epsilon (y = p), which correctly avoids commuting epsilon with phi; g_0 = x + g_0^(p^k); the case k = 1.
- (wprod) and (wphi), including the equality cases.
- Lemma 5 (lower bound) and Corollary 6.
- A is a commutative, associative, unital Q-algebra; the description of f^{cf r} as a sum over carry-free r-tuples.
- Lemma 8(i). Lemma 8(ii): the phi-part (only x^(p^j) survive), the theta-part, the exclusion of constant tuples, the y-exponents (subject to finding 2).
- Lemma 9.
- Lemma 10: the substitution homomorphism, the uniqueness step, x_j^{cf b}, the multinomial step, the use of uniqueness of base-p expansions, the index bookkeeping alpha_delta = u_{-delta} (subject to finding 3).
- Lemma 11(i) to (iv). In (iv) the tuple classification is right for every p, including p = 2 where there are no "other" tuples; the "p^2 Hur" claim is right.
- Proposition 12: integrality; the two displayed formulas; the cancellation of the two brackets (same condition, also for k = 1); E H_delta = H_{delta+1}^{p-1} E H_{delta+1} mod p Hur; the iteration with Pi^r; the coefficient extraction.
- Proposition 13: both cases, the induction, all index conventions mod k.
- Section 7: the assembly, including a(m) != 0, |a(m)| = s_p(m), and the reduction of p^j to p^(j mod k) modulo q-1.
- Section 8 (not part of the proof): rows 1 to 4 of the table checked numerically. The "Modulo p" remark is correct.

## What I tested by computer

Scripts are in `paper/reviews/scratch_frobenius/`, run with `uv run python <script>` from the repository root, standard library only, written from the definitions in the note. Outputs are saved next to them as `t*_output.txt`. **Every check passed.** Wrong variants were confirmed to fail where I tried them (wrong index or ordinary product in Lemma 8(ii); wrong sign in Lemma 11(iv); q not a power of p in Theorem 1).

| Script | What | Parameters |
|---|---|---|
| `t1_system_weights_lead.py` (default and `big`) | F_delta built degree by degree with theta computed literally as (f^p - phi f)/p and exact division asserted; (system) re-verified with generic series multiplication; F_0(x,p) = G; Lemma 5; Corollary 6; Lemma 8(i); Lemma 8(ii) with the carry-free product computed literally, at every m <= N and every delta; C_n = l_0(m) p^t mod p^(t+1); Theorem 1 | (p,k,N): (2,1,260), (2,2,520), (2,3,800), (2,4,1100), (2,5,1300), (3,1,420), (3,2,900), (3,3,1500), (5,1,640), (5,2,1900), (5,3,3200), (7,1,800), (7,2,2500), (11,1,1400); N is the maximal x-degree |
| `t2_hurwitz_carry_eval.py` | Lemma 11(i) to (iv) on random Hurwitz series with coefficients in [-6,6]; Lemma 9; Proposition 12 for all delta, c, b; Proposition 13; Lemma 10; (u^{cf a}/a!)(m) by literal carry-free products | Lemma 11: p in {2,3,5,7}, k <= 3, total degree 7 to 16. H_delta: (p,k) with p <= 7, k <= 4, total degree 10 to 43 |
| `t3_elementary_theta_algebra.py` | (E1) exhaustive and random, zeros included; (E2); Lemma 2 on random f with negative coefficients and terms of x-degree 0; (wprod), (wphi); A commutative, associative, unital, distributive on random functions; powers of x_j | (E1): p in {2,3,5,7,11}; (E2), (wprod), (wphi): p in {2,3,5,7}; Lemma 2 and A: p in {2,3,5} |
| `t4_theorem_large.py` | Theorem 1 including v_p(C_n) = t and the residue. Part A: C_n from the recursion G = x + G^q only. Part B: closed formula | A: q in {2,4,8,16,32,3,9,27,5,25,125,7,49,11,13}, n up to 400 (q=2) down to 12 (q=125). B: 19 values of q up to 125, n up to 6000 (q=2), 5000 (q=3), 4000 (q=5), down to 500 (q=121) |
| `t5_deeper_carry_eval_trees.py` | Propositions 12 and 13 at higher degree, counting non-trivial instances; the three displayed congruences inside the proof of Proposition 12; Section 8: rotation classes of trees against [x^m y^d]F_delta, and class size p^d | (p,k,D) from (2,1,150), (2,2,44), (2,3,24), (2,4,16), (2,5,12) to (13,1,181), 17 cases, k up to 5. Trees: (p,k) = (2,1), (3,1), (2,2), (5,1), (2,3), (3,2), up to 23,714 trees |
| `t6_subst_bigger.py` | Lemma 10 for all m <= N and all delta, and the final assembly exactly as in Section 7 | 12 cases, N from 200 (q=2) to 2000 (q=49) |
| `t7_proof_internals.py` | p divides (pb)!/(b!)^p, and the two identities of Lemma 11(ii); the tuple classification and the p^2 Hur claim of Lemma 11(iv); the carry reduction of Proposition 13 ends at e_0 exactly under its hypothesis, whichever c is chosen; in Lemma 8(ii), y mu^p never has weight -1 | p up to 13 for Lemma 11(ii); p up to 7 otherwise |
| `t0_sanity_print.py` | prints F_delta and G for small cases; confirms that wrong variants of Lemma 8(ii) fail | (p,k) = (2,1), (3,1), (2,2), (3,2), (2,3) |

Sizes worth knowing: Theorem 1 was confirmed from F_0 for n <= 259 (q=2), 173 (q=4), 114 (q=8), 209 (q=3), 112 (q=9), 159 (q=5), 133 (q=7), 139 (q=11), and fewer for larger q. Proposition 12 had 2,958 non-trivial instances for q=8 and 3,264 for q=16; Proposition 13 was checked on 418 vectors for q=8 and 345 for q=4.

## What I could not test or did not check

- Any statement beyond the finite ranges above. k >= 5 is covered only thinly (k=5 for p=2; k=6 only through the closed formula).
- Lemma 11 for all Hurwitz series: random series only.
- Part B of `t4` uses the closed formula, which the note does not prove (finding 1); it is cross-checked against the recursion only in the ranges of Part A.
- The content of experiment E010, of the main paper, and the [KM] reference: not opened, by instruction.
- I did not compile the LaTeX.
