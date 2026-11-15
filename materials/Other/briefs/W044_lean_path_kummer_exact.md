# W044 — Lean: the path proof, part 5 (Kummer's theorem with its residue, and Problem 137, from the count)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## Where things stand

`lean/MMM/Path/` formalizes a proof of Kummer's theorem by rotating blocks of a word (the note `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`; read Lemma `lem:carries`, Proposition `prop:count` from "For the congruence" on, Theorem `thm:binom`, and the section "Proof of Theorem thm:main", lines 223 to 240 and 365 to 402). Compiled and in the build: `Block`, `ClassSize`, `Bound`, `Count`, `Word`, `Kummer`, `Minimal`, `MinBlock`, `MinCount`; and `SlotsDef.lean` (definitions, by the orchestrator: **read it first**). What you need from them:

```lean
def len (p : ℕ) (L : List ℕ) : ℕ := (L.map (fun h => p ^ h)).sum              -- Word.lean
theorem kummer_dvd [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)                     -- Kummer.lean
    (hc : (p - 1) * c + ds p N ≤ ds p n + ds p (N - n)) : p ^ c ∣ N.choose n
theorem exists_blocks (hp : 2 ≤ p) (N : ℕ) : ∃ L : List ℕ, len p L = N ∧ L.length = ds p N
theorem choose_modEq_minWords [hp : Fact p.Prime] (L : List ℕ) (n c : ℕ)       -- SlotsDef.lean
    (hn : n ≤ len p L) (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) :
    (len p L).choose n ≡ minWords p L n [MOD p ^ (c + 1)]
-- SlotsDef.lean: topAt, muAt, slotsAt, slotCount
```

Another agent is proving, at the same time, in `Slots.lean` (brief W043):

```lean
theorem minWords_eq_slotCount [NeZero p] (hp : 2 ≤ p) (L : List ℕ) (n B : ℕ)
    (hn : n ≤ len p L) (hB : len p L < p ^ B) : minWords p L n = slotCount p L n B
```

**You take this statement as a hypothesis** (do not import `Slots.lean`, do not prove it):

```lean
/-- The statement of `Slots.lean`. -/
def SlotHyp (p : ℕ) [NeZero p] : Prop :=
  ∀ (L : List ℕ) (n B : ℕ), n ≤ len p L → len p L < p ^ B → minWords p L n = slotCount p L n B
```

Digits: `ds p n` is the digit sum (`MMM/Digits.lean`), `dig p j n = (n / p ^ j) % p` (`MMM/DigitsCarry.lean`; also `MMM/DigitsFree.lean`: `ds_eq_sum_dig`, `dig_eq_zero_of_lt`). The statement was tested numerically: `experiments/E017_path_slot_count/run.py`, part (2).

## Files you own

`lean/MMM/Path/KummerExact.lean` and `lean/MMM/Path/Problem137.lean` (new). You may append to `lean/MMM/Path/PLAN.md`. Change nothing else.

## Part 1 (`KummerExact.lean`): the digit list and the carries

```lean
theorem exists_digit_blocks (hp : 2 ≤ p) (N : ℕ) :
    ∃ L : List ℕ, len p L = N ∧ L.length = ds p N ∧ (∀ j, L.count j = dig p j N) ∧
      ∀ j, topAt p L j = N / p ^ j

/-- The carry into digit j when n and N - n are added in base p. -/
def carryAt (p N n j : ℕ) : ℕ := N / p ^ j - n / p ^ j - (N - n) / p ^ j

theorem carryAt_zero (hn : n ≤ N) : carryAt p N n 0 = 0
theorem carryAt_le_one (hp : 2 ≤ p) (hn : n ≤ N) (j : ℕ) : carryAt p N n j ≤ 1
/-- The carry recursion of Lemma `lem:carries`. -/
theorem carryAt_rec (hp : 2 ≤ p) (hn : n ≤ N) (j : ℕ) :
    dig p j N + p * carryAt p N n (j + 1) = dig p j n + dig p j (N - n) + carryAt p N n j
/-- The number of carries, through the digit sums. -/
theorem sum_carryAt (hp : 2 ≤ p) (hn : n ≤ N) (B : ℕ) (hB : N < p ^ B) :
    (p - 1) * ∑ j ∈ Finset.range B, carryAt p N n (j + 1) + ds p N = ds p n + ds p (N - n)
```

Plan. `exists_digit_blocks`: the induction of `exists_blocks` (`L' = L.map (· + 1) ++ List.replicate (N % p) 0` for `N / p`), carrying the two extra statements. `carryAt`: write `x / p ^ j = dig p j x + p * (x / p ^ (j + 1))` (`Nat.div_add_mod`, `Nat.div_div_eq_div_mul`, `pow_succ`) for `N`, `n`, `N - n`; `n / p^j + (N - n) / p^j ≤ N / p^j` (`Nat.add_div_le_add_div` or by hand) so the subtractions are not truncated; and `N / p^j < n / p^j + (N - n) / p^j + 2`. `sum_carryAt`: first `(p - 1) * ∑ j ∈ range B, x / p ^ (j + 1) + ds p x = x` for `x < p ^ B` (induction on B, generalising x: `x = p * (x / p) + x % p`, `ds p x = x % p + ds p (x / p)`; grep `MMM/Digits.lean` for the recursion of `ds`), then subtract.

## Part 2 (`KummerExact.lean`): the value of the count, the residue, exactness

```lean
/-- ∏_j x_j!: the product of the factorials of the base-p digits. -/
def digFact (p x : ℕ) : ℕ := ∏ j ∈ Finset.range (x + 1), (dig p j x).factorial

/-- The note's count: for the digit list, slotCount · ∏ n_j! m_j! = ∏_j (N_j + p c_(j+1))!. -/
theorem slotCount_digits (hp : 2 ≤ p) (N n B : ℕ) (hn : n ≤ N) (hB : N < p ^ B) (L : List ℕ)
    (hL : len p L = N) (hcount : ∀ j, L.count j = dig p j N) (htop : ∀ j, topAt p L j = N / p ^ j) :
    slotCount p L n B * (digFact p n * digFact p (N - n)) =
      ∏ j ∈ Finset.range B, (dig p j N + p * carryAt p N n (j + 1)).factorial

/-- Wilson: (r + p)! ≡ -p · r!  (mod p²) for r < p. -/
theorem factorial_add_prime_modEq [Fact p.Prime] (r : ℕ) (hr : r < p) :
    ((r + p).factorial : ℤ) ≡ -(p : ℤ) * (r.factorial : ℤ) [ZMOD (p : ℤ) ^ 2]

/-- Theorem `thm:binom`, the residue (Anton, Stickelberger, Hensel), given the count. -/
theorem choose_residue_of [Fact p.Prime] (H : SlotHyp p) (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N = ds p n + ds p (N - n)) :
    (N.choose n : ℤ) * ((digFact p n * digFact p (N - n) : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ c * (digFact p N : ℤ) [ZMOD (p : ℤ) ^ (c + 1)]

/-- Theorem `thm:binom`, Kummer's theorem: p^c is the exact power of p in the binomial coefficient. -/
theorem kummer_exact_of [Fact p.Prime] (H : SlotHyp p) (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N = ds p n + ds p (N - n)) :
    p ^ c ∣ N.choose n ∧ ¬ p ^ (c + 1) ∣ N.choose n
```

Plan. `slotCount_digits`: with `hL`, `hcount`, `htop`, `muAt p L n j = carryAt p N n j` and `slotsAt p L n j = dig p j N + p * carryAt p N n (j + 1)`; by `carryAt_rec` this is `a + b + c_j` with `a = dig p j n`, `b = dig p j (N - n)`, `c_j ≤ 1`; and `choose s a * choose (s - a) b * a! * b! = s!` when `s = a + b + c_j` with `c_j ≤ 1` (`Nat.choose_mul_factorial_mul_factorial` twice, `(s - a - b)! = 1`). The products of `digFact` over `range (x + 1)` equal the products over `range B` because the digits at positions `≥ B` (and those between) are 0 (`dig_eq_zero_of_lt`; `x < p ^ (x + 1)`). `factorial_add_prime_modEq`: `(r + p)! = p! * ∏ i ∈ range r, (p + 1 + i)` (induction on r), `p! = p * (p - 1)!`, Wilson's theorem in `ZMod p` (`ZMod.wilsons_lemma`; transfer to integers with `ZMod.intCast_eq_intCast_iff` or `(ZMod.intCast_zmod_eq_zero_iff_dvd …)`; grep), `∏ (p + 1 + i) ≡ r! (mod p)`; a congruence modulo p multiplied by p is a congruence modulo p² (`Int.ModEq.mul_left'`). `choose_residue_of`: take `L` from `exists_digit_blocks`, `B = N + 1` (`N < p ^ (N + 1)`); `choose_modEq_minWords` with `H` gives `N.choose n ≡ slotCount [MOD p ^ (c + 1)]`; multiply by `digFact p n * digFact p (N - n)`; the right side is the product of the factorials, and factor by factor `(N_j + p c_(j+1))! ≡ (-p)^(c_(j+1)) · N_j!` modulo `p ^ (c_(j+1) + 1)` (trivial when the carry is 0, Wilson when it is 1). Multiply these: if `x ≡ (-p)^a · u [ZMOD p^(a+1)]` and `y ≡ (-p)^b · v [ZMOD p^(b+1)]` then `x * y ≡ (-p)^(a+b) · (u * v) [ZMOD p^(a+b+1)]` (write the differences as multiples; prove this lemma first), by induction over `range B`; the exponents add up to `∑ carryAt = c` by `sum_carryAt` and `hc` (`p - 1 > 0`). `kummer_exact_of`: divisibility is `kummer_dvd`; if `p^(c+1)` divided `N.choose n`, the residue would give `p^(c+1) ∣ (-p)^c · digFact p N`, hence `p ∣ digFact p N`, impossible: a prime does not divide a product of factorials of numbers `< p` (`Nat.Prime.dvd_mul`, `Nat.Prime.dvd_factorial` is allowed here, `dig_lt`).

## Part 3 (`Problem137.lean`): the Fuss–Catalan numbers

Imports: `MMM.Path.KummerExact` and `MMM.FussFormula` (and `MMM.ResidueForms`, `MMM.ExactCond` for two arithmetic lemmas named below; nothing else of the tree proof). With `q = p ^ k`, `k ≥ 1`, `N = q n + 1`, `m = (q - 1) n + 1 = N - n`:

```lean
theorem residue_fussCatalan_path_of (p : ℕ) [hp : Fact p.Prime] (H : SlotHyp p) (k n t : ℕ)
    (hk : 0 < k) (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
        ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]

theorem problem137_fussCatalan_exact_path_of (p : ℕ) [hp : Fact p.Prime] (H : SlotHyp p)
    (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)

theorem problem137_fussCatalan_path_of (p : ℕ) [hp : Fact p.Prime] (H : SlotHyp p) (k n : ℕ)
    (hk : 0 < k) :
    (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
      (Nat.digits p ((p ^ k - 1) * n + 1)).sum
```

Plan (the note's last section).
- `C := Nat.choose (q n) n / ((q - 1) n + 1)` satisfies `(q n + 1) * C = Nat.choose (q n + 1) n`: `PTree.choose_div_eq_card` and `PTree.card_nodes_mul_eq_choose` in `MMM/FussFormula.lean` (the second is the cyclic-shift lemma; both are about counting trees, not about rotations).
- `ds p (p ^ k * n + 1) = ds p n + 1` and `digFact p (p ^ k * n + 1) = digFact p n` for `k ≥ 1`: the digits of `q n + 1` are a 1 at position 0, zeros at positions `1 … k - 1`, and the digits of `n` from position `k` on (`ds_base_mul`, `ds_pow_add`, `dig_succ` are in `MMM/Digits.lean`, `MMM/DigitsCarry.lean`; grep for a lemma on `ds p (p * x + r)`).
- So the number of carries for `N = q n + 1` and `n` is `t`: `hc : (p - 1) * t + ds p N = ds p n + ds p (N - n)` with `N - n = (q - 1) n + 1` and `ds p x = (Nat.digits p x).sum` (`ds` is defined so; `rfl` or `unfold ds`).
- `kummer_exact_of` and `choose_residue_of` for `N.choose n = N * C`. `p ∤ N` (`N = p * (p^(k-1) n) + 1`), so `p^t ∣ C` (`Nat.Coprime.dvd_of_dvd_mul_left`) and `p^(t+1) ∤ C`. Residue: `N * C * digFact n * digFact m ≡ (-p)^t * digFact n`; cancel `digFact p n` (coprime to `p`; `Int.ModEq.cancel_left_div_gcd` or multiply by an inverse modulo `p^(t+1)`; grep `Int.ModEq` cancellation lemmas); `N * C ≡ C` modulo `p^(t+1)` because `N ≡ 1` modulo `p` and `p^t ∣ C`.
- `digFact p m = ((Nat.digits p m).map Nat.factorial).prod`: `PTree.prod_dig_eq_digits` in `MMM/ResidueForms.lean` gives it for the product over `range m`; the factor at position `m` is `0! = 1` (`dig_eq_zero_of_lt`, `Nat.lt_pow_self`).
- The last theorem from the second as in `MMM/Frob/Problem137.lean` (`problem137_fussCatalan_frobenius`: copy that proof; `multiplicity_eq_of_exact` is in `MMM/ExactCond.lean`, `ds_modEq` in `MMM/Exact.lean`).

## Order of work, and what to do if it does not all fit

Parts 1, 2, 3 in this order; keep every file compiling as you go. If something cannot be proved, leave it out, keep what depends on it conditional under a different name with the missing statement as an explicit hypothesis, and say so.

## Environment and rules

As in `briefs/W033_lean_path_kummer_dvd.md`, sections "Environment" and "Rules" (read them): Lean is not on the PATH (`cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/Path/KummerExact.lean -o .lake/build/lib/lean/MMM/Path/KummerExact.olean`); never `lake build` or anything that downloads; never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean`; grep Mathlib (`lean/.lake/packages/mathlib/Mathlib`) for every lemma name, this Mathlib is newer than your training data; slim imports; no `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`; no theorem with conclusion `True`; no git commands that change anything; every file starts with a comment naming Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-15, not human-reviewed. **No theorem of Mathlib about valuations of factorials or of binomial coefficients** (`padicValNat`, `multiplicity` or `emultiplicity` of factorials or binomials, Legendre, Kummer), no Lucas, no `Nat.Prime.dvd_choose…`: the point of the note is to avoid them. Wilson's theorem, `Nat.Prime.dvd_mul`, `Nat.Prime.dvd_factorial` and the factorial formula for binomial coefficients are allowed. `multiplicity` appears only in the statement of the last theorem. Another agent compiles on this laptop at the same time: one compile at a time.

## Report

For each statement: done or not, the exact statement as in the file, the compile result of each file, `#print axioms` for `choose_residue_of`, `kummer_exact_of` and the last theorem you have, every change to a statement of this brief and why, what you did not verify.
