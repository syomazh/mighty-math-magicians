# Path proof, part 1 — worker W032 (Kimi K3.1 Pro, 2026-11-14, not human-reviewed)

Lean formalization of Lemmas `lem:classes`, `lem:size`, `lem:digits` (the parts used),
`lem:bound` of `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`, for one block
of length `p^h`. Mirrors `MMM/Trees.lean`, `MMM/RotEquiv.lean`, `MMM/ClassSize.lean`,
`MMM/Divisibility.lean`.

## Deviation from the brief's definitions

`Blk` and `cntE` are marked `@[reducible]` (in `Block.lean`) so that `Blk p 0` unifies with `Bool`
and `cntE 0 b` with `if b then 1 else 0`. `Eqv` is *not* reducible: when it was, `induction h`
inside proofs unfolded the goal at the successor case and the elaborator rejected the structural
recursion. Two helper lemmas (`Eqv_zero`, `Eqv_succ`) expose the defining equations instead. All
statements are otherwise exactly as in the brief.

## Status

| Statement | File | Status |
|---|---|---|
| `Blk`, `cntE`, `Eqv`, `Sym`, `d`, `cntS` (definitions) | `Block.lean` | done |
| `Eqv.refl`, `Eqv.symm`, `Eqv.trans`, `eqvSetoid` | `Block.lean` | done |
| `cntE_le`, `cntS_eq` | `Block.lean` | done |
| `cntE_eq_of_eqv : Eqv h u v → cntE h u = cntE h v` | `Block.lean` | done |
| `d_eq_of_eqv : Eqv h u v → d h u = d h v` | `Block.lean` | done |
| `cntS_eq_of_eqv`, `sym_iff_of_eqv` | `Block.lean` | done |
| `card_class [Fact p.Prime] (h) (u) : Nat.card {v : Blk p h // Eqv h u v} = p ^ d h u` | `ClassSize.lean` | done |
| `sym_of_shift`, `classEquiv` (helpers for `card_class`) | `ClassSize.lean` | done |
| `lower_bound (hp : 2 ≤ p) (h) (u) : ds p (cntE h u) + ds p (p^h - cntE h u) ≤ (p-1) * d h u + 1` | `Bound.lean` | done |
| `pow_dvd_card [Fact p.Prime] (h n c) : ds p n + ds p (p^h - n) = (p-1)*c + 1 → n ≤ p^h → p^c ∣ Nat.card {u : Blk p h // cntE h u = n}` | `Bound.lean` | done |

## Compile results (lake env lean, project Lean 4.36.0-rc2)

- `Block.lean`: compiles, one benign unused-section-variable warning.
- `ClassSize.lean`: compiles clean.
- `Bound.lean`: compiles, style warnings only (`haveI` → `have` suggestions; unused `hn`
  hypothesis kept because the brief prescribes it).

## Axioms

```
#print axioms card_class       -- [propext, Classical.choice, Quot.sound]
#print axioms lower_bound      -- [propext, Classical.choice, Quot.sound]
#print axioms pow_dvd_card     -- [propext, Classical.choice, Quot.sound]
#print axioms cntE_eq_of_eqv   -- [propext, Classical.choice, Quot.sound]
#print axioms d_eq_of_eqv      -- [propext, Classical.choice, Quot.sound]
```

Only the standard Mathlib axioms. No `sorry`, no `admit`, no `native_decide`, no `axiom`,
no `unsafe`.

## Notes for the orchestrator

- `lower_bound` and `pow_dvd_card` are stated with `[NeZero p]` (and `[Fact p.Prime]`) as
  instance arguments because `d` needs the instance; the brief's signature had `NeZero` supplied
  implicitly through the section, so the meaning is unchanged.
- `pow_dvd_card`'s hypothesis `hn : n ≤ p ^ h` is unused by the proof (nothing needs it, since
  `cntE_le` already bounds every block); it is kept because the brief lists it.
- The proof of `card_class` first transports `Nat.card {v // Eqv h u v}` to
  `Nat.card {v // Eqv h v u}` by `Eqv.symm`, then follows `MMM/ClassSize.lean` verbatim. The
  induction hypothesis at height `h` is also transported the same way for the product formula.
- No other files were touched. No git commands were run.

---

# Path proof, part 2 — worker W033 (Kimi K3.1 Pro, 2026-11-14, not human-reviewed)

## Status

| Statement | File | Status |
|---|---|---|
| `card_cntE [NeZero p] (h n) : Nat.card {u : Blk p h // cntE h u = n} = (p ^ h).choose n` | `Count.lean` | done |
| `pow_dvd_choose_pow [Fact p.Prime] (h n c) (hc : ds p n + ds p (p ^ h - n) = (p - 1) * c + 1) (hn : n ≤ p ^ h) : p ^ c ∣ (p ^ h).choose n` | `Count.lean` | done |
| `Word p L := (i : Fin L.length) → Blk p (L.get i)`, `len`, `cntEW`, `EqvW`, `dW` | `Word.lean` | done |
| `card_classW [Fact p.Prime] {L} (w) : Nat.card {w' : Word p L // EqvW w w'} = p ^ dW w` | `Word.lean` | done |
| `lower_boundW [NeZero p] (hp : 2 ≤ p) {L} (w) : ds p (cntEW w) + ds p (len p L - cntEW w) ≤ (p - 1) * dW w + L.length` | `Word.lean` | done |
| `card_cntEW [NeZero p] (L) (n) : Nat.card {w : Word p L // cntEW w = n} = (len p L).choose n` | `Word.lean` | done |
| `pow_dvd_choose_of_blocks [Fact p.Prime] (L n c) (hn : n ≤ len p L) : (p - 1) * c + L.length ≤ ds p n + ds p (len p L - n) → p ^ c ∣ (len p L).choose n` | `Kummer.lean` | done |
| `exists_blocks (hp : 2 ≤ p) (N) : ∃ L, len p L = N ∧ L.length = ds p N` | `Kummer.lean` | done |
| `kummer_dvd [Fact p.Prime] (N n c) (hn : n ≤ N) : (p - 1) * c + ds p N ≤ ds p n + ds p (N - n) → p ^ c ∣ N.choose n` | `Kummer.lean` | done |

## Compile results

- `MMM/Path/Count.lean`: compiles clean.
- `MMM/Path/Word.lean`: compiles clean.
- `MMM/Path/Kummer.lean`: compiles, with the intentionally unused `hn` hypothesis in
  `pow_dvd_choose_of_blocks` (exactly as prescribed by the brief).

## Axioms of the final result

`#print axioms MMM.Path.kummer_dvd`:
`[propext, Classical.choice, Quot.sound]`.

All three targets are done. No theorem is left weakened, commented out, or replaced by a
vacuous statement. There is no `sorry`, `admit`, `axiom`, `native_decide`, or `unsafe`.
The only valuation named in these files occurs in the comments saying none is used.
- The proofs use generating functions (coefficients of `(1 + X)^N`), products of block
  equivalence classes, and digit-sum subadditivity. No factorial valuations or binomial
  divisibility theorems are used.


---

# Path proof, part 3 — brief W041 (Claude Fable 5.2, a subagent of the orchestrator, 2026-11-14, not human-reviewed)

Reduction to the minimal words, the equality cases of `lem:bound` and `prop:bound`, and the count
of the minimal blocks. No Mathlib theorem about valuations of factorials or binomial coefficients
is used; binomial coefficients appear only through `card_cntEW` and `Finset.card_powersetCard`.

| Statement | File | Status |
|---|---|---|
| `card_cntEW_modEq_minimal [Fact p.Prime] (L n c) (hc : ∀ w, cntEW w = n → c ≤ dW w) : Nat.card {w // cntEW w = n} ≡ Nat.card {w // cntEW w = n ∧ dW w = c} [MOD p ^ (c + 1)]` | `Minimal.lean` | done |
| `choose_modEq_minimal [Fact p.Prime] (L n c) (hn : n ≤ len p L) (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) : (len p L).choose n ≡ Nat.card {w // cntEW w = n ∧ dW w = c} [MOD p ^ (c + 1)]` | `Minimal.lean` | done |
| `MinBlk`, `d_eq_zero_of_mono`, `mono_of_d_eq_zero`, `minBlk_of_mono`, `minBlk_succ_iff` (statements as in the brief) | `MinBlock.lean` | done |
| helpers `eq_of_cntE_eq_zero`, `eq_of_cntE_eq_pow`, `not_minBlk_of_sym`, `not_sym_of_minBlk`, `sum_ds_ne_of_sym` | `MinBlock.lean` | done |
| `minCount`, `minCount_mono`, `minCount_succ` (statements as asked, with `[NeZero p]` added) | `MinCount.lean` | done |
| `dW_eq_iff` (equality case of `prop:bound`), `card_minimal_words`, `choose_modEq_sum_minCount` | `MinCount.lean` | done |
| `tuple_shape` (`lem:mixed` for one block), `minCount_succ_mul_pow`, `minCount_succ_add`, `minCount_succ_eq` | `MinCount.lean` | done |
| closed form of the sum in `card_minimal_words` (several top blocks) | — | not done, not started |
| residue modulo `p` of `prop:count`, exactness half of Kummer's theorem | — | not done, not started |

Compile (`lake env lean … -o …`): `Minimal.lean` one warning (unused `hn`, prescribed by the
brief); `MinBlock.lean` two warnings (unused `hp` in `d_eq_zero_of_mono` and `mono_of_d_eq_zero`,
prescribed by the brief); `MinCount.lean` clean. `#print axioms` of every theorem listed above:
`[propext, Classical.choice, Quot.sound]`.

Closed recursion proved for one block (`minCount p h a` = number of blocks of height `h` with `a`
letters E attaining the bound): `minCount p h 0 = minCount p h (p^h) = 1`;
`minCount p (h+1) (k p^h) = binom(p, k)` for `0 < k < p`;
`minCount p (h+1) (k p^h + r) = p * binom(p-1, k) * minCount p h r` for `k < p`, `0 < r < p^h`.

---

# Path proof, part 5 — brief W044 (Claude Fable 5.2, a subagent of the orchestrator, 2026-11-15, not human-reviewed)

Kummer's theorem with its residue (the note's Lemma `lem:carries`, the congruence of Proposition
`prop:count`, Theorem `thm:binom`) and Problem 137 for the Fuss–Catalan numbers (the note's last
section), **all from the hypothesis `SlotHyp p`** (the statement that `Slots.lean`, brief W043,
proves: `minWords p L n = slotCount p L n B`). Neither file imports `Slots.lean`. To remove the
hypothesis: `H := fun L n B hn hB => minWords_eq_slotCount hp.out.two_le L n B hn hB`.

| Statement | File | Status |
|---|---|---|
| `SlotHyp p` (definition, as in the brief) | `KummerExact.lean` | done |
| `exists_digit_blocks (hp : 2 ≤ p) (N) : ∃ L, len p L = N ∧ L.length = ds p N ∧ (∀ j, L.count j = dig p j N) ∧ ∀ j, topAt p L j = N / p ^ j` | `KummerExact.lean` | done |
| `carryAt` (definition), `carryAt_zero`, `carryAt_le_one`, `carryAt_rec`, `sum_carryAt` (as in the brief; `N n` implicit) | `KummerExact.lean` | done |
| helper `div_eq_add_carryAt : N / p^j = n / p^j + (N - n) / p^j + carryAt p N n j ∧ carryAt p N n j ≤ 1` | `KummerExact.lean` | done |
| `digFact` (definition), `digFact_eq_prod_range` (the product over any range that contains all digits) | `KummerExact.lean` | done |
| `slotCount_digits` (as in the brief) | `KummerExact.lean` | done |
| `factorial_add_prime_modEq [Fact p.Prime] (r) (hr : r < p) : ((r + p)! : ℤ) ≡ -p * r! [ZMOD p ^ 2]` | `KummerExact.lean` | done |
| `choose_residue_of [Fact p.Prime] (H : SlotHyp p) (N n c) (hn) (hc) : binom(N, n) * (digFact p n * digFact p (N - n)) ≡ (-p)^c * digFact p N [ZMOD p^(c+1)]` | `KummerExact.lean` | done |
| `coprime_digFact : Nat.Coprime p (digFact p x)` | `KummerExact.lean` | done |
| `kummer_exact_of [Fact p.Prime] (H : SlotHyp p) (N n c) (hn) (hc) : p^c ∣ N.choose n ∧ ¬ p^(c+1) ∣ N.choose n` | `KummerExact.lean` | done |
| `digFact_eq_digits : digFact p m = ((Nat.digits p m).map Nat.factorial).prod` | `Problem137.lean` | done |
| `fussCatalan_exact_residue_of` (exactness and residue of the Fuss–Catalan number in terms of `ds` and `digFact`) | `Problem137.lean` | done |
| `residue_fussCatalan_path_of`, `problem137_fussCatalan_exact_path_of`, `problem137_fussCatalan_path_of` (as in the brief) | `Problem137.lean` | done |

Compile (`lake env lean … -o …`): `KummerExact.lean` two warnings (unused `hn` in `carryAt_zero`
and unused `hr` in `factorial_add_prime_modEq`; both hypotheses are those of the brief and the
proofs do not need them); `Problem137.lean` clean. `#print axioms` of `choose_residue_of`,
`kummer_exact_of`, `residue_fussCatalan_path_of`, `problem137_fussCatalan_exact_path_of`,
`problem137_fussCatalan_path_of`: `[propext, Classical.choice, Quot.sound]`.

Notes.

- From Mathlib's number theory the proofs use Wilson's theorem (`ZMod.wilsons_lemma`),
  `Nat.Prime.dvd_factorial`, `Nat.choose_mul_factorial_mul_factorial`,
  `Nat.factorial_mul_ascFactorial`; no valuation of a factorial or of a binomial coefficient, no
  Lucas, no Kummer, no Legendre. `multiplicity` occurs only in `problem137_fussCatalan_path_of`
  (through `multiplicity_eq_of_exact` of `MMM/ExactCond.lean`).
- `Problem137.lean` imports, besides the brief's four files, `MMM.Exact` (for `ds_modEq`, which
  the brief names; it was already imported through `MMM.ResidueForms`) and
  `Mathlib.RingTheory.Coprime.Lemmas`. What the three theorems reach outside `MMM/Path/` and the
  digit files (checked with `#project_modules` of `MMM/Frob/Deps.lean`): `MMM.Counting` (through
  `kummer_dvd`), `MMM.Trees` and `MMM.FussFormula` (`choose_div_eq_card`,
  `card_nodes_mul_eq_choose`), `MMM.ResidueForms` (`prod_dig_eq_digits`, `prod_range_getD`),
  `MMM.Exact` (`ds_modEq`), `MMM.ExactCond` (`multiplicity_eq_of_exact`).
- In `Problem137.lean` the instance `instNeZeroOfPrimePath` is given priority over the tree
  proof's `PTree.instNeZeroOfPrime` (both are in scope there), so that `SlotHyp p` is the same
  term as in `KummerExact.lean` and nothing of `MMM/ClassSize.lean` is reached.
- Helper lemmas with general names (`topAt_*`, `ds_mul_add`, …) are `private`, because
  `Slots.lean` lives in the same namespace and a later file imports both.

---

# Path proof, part 4 — brief W043 (Claude Fable 5.2, a subagent of the orchestrator, 2026-11-15, not human-reviewed)

The count of the minimal words for every list of top blocks:
`minWords_eq_slotCount [NeZero p] (hp : 2 ≤ p) (L : List ℕ) (n B : ℕ) (hn : n ≤ len p L) (hB : len p L < p ^ B) : minWords p L n = slotCount p L n B`
is proved (`Slots.lean`), from `SlotsDef.lean` (unchanged). `p` need not be prime.

| Step of the brief | Statement | File | Status |
|---|---|---|---|
| 1 | `minWords_nil`, `minWords_cons : minWords p (h :: L) n = cfConv p (p ^ h) (len p L) (minCount p h) (minWords p L) n` | `Slots1.lean` | done |
| 2 | `minWords_append : minWords p (L₁ ++ L₂) n = cfConv p (len p L₁) (len p L₂) (minWords p L₁) (minWords p L₂) n` (general lists; from `cfConv_assoc`) | `Slots1.lean` | done |
| 3 | `minWords_replicate` (statement of the brief) | `Slots1.lean` | done |
| 4 | `minWords_cons_succ`, `minWords_cons_zero` | `Slots1.lean` | done |
| 5 | `slotCount_cons_succ`, `slotCount_cons_zero` (the same recursion; `trinomial_pascal`) | `Slots2.lean` | done |
| 6 | `minWords_eq_slotCount` (strong induction on `∑ (p + 1) ^ h`) | `Slots.lean` | done |

Changes to the statements of the brief:
- Steps 1 and 2 are stated with `cfConv p X Y f g n = ∑ a ∈ range (n + 1), if cfCond p X Y a (n - a) then f a * g (n - a) else 0`, where `cfCond p X Y a b` is the condition of the brief with `ds p (a + b)` in place of `ds p n` and `X + Y - (a + b)` in place of `X + Y - n` (the same for `a + b = n`). They hold for every `n`; the hypothesis `hn` of the brief is not needed.
- Step 4: the conditions are `1 ≤ dig p H n` (all E) and `1 ≤ dig p H (p ^ H + len p L - n)` (all S); the extra conjuncts `p ^ H ≤ n` and `n ≤ len p L` of the brief follow from them and are left out.

Compile (`lake env lean … -o …`): `Slots1.lean`, `Slots2.lean`, `Slots.lean` all clean (exit 0, no warning). `#print axioms minWords_eq_slotCount`: `[propext, Classical.choice, Quot.sound]`. Binomial coefficients are used only through `Nat.choose_succ_succ`, `Nat.choose_zero_right` and `Nat.choose_eq_zero_of_lt`.
