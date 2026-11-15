# W037 — Lean: the Frobenius proof, part 7 (the ring of Hurwitz series and its derivations)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## What this is

The last section of `paper/frobenius_proof.tex` (lines 280 to 464) works with "Hurwitz series": power series Σ_a f_a z^a/a! in finitely many variables with **integer** f_a (the paragraph before Lemma `lem:hur`, line 340). This brief asks for that ring in Lean, with its derivations and the facts about p-th powers. It is independent of the other files of `lean/MMM/Frob/` (you need not import them). Read Lemma `lem:hur` and its proof (lines 343 to 383) for the mathematics, but **use the proofs sketched below**, which avoid counting orbits of tuples.

The idea that makes everything short: describe a Hurwitz series by its coefficient function `a ↦ f_a`. Then the product is the binomial convolution, and the derivative ∂/∂z_c is the shift `a ↦ f_(a + e_c)`.

## File you own

`lean/MMM/Frob/Hurwitz.lean` (new). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Definitions and statements (namespace `MMM.Frob`; `ι` a `Fintype` with `DecidableEq`)

```lean
/-- A Hurwitz series in variables indexed by ι: `coeff a` is the integer coefficient of z^a / a!. -/
@[ext] structure Hur (ι : Type*) where
  coeff : (ι → ℕ) → ℤ

/-- Product of binomial coefficients. -/
def mchoose (a b : ι → ℕ) : ℕ := ∏ i, (a i).choose (b i)
```

**Target 1: the ring.** A `CommRing (Hur ι)` instance with these specification lemmas:

```lean
theorem coeff_zero' (a) : (0 : Hur ι).coeff a = 0
theorem coeff_one' (a) : (1 : Hur ι).coeff a = if a = 0 then 1 else 0
theorem coeff_add' (f g : Hur ι) (a) : (f + g).coeff a = f.coeff a + g.coeff a
theorem coeff_neg' (f : Hur ι) (a) : (-f).coeff a = -f.coeff a
theorem coeff_nsmul' (n : ℕ) (f : Hur ι) (a) : (n • f).coeff a = n * f.coeff a
theorem coeff_mul' (f g : Hur ι) (a) :
    (f * g).coeff a = ∑ b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)),
      (mchoose a b : ℤ) * f.coeff b * g.coeff (a - b)
```

Suggested route: the map `toQ : Hur ι → MvPowerSeries ι ℚ` whose coefficient at a (as a finitely supported function; use `Finsupp.equivFunOnFinite`) is `(f.coeff a : ℚ) / ∏ i, ((a i).factorial : ℚ)`. It is injective, and it turns the product above into the product of power series because `(a i).choose (b i) = (a i)! / ((b i)! (a i − b i)!)`. Define zero, one, add, neg, sub, mul, the scalar actions, powers and casts on `Hur ι` by their coefficient formulas, show that `toQ` respects each, and obtain the instance from `Function.Injective.commRing`. A direct proof of the ring axioms is equally acceptable. The names with a prime are to avoid clashes; choose others if you prefer, but keep the statements.

**Target 2: the constant term and the variables.**

```lean
def constCoeff : Hur ι →+* ℤ            -- f ↦ f.coeff 0
def var (c : ι) : Hur ι := ⟨fun a => if a = Pi.single c 1 then 1 else 0⟩
theorem coeff_pow_zero (f : Hur ι) (n : ℕ) : (f ^ n).coeff 0 = (f.coeff 0) ^ n
```

**Target 3: the derivations.**

```lean
/-- ∂/∂z_c: on coefficients it is the shift by the unit vector e_c. -/
def der (c : ι) (f : Hur ι) : Hur ι := ⟨fun a => f.coeff (a + Pi.single c 1)⟩

theorem der_add (c) (f g : Hur ι) : der c (f + g) = der c f + der c g
theorem der_mul (c) (f g : Hur ι) : der c (f * g) = der c f * g + f * der c g
theorem der_one (c) : der c (1 : Hur ι) = 0
theorem der_nsmul (c) (n : ℕ) (f : Hur ι) : der c (n • f) = n • der c f
theorem der_comm (c c') (f : Hur ι) : der c (der c' f) = der c' (der c f)
theorem der_var (c c' : ι) : der c (var c') = if c = c' then 1 else 0
theorem der_pow_succ (c) (f : Hur ι) (n : ℕ) : der c (f ^ (n + 1)) = (n + 1) • (f ^ n * der c f)
theorem coeff_eq_der (f : Hur ι) (a : ι → ℕ) (c : ι) (hc : 0 < a c) :
    f.coeff a = (der c f).coeff (a - Pi.single c 1)
```

`der_mul` is Pascal's rule `(n+1).choose (k+1) = n.choose k + n.choose (k+1)` in the coordinate c (through `toQ` it is the product rule; do whichever is shorter). `der_pow_succ` by induction from `der_mul`.

**Target 4: p-th powers** (p prime).

```lean
theorem dvd_coeff_pow_prime [Fact p.Prime] (f : Hur ι) (a : ι → ℕ) (ha : a ≠ 0) :
    (p : ℤ) ∣ (f ^ p).coeff a
theorem coeff_pow_prime_modEq [Fact p.Prime] (f : Hur ι) (a : ι → ℕ) :
    (f ^ p).coeff a ≡ (if a = 0 then f.coeff 0 else 0) [ZMOD p]

/-- For f without constant term, f^p / p. -/
noncomputable def divPow (p : ℕ) [Fact p.Prime] (f : Hur ι) : Hur ι
theorem divPow_spec [Fact p.Prime] (f : Hur ι) (hf : f.coeff 0 = 0) : p • divPow p f = f ^ p
theorem divPow_coeff_zero [Fact p.Prime] (f : Hur ι) (hf : f.coeff 0 = 0) : (divPow p f).coeff 0 = 0
theorem der_divPow [Fact p.Prime] (c) (f : Hur ι) (hf : f.coeff 0 = 0) :
    der c (divPow p f) = f ^ (p - 1) * der c f
theorem nsmul_left_cancel_hur {n : ℕ} (hn : n ≠ 0) {f g : Hur ι} : n • f = n • g → f = g
```

Proofs. `dvd_coeff_pow_prime`: a ≠ 0 has a coordinate c with 0 < a c; by `coeff_eq_der` and `der_pow_succ` (with p = (p − 1) + 1), `(f ^ p).coeff a = (p • (f ^ (p−1) * der c f)).coeff (a − e_c) = p * …`. `coeff_pow_prime_modEq`: the case a = 0 is `coeff_pow_zero` and Fermat (`Int.ModEq.pow_card_sub_one_eq_one` or `ZMod.pow_card`; grep), the other case is the divisibility. `divPow`: define the coefficient at a as `(f ^ p).coeff a / p`; `divPow_spec` from the divisibility and from `(f ^ p).coeff 0 = 0 ^ p = 0`. `der_divPow`: multiply by p, use `der_nsmul`, `divPow_spec`, `der_pow_succ`, and cancel p (coefficients are integers).

After each target that compiles, update `PLAN.md`.

## Environment and rules

Exactly as in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules": read them there and follow them (compile with `lake env lean MMM/Frob/Hurwitz.lean -o .lake/build/lib/lean/MMM/Frob/Hurwitz.olean`; never `lake build`; grep Mathlib for names, in particular around `MvPowerSeries`, `Finsupp.equivFunOnFinite`, `Fintype.piFinset`, `Function.Injective.commRing`; no `sorry`, no axiom, no theorem with conclusion `True`; the file must compile when you stop, with unfinished targets left out and listed; header naming the model; no git changes). If the ring instance of target 1 cannot be finished, stop there and report exactly which axiom or which compatibility of `toQ` is missing; do not continue with targets 2 to 4 on an assumed instance.

## Report

For each target: done or not, the statements as they are in the file, the compile result, what blocked the first thing you could not finish, and `#print axioms` for `der_divPow` if it exists.
