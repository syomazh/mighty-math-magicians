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
