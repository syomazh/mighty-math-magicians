# Changes proposed by guests/andrei-claudecode to files outside this folder

One entry per change: the file and the place, what is wrong or missing, the exact replacement
text (or a patch file in this folder), and the evidence (AGENTS.md, "How to propose a change").
Not human-reviewed.

Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code, started by Andrei, 2026-11-14. Line numbers are those of `origin/main` at 2cf47d3. "Note C" is `notes/2026-11-14_chemistry_deep_dive.md` in this folder, "note P" is `notes/2026-11-14_polymers_deep_dive.md`.

No proposal here says that a proof is wrong. Entry 1 is a wording that a chemist will read as false; the others are sources, a credit and optional lines.

## 1. `notes/2026-11-14_connections_ranked.md`, section 3.3, statement 2 (line 139): "asymmetric carbon"

- **What is wrong.** The sentence reads: "each asymmetric carbon has three distinguishable staggered positions (the chemists' trans, gauche-plus and gauche-minus [53]), and each symmetric carbon has one." In chemistry an *asymmetric carbon atom* is a carbon with four different groups. The team's asymmetric node is wider: it includes a carbon with two like branches. Smallest example: the ethyl group, C2H5–X. Its CH2 carbon has branches CH3, H, H, so it is an asymmetric node, d = 1 and the class has 3 trees. A chemist says ethyl has no asymmetric carbon, and reads the sentence as giving one conformation. The same word appears in the talk, wherever the butyl picture is explained.
- **Proposed text.** "each carbon whose three branches are not all alike has three distinguishable staggered positions (the chemists' trans, gauche-plus and gauche-minus [53]), and each carbon with three like branches has one. (Such a carbon is a chirality centre or a prochirality centre. It need not be what chemists call an asymmetric carbon, which has four different groups.)"
- **For the talk.** With chemists in the room say "lopsided" or "not a threefold rotor" for the team's notion.
- **Evidence.** Note C, section 5 (the table with the IUPAC terms). `experiments/EC01_chemistry_tower/output.txt`, part C: with 6 carbons the 28 classes have d = 1, 2, 3, 4, 5 in 2, 2, 13, 10, 1 cases, and 0, 1, 2 stereogenic centres in 8, 16, 4 cases; so the two counts differ. The joint table agrees with Table 3.2.2 of Eriksen and Merkle (check C1).
- **Limit.** The IUPAC glossary was read only through a summarising fetch tool. A chemist should confirm the three words.

## 2. `notes/2026-11-14_connections_ranked.md`, section 3.3, "Sources" (line 148): the three papers were opened

- **What is missing.** The line says of OEIS A000625: "(it cites Blair and Henze 1932, Pólya 1936 and Robinson, Harary and Balaban 1976; none opened)".
- **Proposed text.** "(it cites Blair and Henze 1932, Pólya 1936 and Robinson, Harary and Balaban 1976; opened in part by the guest andrei-claudecode from the scans on the OEIS server: Blair–Henze pages 1098–1099, Pólya pages 433–436 and 441–442, Robinson–Harary–Balaban pages 355–359 with Table 2; their counts agree with our enumeration up to 14 carbons)"
- **Also worth one sentence there.** Robinson, Harary and Balaban, page 358, is a printed source for "rotated, not reflected": the root corner of the tetrahedron stays fixed, so the cycle index is that of the cyclic group of order 3.
- **Evidence.** Note C, sections 1 and 11; EC01, checks A1–A6.

## 3. `references/README.md`: six new entries

- **What is missing.** These sources are used in notes C and P and have no entry. Bibliographic fields are from Crossref records fetched on 2026-11-14 unless another source is named. Each is to be checked against its source by whoever adds it.
- **Proposed entries** (how much was read is part of each entry):
  - `NN. C. M. Blair and H. R. Henze, "The number of stereoisomeric and non-stereoisomeric mono-substitution products of the paraffins", Journal of the American Chemical Society 54 (3) (1932), 1098–1106. DOI 10.1021/ja01342a036. Scan linked from OEIS A000620; pages 1098–1099 read by the guest andrei-claudecode. Used for: the model C_nH_(2n+1)X and the rule "α asymmetric carbons, 2^α stereoisomers".`
  - `NN. G. Pólya, "Algebraische Berechnung der Anzahl der Isomeren einiger organischer Verbindungen", Zeitschrift für Kristallographie 93 (1936), 415–443. DOI 10.1524/zkri.1936.93.1.415 (fields as in notes/2026-11-14_motivation_sources.md, item 1; not checked again). Scan linked from OEIS A000598; pages 433–436 and 441–442 read, in German, by the guest andrei-claudecode. Used for: equations (23) to (25).`
  - `NN. R. W. Robinson, F. Harary and A. T. Balaban, "The numbers of chiral and achiral alkanes and monosubstituted alkanes", Tetrahedron 32 (3) (1976), 355–361. DOI 10.1016/0040-4020(76)80049-X (fields from the OEIS record of A000625). Scan on the OEIS server; pages 355–359 read, including Table 2. Used for: the tree model, the cyclic group of order 3 (page 358), the chiral and achiral counts.`
  - `NN. C. A. Eriksen and D. Merkle, "Enumerating Chemical Structures, Stereoisomers, and Stereogenic Units with Analytic Combinatorics", arXiv:2609.02932, version 1 (2026). Sections 3.1 and 3.2 and Tables 3.2.1, 3.2.2 read as extracted text. Used for: counts by number of stereogenic centres; butan-2-ol as the smallest chiral alcohol.`
  - `NN. G. P. Moss, "Basic terminology of stereochemistry (IUPAC Recommendations 1996)", Pure and Applied Chemistry 68 (1996), 2193–2222. DOI 10.1351/pac199668122193 (fields from the web version, iupac.qmul.ac.uk/stereo). Eight entries read only through a summarising fetch tool. Used for: the words chirality centre, prochirality centre, homotopic, asymmetric carbon atom.`
  - `NN. H. Galina, "A theoretical model of hyperbranched polymerization involving an AB_f monomer. Part I. Degree of branching", Polimery 48 (9) (2003), 610–613. DOI 10.14314/polimery.2003.743610. Open access; introduction and the section on the degree of branching read from the text layer (formulas garbled there). Used for: Flory's AB_(f−1) model and the degree of branching 1/2.`
- **Not proposed as an entry:** Flory's 1952 paper (J. Am. Chem. Soc. 74 (11), 2718–2723, DOI 10.1021/ja01131a008). Record only; nobody here has opened it.
- **Evidence.** Note C, section 11; note P, section 9.

## 4. `paper/frobenius_proof.tex`, remark on earlier work (line 536 and after): a credit to Pólya

- **What could be added.** The remark credits Etherington's equation (33) for p = 2, k = 1. For three branches and the full symmetric group, Pólya's 1936 paper has a two-variable equation built the same way: a term for "branches alike" in which the variables are replaced by their powers, and a term carrying y for "branches different". A referee who knows it will expect to see it.
- **Proposed text**, after "He does not consider divisibility.":
  `For three branches and the full symmetric group, P\'olya \cite{Pol36} has an equation of the same shape: with $y$ marking the asymmetric carbon atoms of the structural isomers of the alcohols $C_nH_{2n+1}OH$, his equation~(24) reads $Q(x,y)=1+x\,Q(x,y)\,Q(x^2,y^2)+\tfrac16\,xy\,\bigl[Q(x,y)^3-3\,Q(x,y)\,Q(x^2,y^2)+2\,Q(x^3,y^3)\bigr]$. It is for another group and another statistic, and it says nothing about divisibility.`
  and the bibliography entry of proposal 3 for `Pol36`.
- **Evidence.** EC01, check D1: the equation as transcribed gives the structural isomers by number of asymmetric carbons for n ≤ 14, in agreement with Table 3.2.1 of Eriksen and Merkle (check C2). Check D6: for p = 3 the team's own equation, at y = 1, becomes Pólya's equation (25).
- **Needed first.** A person reads page 436 of the scan. The equation was read by an AI from a German scan.
- **It does not touch the novelty claim**: another group, another statistic, no valuation.

## 5. `notes/2026-11-14_motivation_and_connections.md`, section 5, "On names" (line 60), and `notes/2026-11-14_crossfield_analogies.md`, A3 (line 59)

- **Line 60, what can be said more strongly.** Current: "That the sec-butyl group has two mirror-image forms we found stated only on Wikipedia; it agrees with the two OEIS counts (5 against 4)." Proposed: "That the sec-butyl group has two mirror-image forms is in the chemical literature: Table 2 of Robinson, Harary and Balaban (1976) has two chiral forms with four carbons, and Eriksen and Merkle (2026) call butan-2-ol the smallest chiral alcohol. It agrees with the two OEIS counts (5 against 4)."
- **Line 59, what can be replaced.** Current: "the 81 is the number in our model, which keeps only the rotations of the three bonds and ignores the overall rotation and everything else about a real molecule". Proposed: "the 81 is published for the tert-butyl radical with freely rotating methyl groups (reference 11, appendix: 3 × 3³ = 81, and 162 once inversion is allowed), and for a group R–X the rotation about the bond to X is the rotation at our root, so the overall rotation is included; everything else about a real molecule is ignored". Section 3.3 of the later ranked note already says more, from Domalski and Hearing; this entry only brings the older note in line.
- **A point for both notes.** The model fits R–X (alcohols, chlorides), not free radicals: a free radical inverts easily, which adds a reflection and doubles the group (162 for tert-butyl). Prefer "butyl alcohols" or "butyl groups on a partner" to "butyl radicals".
- **Evidence.** Note C, sections 1 and 6; EC01, checks A3, F3, F4.

## 6. `talk/slides.tex`, frame "Chemistry does it with p = 3" (line 121), and the deck in `talk/`: optional lines, for the humans

- **Could be added to the caption** (exact; EC01, check B3): "Up to all permutations of the branches these are four structures with 1, 9, 18, 27 trees (Konvalinka's orbits). Up to rotation they are five, with 1, 9, 9, 9, 27: every size is a power of 3."
  This is the shortest answer I found to "what did you change in Konvalinka's proof?": 18 = 9 + 9 is the mirror pair.
- **Not proposed for a slide yet:** "one pot of an AB3 monomer gives the five shapes in the ratio 27 : 9 : 9 : 9 : 1". It is exact in an ideal model (rows 9 and 10 of `CLAIMS_PROPOSED.md`), but it has no printed source and no chemist has heard it. If it is said, say "in the ideal model", and do not say that the butyl alcohols form in that ratio: the statement is about a polymer of an AB3 monomer.
- **A caution on weight.** The chemistry is illustration. It defends the choice of rotations and makes 55 = 1 + 9 + 9 + 9 + 27 visible. It is not the reason for the problem, and it is a safer cut than any step of the proof if the talk runs long.
- **Evidence.** Note C, sections 2 and 10; note P, sections 4 and 7.
