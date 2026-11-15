# W040 — Lean: the Frobenius proof, part 10 (Lemma "From the leading part to the labelled series")

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker"). This is the hardest remaining piece; partial results with honest names are welcome.

## Where things stand

`lean/MMM/Frob/Lead.lean` (compiled) defines and proves:

```lean
def lead (p : ℕ) (f : Lambda) (m : ℕ) : ℤ :=
  if 0 < m ∧ (p - 1) ∣ (ds p m - 1) then (f.coeff m).coeff ((ds p m - 1) / (p - 1)) else 0
def cfpow (p : ℕ) (g : ℕ → ℤ) (m : ℕ) : ℤ :=
  ∑ c ∈ (Finset.Nat.antidiagonalTuple p m).filter (fun c => ∑ i, ds p (c i) = ds p m), ∏ i, g (c i)
theorem lead_solution (p : ℕ) [Fact p.Prime] (k : ℕ) (δ : ZMod k) (m : ℕ) :
    (p : ℤ) * lead p (solution p k δ) m =
      (p : ℤ) * alpha p k δ m + cfpow p (lead p (solution p k (δ + 1))) m
```

with `alpha p k δ m = if ∃ j, m = p ^ j ∧ (j : ZMod k) + δ = 0 then 1 else 0` (`YZero.lean`). Digits: `lean/MMM/DigitsCarry.lean` has `dig p j n := (n / p ^ j) % p` with `dig_add`, `dig_sum`, `ds_add_eq` (equality of digit sums means no carries), and `lean/MMM/DigitsFree.lean` has `ds_sum_of_dig_lt`, `eq_of_dig_eq`, `ds_eq_sum_dig`, `dig_eq_zero_of_lt`. Read these files, and Lemma `lem:subst` of `paper/frobenius_proof.tex` with its proof (lines 298 to 338). Change none of them.

The note proves the lemma through a ring homomorphism into an algebra with a "carry-free product". This brief asks for the same statement by a direct induction on m, which needs no such algebra.

## File you own

`lean/MMM/Frob/Subst.lean` (new). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Definitions (namespace `MMM.Frob`; `[NeZero k]` so that `ZMod k` is finite)

```lean
/-- a(m): the base-p digits of m added up according to the residue class of their position. -/
def digitVec (p k : ℕ) (m : ℕ) : ZMod k → ℕ :=
  fun c => ∑ j ∈ Finset.range (m + 1), if (j : ZMod k) = c then dig p j m else 0

/-- ∏_j m_j!. -/
def digitFact (p m : ℕ) : ℕ := ∏ j ∈ Finset.range (m + 1), (dig p j m).factorial

/-- The ordered p-tuples of multi-indices with sum a. -/
def tuplesOf (p : ℕ) {ι : Type*} [Fintype ι] [DecidableEq ι] (a : ι → ℕ) : Finset (Fin p → ι → ℕ) :=
  (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun c => Finset.range (a c + 1)).filter
    (fun u => ∑ i, u i = a)

/-- ∏_c (a_c)! / ∏_i (u_i c)!: the multinomial coefficient of a splitting of a multi-index. -/
def mmultinomial {p : ℕ} {ι : Type*} [Fintype ι] (u : Fin p → ι → ℕ) : ℕ :=
  ∏ c, Nat.multinomial Finset.univ (fun i => u i c)

/-- The recursion satisfied by the coefficients T_δ(a) of the labelled series H_δ = z_(-δ) + H_(δ+1)^p / p. -/
def LabelledRec (p k : ℕ) [NeZero k] (T : ZMod k → (ZMod k → ℕ) → ℤ) : Prop :=
  (∀ δ, T δ 0 = 0) ∧
  ∀ δ a, (p : ℤ) * T δ a =
    (p : ℤ) * (if a = Pi.single (-δ) 1 then 1 else 0) +
      ∑ u ∈ tuplesOf p a, (mmultinomial u : ℤ) * ∏ i, T (δ + 1) (u i)
```

(`range (m + 1)` is long enough because `p ^ j > m` for `j > m`. If a definition is awkward in Lean, change it as little as possible, keep the meaning, and say what you changed.)

## The statement

```lean
theorem lead_mul_digitFact (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k]
    (T : ZMod k → (ZMod k → ℕ) → ℤ) (hT : LabelledRec p k T) (δ : ZMod k) (m : ℕ) :
    lead p (solution p k δ) m * (digitFact p m : ℤ) = T δ (digitVec p k m)
```

## Proof plan

Strong induction on m, for all δ at once. For m = 0 both sides are 0 (`lead … 0 = 0` by definition, `digitVec p k 0 = 0`, `T δ 0 = 0`). For m ≥ 1 multiply by p (ℤ has no zero divisors) and compare `lead_solution`, multiplied by `digitFact p m`, with the recursion of `hT` at `a = digitVec p k m`. Three facts are needed.

1. **The unit term.** `alpha p k δ m * digitFact p m = if digitVec p k m = Pi.single (-δ) 1 then 1 else 0`. If m = p^j then the only non-zero digit is 1 at position j, so `digitFact = 1` and `digitVec = Pi.single (j : ZMod k) 1`, and `(j : ZMod k) + δ = 0 ↔ (j : ZMod k) = -δ`. Conversely if `digitVec p k m` is a unit vector then the digit sum of m is 1, so m is a power of p (`eq_pow_of_ds_eq_one` in `Lead.lean`).
2. **Carry-free tuples are digit matrices.** A tuple `c : Fin p → ℕ` with sum m is in the filter of `cfpow` exactly when the digits add up position by position: `∀ j, ∑ i, dig p j (c i) = dig p j m` (no carries; from `ds_add_eq` / `ds_sum_of_dig_lt` and `dig_sum`). For such a tuple `digitVec p k m = ∑ i, digitVec p k (c i)`, every `c i ≤ m`, and `digitFact p m = (∏ j, Nat.multinomial Finset.univ (fun i => dig p j (c i))) * ∏ i, digitFact p (c i)`.
3. **Regrouping.** For a fixed `u ∈ tuplesOf p (digitVec p k m)`, the sum over the carry-free tuples c with `digitVec p k (c i) = u i` for all i of `∏ j, Nat.multinomial Finset.univ (fun i => dig p j (c i))` equals `mmultinomial u`. This is a Vandermonde identity, class by class: for each residue class of positions, the ways to split the digits m_j (j in the class) among the p entries with prescribed totals `u i c` are counted with weights ∏ multinomial(m_j; …) and add up to multinomial(Σ_j m_j; (u i c)_i) (`Nat.multinomial` of a sum; prove it by induction on the number of positions from the two-position case, or from the multinomial theorem `Finset.sum_pow` / `Nat.sum_multinomial…`; grep `Mathlib/Data/Nat/Choose/Multinomial.lean` and `Mathlib/Data/Nat/Choose/Vandermonde.lean`). A carry-free tuple is the same thing as a matrix of digits `d i j ≤ p − 1` with column sums `dig p j m`: `c i = ∑ j, d i j * p ^ j`.

Then: by 2 and the induction hypothesis (entries equal to m force another entry to be 0, where `lead` vanishes and `T _ 0 = 0`; all other entries are < m),
`cfpow p (lead p (solution p k (δ+1))) m * digitFact p m = ∑ c carry-free, (∏ j multinomial …) * ∏ i, T (δ+1) (digitVec p k (c i))`, and by 3 this is `∑ u ∈ tuplesOf p (digitVec p k m), mmultinomial u * ∏ i, T (δ+1) (u i)`.

## Order of work, and what to do if it does not all fit

Prove fact 1 first, then fact 2, then state fact 3 as a lemma `vandermonde_digits` and derive `lead_mul_digitFact` **from facts 1, 2 and 3**; prove fact 3 last. If fact 3 (or fact 2) cannot be finished, keep the derivation with the unproved fact as an explicit hypothesis of a theorem named `lead_mul_digitFact_of`, and say so. Do not state `lead_mul_digitFact` unless everything is proved. Small computer checks of the statement are easy (p = 2, 3; k = 1, 2; m ≤ 30) if you want to test a formulation before proving it: `uv run python` is available.

## Environment and rules

Exactly as in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Frob/Subst.lean -o .lake/build/lib/lean/MMM/Frob/Subst.olean`; never `lake build`; grep Mathlib for names; no `sorry`, no axiom, no theorem with conclusion `True`; the file must compile when you stop; header naming the model; no git changes). Several other workers compile on this machine tonight: one compile at a time, and be patient.

## Report

For each fact and for the theorem: done or not, the statement as it is in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for your last theorem.
