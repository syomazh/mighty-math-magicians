# W042 — Lean: the Frobenius proof, part 11 (the family H, its recursion, the carry congruence)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14, for a fresh-context Claude agent (Open Math OS is short tonight). You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## What this is

The last section of `paper/frobenius_proof.tex` (lines 280 to 464): Lemma `lem:H` (the series H_δ), Lemma `lem:hur` (iv), Proposition `prop:carry`. Read them with their proofs. The pieces you build on:

- **The ring of Hurwitz series.** Specified in `briefs/W037_lean_frobenius_hurwitz.md` (read it in full: it fixes `Hur ι`, `mchoose`, the `CommRing` instance with `coeff_zero'`, `coeff_one'`, `coeff_add'`, `coeff_neg'`, `coeff_nsmul'`, `coeff_mul'`, then `constCoeff`, `var`, `coeff_pow_zero`, `der`, `der_add`, `der_mul`, `der_one`, `der_nsmul`, `der_comm`, `der_var`, `der_pow_succ`, `coeff_eq_der`, `dvd_coeff_pow_prime`, `coeff_pow_prime_modEq`, `divPow`, `divPow_spec`, `divPow_coeff_zero`, `der_divPow`, `nsmul_left_cancel_hur`). An Open Math OS worker is writing it in `lean/MMM/Frob/Hurwitz.lean` and may not finish. **At the start, test whether that file compiles** (`lake env lean MMM/Frob/Hurwitz.lean`, without `-o`) **and contains all of those statements. If yes, import it and do not write a ring. If not, write the ring yourself in `lean/MMM/Frob/HurwitzC.lean`, with the same namespace, names and statements as that brief, without importing `Hurwitz.lean`** (you may read that file for ideas; do not edit it). Decide once and say which you did.
- **The derivative identity.** `lean/MMM/Frob/PowDeriv.lean` (compiled): `IsDer`, and `IsDer.iterate_pow_prime : ∃ r, D^[p] (u ^ p) = p • (u ^ (p - 1) * D^[p] u) + p.factorial • (D u) ^ p + (p ^ 2) • r`.

## Files you own

`lean/MMM/Frob/HurwitzC.lean` (only if needed, see above), `lean/MMM/Frob/HFamily.lean`, `lean/MMM/Frob/Carry.lean` (new). You may append a section to `lean/MMM/Frob/PLAN.md`. Nothing else.

## Part 1 (`HFamily.lean`): the family H_δ and its coefficients

Multi-indices are `ZMod k → ℕ`, with `[NeZero k]`.

```lean
/-- Lemma "H": the unique family without constant terms with H_δ = z_(-δ) + H_(δ+1)^p / p. -/
theorem exists_unique_Hfam (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] :
    ∃! H : ZMod k → Hur (ZMod k),
      (∀ δ, (H δ).coeff 0 = 0) ∧ ∀ δ, H δ = var (-δ) + divPow p (H (δ + 1))

noncomputable def Hfam (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] : ZMod k → Hur (ZMod k)   -- the family
theorem Hfam_coeff_zero (δ) : (Hfam p k δ).coeff 0 = 0
theorem Hfam_eq (δ) : Hfam p k δ = var (-δ) + divPow p (Hfam p k (δ + 1))

/-- T_δ(a): the coefficient of z^a / a! in H_δ. -/
noncomputable def T (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ : ZMod k) (a : ZMod k → ℕ) : ℤ :=
  (Hfam p k δ).coeff a
theorem T_zero (δ) : T p k δ 0 = 0
theorem T_single (δ c : ZMod k) : T p k δ (Pi.single c 1) = if c = -δ then 1 else 0
```

Plan for existence: iterate. `Hiter 0 = fun _ => 0`, `Hiter (n + 1) = fun δ => var (-δ) + divPow p (Hiter n (δ + 1))`. All iterates have constant coefficient 0. Key lemma: for f, g without constant term that agree at every multi-index of total degree < N, `divPow p f` and `divPow p g` agree at every multi-index of total degree ≤ N (for N ≥ 1): prove it through `coeff_eq_der` and `der_divPow` (the coefficient of `divPow p f` at a ≠ 0 is a coefficient of `f ^ (p - 1) * der c f` at `a - e_c`, a finite sum of products of coefficients of f at multi-indices of total degree ≤ deg a − … ; make precise the statement "a coefficient of a product at b depends only on the coefficients of the factors at multi-indices ≤ b", from `coeff_mul'`, and note that every factor of `f ^ (p - 1) * der c f` evaluated at an index ≤ a − e_c involves f at total degree ≤ deg a; then use that f has no constant term to gain one degree: a term of the product in which `der c f` is taken at b' = a − e_c and all other factors at 0 vanishes when p ≥ 2). If that route is awkward, an equivalent statement is enough: **the coefficient of `f ^ p` at a multi-index of total degree n depends only on the coefficients of f at total degree ≤ n − p + 1 ≤ n − 1 when f has no constant term**, which is the note's own argument. So the coefficient of total degree n of `Hiter N δ` no longer changes once N > n; define `Hfam δ` by `coeff a := (Hiter (deg a + 1) δ).coeff a`. Uniqueness by the same lemma and strong induction on the total degree. (`lean/MMM/Frob/Existence.lean` does the same construction for another ring: copy its shape.)

## Part 2 (`Carry.lean`): the explicit recursion

```lean
/-- Coefficient of a product of p Hurwitz series. -/
theorem coeff_prod_fin {ι : Type*} [Fintype ι] [DecidableEq ι] (p : ℕ) (f : Fin p → Hur ι) (a : ι → ℕ) :
    (∏ i, f i).coeff a =
      ∑ u ∈ (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun c => Finset.range (a c + 1)).filter
              (fun u => ∑ i, u i = a),
        ((∏ c, Nat.multinomial Finset.univ (fun i => u i c) : ℕ) : ℤ) * ∏ i, (f i).coeff (u i)

theorem T_rec (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ : ZMod k) (a : ZMod k → ℕ) :
    (p : ℤ) * T p k δ a = (p : ℤ) * (if a = Pi.single (-δ) 1 then 1 else 0) +
      ∑ u ∈ (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun c => Finset.range (a c + 1)).filter
              (fun u => ∑ i, u i = a),
        ((∏ c, Nat.multinomial Finset.univ (fun i => u i c) : ℕ) : ℤ) * ∏ i, T p k (δ + 1) (u i)
```

Keep the right-hand sides **literally in this form**: another file (`Subst.lean`, by another worker) uses definitions `tuplesOf` and `mmultinomial` that unfold to exactly these expressions, and the two will be matched by unfolding. `coeff_prod_fin` by induction on p from `coeff_mul'` (a multinomial coefficient with one more entry is a binomial coefficient times the multinomial coefficient of the rest); `T_rec` from `Hfam_eq`, `divPow_spec` (`p • divPow p f = f ^ p`), `f ^ p = ∏ i : Fin p, f` and `coeff_prod_fin`.

## Part 3 (`Carry.lean`): Lemma "hur" (iv) and the carry congruence

```lean
theorem isDer_der {ι : Type*} [Fintype ι] [DecidableEq ι] (c : ι) : IsDer (der c : Hur ι → Hur ι)

/-- Lemma "hur" (iv), second formula. -/
theorem iterate_der_divPow {ι : Type*} [Fintype ι] [DecidableEq ι] (p : ℕ) [Fact p.Prime] (c : ι)
    (f : Hur ι) (hf : f.coeff 0 = 0) :
    ∃ r : Hur ι, (der c)^[p] (divPow p f) =
      f ^ (p - 1) * (der c)^[p] f + (p - 1).factorial • (der c f) ^ p + p • r

/-- Proposition "The carry operator". -/
theorem carry (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ c : ZMod k) (b : ZMod k → ℕ) :
    (p : ℤ) ∣ T p k δ (b + p • Pi.single c 1) + T p k δ (b + Pi.single (c + 1) 1)
```

Plan. `iterate_der_divPow`: apply `(der c)^[p]` to `p • divPow p f = f ^ p`, use `IsDer.iterate_pow_prime`, and cancel p (`nsmul_left_cancel_hur`; `p.factorial = p * (p - 1).factorial`). `carry`: follow the note's proof (lines 404 to 428). Let `E f := (der c)^[p] f + der (c + 1) f`; its coefficient at b is `f.coeff (b + p • e_c) + f.coeff (b + e_(c+1))` (iterate `der`'s definition). Say that a Hurwitz series is "divisible by p" if all its coefficients are; such series form an ideal (a multiple of a series divisible by p is divisible by p: from `coeff_mul'`), and a series of the form `p • r` is divisible by p. Show, modulo p: `E (Hfam δ) ≡ (Hfam (δ+1)) ^ (p - 1) * E (Hfam (δ+1))`, using `Hfam_eq`, `der_divPow`, `iterate_der_divPow`, Wilson's theorem `(p - 1)! ≡ -1` (`ZMod.wilsons_lemma` or `Nat.prime_iff_fac_equiv_neg_one`; grep), `coeff_pow_prime_modEq` applied to `der c (Hfam (δ+1))` (its p-th power is congruent to its constant coefficient, which is `T (δ+1) e_c = [c = -(δ+1)]`), and `der (c+1) (var (-δ)) = [c + 1 = -δ]`, `(der c)^[p] (var (-δ)) = 0` for p ≥ 2; the two brackets are the same condition and cancel. Iterating k times (once round `ZMod k`), `E (Hfam δ) ≡ Π * E (Hfam δ)` with `Π` a product of series without constant term, hence `E (Hfam δ) ≡ Π ^ r * E (Hfam δ)` for every r; and `Π ^ r` has no coefficient at multi-indices of total degree < r (a product of r series without constant term), so taking r larger than the total degree of b shows that the coefficient of `E (Hfam δ)` at b is divisible by p. (To go once round: iterate the congruence `k` times along δ, δ+1, …, δ+k = δ, using `Nat.cast` into `ZMod k` and `ZMod.natCast_self`.)

## Environment and rules

As in `briefs/W031_lean_frobenius_existence.md`, sections "Environment" and "Rules" (read them): Lean is not on the PATH (`cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/Frob/HFamily.lean -o .lake/build/lib/lean/MMM/Frob/HFamily.olean`); never `lake build` or anything that downloads; never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean`; grep Mathlib (`lean/.lake/packages/mathlib/Mathlib`) for every lemma name, this Mathlib is newer than your training data; slim imports; no `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`; no theorem with conclusion `True`; no git commands that change anything; every file starts with a comment naming Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-14, not human-reviewed. Other processes compile on this laptop: one compile at a time. Keep every file compiling as you go; if a statement cannot be proved, leave it out, keep what depends on it conditional under a different name with the missing statement as an explicit hypothesis, and say so.

## Report

Which ring file you used; for each statement of parts 1 to 3: done or not, the exact statement as in the file; the compile result of each file; `#print axioms` for `carry`, `T_rec` and `exists_unique_Hfam`; what you changed in any statement and why; what you did not verify.
