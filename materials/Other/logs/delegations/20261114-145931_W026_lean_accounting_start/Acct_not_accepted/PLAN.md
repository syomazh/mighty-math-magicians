# Accounting note — Lean plan (W026)

Written by worker `open-math — kimi-k3.1-pro` (model `moonshotai/kimi-k3.1-pro`), 2026-11-14; not human-reviewed.
Source note: `paper/accounting_proof.tex` (5 sections, compiled as `paper/accounting_proof.pdf`). Claim C20 of `CLAIMS.md` is its theorem in Dwork form.

## Conventions used below

- `p : ℕ` prime (`[Fact p.Prime]`), `k ≥ 1`, `q = p ^ k`, `m = (q − 1) * n + 1`.
- `ds p m = (Nat.digits p m).sum` is `s_p(m)`; `dig p j m = (m / p ^ j) % p` is `m_j`.
- `N(m) = (m − 1)/(p − 1)` (internal nodes of a p-ary tree with m leaves), `ν(m) = (m − s)/(p − 1)` (digit-forest nodes), `t = N − ν = (s − 1)/(p − 1)`.
- `ℚₚ` residue language is written as `≡ (−p)^t [ZMOD p^(t+1)]` for the integer statement `C * ∏ m_j! ≡ (−p)^t`.
- `L(m)` is `# { cyclic k-blocked p-ary trees with leaves labelled 1..m }`; `T(a)` is the labelled cyclic count for a vector `a` (indices mod k) used in §1(B) and Lemma L0; `𝔉(m)` / `F(m)` is the digit-forest structure set.
- References to existing Lean: all `MMM.*` below are in `lean/MMM/` except `MMM.Acct.*` which is this folder; Mathlib refs are in `lean/.lake/packages/mathlib`.

## Table

| label in note | statement in one line | proposed Lean statement (as code) | which existing Lean theorems / Mathlib objects it needs | depends on | difficulty | status |
|---|---|---|---|---|---|---|
| §1 borrowed (A) | Blocked form + class size for labelled trees: rotation class has `p^d` trees, `d =` asymmetric nodes; all labelled trees split as `p^d` per class | `PTree.card_pow_ary_eq_card_blocked` + `LTree.card_class` (already checked) | `MMM.BlockedForm`, `MMM.LRot`, `MMM.ClassSize` | — | easy | done (borrowed; not re-proved here) |
| §1 borrowed (B) | Carry proposition + terminal vectors: `a_c ≥ p ⇒ T(a) ≡ −T(a − p·e_c + e_{c+1}) (mod p)`; if all `a_c < p` then `T(a)=0` unless `a = e₀` | already checked in main proof as ingredients of `LTree.cherry_of_fixed` / `C5` | `MMM.Cherry`, `MMM.CherryB`, `MMM.ExactAll` | — | medium | done (borrowed) |
| Lemma L0 (Iterated carries) | For `a` with `∑ a_c ≥ 1` (and `∑ a_c p^c ≡ 1 (mod q−1)` if `q>2`): `T(a) ≡ (−1)^{(∑ a_c −1)/(p−1)} (mod p)` | `theorem MMM.Acct.iteratedCarries {p k} [Fact p.Prime] (a : Fin k → ℕ) (ha : 0 < ∑ c, a c) (hW : q>2 → ∑ c, a c * p^c ≡ 1 [MOD q−1]) : (Nat.card { cyclic k-blocked p-ary trees with label-class vector a } : ℤ) ≡ (-1 : ℤ) ^ ((∑ c, a c − 1)/(p−1)) [ZMOD p]` | `T(a)` definition from main paper; `LTree.labelled_valuation` for the case `a = m·e₀` already gives a congruence, but general-a needs the same `exists_class` + cherry induction | (B) | hard | not done — requires a standalone `T(a)` construction (multiset `Vector a`) |
| Lemma L1 (i) | `m! * C = p^{N(m)} * L(m)` where `L(m)` = cyclic k-blocked labelled count on m labels | `theorem MMM.Acct.L1_plane (p k m : ℕ) [Fact p.Prime] … : Nat.factorial m * Nat.card {T : PTree (p^k) // T.nodes = n} = p ^ N(m) * L(m)` or with `PTree.leaves = m` version | `PTree.leaves↔nodes`, `MMM.LRot.card_class` (`p^{N(m)}` per class), `PTree.card_pow_ary_eq_card_blocked` | (A) | easy | not done — statement proved in note by counting plane labellings then dividing by rotation; Lean has `card_class` and `finite_good` but no combined `m! * |unlabelled| = p^N * |labelled cyclic|` lemma yet |
| Lemma L1 (ii) | `L(m) ≡ (−1)^{N(m)} (mod p)` (i.e. `L(m)=T(m·e₀)` and Lemma L0) | `theorem MMM.Acct.L1_residue {p k} [Fact p.Prime] (hk : 0<k) (m : ℕ) (hm : m ≡ 1 [MOD p^k−1]) : (L(m) : ℤ) ≡ (-1 : ℤ) ^ N(m) [ZMOD p]` | Lemma L0 with `a = m·e₀` | L0, L1(i) | medium | not done — follows from L0 |
| Lemma L3 | `m! = p^{ν(m)} * ∏_j m_j! * |𝔉(m)|` where `𝔉(m)` = digit-forest structures on `1..m` | `theorem MMM.Acct.L3 (p m : ℕ) [Fact p.Prime] : m.factorial = p ^ ν(m) * (∏ j ∈ range m, (dig p j m).factorial) * Nat.card (DigitForest p m)` | finite type for digit forests; orbit-stabiliser lemma; `Nat.Prime.multiplicity_factorial` is NOT used — the factor `p^{ν(m)}` is to be derived from `p`-power automorphisms of complete trees | — | hard | partially done — `MMM.Acct.DigitForest` defines `F(m)` and proves `prodAutComplete` below; full `L3` not yet proved in Acct |
| Lemma L4 | `|𝔉(m)| ≡ (−1)^{ν(m)} (mod p)` via `|𝔉(m)| = binom(m,m₀)·K(a)·|𝔉(a)|` with `K(a) ≡ (−1)^a` | `theorem MMM.Acct.L4 {p m} [Fact p.Prime] : (Nat.card (DigitForest p m) : ℤ) ≡ (-1 : ℤ) ^ ν(m) [ZMOD p]` | `Nat.choose` + Lucas-type lemmas mod p (`Mathlib.Data.Nat.Choose.Lucas`), `ZMod` cyclic fixed-point lemmas for `K(a)`; induction on `a = ⌊m/p⌋` | L3 not needed for statement | hard | not done — `binom(pa+m₀, m₀) ≡ 1` and `K(a) ≡ (−1)^a` each need a ℤₚ-action lemma |
| Corollary (Legendre + residue) | `v_p(m!) = ν(m)` and `m!/p^{ν(m)} ≡ (−1)^{ν(m)} ∏ m_j! (mod p)` | `theorem MMM.Acct.legendre_valuation {p m} [Fact p.Prime] : multiplicity p m.factorial = ν(m)` and `theorem MMM.Acct.legendre_residue … : (m.factorial / p ^ ν(m) : ℤ) ≡ (-1 : ℤ) ^ ν(m) * (∏ j, (dig p j m).factorial : ℤ) [ZMOD p]` | Mathlib already has `Nat.Prime.sub_one_mul_multiplicity_factorial : (p−1)*ν(m) = m − s` (`lean/.lake/packages/mathlib/Mathlib/Data/Nat/Multiplicity.lean:115`) so valuation part is Mathlib; residue is L3+L4 | L3, L4 | medium | valuation done via Mathlib alias (in `FactorialValuation.lean`); residue not done |
| Theorem (Dwork form = C20) | `C·∏ m_j! ≡ (−p)^t (mod p^{t+1})` i.e. `#trees * m! ≡ (−p)^N (mod p^{N+1})` | `theorem MMM.Acct.dwork_form (p k m t : ℕ) [Fact p.Prime] (hk : 0<k) (ht : (p−1)*t+1 = ds p m) (hm : m ≡ 1 [MOD p^k−1]) : (Nat.card {T : PTree (p^k) // T.leaves=m} * (∏ j∈range m, (dig p j m).factorial : ℕ) : ℤ) ≡ (-(p:ℤ))^t [ZMOD (p:ℤ)^(t+1)]` equivalently `Nat.card … * m.factorial ≡ (-(p:ℤ))^N [ZMOD p^(N+1)]` | `MMM.ResidueB.residue_primePower` already is this statement (checked); alternative route `PTree.residue` + L3/L4 + L1 | L1+L3+L4 | easy if quoted from `MMM.ResidueB` | done via `MMM.ResidueB.residue_primePower` — Acct proves Dwork equivalence `C·m! ≡ (−p)^N` from it and `L3∨Mathlib` (see `DworkForm.lean`) |
| Prop Sand (a) | On half-line `0,1,…`, `m` grains at 0, rule `p → 1 next`, every toppling sequence ends after `ν(m)` steps at base-p digits | `theorem MMM.Acct.sand_halfLine (p m : ℕ) (hp : 2 ≤ p) : sandpileSteps p m (halfLineTopplings) = ν(m) ∧ finalConfig = digits p m` (with `GrainConfig = ℕ → ℕ` finitely supported, `toppleAt i` : `g i ≥ p → g' i = g i − p, g' (i+1) = g (i+1)+1`) | `MMM.Digits`, `MMM.DigitsCarry` (`ds_pow`, `ds_sum_pow`, `ds_base_mul`) | — | easy | not done — definitions scaffolded in `Sandpile.lean`, no theorem yet |
| Prop Sand (b) | On ring `ℤ/k`, `m ≡ 1 (mod p^k−1) →` ends after `N(m)` steps at single grain on 0; if `q−1 ∣ m` ends at `(p−1,…,p−1)` | `theorem MMM.Acct.sand_ring (p k m : ℕ) (hp : 2 ≤ p) (hk : 0<k) (hm : m ≡ 1 [MOD p^k−1]) : sandpileStepsRing p k m = N(m)` | invariant `W = ∑ g_c p^c` mod `q−1` from `MMM.CherryB` lemmas (`pow_modEq_one`, `pow_modEq_of_mod_eq`) | — | medium | not done — same scaffold |

## Existing-Lean coverage note

- What the note's Lemma L1 *claims* (`m!·C = p^N·L(m)`, `L(m) ≡ (−1)^N`) is not a separate theorem in `lean/MMM/`, but its ingredients are: `LTree.card_class` gives `p^d = p^N` per class when labels are distinct (every node asymmetric), and `LTree.labelled_congruence` / `labelled_congruence_blocked` gives the residue `(-p)^t` for the full labelled count — from which `(-1)^N` can be deduced after dividing by `p^N`. Lemma 1 of the note does follow from `MMM.ResidueB` + `LTree.card_class` modulo rewriting, but the note's split `m!·C = p^N·L(m)` is not stated as a named lemma in Lean; `Acct/L1FromExisting.lean` records the implication.
- What `C12` in `CLAIMS.md` (compact form `C·∏ m_j! ≡ (−p)^t`) is already `MMM.ResidueB.residue_primePower`. The accounting proof re-derives it via `m!`. So the Dwork form is *corollary* of checked Lean, not independent of it.

## Difficulty rubric

- easy: direct combination of an existing Mathlib lemma (Legendre valuation) or a one-line `simp`/`omega` from `MMM.Digits*`.
- medium: a short induction (sandpile, L1 residue once L0 is assumed) or a Mathlib `ZMod`/`choose` application needing a Lucas lookup.
- hard: needs a new finite type (digit forests, `T(a)`) + a ℤₚ fixed-point count or an orbit-stabiliser argument with automorphisms of complete trees.

## Deliverable map for this brief

- `PLAN.md` (this file).
- `MMM/Acct/Basic.lean` — `N(m)`, `ν(m)`, `t(m)` arithmetic from `ds` (no new axioms).
- `MMM/Acct/FactorialValuation.lean` — Legendre valuation `v_p(m!) = ν(m)` via Mathlib, with `#print axioms` hygiene.
- `MMM/Acct/DigitForest.lean` — definition of `DigitForest p m` (multiset-of-blocks model) and the automorphism count `p^{(p^j−1)/(p−1)}` per complete tree height `j`.
- `MMM/Acct/DworkForm.lean` — `C·∏ m_j! ≡ (−p)^t` from `MMM.ResidueB` and its equivalence to `C·m! ≡ (−p)^N` modulo using the valuation (no circularity).
- `MMM/Acct/L1FromExisting.lean` — Lemma L1's labelled identity read off existing Lean (`card_class` + `residue_primePower`).
- `MMM/Acct/Sandpile.lean` — scaffold definitions for the sand proposition (no sorry; theorems left as future work and documented as such here).
- Future (not in this time box): full orbit-stabiliser proof of L3, induction for L4, and the general `T(a)` iterated-carry lemma L0.

## What is not claimed

- No Acct file in this batch proves `T(a) ≡ (−1)^{…}` for general `a`, nor the full `m! = p^ν ∏ m_j! |𝔉(m)|` by symmetry, nor the sandpile propositions. Those are listed as `not done` with blockers above. Any Acct theorem whose proof would need them quotes Mathlib's Legendre valuation instead and says so in the header comment.
