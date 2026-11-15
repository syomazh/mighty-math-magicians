# Polymers, looked at closely, and which chemistry to use for motivation

- **Date:** 2026-11-14 (Saturday afternoon).
- **Author:** Claude Fable 5.2 (AI), in a second Claude Code session working with a team member who was asked to look into the connections. **Not written by the orchestrator. Not human-reviewed.** Guest folder `guests/andrei-claudecode/` (see `AGENTS.md`).
- **Moved:** first written at `notes/2026-11-14_polymers_deep_dive.md` in a local clone that did not yet have `AGENTS.md` (local commit 6789468, never pushed). Moved into this guest folder on 2026-11-14, about 18:15 PT. Changed in the move: this line, the paths to the guest's own files. Nothing else.
- **Status:** statements marked **exact** are checked in `guests/andrei-claudecode/experiments/EC02_polymers` (17 checks, all pass; ids in brackets). What polymer chemists say was read today in the sources of section 9, most of them only in part; **Flory's 1952 paper and his book were not opened**. Statements marked **ours** are derivations made here; they are short and are checked, but no source was found that states them.
- **Companion:** `guests/andrei-claudecode/notes/2026-11-14_chemistry_deep_dive.md` (alcohols and stereoisomers). Section 7 compares the two and decides.

Notation: a monomer AB_(f−1) has one group A and f − 1 groups B; q = f − 1; n units in a molecule; α = fraction of B groups that have reacted.

---

## 0. The decision, in five lines

1. **For motivation, polymers are better than the alcohols.** They are the one place where the Fuss–Catalan number itself is the chemist's count and where the class size p^d means something by itself: it is the odds of an isomer in a one-pot reaction.
2. **The alcohols stay, in a different role:** they are the best illustration of the classes for p = 3, of "rotations, not reflections", and of what was changed in Konvalinka's proof. That belongs with the proof.
3. The two stories meet in one picture the team already has. In a one-pot reaction of an AB3 monomer the four-unit molecules are the five butyl shapes, **in the ratio 27 : 9 : 9 : 9 : 1** [B3]. The sum is 55.
4. The one-line hook for two branches: chemists make perfect dendrimers step by step because one pot will not do it; **the chance that a random 7-unit molecule is the perfect one is 1 in 429**, one over a Catalan number [F1, C2].
5. Two honest limits. For two branches the mathematics is prior work (Etherington, Deutsch–Sagan), so this is motivation, not novelty. And the "odds" statement is ours: proved in five lines and simulated, but not found in a polymer source. A polymer chemist should hear it once before it goes on a slide.

---

## 1. What the repository had, and what is new here

It had Stockmayer's factor for monomers with f equal groups, from a 2022 secondary source: a Fuss–Catalan number divided by the number of free groups (E012, part L), and the remark that dendrons are our atoms. Not there: the hyperbranched case AB_(f−1), where no division is needed and every molecule is a rooted tree; the reading of class sizes as odds; the gel point; the degree of branching.

## 2. A hyperbranched molecule is a rooted tree

**The model (from the sources).** Flory (1952) treated monomers with one group A and f − 1 groups B, where A reacts only with B, and derived the size distribution of the branched molecules they form (Galina 2003 says so in its introduction; only acyclic molecules are considered). Such polymers are now called hyperbranched; they are made in one pot, while dendrimers, the perfectly branched molecules, need a synthesis of many steps (search-result summary of a 2012 review, not opened).

**Exact [A1].** In a ring-free molecule of n such monomers exactly one A is free and (f − 2)n + 1 groups B are free. So:

| polymer chemistry | our trees |
|---|---|
| unit (a reacted monomer) | node |
| the unit with the free A, the "focal point" | root |
| a reacted B | edge to a child |
| a free B | leaf; there are m = (q − 1)n + 1 of them |
| perfect dendron of generation g | atom: the complete tree of height g |
| isomers of the n-mer | trees up to the symmetry of the B groups of a unit |

This is cleaner than the case in the repository: nothing has to be chosen as a root and nothing divided out.

**Which symmetry.** For AB2 the two B groups of a unit are interchangeable, so an isomer is a binary tree up to swapping: our classes for p = 2, with no further assumption. For AB3 it depends on the monomer. If the three B groups sit on a tetrahedral atom, they can be rotated and not reflected, exactly as for a carbon atom: our classes for p = 3. Such a monomer exists according to a search-result summary (triallylsilane, three allyl groups and one hydrogen on silicon; Lach, Müller, Frey and Mülhaupt 1997; paper not opened). For other shapes of monomer the right group may be the full symmetric group.

## 3. The count is the Fuss–Catalan number

**Exact [A1], from bond patterns with no trees in the program.** The number of ways in which n labelled monomers AB_(f−1) with labelled B groups form one ring-free molecule is n! × FussCatalan(f − 1, n). For AB2: 2, 30, 336, 5040, 95040 = n! × 2, 5, 14, 42, 132.

**The size distribution (ours as a derivation; Flory's formula was not opened).** Start at the focal point and follow the reacted B groups. If each B has reacted with probability α independently, a given tree with n units has probability α^(n−1)(1 − α)^((f−2)n+1), so

    fraction of molecules with n units = FussCatalan(f − 1, n) · α^(n−1) · (1 − α)^((f−2)n+1).

**Exact [D1]:** these fractions add up to 1 as long as α ≤ 1/(f − 1). **Checked by simulation [C1]:** 10^6 monomers AB2 reacted to 80%; the 200,000 molecules have sizes 72477, 34368, 20678, 13774, … against 72000, 34560, 20736, 13935, … from the formula with the Catalan numbers 1, 2, 5, 14.

In the mathematical literature this is a branching process; Aldous (1999) notes that branching-process models of polymerization go back to Flory and names Ziff (1980) for a clear account.

## 4. Class sizes are odds

**Lemma (ours).** In the one-pot reaction in which, at each step, a free A reacts with a free B of another molecule and all such pairs are equally likely, all ring-free bond patterns with the same number of bonds are equally likely at every stage.

*Proof.* After j bonds there are N − j molecules, each with one free A, and (f − 1)N − j free B groups. A free A can react with every free B except those of its own molecule, so the number of possible next bonds is (N − j)·B − B = (N − j − 1)·((f − 1)N − j) with B the number of free B groups: it depends only on j. Hence every history of j bonds has the same probability. A ring-free pattern with j bonds can be built in every order of its bonds, so it has j! histories. ∎

**Exact [B1, B2]:** followed through every history for 5 monomers AB2 and for 4 monomers AB3.

**Consequence (exact [B3]; simulated [C2]).** Among the molecules with n units, an isomer T occurs with frequency

    p^d(T) / FussCatalan(p, n),      p = f − 1,

because a class of the main proof has p^d plane trees (Step 1) and each plane tree has n! labellings. So the statement "the Fuss–Catalan number is a sum of powers of p, one for each class" becomes: **the probabilities of the isomers add up to 1.**

- AB2, five units: six isomers with odds 16 : 8 : 8 : 4 : 4 : 2 out of 42.
- AB3, four units: five isomers with odds **27 : 9 : 9 : 9 : 1** out of 55. These are the five butyl shapes of the motivation slide; the two mirror-image ones are equally likely.
- In the simulation, 4157 of 20,678 trimers were the perfect dendron (1 in 5 expected) and 8 of 5835 heptamers (13.6 expected, 1 in 429).

This is the equal-reactivity principle seen at the level of single isomers. It is surely known to polymer theorists in some form; we did not find it stated. (Pitman's "Coalescent random forests", 1999, is about uniformly random forests arising from merging processes; record only, not read.)

## 5. The theorem in polymer words

For AB2 (exact, [F1, F2]; for other primes the same with p in place of 2 where the symmetry is by rotations):

- every isomer weight is a power of 2, and the weights of all isomers of the n-mer add up to Catalan(n);
- **no isomer is rarer than 2^t in Catalan(n)**, where t = (number of ones in the binary expansion of n + 1) − 1; the rarest ones are perfect dendrons, one for each binary digit 1 of n + 1, joined by t lopsided units; their number is odd;
- so the power of 2 in the Catalan number is log2 of the weight of the rarest isomer;
- a perfect dendron exists only for n = 1, 3, 7, 15, 31, …, and then a random n-mer is perfect with probability 1/Catalan(n): 1 in 5, 1 in 429, 1 in 9,694,845, 1 in 14,544,636,039,226,909.

**What chemists measure instead.** The degree of branching DB compares the numbers of units with two, one and no reacted B (dendritic, linear, terminal). For AB2 it is twice the dendritic units over twice the dendritic plus the linear ones; it is 0 for a linear chain and 1 for a perfect dendrimer; in a random polymerization it grows linearly with conversion and reaches 1/2 (Galina 2003, text read). **Exact [C3, E1]:** in our model DB = α, half the conversion of A (simulation: 0.4008 against 0.4000), and the average over all trees with n units tends to 1/2. For AB3 the same model gives 4/9 = 0.44 [E2], the value quoted for AB3 polymers and close to a measurement on the triallylsilane polymer (0.48 ± 0.05; search-result summary).

**A remark that may interest a chemist (ours).** DB is a local count. A molecule in which every unit has two or no reacted B has DB = 1 and can still be far from a dendrimer. Our d is a global count: d = 0 only for the perfect dendron. Among the 7-unit molecules with DB = 1 there are five plane trees and one of them is perfect.

## 6. The gel point is a radius of convergence

For monomers with f equal groups (the case already in the repository) Flory's theory predicts a gel, one molecule spanning the vessel, when the reacted fraction reaches α = 1/(f − 1) (Wikipedia, as recorded in `motivation_sources.md`, item 20). In the size distribution the conversion enters through β = α(1 − α)^(f−2).

**Exact [D2].** β is largest exactly at α = 1/(f − 1), and its value there, (f − 2)^(f−2)/(f − 1)^(f−1), is the radius of convergence of the series Σ FussCatalan(f − 1, n) z^n: 1/4 for f = 3, 4/27 for f = 4. So **gelation is the generating function of our numbers reaching its singularity.** For AB_(f−1) monomers α cannot exceed 1/(f − 1), the value at complete reaction of A, which is why hyperbranched polymers do not gel.

This says nothing about divisibility. It is the best answer found to "do Fuss–Catalan numbers matter to anyone?": their growth rate is a measurable property of a reacting mixture.

**Analogy only.** Measured with the usual absolute value the series converges up to 4/27; measured 3-adically its coefficients are integers that are units infinitely often, so the radius is 1. The theorem is about the second way of measuring.

## 7. Polymers or alcohols for motivation?

| question | alcohols (p = 3) | hyperbranched polymers |
|---|---|---|
| Is the Fuss–Catalan number the chemist's own count? | no: plane trees are not molecules | **yes**: n! × FussCatalan ways for n monomers to join [A1] |
| Do the classes mean something? | yes: stereoisomers, with printed tables from 1932 on | yes: isomers of the n-mer |
| Does the class size p^d mean something? | indirectly: 3^n over the symmetry number | **directly: the odds of that isomer** [B3] |
| Does the sum over classes mean something? | no | **yes: probabilities add up to 1** |
| What does the theorem say there? | which alcohol is most symmetric | which isomer is rarest, and how rare; why one pot does not give dendrimers |
| Which primes are natural? | 3 | 2 (the common monomers); 3 for a tetrahedral AB3; the count itself for every f |
| Is the mathematics new at that prime? | **yes** (p = 3 is beyond the earlier work) | no for p = 2 |
| Does it explain "rotations, not reflections"? | **yes** | only for a tetrahedral AB3 |
| How well sourced? | **strong**: 1932, 1936, 1976, 2026, parts read | model and DB sourced; Flory not opened; the odds statement is ours |
| Is there a real measurement behind it? | melting points, as colour | size distributions, gel points and DB = 0.5 are measured quantities |

**Decision.** Motivation should answer "why would anyone count these trees, and why should the answer be a power of p?". The alcohols answer only the second half, and only by way of symmetry numbers. The polymers answer both: the trees are the molecules, the count is Flory's, and powers of p are odds. **Use the polymers to motivate and the alcohols to explain the proof.**

**The smallest change to the talk that does this** (suggestion; the humans decide):

1. Keep the butyl picture, and add one line under it: "one pot of an AB3 monomer gives these five in the ratio 27 : 9 : 9 : 9 : 1".
2. On the dendrimer picture (`fig_dendrimer`, already drawn) add: "a random molecule against the perfect one; for 7 units and two branches the perfect one has odds 1 in 429".
3. Say once: "the number of trees is what Flory counted in 1952 for these polymers".
4. Keep "structural isomers against stereoisomers" (the alcohols) for the moment the group is chosen in the proof.

**Risks.** (a) A judge may ask whether the two-branch case is new: it is not, and the slide on earlier work already says so. (b) A polymer chemist may object that real monomers do not have equally reactive groups and that rings form; both are stated assumptions of Flory's model (Galina 2003; a review summary notes that real AB2 polymers often miss DB = 0.5 for this reason). (c) "Odds of an isomer" has no printed source yet.

## 8. Questions for a chemist

1. Is it accepted that in the ideal one-pot AB2 reaction two isomers of the same size occur in proportion to their numbers of configurations? Is there a standard reference?
2. Is Flory's number of configurations for A–R–B_(f−1) polymers the expression (fn − n)!/(n!·(fn − 2n + 1)!)? (That is our Fuss–Catalan number; we could not open the paper.)
3. Is triallylsilane a fair example of an AB3 monomer whose three B groups can be rotated but not reflected? Are there others?
4. Would a polymer chemist find "number of lopsided units" a meaningful complement to the degree of branching?
5. Convergent dendrimer synthesis joins identical dendrons on a new unit to make the next generation. Is it fair to call that "a carry"?

## 9. Sources, and how much of each was read

All on 2026-11-14 by the AI author. Bibliographic fields are from Crossref records fetched today.

- P. J. Flory, "Molecular Size Distribution in Three Dimensional Polymers. VI. Branched Polymers Containing A—R—B_(f−1) Type Units", J. Am. Chem. Soc. 74 (11) (1952), 2718–2723, DOI 10.1021/ja01131a008. **Record only.**
- H. Galina, "A theoretical model of hyperbranched polymerization involving an AB_f monomer. Part I. Degree of branching", Polimery 48 (9) (2003), 610–613, DOI 10.14314/polimery.2003.743610. Open access; the text layer of the PDF was read (introduction and the section on the degree of branching; formulas are garbled in the text layer).
- D. Aldous, "Deterministic and Stochastic Models for Coalescence (Aggregation and Coagulation): A Review of the Mean-Field Theory for Probabilists", Bernoulli 5 (1) (1999), from page 3, DOI 10.2307/3318611. One page of the author's preprint read (the remark on Flory and branching processes).
- D. Hölter, A. Burgath, H. Frey, "Degree of branching in hyperbranched polymers", Acta Polymerica 48 (1–2) (1997), 30–35, DOI 10.1002/actp.1997.010480105. **Record only**; its content as reported by Galina 2003 and by search-result summaries.
- C. Lach, P. Müller, H. Frey, R. Mülhaupt, "Hyperbranched polycarbosilane macromonomers bearing oxazoline functionalities", Macromol. Rapid Commun. 18 (3) (1997), 253–260, DOI 10.1002/marc.1997.030180306. **Record and a search-result summary only.**
- T. Higashihara, Y. Segawa, W. Sinananwanich, M. Ueda, "Synthesis of hyperbranched polymers with controlled degree of branching", Polymer Journal 44 (1) (2012), 14–29, DOI 10.1038/pj.2011.99. **Record and a search-result summary only** (the publisher's PDF asked for a login).
- C. J. Hawker, J. M. J. Fréchet, "Preparation of polymers with controlled molecular architecture. A new convergent approach to dendritic macromolecules", J. Am. Chem. Soc. 112 (21) (1990), 7638–7647, DOI 10.1021/ja00177a027. **Record only**; what "convergent" means in question 5 is from memory.
- R. M. Ziff, "Kinetics of polymerization", J. Stat. Phys. 23 (2) (1980), 241–263, DOI 10.1007/bf01012594; J. Pitman, "Coalescent Random Forests", J. Combin. Theory Ser. A 85 (2) (1999), 165–193, DOI 10.1006/jcta.1998.2919. **Records only.**
- Already in `references/README.md`: Stockmayer 1943 (18), Tanaka 2022 (19), Tomalia et al. 1985 and the dendrimer review (29).

## 10. Not verified

- No chemist has read this. Flory's formula, the definition of the degree of branching for AB3 and the chemistry of triallylsilane rest on memory or on search-result summaries, as marked.
- The simulation is one run with one seed.
- For q = 4 the team's group at a node is the symmetry group of a square. Whether a monomer with four B groups in a square exists was not looked into.
- Whether "all bond patterns are equally likely" or "isomers occur in proportion to p^d" is in the polymer literature is unknown; the search was short.
