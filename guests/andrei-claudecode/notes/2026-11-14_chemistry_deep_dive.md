# Chemistry, looked at closely: what the sources say and what follows for us

- **Date:** 2026-11-14 (Saturday afternoon).
- **Author:** Claude Fable 5.2 (AI), in a second Claude Code session working with a team member who was asked to look into the connections. **Not written by the orchestrator. Not human-reviewed.** Guest folder `guests/andrei-claudecode/` (see `AGENTS.md`).
- **Moved:** first written at `notes/2026-11-14_chemistry_deep_dive.md` in a local clone that did not yet have `AGENTS.md` (local commit 8cbcf1c, never pushed). Moved into this guest folder on 2026-11-14, about 18:15 PT. Changed in the move: this line, the paths to the guest's own files, the words "Not yet committed" in the author line, and one dated addendum in section 12. Nothing else.
- **Status:** every statement marked **exact** is checked in `guests/andrei-claudecode/experiments/EC01_chemistry_tower` (27 checks, all pass; check ids in brackets). Statements about what chemists say were read today in the sources listed in section 11, where it also says how much of each source was read. Statements marked **our reading** are deductions that a chemist should confirm.
- **Relation to earlier notes:** this deepens section 5 of `notes/2026-11-14_motivation_and_connections.md` and item A3 of `notes/2026-11-14_crossfield_analogies.md`. Section 9 lists four things in those notes that can now be said more strongly or should be reworded.

Notation: n carbons; the molecule C_nH_(2n+1)X is a ternary tree with n nodes and m = 2n + 1 leaves (the hydrogens); d = number of carbons whose three branches are not all alike (the team's "asymmetric nodes"); t = (s_3(m) − 1)/2.

---

## 0. In six lines

1. The right chemical object is the **monosubstituted alkane C_nH_(2n+1)X** (an alcohol if X = OH), not a free radical. That is how the chemists who first counted them set it up (1932), and it is the only setting in which the "two forms of sec-butyl" are real: **butan-2-ol is the smallest chiral alcohol**.
2. Chemists have three counts, and they are our three groups: structural isomers (all permutations; Konvalinka's orbits), stereoisomers (rotations; our classes), plane trees (no symmetry; the Fuss–Catalan number). **For q = 3, the step from Konvalinka's proof to ours is the step from structural isomers to stereoisomers.**
3. Chemists have a famous rule one level up, "a structure with α asymmetric carbons has 2^α stereoisomers". It has exceptions (first at 13 carbons, as Pólya noted in 1936). Our law one level down, "a stereoisomer carries 3^d plane trees", has none.
4. **Pólya's 1936 paper already contains a two-variable functional equation of the same kind as the deformed equation of our Frobenius note**, for a different group and a different statistic. It should be credited next to Etherington.
5. The number 81 for tert-butyl is not only "the number in our model": it is the **published symmetry number of the tert-butyl radical with rotating methyl groups**, and the published permutations of its nine hydrogens generate exactly our group.
6. The team's word "asymmetric" clashes with chemistry. A chemist's *asymmetric carbon* has four different groups. Our d counts more: chirality centres **and** prochirality centres.

---

## 1. Which molecules, exactly

**From the sources.** Blair and Henze (1932) count the "mono-substitution products of the paraffins", C_nH_(2n+1)X, sorted into primary, secondary and tertiary and into stereoisomeric and non-stereoisomeric; their total is the sequence 1, 1, 2, 5, 11, 28, 74, … (now OEIS A000625). Robinson, Harary and Balaban (1976) set up the model we use: a rooted tree in which every carbon has four neighbours; the root stands for the substituent or the radical site; the hydrogens are the endpoints; the four neighbours of a carbon are placed at the corners of a tetrahedron. They state the two assumptions: rotation about every carbon–carbon single bond is free, and not every tree need be a molecule that can actually be made. On the group they are explicit: the root corner of the tetrahedron stays fixed, so the other three corners can only be moved by the identity and the two rotations by 120°, and the cycle index is that of the cyclic group of order 3 (their page 358). This is the printed source for "rotated, not reflected".

**Why not "alkyl radicals".** A free alkyl radical flips through a flat shape very easily. Gilson and Irikura (2010) treat exactly this for the tert-butyl radical: 81 if only rotations are allowed, 162 once the easy "pyramidal inversion" is included. The extra factor 2 is a reflection. So for free radicals the honest group is larger than ours; for R–X with a real substituent it is ours.

**Consequence for the slide.** Say "the five butyl alcohols" (or "butyl chlorides"): 2-methylpropan-2-ol (tert-butanol), 2-methylpropan-1-ol (isobutanol), (R)- and (S)-butan-2-ol, butan-1-ol. Plane trees over them: 1, 9, 9, 9, 27 [G1]. That butan-2-ol exists in two mirror forms is textbook chemistry and is stated in a 2026 paper on counting stereoisomers (Eriksen and Merkle call them the smallest chiral alcohol); the earlier note had only Wikipedia for it.

## 2. Three counts, three groups

| carbons n | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | what is compared at each carbon | in chemistry | in our problem |
|---|---|---|---|---|---|---|---|---|---|---|---|
| plane trees | 1 | 3 | 12 | 55 | 273 | 1428 | 7752 | 43263 | nothing (branches ordered) | — | Fuss–Catalan number, q = 3 |
| stereoisomers | 1 | 1 | 2 | 5 | 11 | 28 | 74 | 199 | rotations (C3) | Blair–Henze 1932; Pólya's s(x) | our rotation classes |
| structural isomers | 1 | 1 | 2 | 4 | 8 | 17 | 39 | 89 | all permutations (S3) | Henze–Blair 1931; Pólya's r(x) | Konvalinka's orbits |

**Exact [A1, A2, B1, B2, B3].** All three rows agree with the printed tables up to 14 carbons. A stereoisomer carries exactly 3^d plane trees. A structural isomer carries the sum of 3^d over its stereoisomers, which is Konvalinka's product of multinomial coefficients. For four carbons: structural isomers carry 1, 9, 18, 27; stereoisomers carry 1, 9, 9, 9, 27. The 18 is not a power of 3 **because sec-butyl has two mirror forms**. From 6 carbons on, more than half of the structural isomers carry a number of plane trees that is not a power of 3.

**Our reading.** Chemists refined their count from structural isomers (1931) to stereoisomers (1932). For q = 3 the team's change of group is the same refinement, and it is what turns orbit sizes into pure powers of 3. This is a one-sentence answer to "what did you change in Konvalinka's proof?" for an audience that knows chemistry.

Also checked [A3–A7]: the split into achiral and chiral forms agrees with the 1976 table; "achiral" is not the same as "no stereogenic centre" (first difference at 9 carbons: the two meso-type forms of 3,5-dimethylheptan-4-ol, the example drawn in Eriksen–Merkle's Figure 4).

## 3. The chemists' 2^α rule and our 3^d law

**From the sources.** Blair and Henze open their paper with the rule every chemist learns: a compound with α asymmetric carbon atoms exists in 2^α stereoisomeric forms, unless the asymmetric atoms are not structurally distinct or "pseudo-asymmetry" intervenes. Pólya (1936) says the same and adds two facts: α asymmetric carbons first occur at 2α + 2 carbons, in a single structure; and the count 2^α is first too large at C13H27OH, again for a single structure.

**Exact [D2, D3, D4].** Both of Pólya's remarks hold in our enumeration. The exceptional structure at 13 carbons is the carbinol with three sec-butyl groups: three asymmetric carbons, 4 stereoisomers instead of 8.

**The contrast (exact [B2]).** One level down there are no exceptions: the plane trees over a stereoisomer number exactly 3^d, for every n. The reason, in our words: by Step 1 of the main proof a rotation class is an orbit of a group of 3-power order, whereas the stereoisomers of one structure are not the orbit of a group.

| | from | to | size of a fibre | exceptions |
|---|---|---|---|---|
| van 't Hoff's rule (chemistry) | structural isomer | its stereoisomers | 2^α, α = asymmetric carbons | yes, from 13 carbons on; always fewer |
| Step 1 of our proof | stereoisomer | its plane trees | 3^d, d = carbons with branches not all alike | none |

## 4. Pólya's equation (24) and our deformed equation

**From the source (scan of the 1936 paper, pages 435–436 and 441; German; read by an AI, a human should confirm).** Pólya asks how many structurally isomeric alcohols C_nH_(2n+1)OH have exactly α asymmetric carbons, collects the answers in Q(x, y) = Σ T_n^(α) x^n y^α (his (23)), and gives

    (24)   Q(x, y) = 1 + x·Q(x, y)·Q(x², y²) + x·y·[Q(x, y)³ − 3·Q(x, y)·Q(x², y²) + 2·Q(x³, y³)]/6
    (25)   s(x)   = 1 + x·[s(x)³ + 2·s(x³)]/3.

Q(x, 0) is his q (no asymmetric carbon), Q(x, 1) = r (structural isomers), and Q(x, 2) is his upper bound for the stereoisomers.

**Ours, for p = 3, counted by carbons (the same equation as in `paper/frobenius_proof.tex`, with F(x, y) = x·A(x², y)).**

    A(x, y) = 1 + x·A(x³, y³) + x·y·[A(x, y)³ − A(x³, y³)]/3 ,     A(x, 1) = s(x),   A(x, 3) = Fuss–Catalan series.

**Exact [D1, D5, D6].** Both equations reproduce the enumerations up to 14 carbons.

| n | Pólya's Q_n(y): structural isomers by asymmetric carbons | our A_n(y): stereoisomers by d |
|---|---|---|
| 4 | 3 + y | 1 + 3y² + y³ |
| 5 | 5 + 3y | y + 3y² + 6y³ + y⁴ |
| 6 | 8 + 8y + y² | 2y + 2y² + 13y³ + 10y⁴ + y⁵ |
| 7 | 14 + 20y + 5y² | y + 6y² + 15y³ + 36y⁴ + 15y⁵ + y⁶ |

**Our reading.** The two equations are built the same way: a term for "branches alike", in which the variables are replaced by their powers, and a term carrying y for "branches different". So the lineage of the deformed equation is: Pólya 1936 (group S3, y marks asymmetric carbons), Etherington 1939 (two branches, y marks unbalanced nodes; already credited), ours (rotations, any prime, prime powers, y marks d). Pólya's equation is for another group and another statistic and says nothing about divisibility, so it does not touch our novelty claim; but a referee who knows it will expect to see it cited. **Suggested action: one sentence and one bibliography entry in the remark on earlier work of the Frobenius note, after a human has looked at page 436.**

A difference worth one sentence in the talk: Pólya's Q(x, 2) only bounds the next count (section 3), while our A(x, 3) *is* the next count.

## 5. A dictionary for talking to a chemist

The IUPAC glossary of stereochemistry (1996) has a word for each kind of carbon. **Our reading**, with X–C(a)(b)(c) a carbon and its three branches:

| branches | team's word | chemist's word | example in the glossary | factor in class size | factor in symmetry number |
|---|---|---|---|---|---|
| a = b = c | symmetric node | the three branches are *homotopic* (related by a threefold rotation); a "threefold rotor" | chloroform's three chlorines | 1 | 3 |
| two alike | asymmetric node | *prochirality centre* (the two like branches are enantiotopic or diastereotopic) | C-1 of ethanol; C-3 of butan-2-ol | 3 | 1 |
| all different | asymmetric node | *chirality centre* (stereogenic centre; includes pseudo-asymmetric carbons) | C-2 of butan-2-ol | 3, and two forms exist | 1 |

So **d = chirality centres + prochirality centres**, and n − d = the carbons that are threefold rotors. The stereogenic part of this is checked against a printed table [C1]; the prochirality part is by definition only.

**Warning.** In chemistry "asymmetric carbon atom" is van 't Hoff's term for a carbon with four different groups. Ethanol has none; in the team's language its CH2 carbon is an "asymmetric node". With chemists in the room say "lopsided" or "not a threefold rotor" for our notion. (An earlier answer in this session equated d with the number of stereocentres. That was wrong; the table above is the correction.)

Joint counts, for the record [Part C of the output]: with 6 carbons the 28 stereoisomers have d = 1, 2, 3, 4, 5 in 2, 2, 13, 10, 1 cases and 0, 1, 2 stereogenic centres in 8, 16, 4 cases.

## 6. Symmetry numbers: the 81 is in the literature

**From the source.** Gilson and Irikura (2010) define the symmetry number as the order of the group of permutations of identical atoms that the allowed motions realise; it lowers the entropy by R·ln σ. Their appendix works the tert-butyl radical: 3 for the rigid shape, 3 × 3³ = 81 when the methyl groups may rotate, and 162 with inversion; they print the generating permutations of the nine hydrogens.

**Exact [F3, F4].** Those permutations generate groups of order 81 and 162, and the group of order 81 is, permutation for permutation, the symmetry group of our tert-butyl tree: the "overall threefold rotation" is the rotation at the root, the "methyl torsion" is the rotation at a methyl node. Also 81 is the largest power of 3 dividing 9!, the order of a Sylow 3-subgroup of the permutations of nine hydrogens.

**Exact in the tree model, our reading as chemistry [F1, E4].** For R–X the rotations that keep the molecule form a group of order 3^(n−d), one factor 3 for every threefold rotor, the whole-molecule rotation about the C–X bond being the rotation at the root. Hence

    largest symmetry number of an alcohol with n carbons = 3^(n−t) = the largest power of 3 dividing (2n+1)!,

where 2n + 1 is the number of hydrogens on carbon, and the theorem reads: **the power of 3 in the number of ternary trees is n minus log_3 of the best symmetry number.** The earlier note's caution that the model "ignores the overall rotation" can be dropped for R–X: it is included.

**The most symmetric alcohols [E1–E3].** Their number is never divisible by 3, and for one prime it is (3t)!/(t!·3^t·∏ m_j!).

| n | hydrogens, base 3 | t | most symmetric alcohol(s) | symmetry number |
|---|---|---|---|---|
| 1 | 3 = 10 | 0 | methanol | 3 |
| 2 | 5 = 12 | 1 | ethanol | 3 |
| 3 | 7 = 21 | 1 | propan-2-ol | 9 |
| 4 | 9 = 100 | 0 | 2-methylpropan-2-ol (tert-butanol) | 81 |
| 5 | 11 = 102 | 1 | 2,2-dimethylpropan-1-ol (neopentyl alcohol) | 81 |
| 6 | 13 = 111 | 1 | (R)- and (S)-3,3-dimethylbutan-2-ol: a mirror pair | 243 |
| 7 | 15 = 120 | 1 | 2,3,3-trimethylbutan-2-ol | 729 |
| 8 | 17 = 122 | 2 | ten of them (8 chiral, 2 achiral) | 729 |
| 9 | 19 = 201 | 1 | 2,2,4,4-tetramethylpentan-3-ol | 6561 |
| 13 | 27 = 1000 | 0 | tri-tert-butylcarbinol | 3^13 |

Two remarks. At 6 carbons the minimum is reached by a pair of mirror images, so "the most symmetric molecule" can be chiral: 13 = 111 in base 3 means one carbon carrying three different perfect branches (hydrogen, methyl, tert-butyl), which is a chirality centre. And the perfectly branched alcohol with 13 carbons is a real compound: tri-tert-butylcarbinol was first made by Bartlett and Schneider in 1945 (bibliographic record and Wikipedia only; paper not read). So "the number of ternary trees with 13 nodes, 300,830,572, is prime to 3" has a molecule behind it, as 55 has tert-butanol.

**Hydrogens (exact [F2], small).** The symmetry group splits the hydrogens into classes of interchangeable ("homotopic") ones; there are at least s_3(2n+1) classes, and the most symmetric alcohols have exactly that many, of sizes given by the digits (tert-butanol: one class of 9; neopentyl alcohol: 9 + 1 + 1). This does not characterise them: 3-ethylpentan-3-ol also has only three classes.

## 7. A physical echo: symmetric isomers melt higher (analogy, with real data)

Chemists know an empirical rule, Carnelley's rule (1882): among isomers the more symmetrical ones tend to melt higher. It is usually explained through the entropy of melting and the symmetry number (Brown and Brown 2000 and Yalkowsky 2014; bibliographic records and one abstract only).

Melting points from PubChem (values of the Hazardous Substances Data Bank, read 2026-11-14):

| alcohol | plane trees | symmetry number | melting point |
|---|---|---|---|
| tert-butanol | 1 | 81 | +25.8 °C |
| isobutanol | 9 | 9 | −108 °C |
| butan-2-ol (racemic) | 9 + 9 | 9 | −114 °C |
| butan-1-ol | 27 | 3 | −88.6 °C |
| neopentyl alcohol | 3 | 81 | +53 °C |
| 2-methylbutan-2-ol | 9 | 27 | −9.1 °C |
| pentan-1-ol | 81 | 3 | −79 °C |

The alcohol that stands alone in its class is the only butanol that is solid on a cool day, and the most symmetric pentanol melts 60 degrees above the next. **This is a rule of thumb, not a law**: lower down the order is not monotone (butan-1-ol melts above isobutanol), and melting depends on much else. Use it as colour, not as a claim.

## 8. Questions for a chemist

1. Is "monosubstituted alkane with free rotation about every C–C bond" the model you would expect for counting stereoisomers of alcohols? Anything a chemist would object to in "rotated, not reflected"?
2. Is section 5's table right in your vocabulary: threefold rotor / prochirality centre / chirality centre? Is there one word for "a carbon that is a chirality centre or a prochirality centre"?
3. Would you call 3^(number of threefold rotors) the symmetry number of an alkyl chloride or an alcohol in the free-rotor picture? Do standard tables give 81 for tert-butyl chloride or isobutane?
4. Do tert-butanol, neopentyl alcohol and tri-tert-butylcarbinol mean anything to you as a family ("globular" molecules, plastic crystals)? Is Carnelley's rule something you would accept on a slide?
5. Is there a chemical reading of a *carry*: three identical groups on one carbon behaving as one larger symmetric group?

## 9. What to reword in the existing material

1. `motivation_and_connections.md`, section 5, "On names": the chirality of sec-butyl is no longer "found stated only on Wikipedia". Sources: Robinson–Harary–Balaban (their Table 2 has two chiral planted trees with 4 carbons), Eriksen–Merkle (butan-2-ol as the smallest chiral alcohol). Prefer "butyl alcohols" to "butyl groups" (section 1).
2. `crossfield_analogies.md`, A3: the caution that 81 is only "the number in our model" can be replaced by the citation in section 6.
3. Everywhere chemists may listen: avoid "asymmetric carbon" for our notion (section 5).
4. `paper/frobenius_proof.tex`, remark on earlier work, and the reference slide: consider crediting Pólya 1936, equations (23)–(24), next to Etherington (section 4). A human should read the page first.

## 10. Lines that could go on a slide or in the Q&A

- "For three branches, Konvalinka's classes are the chemist's structural isomers and ours are the stereoisomers. Sec-butyl has two mirror forms, so his class has 18 trees and ours have 9 and 9."
- "Chemists have a 2^α rule with exceptions. One level down we have a 3^d law without exceptions."
- "The symmetry number 81 of tert-butyl is in the physical-chemistry literature. It is the largest power of 3 dividing 9!."
- Q: "Is the two-variable equation new?" A: "For two branches it is Etherington's (1939); for structural isomers with three branches Pólya had one in 1936; for rotations at any prime and for prime powers we did not find it."

## 11. Sources, and how much of each was read

All read on 2026-11-14 by the AI author. Bibliographic fields are from Crossref records fetched today unless another source is named. Nothing was added to `references/`; the scans were read from the OEIS server and not saved in the repository.

- C. M. Blair, H. R. Henze, "The number of stereoisomeric and non-stereoisomeric mono-substitution products of the paraffins", J. Am. Chem. Soc. 54 (3) (1932), 1098–1106, DOI 10.1021/ja01342a036. Scan on the OEIS server (linked from A000620): pages 1098–1099 read.
- G. Pólya, "Algebraische Berechnung der Anzahl der Isomeren einiger organischer Verbindungen", Z. Kristallogr. 93 (1936), 415–443, DOI 10.1524/zkri.1936.93.1.415 (fields as in `notes/2026-11-14_motivation_sources.md`, item 1). Scan on the OEIS server (linked from A000598): pages 433–436 and 441–442 read, in German.
- R. W. Robinson, F. Harary, A. T. Balaban, "The numbers of chiral and achiral alkanes and monosubstituted alkanes", Tetrahedron 32 (3) (1976), 355–361, DOI 10.1016/0040-4020(76)80049-X (fields from the OEIS record of A000625). Scan on the OEIS server: pages 355–359 read, including Table 2.
- C. A. Eriksen, D. Merkle, "Enumerating Chemical Structures, Stereoisomers, and Stereogenic Units with Analytic Combinatorics", arXiv:2609.02932 (version 1, 2026; the arXiv page says submitted to J. Math. Chem.; licence CC BY 4.0). Sections 3.1 and 3.2 and Tables 3.2.1, 3.2.2 read as extracted text.
- M. K. Gilson, K. K. Irikura, reference 11 of `references/README.md`. Full text of the author manuscript fetched through the NCBI E-utilities API (PMC3079527); the appendix example "tert-butyl radical" and the passages on methyl rotation read.
- G. P. Moss, "Basic terminology of stereochemistry (IUPAC Recommendations 1996)", Pure Appl. Chem. 68 (1996), 2193–2222, DOI 10.1351/pac199668122193 (fields from the web version, iupac.qmul.ac.uk/stereo). Entries read **only through a summarising fetch tool**: asymmetric carbon atom, homotopic, enantiotopic, diastereotopic, pseudo-asymmetric carbon atom, prochirality, prochirality centre, stereogenic unit.
- P. D. Bartlett, A. Schneider, "The Synthesis of Tri-t-butylcarbinol and Other Highly Branched Alcohols by Means of Sodium", J. Am. Chem. Soc. 67 (1) (1945), 141–144, DOI 10.1021/ja01217a049. Record only; that the compound is the alcohol with three tert-butyl groups was read on Wikipedia.
- R. J. C. Brown, R. F. C. Brown, "Melting Point and Molecular Symmetry", J. Chem. Educ. 77 (6) (2000), 724, DOI 10.1021/ed077p724 (record only). S. H. Yalkowsky, "Carnelley's Rule and the Prediction of Melting Point", J. Pharm. Sci. 103 (9) (2014), 2629–2634, DOI 10.1002/jps.24034 (abstract, through a summarising fetch tool).
- OEIS records A000598, A000620, A000621, A000622, A000625, A005628 (JSON). PubChem melting-point records for the compounds of section 7.

## 12. Not verified

- No chemist has read any of this. Sections 5, 6 (the sentence about R–X) and 8 are where a chemist is most needed.
- The names in sections 6 and 7 were derived by hand from the structures; the counts are checked, the names are not.
- Carnelley's 1882 paper, Brown–Brown and the body of Yalkowsky's paper were not read. PubChem lists several melting points per compound; one database's values are shown.
- Pólya's 1937 Acta paper was not opened; the OEIS says the equation for q is on its pages 151–152.
- That standard thermochemical tables list 81 for tert-butyl chloride or isobutane was **not** found in a source today; only the tert-butyl radical example was.
  - *Addendum, 2026-11-14 about 18:15 PT.* The team's later note `notes/2026-11-14_connections_ranked.md`, section 3.3, reports from Domalski and Hearing 1988 (reference 39 of `references/README.md`) the value 81 for 2-methylpropane and 27 × 3 × 2 for tert-butylbenzene. I have not opened that source.
