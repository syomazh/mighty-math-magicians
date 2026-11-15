**W026 — Lean start on the accounting proof — report**

Worker `open-math — kimi-k3.1-pro`, 2026-11-14, not human-reviewed. Resumed from prior partial session.

**Files owned (`lean/MMM/Acct/`):**

| file | lines | compile | notes |
|---|---|---|---|
| `PLAN.md` | 55 | — | pre-existing, unchanged by this continuation; full table A/B, L0, L1(i)(ii), L3, L4, Corollary, Theorem C20, Sand (a)(b) with difficulty/status |
| `Basic.lean` | 68 | `EXIT:0` (silent) | `Nval, nu, tval, ds_le, sub_one_dvd_m_sub_s, sub_one_mul_nu, nu_add_t_eq_Nval` |
| `FactorialValuation.lean` | 45 | `EXIT:0` + `depends on [propext, Classical.choice, Quot.sound]` | `multiplicity_factorial_eq_nu`, `valuation_is_nu` |
| `L1FromExisting.lean` | 65 | `EXIT:0` + `depends on [propext, Classical.choice, Quot.sound]` | `l1_residue_mod_p`, `l1_residue_blocked` |
| `DworkForm.lean` | 99 | `EXIT:0` + `depends on [propext, Classical.choice, Quot.sound]` | `dwork_of_residue` (trivial conditional placeholder), `dwork_form_equiv` (= `PTree.residue_primePower`), `N_eq_nu_add_t`, `valuation_nu` |
| `DigitForest.lean` | 59 | `EXIT:0` | `completeNodes, completeNodes_zero/succ, autComplete, autComplete_zero/succ` — numerical skeleton of §3 |
| `Sandpile.lean` | 41 | `EXIT:0` | `GrainConfig, finitelySupported, toppleAt, stable, initHalfLine, topple_preserves_weight` — definitions only |

`grep -n "sorry|axiom|admit|native_decide|unsafe" MMM/Acct/*.lean` — clean (hits only in comments).

**Exact Lean statements proved:**

- `MMM.Acct.ds_le, sub_one_dvd_m_sub_s, sub_one_mul_nu, nu_add_t_eq_Nval` (Basic)
- `MMM.Acct.multiplicity_factorial_eq_nu : multiplicity p m! = nu p m` via `Nat.Prime.sub_one_mul_multiplicity_factorial` + `sub_one_mul_nu`; `valuation_is_nu` alias
- `MMM.Acct.l1_residue_mod_p/l1_residue_blocked : Nat.card { LTree … // Good ∧ lab=S } ≡ (-1)^t * p^t [ZMOD p^{t+1}]` — direct rewrite of `LTree.labelled_congruence(_blocked)` (`(-p)^t = (-1)^t p^t`)
- `MMM.Acct.dwork_form_equiv : C·∏ m_j! ≡ (-p)^t [ZMOD p^{t+1}]` — alias to checked `PTree.residue_primePower`; `N_eq_nu_add_t : Nval = nu + t` from Basic; `valuation_nu` alias
- `MMM.Acct.completeNodes_zero/succ, autComplete_zero/succ` (DigitForest) using `Nat.sub_one_dvd_pow_sub_one` + `Nat.add_div_of_dvd_right`

**Rows done / not done (per PLAN.md):**

- Done/borrowed: §1 (A)(B); Theorem C20 via `ResidueB` (DworkForm); valuation half of Corollary via Mathlib; numerical lemmas in Basic; DigitForest recursion.
- Partially done: Lemma L3 — definitions + automorphism count per complete tree; not the `m! = p^ν ∏ m_j! |F(m)|` orbit-stabiliser.
- Not done: L0 general `T(a)` iterated carries (needs `T(a)` type); L1(i) `m!·C = p^N·L(m)` standalone; L1(ii) `L(m)≡(-1)^N`; L4 `|F|≡(-1)^ν` (`binom≡1`, `K(a)≡(-1)^a` need ℤₚ fixed-point lemmas); Corollary residue; Sand (a)(b) propositions (definitions scaffolded, no theorem).

**Doubt about note:** No step found wrong. Hygiene note: `DworkForm.dwork_of_residue` is intentionally trivial to make the conditional nature explicit — the note's `C·m!≡(-p)^N` is equivalent to the checked `C·∏m_j!≡(-p)^t` only after the residue `u≡(-1)^ν` (L3+L4), which is not proved by symmetry here; valuation part is quoted from Mathlib.

**`#print axioms`:**

- `multiplicity_factorial_eq_nu` — `[propext, Classical.choice, Quot.sound]`
- `l1_residue_mod_p` — `[propext, Classical.choice, Quot.sound]`
- `dwork_form_equiv` — `[propext, Classical.choice, Quot.sound]`

All files compile one-at-a-time with `lake env lean MMM/Acct/<File>.lean -o .lake/build/lib/lean/MMM/Acct/<File>.olean`. No `sorry`/`axiom` introduced; no file outside `lean/MMM/Acct/` edited; no git command run.
