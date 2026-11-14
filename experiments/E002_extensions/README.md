<!-- Author: moonshotai/kimi-k3.1-pro (AI), 2026-11-13. Exploratory; not human-reviewed. -->
# E002 extensions: profiles, weighted numbers, closed families

## Goal

Test the numerical claims C9, C10 and C11 of `briefs/W003_extensions_numerics.md`, using rotation equivalence on the complete depth-`k` `p`-ary refinement of a `q`-ary tree, where `q=p^k`. Also explore the number of classes with `d=t,t+1,t+2` asymmetric nodes.

Every assertion is supported only within the explicitly listed finite ranges. These results do not establish general theorems.

## Hypothesis

- **C9:** weighted orbit sums are integral, satisfy Konvalinka's root recurrence and have the expected weighted congruence; transitivity of the rotations on branches is relevant to the recurrence.
- **C10:** for a profile `(n_0,...)`, the product of `binom(q*n_i,n_(i+1))` is exactly the class-size sum and has valuation at least `t=(s_p((q-1)n+1)-1)/(p-1)`.
- **C11:** a family closed under rotations has size divisible by `p^t`, and its residue divided by `p^t` is the number of minimal classes modulo `p`, provided higher-valuation terms vanish as in the proposed mechanism. Test bounded-height trees and trees whose leaves all have depth at least `g`.

## Method

`run.py` uses no factorial formula for p-adic valuations. `vp(x,p)` computes valuations by repeated integer division, with exact `int` and `Fraction` arithmetic throughout.

- Build rotation orbits recursively from ordered `q`-ary root branches. Record the class size `p^d`, its profile and its root children. Every build checks the Fuss--Catalan total. Canonical profile data preserves the profile under rotations.
- **A(a):** enumerate profiles without using the orbit cache. At each level choose an arbitrary subset of the `q*n_i` available child slots, with next size `0,...,q*n_i`, until the total is `n` and a zero level is reached. Multiply `binom(q*n_i,n_(i+1))` at each transition. The terminal factor `binom(q*n_h,0)=1` and other empty borders are implicit. Explicit plane-tree counts and products are also cross-checked for `n=1,...,5` in each case (and `n=1,...,4` with `--smoke`).
- **A(b,c):** use that independent profile iterator alone. Factor all products directly and test `v_p>=t`. Among tight products, sum `count/p^t mod p` and compare it with `(-1)^t/(product of factorials of base-p digits of m)`. Tight-profile sets and residues are obtained independently from orbit data.
- **B:** four weight functions at each `q`: `1+q^2*x` and the degree at most three polynomials whose coefficients `c0,c1,c2,c3` are chosen uniformly from `[-q,q]` using `random.Random(137)`. The displayed coefficient vectors are part of `output.txt`/`part_b_lower.txt`. Check the weight hypotheses by finite differences on the domain needed for the computations.
  
  For every orbit and every `x=0,...,5`, compute `sum_T w_b(T)(x)` by walking **explicit plane trees**, then divide exactly by the separate orbit cardinality. This is not computed from the recurrence. Check integrality, `r(0)=1 mod q`, and equality with the exact rational Konvalinka recurrence. Sum explicit weights at `x=0` and test the required congruence modulo `p^(t+k)`. The non-transitive `lower` control at `(p,k)=(2,2)` fixes the lower block order but rotates the upper level; it is a genuinely different group, not merely a different universal orbit numbering.
- **C:** for `k=1` and every nonempty family, compute exact class-size totals, direct valuations and the number of classes with size exactly `p^t` modulo `p`. Height is maximum **leaf** depth. Independently enumerate qualifying plane trees for `n<=5` as a check on family predicates and totals.
- **D:** exact class-size valuations produce `N_t,N_(t+1),N_(t+2)` and `C_n^(q)/p^t mod p^2`.

Required command, run after the smoke run:

```sh
uv run python experiments/E002_extensions/run.py > experiments/E002_extensions/output.txt
```

`output.txt` contains A/B tables and all summaries. The generated `part_a_tight_profiles.txt`, `part_d.txt`, `part_c_families.txt` preserve the exhaustive requested data. `part_b_lower.txt` records every non-transitive recurrence failure with all six direct and recurrence values, rather than suppressing failures. Companion-file provenance headers include the actual UTC generation time.

## Results

### C9: supported for the tested weights and ranges (not proved in general)

For each row, `interval` is the tested interval of `n` and `points` is the number of checked `(weight, orbit, x)` values (four weights, every orbit, all `x=0,...,5`).

| `(p,k)` | `q` | Full-group interval | Direct-orbit points | Congruences | Full-group failures |
|---|---:|---:|---:|---:|---|
| `(2,1)` | 2 | 1--10 | 9,552 | 40 | 0 |
| `(3,1)` | 3 | 1--8 | 7,704 | 32 | 0 |
| `(5,1)` | 5 | 1--6 | 3,624 | 24 | 0 |
| `(2,2)` | 4 | 1--6 | 1,728 | 24 | 0 |
| `(3,2)` | 9 | 1--4 | 384 | 16 | 0 |
| `(2,3)` | 8 | 1--4 | 384 | 16 | 0 |

There were no direct divisibility failures, no `r(0)` residue failures, no recurrence mismatches, and no weighted congruence failures in the table.

For the non-transitive lower control `(p,k,q)=(2,2,4)`, all 4,224 direct-orbit points were integral and every tested `r(0)` residue was correct through `n=5`. Nevertheless **4,122 of the 4,224 root-recurrence comparisons failed**. Already for the simple weight at `n=2`, `r_O(0)=9` while the root recurrence gives `13`. All failing cases and their six exact value pairs are in `part_b_lower.txt`.

This confirms that B(ii) fails for this smaller action on these examples; it is not a counterexample to the full-transitive C9 hypothesis. B(i) did not fail. The non-transitive theorem has not been tested or proved.

### C10: supported for all profiles in these ranges (not proved in general)

| `(p,k)` | `q` | Profile interval | Profile/product/count failures | Divisibility failures `v_p<t` | Residue-sum failures |
|---|---:|---:|---:|---:|---:|
| `(2,1)` | 2 | 1--22 | 0 | 0 | 0 |
| `(3,1)` | 3 | 1--15 | 0 | 0 | 0 |
| `(5,1)` | 5 | 1--14 | 0 | 0 | 0 |
| `(2,2)` | 4 | 1--14 | 0 | 0 | 0 |
| `(3,2)` | 9 | 1--12 | 0 | 0 | 0 |
| `(2,3)` | 8 | 1--12 | 0 | 0 | 0 |

The orbit-builder profile sets agree exactly with independent product enumeration at every `n`. Direct plane-tree checks agree for `n<=5`. Every independent product has direct repeated-division valuation at least `t`. The full tight-profile lists, including residues, are in `part_a_tight_profiles.txt`; all tight-profile residue sums match the requested digit formula.

For example, binary `n=1,...,22` has tight-profile counts following the base-two digit pattern below. Each listed residue is nonzero modulo 2, so only its total is shown here:

| Tight profile count for binary `(p,k)=(2,1)` | 1 | 3 | 13 |
|---|---|---|---|
| Conjectural number from `t` | 1 if `t=0,1` | 3 if `t=2` | 13 if `t=3` |

**Conjecture only:** tight-profile sets and their residues can be described in terms of the base-`p` digits of `m` via a digit skeleton or atom chain. This experiment has no independent geometric characterization or bijection proving such a description. It is not reported as a theorem.

### C11: supported for the two tested families (not tested for arbitrary closed families)

Tested at `p=2` for `n=1,...,16`, `h=0,...,10`, `g=0,...,10`; and at `p=3` for `n=1,...,13`, `h=0,...,9`, `g=0,...,9`. Empty families were not tested because the valuation is undefined. Every nonempty family had the exact size and residue reported in `part_c_families.txt`. Plane-tree checks agree through `n=5`.

| Claim within tested nonempty families | `p=2` | `p=3` |
|---|---:|---:|
| `v_p(|F|)<t` | 0 cases | 0 cases |
| Minimal-class residue mismatch | 0 cases | 0 cases |
| Independent family count mismatch | 0 cases | 0 cases |
| Families with `v_p(|F|)>t` | some; see below | some; see below |

For example, binary `n=4,g=2` has `|F|=4`, so `v_2(|F|)=2>t=1` and zero minimal classes. This is an allowed higher-valuation family, not a C11 failure. Height cases include `p=2,n=6,h=4`: `|F|=20`, `v_2=2=t`, one minimal class; and `p=3,n=5,g=2`: `|F|=9`, `v_3=2>t=1`.

C11 is **not tested** for non-transitive actions, for general predetermined shapes, or for a universally quantified unspecified rotation-closed family. This experiment does not establish a general mechanism ensuring that minimal-class residue is the only contribution modulo `p`.

### D: second-order conjecture only

The complete table, including `N_(t+1)` and `N_(t+2)`, is in `part_d.txt`. For `q=p=2`, the observed rows support:

**Conjecture:** `N_t=1` when `t=0`, and `N_t=(2t-1)!!` when `t>0`.

No general closed formula for `N_(t+1)` modulo `p` is claimed. No pattern is promoted to a proof. The second-order experiments are exploratory.

## Analysis

The principal positive evidence is threefold: the weight computations pass independently of the recurrence used for comparison, the profile-divisibility calculation is derived solely from the independent slot-subset enumeration, and the family valuations are tested with exact totals and direct small-tree checks. The direct orbit mean divides each independently summed class total by that same class's own size.

The intended lower-group failure clarifies the computational scope: equality of direct weighted means with the Konvalinka root recurrence is a substantial test of transitivity, not an automatic tautology enforced by the canonical numbering. Ordinary direct divisibility survives the lower-group examples, so it must be evaluated separately.

C10's residue pattern gives usable data for a further digit-based conjecture but not a proof of a geometric construction. The `v_p>t` rows in C are explicitly expected possibilities: divisibility alone does not demand equality. In every such nonempty tested family, the count of minimal classes modulo `p` is consistent with the residue.

At an intermediate development stage, false A and C failures were caused by a partial-profile stopping condition, an accidental per-tree multiplication by the product instead of per-tree counting, and an internal-depth versus leaf-height mismatch. These were checker faults and were corrected without changing mathematical acceptance criteria. The retained final run uses the corrected checks and contains no unexplained failures. No failed mathematical check is filtered out.

All numerical claims here are at `computed` evidence level, not `ai-proved`, independently reviewed or human-signed.

## Next steps

1. Give a human-reviewed proof of the profile product and divisibility; then characterize the tight profiles from base-`p` digits rather than inferring them from finite tables.
2. Prove the orbit-mean recursion under transitivity and explain precisely where it fails for a non-transitive action. Validate the underlying general C9 argument separately.
3. Establish C11 for all rotation-closed families by identifying contributing minimal classes; compute when higher valuations are nevertheless possible as illustrated above.
4. Seek an independent second-order formula for `N_(t+1)`, and prove or refute the binary odd-double-factorial conjecture for `N_t`.
5. Before any use in the presentation, obtain independent review and required human sign-off; expand computationally expensive ranges only if a reproduced run records all exact results and failures.

### Files

- `run.py`: all computations and file generation.
- `output.txt`: complete compact run summaries and zero/unexpected-failure counts.
- `part_a_tight_profiles.txt`: exhaustive tight profiles and residues.
- `part_b_lower.txt`: every non-transitive failing comparison with all six values.
- `part_c_families.txt`: all nonempty exact C family rows.
- `part_d.txt`: second-order tables for all six `(p,k)` cases.

No additional non-transitive `(3,2)` run was completed; the brief only specifically required the lower action at `k=2` and the implemented control uses `(2,2)` through `n=5`.
