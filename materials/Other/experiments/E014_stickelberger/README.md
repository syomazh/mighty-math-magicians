# E014 — a numerical test of the Stickelberger question

- **Date:** 2026-11-14, by Claude Fable 5.2 (orchestrator). Not human-reviewed.
- **Belongs to:** claim C21 in `CLAIMS.md`; note B1′ in `notes/2026-11-14_crossfield_analogies.md`.

## Goal

Our residue formula, written with a number π such that π^(p−1) = −p·(unit), reads C ≡ π^(s−1)/∏ m_j!. Stickelberger's congruence for Gauss sums has the same shape. We had that congruence only from a secondary source. This experiment checks (1) that the congruence holds in the normalisation we quote, and (2) that the Fuss–Catalan number and the Gauss sum then agree to leading order.

## Definitions

p prime, q = p^r, ω the Teichmüller character of F_q^*, ζ a primitive p-th root of unity, π = ζ − 1. For 0 ≤ a < q − 1,

    G(a) = Σ over x in F_q^* of ω(x)^(−a) · ζ^Tr(x).

s(a) is the base-p digit sum of a and a_i its digits.

## Hypotheses

- **S1 (Stickelberger's congruence):** G(a)·∏ a_i! ≡ −π^s(a) (mod π^(s(a)+1)).
- **S2 (comparison):** for Q = p^k and m = (Q−1)n + 1 < q − 1: C_n^(Q)·∏ m_j! ≡ −G(m)·∏ m_j!/π (mod π^s(m)). Given S1, this is equivalent to our theorem.

## Method

`uv run python experiments/E014_stickelberger/run.py` (output in `output.txt`). Exact arithmetic in (Z/p^N)[t]/(h)[π]/(minimal polynomial of π), with h irreducible of degree r modulo p; Teichmüller lifts by repeated q-th powers; the π-adic valuation of Σ c_i π^i is min(i + (p−1)·v_p(c_i)). `control.py` (output in `control_output.txt`) alters the statement (wrong sign, no factorials, exponent s + 1) and checks that the altered versions fail.

## Results

- S1 holds for every exponent in the 12 fields tested: q = 4, 8, 16, 32, 3, 9, 27, 5, 25, 7, 49, 11.
- S2 holds for all 77 pairs tested: binary, 4-ary and 8-ary trees against Gauss sums over F_16 and F_32; ternary and 9-ary trees against F_27; 5-ary against F_25; 7-ary against F_49.
- Controls: for p = 3, 5, 7 none of the altered statements passes for any exponent. (For p = 2 the sign cannot be tested, since −1 ≡ 1.)

## Analysis

- S1 is a classical theorem; this run only confirms that we quote it in a correct normalisation (sum without a leading minus sign, π = ζ − 1, exponent −a on the Teichmüller character).
- S2 is then a consequence of two proved statements (Stickelberger's congruence and our theorem), and the run confirms the bookkeeping. In words: **to leading order, the Fuss–Catalan number with m leaves is −1/π times the Gauss sum of exponent m.**
- What the computer cannot say: whether this is a known remark, and whether it is more than the factorial structure seen twice (Gauss sums are products of values of the p-adic gamma function; the Fuss–Catalan number is a ratio of factorials). That is the question for the professor.

## Next steps

None by machine. A human decides whether the sentence goes into the talk.
