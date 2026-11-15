# The Frobenius proof in plain words, with one worked example

- **Date:** 2026-11-14 (Saturday morning)
- **Author:** Claude Fable 5.2 (AI, orchestrator).
- **Purpose:** a reading aid for `paper/frobenius_proof.pdf` (claim C18). The note is the proof; this file only explains it. All numbers below were produced by `experiments/E010_frobenius_complete/run.py` or `experiments/E011_crossfield_checks/run.py`, or are small enough to check by hand. Not human-verified.

## What the proof does, in six sentences

1. The Fuss–Catalan numbers are the coefficients of the series G with G = x + G^q. That equation is the only thing we use about them.
2. For any series f with integer coefficients, f^p = f(x^p) + p·θ(f), where θ(f) again has integer coefficients ("raising to the p-th power is substituting x^p, up to a multiple of p").
3. Write a variable y in place of that factor p. The equation G = x + G^p becomes F = x + F(x^p, y^p) + y·θ(F). Its solution F has coefficients that are polynomials in y, and putting y = p gives back G. (For q = p^k there are k such equations chained in a ring.)
4. **Lower bound.** Give the monomial x^m y^d the weight (p−1)d − s_p(m). Because digit sums can only drop when numbers are added, every monomial of F has weight at least −1. That says: in the coefficient of x^m the lowest power of y is at least y^t. So p^t divides the Fuss–Catalan number.
5. **The lowest term.** The monomials of weight exactly −1 satisfy the same equation, except that products with a carry are thrown away. Solving that equation gives: (coefficient of x^m y^t) × ∏ m_j! = T, where T is the coefficient of a "labelled" series H = z + H^p/p.
6. **Not divisible by p.** Modulo p the series H is killed by the operator "differentiate p times, plus differentiate once". In terms of coefficients: T(a + p) ≡ −T(a + 1). Stepping down gives T ≡ (−1)^t. Hence C·∏ m_j! ≡ (−p)^t modulo p^(t+1).

## The worked example: p = 2, q = 2 (Catalan numbers)

Here θ(f) = (f² − f(x², y²))/2 and the equation is F = x + F(x², y²) + y·θ(F).

**Step 3: computing F.** Coefficient by coefficient (m = number of leaves):

| m | coefficient of x^m in F | at y = 2 | Catalan number |
|---|---|---|---|
| 1 | 1 | 1 | C_0 = 1 |
| 2 | 1 | 1 | C_1 = 1 |
| 3 | y | 2 | C_2 = 2 |
| 4 | 1 + y² | 5 | C_3 = 5 |
| 5 | y + y² + y³ | 14 | C_4 = 14 |
| 6 | y + 2y² + 2y³ + y⁴ | 42 | C_5 = 42 |
| 7 | 3y² + 3y³ + 4y⁴ + y⁵ | 132 | C_6 = 132 |
| 8 | 1 + y² + 7y³ + 7y⁴ + 6y⁵ + y⁶ | 429 | C_7 = 429 |

How m = 6 is computed: F(x², y²) contributes the coefficient of x³ with y replaced by y², that is y². The coefficient of x⁶ in F² is 2·(y + y² + y³) + 2·(1 + y²) + y² = 2 + 2y + 5y² + 2y³; subtract y², halve, multiply by y: y + y² + 2y³ + y⁴. Total: y + 2y² + 2y³ + y⁴.

What the table means for trees (not needed for the proof): the coefficient of y^d counts the shapes of binary trees with m leaves and d asymmetric nodes. Putting y = 1 gives the number of shapes: 1, 1, 1, 2, 3, 6, 11, 23.

**Step 4: the lower bound.** t = s_2(m) − 1, the number of ones in m minus one:

| m | binary | t | lowest power of y in the table |
|---|---|---|---|
| 5 | 101 | 1 | y |
| 6 | 110 | 1 | y |
| 7 | 111 | 2 | y² |
| 8 | 1000 | 0 | 1 |

Why it must be so, at m = 7 for instance: a term of the coefficient of x⁷ arises as y·(term at x^a)·(term at x^b) with a + b = 7. Its y-exponent is 1 + d_a + d_b ≥ 1 + (s(a) − 1) + (s(b) − 1) = s(a) + s(b) − 1 ≥ s(7) − 1, because s(a) + s(b) ≥ s(a + b). The other kind of term, from F(x², y²), does not occur for odd m.

**Step 5: the lowest term.** Write ℓ(m) for the coefficient of the lowest possible power y^t: ℓ = 1, 1, 1, 1, 1, 1, 3, 1 for m = 1, …, 8. The rule is

    ℓ(m) = [m is a power of 2] + (1/2)·Σ ℓ(a)·ℓ(b)   over the pairs a + b = m that add without a carry.

- m = 6 = 110: the carry-free pairs are (2, 4) and (4, 2). So ℓ(6) = (1 + 1)/2 = 1.
- m = 7 = 111: all six pairs (1,6), (2,5), (3,4) and their reverses are carry-free. So ℓ(7) = 6/2 = 3.
- m = 8 = 1000: no pair is carry-free (two positive numbers with digit sums ≥ 1 would need total digit sum 1). So ℓ(8) = 1, from the first term.

Pairs with a carry are dropped because a carry raises the weight above −1: those terms have a higher power of y.

The labelled series is H = z + H²/2 = z + z²/2 + 3z³/3! + 15z⁴/4! + 105z⁵/5! + …, so T(1), T(2), … = 1, 1, 3, 15, 105 (the numbers of binary trees with labelled leaves, though the proof does not use that). The lemma says ℓ(m)·∏ m_j! = T(s_2(m)): for m = 7 the digit sum is 3 and ℓ(7) = 3 = T(3); for m = 6 the digit sum is 2 and ℓ(6) = 1 = T(2). (For p = 2 all digits are 0 or 1, so the factorials are 1.)

**Step 6: not divisible by 2.** The carry rule for p = 2 is T(a + 2) + T(a + 1) ≡ 0 (mod 2): 1 + 1, 3 + 1, 15 + 3, 105 + 15 are all even. Starting from T(1) = 1 this gives T(s) odd for every s. So ℓ(m) is odd, and the power of 2 in the Catalan number is exactly t.

Where the rule comes from: differentiate H = z + H²/2 twice. (H²/2)″ = H·H″ + (H′)². Modulo 2, in the ring of series Σ f_n z^n/n! with integer f_n, a square is its constant term: (H′)² ≡ 1. And (H²/2)′ = H·H′. Adding: H″ + H′ ≡ 1 + H·(H″ + H′) + 1 ≡ H·(H″ + H′), which forces H″ + H′ ≡ 0. For general p the same computation with the p-th derivative produces the sign −1 through Wilson's theorem, (p−1)! ≡ −1.

## A second example: p = 3 (ternary trees), to see the factorials

F = x + x³ + y·x⁵ + (y + y²)·x⁷ + (1 + 3y² + y³)·x⁹ + (y + 3y² + 6y³ + y⁴)·x¹¹ + …; at y = 3: 1, 1, 3, 12, 55, 273.

- m = 5 = 12 in base 3: digit sum 3, t = 1, digits 2 and 1. ℓ(5) = 1, ∏ m_j! = 2, and T(3) = 2 (the labelled series is H = z + H³/3 = z + 2z³/3! + 40z⁵/5! + …). Indeed 1 × 2 = 2.
- m = 11 = 102 in base 3: digit sum 3, t = 1, ℓ(11) = 1, ∏ m_j! = 2, T(3) = 2.
- The carry rule T(a + 3) + T(a + 1) ≡ 0 (mod 3): 2 + 1 = 3 and 40 + 2 = 42.
- Conclusion for m = 5: C·∏ m_j! = 3 × 2 = 6 ≡ −3 (mod 9). Correct: (−p)^t = −3.

## How the two proofs correspond

| Tree proof | Frobenius proof |
|---|---|
| a class with d asymmetric nodes has p^d trees | put y = p |
| symmetric node / asymmetric node | F(x^p, y^p) / y·θ(F) |
| d ≥ t by digit sums | weight ≥ −1 |
| minimal trees are skeletons of atoms | the weight −1 part obeys the carry-free equation |
| equal atoms may be permuted | division by ∏ m_j! from the multinomial theorem |
| a carry is a collapsing cherry | (∂^p + ∂)H ≡ 0 modulo p |

The tree proof is the one the problem asks for. The Frobenius proof never mentions a tree, so it cannot share a mistake with it.
