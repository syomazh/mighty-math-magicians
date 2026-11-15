# W038 — Lean: the Frobenius proof, part 8 (the p-th derivative of a p-th power)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## What this is

Lemma `lem:hur` (iv) of `paper/frobenius_proof.tex` (lines 349 to 353, proof lines 372 to 382) needs one identity about a derivation of a commutative ring. This brief asks for it as a self-contained statement, with no reference to the rest of the project. Read the proof in the note (it uses fact E2, line 101: non-constant p-tuples fall into orbits of p under the cyclic shift).

## File you own

`lean/MMM/Frob/PowDeriv.lean` (new; it needs no import from the project). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Statements (namespace `MMM.Frob`; `R` a commutative ring)

```lean
/-- A derivation given as a plain function: additive, with the product rule. -/
structure IsDer {R : Type*} [CommRing R] (D : R → R) : Prop where
  add : ∀ a b, D (a + b) = D a + D b
  mul : ∀ a b, D (a * b) = D a * b + a * D b

-- helpers (names yours): D 0 = 0, D 1 = 0, D (n • a) = n • D a, D of a finite sum,
-- and the same for the iterates D^[n].

/-- Leibniz' rule for two factors. -/
theorem IsDer.iterate_mul {D : R → R} (hD : IsDer D) (n : ℕ) (a b : R) :
    D^[n] (a * b) = ∑ i ∈ Finset.range (n + 1), (n.choose i) • (D^[i] a * D^[n - i] b)

/-- Leibniz' rule for m factors. -/
theorem IsDer.iterate_prod {D : R → R} (hD : IsDer D) (m n : ℕ) (f : Fin m → R) :
    D^[n] (∏ i, f i) =
      ∑ c ∈ Finset.Nat.antidiagonalTuple m n, (Nat.multinomial Finset.univ c) • ∏ i, D^[c i] (f i)

/-- Fact E2 as a statement about sums: over a set of p-tuples that is closed under the cyclic
shift and contains no constant tuple, a shift-invariant function sums to a multiple of p. -/
theorem sum_cyclic_invariant {M : Type*} [AddCommGroup M] (p : ℕ) [Fact p.Prime] {α : Type*}
    [DecidableEq α] (S : Finset (Fin p → α))
    (hS : ∀ c ∈ S, (fun i => c (i + 1)) ∈ S)
    (F : (Fin p → α) → M) (hF : ∀ c ∈ S, F (fun i => c (i + 1)) = F c)
    (hne : ∀ c ∈ S, ¬ ∀ i j, c i = c j) : ∃ r : M, ∑ c ∈ S, F c = p • r

/-- The identity behind Lemma "hur" (iv). -/
theorem IsDer.iterate_pow_prime {D : R → R} (hD : IsDer D) (p : ℕ) [Fact p.Prime] (u : R) :
    ∃ r : R, D^[p] (u ^ p) =
      p • (u ^ (p - 1) * D^[p] u) + p.factorial • (D u) ^ p + (p ^ 2) • r
```

(`Fin p` needs `NeZero p` for `i + 1`; get it from the prime. If a statement does not typecheck as written, change it as little as possible and say what you changed.)

## Proof plan

- `iterate_mul`: induction on n with Pascal's rule (`Nat.succ_choose_succ` or `Nat.choose_succ_succ`), as for the binomial theorem. Compare Mathlib's proof of `Commute.add_pow` or of `Polynomial.iterate_derivative_mul` and copy its shape.
- `iterate_prod`: induction on m (peel off one factor with `Fin.prod_univ_succ` or `Fin.prod_univ_castSucc`), using `iterate_mul` and the description of `Finset.Nat.antidiagonalTuple (m + 1) n` in Mathlib (`Finset.Nat.antidiagonalTuple_succ` or `Finset.Nat.sum_antidiagonalTuple_succ`: grep `Mathlib/Data/Fin/Tuple/NatAntidiagonal.lean`), and `Nat.multinomial` of a tuple with one more entry equals a binomial coefficient times the multinomial of the rest (`Nat.multinomial_insert` or similar in `Mathlib/Data/Nat/Choose/Multinomial.lean`).
- `sum_cyclic_invariant`: group the sum by the value of F: `∑ c ∈ S, F c = ∑ y ∈ S.image F, (S.filter (F · = y)).card • y` (`Finset.sum_fiberwise_of_maps_to` or `Finset.sum_comp`). Each fibre `S.filter (F · = y)` is mapped to itself by the shift `σ c = fun i => c (i + 1)`, which is a bijection of the fibre with `σ^[p] = id` and without fixed points (a tuple fixed by the shift is constant: `c i = c (i + 1)` for all i gives `c i = c 0` by induction on `i.val`). Hence p divides the cardinality of each fibre: use Mathlib's `Equiv.Perm.card_fixedPoints_modEq` (a permutation of prime-power order has as many fixed points as elements, modulo p; grep it), or `MulAction.card_modEq_card_fixedPoints`, on the fibre as a subtype; or prove directly that the orbits of σ on the fibre have exactly p elements.
- `iterate_pow_prime`: `u ^ p = ∏ i : Fin p, u` (`Finset.prod_const`, `Finset.card_fin`); apply `iterate_prod` with m = n = p. Split `Finset.Nat.antidiagonalTuple p p` into three parts. (a) The constant tuple `fun _ => 1` (the only constant tuple with sum p): its multinomial coefficient is p!, its product is `(D u) ^ p`. (b) The p tuples `Pi.single i p`: the multinomial coefficient is 1 and the product is `u ^ (p - 1) * D^[p] u`. (c) All others: they are non-constant and have every entry < p, so `Nat.multinomial Finset.univ c = p! / ∏ (c i)!` is divisible by p (p divides p! and not the denominator; `Nat.Prime.dvd_factorial`, `Nat.Prime.dvd_mul`); write it as `p * g c`; the set (c) is closed under the shift and `c ↦ g c • ∏ i, D^[c i] u` is shift-invariant (reindex the products with `Equiv.addRight 1` or `Fin.cycleRange`; `Nat.multinomial` is invariant under a permutation of the index set). By `sum_cyclic_invariant` the sum over (c) is `p • (p • r)`.

Do the targets in this order. If `sum_cyclic_invariant` or `iterate_prod` cannot be finished, state `iterate_pow_prime` with the missing one as an explicit hypothesis under the name `iterate_pow_prime_of`, and say so; do not state the unconditional theorem unless it is proved.

## Environment and rules

Exactly as in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Frob/PowDeriv.lean -o .lake/build/lib/lean/MMM/Frob/PowDeriv.olean`; never `lake build`; grep Mathlib for names; no `sorry`, no axiom, no theorem with conclusion `True`; the file must compile when you stop; header naming the model; no git changes). Several other workers compile on this machine tonight: one compile at a time, and be patient.

## Report

For each statement: done or not, the statement as it is in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for `IsDer.iterate_pow_prime` if it exists.
