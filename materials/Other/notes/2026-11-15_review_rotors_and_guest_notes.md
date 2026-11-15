# Review: the rotor-chemistry report (W029) and the guest's notes on chemistry and polymers

Written by Claude Fable 5.2 (a subagent of the orchestrator, brief `briefs/W045_review_rotors_and_guest_notes.md`), 2026-11-15. Not human-reviewed.

Reviewed: `notes/2026-11-14_physical_search_rotors_W029.md` with `experiments/E016_rotor_orbits/`; `guests/andrei-claudecode/notes/2026-11-14_chemistry_deep_dive.md` and `2026-11-14_polymers_deep_dive.md` with that guest's `experiments/`, `PROPOSALS.md` and `CLAIMS_PROPOSED.md`. Nothing that exists was changed; this file is the only thing written.

How sources were read. Every source below was opened today with the fetch tool. That tool hands the page to a small model and returns its answer, so a page read that way is "read through a summarising tool". Where the source is a PDF the tool also keeps the file (outside the repository), and I then read the pages myself as images; those are marked "page image". Reference numbers in square brackets are those of `references/README.md`; sources that are not in that file have keys N1 to N20 (N9 is not used) and are listed under "References to add" with the data that the page or the record returned today. Nothing is cited from memory.

## 1. Verdict in five lines

1. **The mathematics stands.** All four scripts were rerun with `uv run python` and print exactly their stored outputs (E016; EC01: 27 of 27; EC02: 17 of 17; EC03: 2 of 2). Two slips in the prose: W029 gives the wrong hydrogen orbits for n-butyl, and the polymer note has a wrong first number in one list.
2. **The sources mostly say what the notes say.** Of 41 statements attributed to a source, 31 are confirmed with the place, 4 in part, 2 are not what the source says, 4 could not be opened. The ones a slide needs were read in page images: Robinson–Harary–Balaban p. 358 and Table 2, Pólya p. 436, Blair–Henze p. 1098, Eriksen–Merkle p. 18, Domalski–Hearing pp. 1655–1657.
3. **W029 is sound on content and unreliable on citations.** Three author names are wrong, one source is attributed to the wrong book with a dead link, one sentence is not in its source, one reagent is wrong. Take no bibliographic data from it.
4. **The four risks.** "Asymmetric carbon" is handled, but "chirality centre" should be "stereogenic centre". Of the symmetry numbers on the butyl slide only 81 is printed anywhere (for the tert-butyl radical and for 2-methylpropane); none is printed for an alcohol. Free radicals double the group (162). The ratio 27 : 9 : 9 : 9 : 1 is exact in an ideal model and has no printed source; Flory's paper was opened by nobody.
5. **Recommendation.** Keep the present wording of section 3.3 (positions of a carbon, rotated and not reflected). Do not rebuild it around homotopic groups and symmetry numbers; give each of those one supporting sentence in its sourced form. Keep the polymer ratio off the slides.

## 2. What the scripts printed

| Script | Command (from the repository root) | Last line printed | Against the stored output |
|---|---|---|---|
| E016 | `uv run python experiments/E016_rotor_orbits/run.py` | "Checks passed: class counts A000625, ordered-tree orbit sizes, group orders, permutation bijectivity and closure, orbit sizes, and base-3 orbit sizes at the maxima." | identical |
| EC01 | `uv run python guests/andrei-claudecode/experiments/EC01_chemistry_tower/run.py` | "27 checks, 27 passed" | identical after the two header lines |
| EC02 | `uv run python guests/andrei-claudecode/experiments/EC02_polymers/run.py` | "17 checks, 17 passed" | identical after the two header lines |
| EC03 | `uv run python guests/andrei-claudecode/experiments/EC03_path_proof_check/run.py` | "2 checks, all pass (328 + 26 cases)" | identical after the two header lines |

EC03 concerns claim C24 and is not used by the two notes; it was rerun only because it is in the folder. The numbers typed into EC01 from the literature that I could compare with the source agree: Table 2 of Robinson–Harary–Balaban (all four columns, n = 0 to 14) and Tables 3.2.1 and 3.2.2 of Eriksen–Merkle (rows n = 4 to 7), both in page images, and the three permutations of Gilson–Irikura, through the summarising tool.

## 3. Table of statements

Status: **script** = a mathematical statement checked by a script that I reran; **confirmed** = attributed to a source, and the source says it (place given); **in part** = the source supports part of the sentence; **not in source** = the source does not say it; **not opened** = I could not open the source; **unsupported** = no script and no opened source (a reading, a judgment, or a deduction nobody ran); **wrong** = contradicted by a script or by the record.

### 3.1 W029 (`notes/2026-11-14_physical_search_rotors_W029.md`)

| # | Statement (section of W029) | Status | Evidence, place, remarks |
|---|---|---|---|
| W1 | Replacing either CH2 hydrogen of ethanol by D gives the R or the S form, so they are enantiotopic; the three hydrogens of its methyl group, and of any methyl group, are homotopic; in (R)-glyceraldehyde-3-phosphate the analogous pair is diastereotopic (L1) | confirmed | N1, section "Prochiral carbons" (summarising tool). The page defines the three words by replacement only, not by symmetry operations. |
| W2 | Homotopic by the substitution test; enantiotopic protons have the same shift in the achiral solvents normally used; diastereotopic protons appear at different places (example 2-bromo-2-chlorobutane); the chair flip of cyclohexane is much faster than the NMR time scale except at very low temperature (L1) | confirmed | N2 (summarising tool). The page says nothing about tert-butyl or a nine-proton singlet. |
| W3 | A text by J. D. Roberts discusses rotation about C–C bonds, residence times in the staggered conformations and averaged environments of methylene protons, and does not show that an alkyl hydrogen set is exchanged by a threefold rotation (L1) | confirmed, **wrong book and dead link** | The link in W029 returns 404, and chapter 3 of Roberts and Caserio's book is "Organic Nomenclature". The page exists as section 3.9 of another book by Roberts, N3 (summarising tool). Its examples are methyl 2,3-dibromo-2-methylpropionate, 1,2-dibromo-2-methylpropane and 2-nitro-2-methyl-1,3-propanediol. |
| W4 | The same page "cautions against treating a simple propeller diagram as fully describing molecular asymmetry" (L1) | not in source | N3: asked for the words propeller, diagram, caution, simple: none occurs in the body of the page, and there is no warning about pictures. |
| W5 | PubChem has a 1H spectrum of tert-butanol (Bruker AC-300) as an image, with no text saying "9H singlet" (L1) | confirmed | N10, compound 6386, heading "1H NMR Spectra" (JSON through the summarising tool): an image only, no multiplicity, no shifts. |
| W6 | A paper on tri-tert-butylmethanol reports temperature-dependent solid-state 13C CP/MAS spectra and barriers 20–30% higher than in solution, ascribed to the lattice; nothing about 27 protons or a singlet (L1) | confirmed, **authors' names wrong** | N8, abstract in the OpenAlex record. W029 has "A. J. Barrie and M. R. Anderson"; OpenAlex and Crossref both have Patrick J. Barrie and J. Edgar Anderson. |
| W7 | In the model CH3–CH2–X has hydrogen orbits 3, 1, 1; the two CH2 hydrogens are different orbits (L1, L4) | script | E016, line n = 2. |
| W8 | tert-Butyl has one orbit of 9 hydrogens (L1, L4) | script | E016, n = 4, class 5; EC01 F2. |
| W9 | Tri-tert-butylmethyl (13 carbons) has one orbit of 27 hydrogens (L1) | unsupported (true) | No script reaches it: E016 stops at 5 carbons, EC01 part F at 8. It is true: the rotations of a complete tree act transitively on its leaves, by induction on the height. |
| W10 | Sztraka on methylamine: (567) and (576) are cyclic permutations of the methyl hydrogens and are feasible; exchanges of two methyl hydrogens are feasible only together with E*, the inversion of all particles; the unstarred exchanges and the starred cyclic permutations are infeasible; feasible means achievable during the experiment and depends on the barriers (L2) | confirmed | N4, pp. 94–95, lists (1a) and (1b) and Fig. 2a, 2b (page images, pp. 93–97). Tables I and II lie after p. 97 and were not read by me; the lists and the figure carry the same content. |
| W11 | Šimėnas et al.: above the barrier the methyl group reorients classically and stochastically; at low temperature three localised states overlap and split into an A ground state and degenerate E_A, E_B; the three sub-Hamiltonians differ by a permutation of the hyperfine couplings (0°, 120°, 240°); different proton-spin symmetry of the tunnelling states, QRIP (L2) | confirmed | N5, full-text XML (summarising tool). |
| W12 | An abstract on the nuclear spin isomers of nitromethane and the permutation symmetry of its methyl group (L2) | confirmed, **authors' names wrong** | N6, Crossref abstract. W029 has "K. Grohmann and H. Leibscher"; Crossref has Thomas Grohmann and Monika Leibscher. |
| W13 | An abstract that separates AA/EE from AE/EA tunnelling states of coupled methyl rotors (L2) | confirmed, **author's name wrong** | N7, OpenAlex abstract; the molecule is 2,6-dimethylphenol. W029 has "H. L. Welsh et al."; the first author is Blair A. Welsh. |
| W14 | Fernández-Ramos et al.: the classical rotational partition function carries 1/σ_rot; for 16O2 half the rotational levels are missing; for methane 1/12 of the states; σ_rot = m!/n_d (their (5)); methane 4! = 24 configurations, two classes, σ = 12 (L3) | not opened | [12]. The publisher's pages answer with a cookie redirect and no content. The text copy that W029 left in `experiments/E016_rotor_orbits/tmp/fernandez2007.txt` (it carries the article's header) contains all five statements; that is a comparison with the worker's copy, not with the source. |
| W15 | The same paper: reaction symmetry number = σ_rot of the reactants over σ_rot of the transition state (their (4)); 12/3 = 4 for hydrogen abstraction from methane "by F" (their (6)); 3·12/3 = 12 with CF3 (their (7)); the extra factor 3 has nothing to do with internal rotation; internal rotation is their section 3.5 (L6) | not opened; **one detail wrong** | Same as W14. In the worker's own copy the reaction of (6) is the abstraction of a hydrogen from methane by a hydrogen atom, with 1·12/3; no fluorine atom occurs there. The rest agrees with the copy. |
| W16 | The table of the 11 classes with up to 5 carbons: group order 3^(n−d), orbit sizes, Σ 3^d = binom(3n, n)/(2n+1) (L4) | script | E016, all lines. |
| W17 | The largest group order at each n is 3^ν with ν the exponent of 3 in (2n+1)!, and there the orbit sizes are powers of 3 with multiplicities the base-3 digits of 2n+1 (L4) | script | E016 (n ≤ 5); EC01 E4 and F2 (n ≤ 14 and n ≤ 8). |
| W18 | "n = 4, 1: n-butyl … model orbits 3, 3, 1, 1, 1" (L4, list item 1) | **wrong** | E016 prints 3, 1, 1, 1, 1, 1, 1 for that class (the chain), as it must: one methyl and three CH2. The orbits 3, 3, 1, 1, 1 belong to isobutyl and to the two sec-butyl classes. The table of W029 is right; the sentence under it is not. |
| W19 | Isobutyl 3, 3, 1, 1, 1; the two sec-butyl classes 3, 3, 1, 1, 1 each; tert-butyl 9 (L4, items 2 to 4) | script | E016, n = 4, classes 2 to 5. Which class has which name agrees with the SMILES and names of EC01, part G. |
| W20 | The CH2 hydrogens of one stereoisomer of a sec-butyl group are diastereotopic (L4) | confirmed (by applying the sourced test) | N1 and N2 give the test; [73], p. 357, itself speaks of the diastereotopic CH2 of an ethyl or n-propyl group in the chiral heptanes (page image). |
| W21 | Cyvin, Brunvoll, Cyvin and Lüttke: "alkanoid" systems are chemical graphs embeddable in the diamond lattice that stand for the staggered conformers of alkanes; overlapping and non-overlapping systems; no mention of C3, of alkyls or of a binomial formula (L5) | confirmed | Crossref abstract of DOI 10.1515/zna-1995-0911 (a link of [52]), summarising tool. |
| W22 | No literature was found that links this chemistry to the power of 3 in the ternary tree numbers (verdict, L7) | unsupported (a negative) | Cannot be checked. Nothing that I opened contradicts it. |
| W23 | "Only report, code and output remain" (last paragraph) | **wrong** | `experiments/E016_rotor_orbits/tmp/` holds 12 downloaded files, about 1.1 MB (pages, API answers, two text copies of articles). The folder is ignored by git (`.gitignore`, line 35), so nothing was committed. |

### 3.2 The guest's chemistry note

| # | Statement (section) | Status | Evidence, place, remarks |
|---|---|---|---|
| G1 | Blair and Henze (1932) count the mono-substitution products C_nH_(2n+1)X, sorted into primary, secondary, tertiary and into stereoisomeric and non-stereoisomeric; their total is A000625 (1) | confirmed | [71], pp. 1098–1100 (page images). That the total column is A000625 is a comment in the OEIS entry [38]. |
| G2 | Robinson, Harary and Balaban: rooted trees with carbons of degree 4, the root standing for the substituent or the radical site; a tetrahedron at every carbon; two assumptions (free rotation about every C–C bond; not every arrangement is equally feasible); the root corner is fixed, so only the identity and the two rotations by 120° remain, the cyclic group of order 3 (1) | confirmed | [73], pp. 355, 356 and 358 (page images). On p. 355 they add that the radical site is taken to be pyramidal. On p. 357 they define a carbon as asymmetric when its four branches are all distinct. |
| G3 | For the free tert-butyl radical: 81 with rotations only, 162 with pyramidal inversion (1, 6) | confirmed | [11], appendix, example "tert-Butyl radical": C3v without the reflection gives 3; with rotating methyl groups 3 × 3³ = 81; with pyramidal inversion 81 × 2 = 162 (full-text XML, summarising tool). |
| G4 | Butan-2-ol is the smallest chiral alcohol (Eriksen–Merkle); Table 2 of [73] has two chiral planted trees with 4 carbons (1, 9) | confirmed | [76], p. 18, under Table 3.2.1; [73], Table 2, p. 356, row n = 4: 3 achiral, 2 chiral (page images). |
| G5 | The three rows plane trees, stereoisomers, structural isomers, n ≤ 14 (2) | script, and confirmed | EC01 A1, A2. [73], Table 2, columns "steric" and "quartic", agree with the output for n = 0 to 14 (page image). |
| G6 | A stereoisomer carries exactly 3^d plane trees; a structural isomer carries the sum over its stereoisomers; for 4 carbons 1, 9, 18, 27 against 1, 9, 9, 9, 27 (2) | script | EC01 B1 to B3. |
| G7 | "From 6 carbons on, more than half of the structural isomers carry a number of plane trees that is not a power of 3" (2) | script for n = 6, 7, 8 only | EC01 prints 9 of 17, 25 of 39, 66 of 89. Nothing was computed beyond 8 carbons; say "for 6, 7 and 8 carbons". |
| G8 | Achiral and chiral counts agree with the 1976 table; "achiral" and "no stereogenic centre" first differ at 9 carbons, by the two meso-type forms of 3,5-dimethylheptan-4-ol, the example of Eriksen–Merkle's Figure 4 (2) | script, and confirmed | EC01 A3 to A7. [73], Table 2; [76], p. 13, Figure 4, which shows three stereoisomers of that alcohol and names the pseudo-asymmetric centre (page images). |
| G9 | Blair and Henze open with the rule: α asymmetric carbons, 2^α stereoisomers, unless the asymmetric carbons are not structurally distinct or pseudo-asymmetry intervenes (3) | confirmed | [71], p. 1098, first paragraph (page image; they write 2^n). |
| G10 | Pólya: α asymmetric carbons first occur at 2α + 2 carbons, in a single structure; the count 2^α is first too large at C13H27OH, for a single structure (3) | confirmed, and script | [72], p. 436, last paragraph (page image, German). EC01 D2 to D4; the structure is the carbinol with three sec-butyl groups, 4 stereoisomers instead of 8. |
| G11 | Pólya's equations (23), (24), (25) as transcribed in the note (4) | confirmed, and script | [72], p. 436 (page image): the three equations are as the note has them. This is a second reading by an AI, not the reading by a person that the guest asks for. EC01 D1. |
| G12 | "Q(x, 0) is his q, Q(x, 1) = r, and Q(x, 2) is his upper bound for the stereoisomers" (4) | in part | The upper bound is on p. 436: the number sought is T(0) + 2T(1) + 4T(2) + … or less. The letters q and r are on pages I did not read (433–434, 441–442). |
| G13 | The team's equation at p = 3 counted by carbons, and the table of polynomials Q_n(y) and A_n(y) for n = 4 to 7 (4) | script | EC01 D5, D6 and the printed table. The Q_n(y) for n = 4, 5, 6 are also printed in [76], p. 17. |
| G14 | "Pólya's equation is of the same kind as the deformed equation", lineage Pólya, Etherington, ours (0, 4) | unsupported (a judgment) | Both equations are confirmed (G11, G13). That they are "of the same kind" is the guest's comparison; a person should make it before the paper credits it. |
| G15 | In the IUPAC glossary an asymmetric carbon atom is van 't Hoff's name for a carbon attached to four different entities (5) | confirmed | [74], web version, section A (summarising tool). The glossary adds that "asymmetric" used for "chiral" is loose usage. |
| G16 | Homotopic: related by an n-fold rotation axis; example, the three chlorines of chloroform (5) | confirmed | [74], section F to M (summarising tool). The other two examples there are tartaric acid and a cyclodextrin: all rigid molecules, no methyl group, no internal rotation. |
| G17 | Prochirality centre; examples C-1 of ethanol and C-3 of butan-2-ol (5) | confirmed | [74], section N to Q (summarising tool). The entry "prochirality" has four senses; the one used is the third (a tetrahedral atom with two stereoheterotopic groups). |
| G18 | A carbon with three different branches is a "chirality centre (stereogenic centre; includes pseudo-asymmetric carbons)"; hence d = chirality centres + prochirality centres (5) | not in source | The glossary's entry for chirality centre does not mention pseudo-asymmetric atoms, and [76], p. 16, says that pseudo-asymmetric centres are stereogenic centres "but not strictly chirality centres" (Eriksen and Merkle). The correct sentence is **d = stereogenic centres + prochirality centres**. The difference begins at 9 carbons, so it does not touch the butyl slide; but the phrase "a chirality centre or a prochirality centre" has been carried into section 3.3 of the ranked note. The stereogenic half is checked (EC01 C1 against Table 3.2.2 of [76]; rows n = 4 to 7 compared by me). The prochirality half is a definition that a chemist should confirm. |
| G19 | With 6 carbons: d = 1, …, 5 in 2, 2, 13, 10, 1 cases; 0, 1, 2 stereogenic centres in 8, 16, 4 cases (5) | script | EC01, part C; the second triple is also the row z⁶ of Table 3.2.2 of [76] (page image). |
| G20 | Gilson and Irikura: the symmetry number is the order of the group of permutations of identical atoms that the allowed motions realise; it lowers the entropy by R ln σ (6) | confirmed | [11], main text and conclusions (summarising tool). |
| G21 | Their appendix prints generating permutations of the nine hydrogens of the tert-butyl radical (6) | confirmed | [11], appendix: [7,8,9,1,2,3,4,5,6] the threefold rotation of the molecule, [3,1,2,4,5,6,7,8,9] the methyl torsion, [1,2,3,7,8,9,4,5,6] the inversion with rotation and torsion. `run.py`, lines 428 to 430, has the same three. |
| G22 | These generate groups of order 81 and 162; the group of order 81 is, permutation for permutation, the rotation group of the tert-butyl tree; 81 is the largest power of 3 dividing 9! (6) | script | EC01 F3, F4. |
| G23 | In the tree model the rotations that keep a class form a group of order 3^(n−d), and the largest order with n carbons is 3^(n−t), the largest power of 3 dividing (2n+1)! (6) | script | EC01 F1 (n ≤ 8), E4 (n ≤ 14). |
| G24 | Read as chemistry: 3^(n−d) is the symmetry number of the alcohol or of R–X; the overall rotation is included, so the earlier caution can be dropped (6) | unsupported | No opened source gives a symmetry number for any alcohol or any R–X other than CH3Cl (σ = 3 in [11]); [11] does not mention alcohols. The statement is what the procedure of [39] gives if OH or X counts as a partner without symmetry (methyl 3; a symmetric group is spun into a pseudo-atom; repeat), and it agrees with 2-methylpropane, 81, in [39], p. 1656. It is the team's extension of a rule for hydrocarbons, and [11] warns that coupled rotors do not multiply (acetone with geared methyl groups: 6, not 18). |
| G25 | Table of the most symmetric alcohols for n = 1 to 9 and 13, with 3^(n−t) (6) | script (numbers) | EC01, part E. The names are the guest's, by hand. I compared each with the SMILES that the script prints for that row: all agree. The "symmetry numbers" are values of the model (G24), not values from a table. |
| G26 | Tri-tert-butylcarbinol exists; first made by Bartlett and Schneider in 1945 (6) | confirmed | N11: the Wikipedia article on the compound (summarising tool) and the Crossref record. The paper was not opened. Neither says anything about 27 equivalent hydrogens; N8 (W6) shows that rotation in this alcohol is hindered. |
| G27 | The number of ternary trees with 13 nodes, 300,830,572, is prime to 3 (6) | script | EC01, part A, n = 13; also [70]. |
| G28 | The hydrogens fall into at least s_3(2n+1) classes, with equality and digit-given sizes for the most symmetric alcohols; 3-ethylpentan-3-ol also has three classes (6) | script | EC01 F2 (n ≤ 8). Calling the classes "homotopic" is right by the substitution test (N1, N2); it is not literally the glossary's definition (G16), which has no internal rotation in it. |
| G29 | Carnelley's rule (1882): among isomers the more symmetrical melt higher; "usually explained through the entropy of melting and the symmetry number" (7) | in part | N13, abstract (PubMed, summarising tool): the rule, attributed to Carnelley 1882 and quoted there from N12, and its explanation by the entropy of melting. The words "symmetry number" are not in the abstract. N12 is a record only. |
| G30 | The seven melting points (7) | confirmed | N10, heading "Melting Point", values of the Hazardous Substances Data Bank: tert-butanol 25.81 °C, isobutanol −108, butan-2-ol −114, butan-1-ol −88.6, neopentyl alcohol 53, 2-methylbutan-2-ol −9.1, pentan-1-ol −79. Other databases in the same records differ by up to a few degrees. |
| G31 | "The most symmetric pentanol melts 60 degrees above the next" (7) | unsupported | Three of the eight pentanols were looked up. |
| G32 | Domalski and Hearing give 81 for 2-methylpropane and 27 × 3 × 2 for tert-butylbenzene (12, addendum; the guest had not opened it) | confirmed | [39], Appendix D, p. 1656 (2-methylpropane: 27 × 3 = 81, external 1) and p. 1657 (t-butylbenzene: 27 × 2 × 3 = 162); also ethane 3 × 3 = 9 and total 18, a total that the paper says holds for all n-alkanes, p. 1655 (page images). |

### 3.3 The guest's polymer note

| # | Statement (section) | Status | Evidence, place, remarks |
|---|---|---|---|
| P1 | Flory (1952) treated monomers with one A and f − 1 groups B and derived the size distribution; "Galina 2003 says so in its introduction; only acyclic molecules are considered" (2) | in part | The title of N14 names A–R–B_(f−1) units and a size distribution (Crossref record; paper not opened by anyone). [75], p. 610: Flory, in the 1952 paper and in his book, derived the size distribution for an **AB2** monomer; p. 611: the restriction to acyclic molecules is stated for Galina's own model, not reported of Flory's (text layer of the PDF on the journal's site). |
| P2 | Hyperbranched polymers are made in one pot, dendrimers in many steps (a 2012 review, not opened by the guest) (2) | not opened | N17: the Crossref record has no abstract and the publisher's page answers with a cookie redirect. |
| P3 | A ring-free molecule of n monomers has one free A and (f − 2)n + 1 free B; the dictionary unit–node, focal point–root, free B–leaf (2) | script | EC02 A1. |
| P4 | n labelled monomers with labelled B groups form one ring-free molecule in n! × FussCatalan(f − 1, n) ways (3) | script; **one number wrong** | EC02 A1 (f = 3, n ≤ 6; f = 4, 5, n ≤ 5; f = 6, n ≤ 4). In "For AB2: 2, 30, 336, 5040, 95040 = n! × 2, 5, 14, 42, 132" the first number should be 4 = 2! × 2. |
| P5a | A hyperbranched polymer of triallylsilane exists (2) | confirmed | N16, Crossref abstract: hyperbranched polycarbosilanes by hydrosilylation of triallylsilane (summarising tool). |
| P5b | Its three B groups sit on a tetrahedral atom and "can be rotated and not reflected", so its isomers are our classes for p = 3 (2) | unsupported | The guest's reading; the abstract does not say it. It is the same geometry as G2, on silicon. |
| P6 | Fraction of molecules with n units = FussCatalan(f − 1, n) α^(n−1) (1 − α)^((f−2)n+1); these add up to 1 for α ≤ 1/(f − 1) (3) | script | EC02 D1; the simulation C1 (10^6 monomers, one seed; sizes 72477, 34368, 20678, 13774 against 72000, 34560, 20736, 13934.6). That this is Flory's formula is not established: see P20. |
| P7 | Aldous: branching-process models of polymerization go back to Flory; Ziff gives a clear account (3) | confirmed | N18, preprint dated 10 July 1997, p. 24, the remark at the end of section 3.1 (page image). |
| P8 | The lemma: after j bonds the number of possible next bonds is (N − j − 1)((f − 1)N − j), so all ring-free bond patterns with j bonds are equally likely (4) | script (two cases); proof read | EC02 B1, B2 for (f, N) = (3, 5) and (4, 4). I read the proof and found no gap: the count of next bonds is right, and every order of the bonds of a forest is a possible history. I am the same model as its author, so this is not the review by a different model that the grade `ai-reviewed` asks for. |
| P9 | An isomer T with n units occurs with frequency p^d(T)/FussCatalan(p, n): 16 : 8 : 8 : 4 : 4 : 2 of 42 for AB2 and five units; 27 : 9 : 9 : 9 : 1 of 55 for AB3 and four units (0, 4) | script (exact in the model) | EC02 B3 prints 8/21, 4/21, 4/21, 2/21, 2/21, 1/21 and 27/55, 9/55, 9/55, 9/55, 1/55. No printed source states it (the guest says so). For AB3 it needs P5b, and it holds for an ideal reaction: equal reactivity, no rings. |
| P10 | The numbers of the simulation: 4157 of 20,678 trimers, 8 of 5835 heptamers (4) | script | EC02 C2, same seed, same numbers. |
| P11 | For AB2: every weight is a power of 2; no isomer is rarer than 2^t in Catalan(n); a perfect dendron exists only for n = 1, 3, 7, 15, 31, …, with odds 1 in 5, 429, 9,694,845, 14,544,636,039,226,909 (5) | script | EC02 F1, F2. For p = 2 this is prior work ([2], [4], [36]); the note says so. |
| P12 | The degree of branching is 0 for a linear chain and 1 for a perfect dendrimer; in a random polymerization of AB2 it grows linearly with the conversion and reaches 1/2 (5) | confirmed | [75], pp. 612–613 (text layer). In that text layer the definition reads: twice the number of dendritic units over the total number of units. The form in the note, 2D/(2D + L), is that of N15, whose paper was not opened; the two agree for large molecules. |
| P13 | In the model the degree of branching equals α (0.4008 against 0.4000), and its average over all trees with n units tends to 1/2 (5) | script | EC02 C3, E1. |
| P14 | For AB3 the model gives 4/9 = 0.44, "the value quoted", close to 0.48 ± 0.05 measured on the triallylsilane polymer (5) | confirmed | N15, abstract: at most 0.5 for AB2 and 0.44 for AB3. N16, abstract: 0.48 ± 0.05 by a modified definition, theory 0.44. The formula in EC02 E2 was written from memory (the guest says so). |
| P15 | "Among the 7-unit molecules with DB = 1 there are five plane trees and one of them is perfect" (5) | unsupported (true) | No check in EC02. It is the count of binary trees with three branching units, 5, of which one is complete. |
| P16 | For monomers with f equal groups the gel point is α = 1/(f − 1) (6) | confirmed | N20 (Wikipedia; summarising tool): α_c = 1/(f − 1), under equal reactivity and no intramolecular reaction. |
| P17 | α(1 − α)^(f−2) is largest at α = 1/(f − 1), where it equals the radius of convergence of the Fuss–Catalan series (6) | script | EC02 D2 (f = 3 to 8). |
| P18 | For AB_(f−1) monomers α cannot exceed 1/(f − 1), "which is why hyperbranched polymers do not gel" (6) | in part | [75], p. 611: in Flory's definition the conversion runs from 0 to 1/f, f being Galina's number of B groups; p. 610: these monomers give highly branched material that is not cross-linked. The "which is why" is the guest's. |
| P19 | Measured 3-adically the series has radius of convergence 1 (6) | unsupported (true) | No script. It follows from the theorem: the coefficients are integers and are prime to 3 for n = (3^k − 1)/2 ([70]). The note marks it as an analogy. |
| P20 | "The count is Flory's"; slide line "the number of trees is what Flory counted in 1952 for these polymers" (7) | unsupported | Nobody has opened N14 or Flory's book. What is established is only that Flory derived a size distribution (P1). The guest asks the same thing as an open question (section 8, question 2). |
| P21 | "Real AB2 polymers often miss DB = 0.5" (7, risks; from a summary of a review) | not opened | N17, as P2. |
| P22 | Stockmayer's factor = FussCatalan(f − 1, n)/((f − 2)n + 2) (1, and EC02) | script | EC02 D3; the formula itself is in [19]. |

### 3.4 Counts

| Status | W029 | chemistry note | polymer note | all |
|---|---|---|---|---|
| script | 5 | 11 | 10 | 26 |
| confirmed | 11 | 15 | 5 | 31 |
| in part | 0 | 2 | 2 | 4 |
| not in source | 1 | 1 | 0 | 2 |
| not opened | 2 | 0 | 2 | 4 |
| unsupported | 2 | 3 | 4 | 9 |
| wrong | 2 | 0 | 0 | 2 |
| all | 23 | 32 | 23 | 78 |

Rows with two statuses (G5, G8, G10, G11) are counted once, under the first. Wrong details inside rows of another status: W3 (book and link), W6, W12, W13 (names), W15 (reagent), P4 (one number).

`CLAIMS_PROPOSED.md`, rows 1 to 13, agree with the rerun outputs. `PROPOSALS.md`: entry 1 is already in section 3.3; entry 4 (credit to Pólya) now has a second reading of p. 436 that agrees with the first, and still needs a person; the caution in entry 6 about the ratio 27 : 9 : 9 : 9 : 1 is the same as mine.

## 4. Sources opened, with the place

Page images (read by me):

- [73] Robinson, Harary, Balaban: scan at `https://oeis.org/A000625/a000625.pdf`, pp. 355–358, Table 2 on p. 356, the cyclic group on p. 358.
- [72] Pólya: scan at `https://oeis.org/A000598/a000598_3.pdf`, pp. 435–438; equations (23) to (25) and the two remarks on p. 436.
- [71] Blair and Henze: scan at `https://oeis.org/A000620/a000620.pdf`, pp. 1098–1100.
- [76] Eriksen and Merkle: `https://arxiv.org/pdf/2609.02932v1`, pp. 10–20 (Figures 3 to 5, Tables 3.2.1 to 3.2.3; butan-2-ol as the smallest chiral alcohol on p. 18; cyclic permutations on p. 12; pseudo-asymmetric centres on pp. 13 and 16). The abstract page gives version 1, 28 August 2026, a comment that it was submitted to J. Math. Chem., and the licence CC BY 4.0.
- [39] Domalski and Hearing: `https://srd.nist.gov/jpcrdreprint/1.555814.pdf`, pp. 1654–1657 (Appendix D).
- N4 Sztraka: pp. 93–97.
- N18 Aldous, preprint: pp. 1–4 and 20–24.

Through the summarising tool, or as records:

- [11] Gilson and Irikura: `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=3079527` (both halves of the XML): definition, entropy, appendix example "tert-Butyl radical", acetone, CH3Cl.
- [74] IUPAC glossary: `https://iupac.qmul.ac.uk/stereo/`, sections `A.html`, `BC.html`, `DE.html`, `FM.html`, `NQ.html`: asymmetric carbon atom, chirality centre, enantiotopic, diastereotopic, homotopic, prochirality, prochirality centre, pseudo-asymmetric carbon atom, pro-R and pro-S. Enantiotopic is defined there by symmetry elements of the second kind only: this is the wording that W029 could not retrieve (its lead 1).
- [75] Galina: `https://ichp.vot.pl/index.php/p/article/view/1904` and its PDF (`…/article/download/1904/2100`), text layer of pp. 610–613. The DOI itself redirects to a host whose certificate does not match.
- [38] OEIS A000625 and [52] OEIS A121179 (JSON): names, comments, formulas, links. A121179 carries the comment of 2019 that binom(3n, n)/(2n+1) counts the positions in space of the conformers of an alkyl relative to another alkyl without C3 symmetry.
- N1, N2, N3 (LibreTexts pages); N5 (Europe PMC XML); N6, N8, N11 to N17, N19 (Crossref records, three with abstracts); N7 and N8 (OpenAlex records with abstracts); N10 (PubChem); N13 (PubMed abstract); N11 and N20 (Wikipedia); the Crossref record of the Cyvin paper of W21.

## 5. Sources not opened

Tried and failed:

- [12] Fernández-Ramos et al. at `link.springer.com` (PDF and article page): cookie redirect, no content. Compared only with the worker's text copy (W14, W15).
- N17 Higashihara et al. at `www.nature.com`: the same cookie redirect.

Dead links replaced by a working one: the LibreTexts address of W029 for Roberts (404; found as N3); Europe PMC for [11] (HTTP 500; read through the NCBI interface); the DOI of [75] (certificate mismatch; read on the journal's own site); two guessed Wikipedia titles for tri-tert-butylcarbinol (404; found under its systematic name).

Not attempted, and so not confirmed by this review: Flory's paper N14 and his book; the full texts of N6, N7, N8, N12, N13, N15, N16 and of Bartlett and Schneider; Carnelley's paper of 1882; Hawker–Fréchet, Ziff and Pitman (records only); the papers of Cyvin and co-authors behind [52]; Longuet-Higgins; Pollak and Pechukas; Pólya's pages 433–434 and 441–442; Blair and Henze after p. 1100; Sztraka's Tables I and II; the OEIS entries A000598, A000620, A000621, A005628 (EC01 A5 and A6 rest on the last three as typed by the guest); [40] and [53] of section 3.3, which belong to the team's text and not to the three documents.

## 6. References to add

For the orchestrator to check and enter; none of these is in `references/README.md`. Fields are as the page or the record returned them today.

- **N1.** Tim Soderberg, *Organic Chemistry with a Biological Emphasis*, section 3.12 "Prochirality", Chemistry LibreTexts. `https://chem.libretexts.org/Bookshelves/Organic_Chemistry/Book%3A_Organic_Chemistry_with_a_Biological_Emphasis_v2.0_(Soderberg)/03%3A_Conformations_and_Stereochemistry/3.12%3A_Prochirality`
- **N2.** Steven Farmer, Dietmar Kennepohl, Lauren Reutenauer, "5.4: Types of Protons", in *Introduction to Organic Spectroscopy*, Chemistry LibreTexts. `https://chem.libretexts.org/Bookshelves/Organic_Chemistry/Introduction_to_Organic_Spectroscopy/05%3A_Proton_Nuclear_Magnetic_Resonance_Spectroscopy_(NMR)/5.04%3A_Types_of_Protons`
- **N3.** John D. Roberts, *Nuclear Magnetic Resonance: Applications to Organic Chemistry*, section 3.9 "Spin-Spin Splitting and Molecular Asymmetry", Chemistry LibreTexts (the year of the book is not on the page). `https://chem.libretexts.org/Bookshelves/Organic_Chemistry/Nuclear_Magnetic_Resonance%3A_Applications_to_Organic_Chemistry_(Roberts)/03%3A_Spin-Spin_Splitting/3.09%3A_Spin-Spin_Splitting_and_Molecular_Asymmetry`
- **N4.** L. Sztraka, "Determination of the nuclear spin statistical weights for the rotation-internal rotation-inversion levels of methylamine", Periodica Polytechnica, Chemical Engineering 31 (1–2), from p. 93; received 15 April 1986 (the year of the issue is not printed on the pages read; the file name has 1987). `https://pp.bme.hu/ch/article/download/2806/1911`
- **N5.** M. Šimėnas, D. Klose, M. Ptak, K. Aidas, M. Mączka, J. Banys, A. Pöppl, G. Jeschke, "Magnetic excitation and readout of methyl group tunnel coherence", Science Advances 6 (18) (2020), eaba1517. DOI 10.1126/sciadv.aba1517. `https://www.ebi.ac.uk/europepmc/webservices/rest/PMC7195165/fullTextXML`
- **N6.** Thomas Grohmann, Monika Leibscher, "Quantum-dynamical consequences of the permutation symmetry of methyl groups", The Journal of Chemical Physics 132 (23) (2010), 234301. DOI 10.1063/1.3425880. `https://api.crossref.org/works/10.1063/1.3425880`
- **N7.** Blair A. Welsh, Judit Zádor, Sven Herbers, Edwin L. Sibert, Timothy S. Zwier, "Methyl Rotor State-Dependent Quenching of OH Tunneling in 2,6-Dimethylphenol", The Journal of Physical Chemistry Letters 17 (13) (2026), 3749–3758. DOI 10.1021/acs.jpclett.6c00128. `https://api.openalex.org/works/https://doi.org/10.1021/acs.jpclett.6c00128`
- **N8.** Patrick J. Barrie, J. Edgar Anderson, "A dynamic NMR study of sterically hindered trialkylmethanols in the solid phase", Journal of the Chemical Society, Perkin Transactions 2, 1992, issue 11, p. 2031 (neither record gives a volume or a last page). DOI 10.1039/p29920002031. `https://api.crossref.org/works/10.1039/p29920002031`
- **N10.** PubChem, compound records 6386 (tert-butanol), 6560 (isobutanol), 6568 ((±)-2-butanol), 263 (1-butanol), 6404 (neopentyl alcohol), 6405 (2-methyl-2-butanol), 6276 (1-pentanol), headings "Melting Point" and, for 6386, "1H NMR Spectra". `https://pubchem.ncbi.nlm.nih.gov/rest/pug_view/data/compound/6386/JSON?heading=Melting+Point` and likewise.
- **N11.** Paul D. Bartlett, Abraham Schneider, "The Synthesis of Tri-t-butylcarbinol and Other Highly Branched Alcohols by Means of Sodium", Journal of the American Chemical Society 67 (1) (1945), 141–144. DOI 10.1021/ja01217a049. `https://api.crossref.org/works/10.1021/ja01217a049`. That it is the first preparation: Wikipedia, `https://en.wikipedia.org/wiki/2,2,4,4-Tetramethyl-3-t-butyl-pentane-3-ol`.
- **N12.** R. J. C. Brown, R. F. C. Brown, "Melting Point and Molecular Symmetry", Journal of Chemical Education 77 (6) (2000), 724. DOI 10.1021/ed077p724. `https://api.crossref.org/works/10.1021/ed077p724`
- **N13.** Samuel H. Yalkowsky, "Carnelley's Rule and the Prediction of Melting Point", Journal of Pharmaceutical Sciences 103 (9) (2014), 2629–2634. DOI 10.1002/jps.24034. Abstract: `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=24899585&rettype=abstract&retmode=text`
- **N14.** Paul J. Flory, "Molecular Size Distribution in Three Dimensional Polymers. VI. Branched Polymers Containing A—R—B_(f−1) Type Units", Journal of the American Chemical Society 74 (11) (1952), 2718–2723. DOI 10.1021/ja01131a008. `https://api.crossref.org/works/10.1021/ja01131a008`. **Not opened by anyone.**
- **N15.** D. Hölter, A. Burgath, H. Frey, "Degree of branching in hyperbranched polymers", Acta Polymerica 48 (1–2) (1997), 30–35. DOI 10.1002/actp.1997.010480105. `https://api.crossref.org/works/10.1002/actp.1997.010480105`
- **N16.** Christian Lach, Philipp Müller, Holger Frey, Rolf Mülhaupt, "Hyperbranched polycarbosilane macromonomers bearing oxazoline functionalities", Macromolecular Rapid Communications 18 (3) (1997), 253–260. DOI 10.1002/marc.1997.030180306. `https://api.crossref.org/works/10.1002/marc.1997.030180306`
- **N17.** Tomoya Higashihara, Yukari Segawa, Warapon Sinananwanich, Mitsuru Ueda, "Synthesis of hyperbranched polymers with controlled degree of branching", Polymer Journal 44 (1), 14–29 (Crossref: online 19 October 2011, issue of January 2012). DOI 10.1038/pj.2011.99. `https://api.crossref.org/works/10.1038/pj.2011.99`. **Record only.**
- **N18.** David J. Aldous, "Deterministic and Stochastic Models for Coalescence (Aggregation and Coagulation): A Review of the Mean-Field Theory for Probabilists", Bernoulli 5 (1) (1999), from p. 3. DOI 10.2307/3318611. Preprint of 10 July 1997: `https://www.stat.berkeley.edu/~aldous/Papers/me78.pdf`
- **N19.** Records only (Crossref): Craig J. Hawker, Jean M. J. Fréchet, Journal of the American Chemical Society 112 (21) (1990), 7638–7647, DOI 10.1021/ja00177a027; Robert M. Ziff, "Kinetics of polymerization", Journal of Statistical Physics 23 (2) (1980), 241–263, DOI 10.1007/bf01012594; Jim Pitman, "Coalescent Random Forests", Journal of Combinatorial Theory, Series A 85 (2) (1999), 165–193, DOI 10.1006/jcta.1998.2919.
- **N20.** Wikipedia, "Flory–Stockmayer theory". `https://en.wikipedia.org/wiki/Flory%E2%80%93Stockmayer_theory`

Additions to existing entries, if the orchestrator agrees: the three scan addresses of section 4 to [71], [72], [73]; to [73] also p. 355 (radical site taken as pyramidal) and p. 357 (asymmetric = four distinct branches; diastereotopic CH2 groups); to [74] the section pages; to [75] the journal's page and that its introduction says AB2; to [76] p. 12 (rotation classes as the cycle construction), p. 13 (Figure 4), p. 16 (pseudo-asymmetric centres are stereogenic, not chirality centres), p. 18; to [12] that the reaction of its equation (6) is H + CH4 (from the worker's copy; the source itself still has to be opened); to [11] the appendix example and the three permutations.

## 7. The question: reorganize section 3.3 around homotopic groups and symmetry numbers?

**No. Keep the present wording as the spine, with three small repairs, and give the chemists' two notions one supporting sentence each.**

Reasons.

1. **The present wording names the quantity of the theorem; the other names its complement.** The theorem is about the number of ordered trees in a class, 3^d: one factor 3 for every carbon whose three branches are not all alike, because such a carbon can be turned into three different positions. Homotopic groups and symmetry numbers describe the turns that change nothing, 3^(n−d). A paragraph built on them reaches 55 = 1 + 9 + 9 + 9 + 27 only through 3^n divided by a symmetry number, and that is one step more than a listener can take in a talk.

2. **Every printed symmetry number belongs to a whole molecule or to a radical.** Opened today: 81 for the tert-butyl radical with rotating methyl groups ([11]), 81 for 2-methylpropane, 9 internal and 18 in all for ethane, 18 in all for every n-alkane, 162 for tert-butylbenzene ([39]). Of the five numbers 81, 9, 9, 9, 3 of the butyl slide only 81 is printed. A paragraph organised around symmetry numbers puts the objection of section 3.3 ("your numbers are not in the tables") at the centre instead of at the edge. No source gives a symmetry number for an alcohol (G24). And the rule "multiply the rotors" fails for coupled rotors ([11], acetone), while the most symmetric large groups are exactly the crowded ones (W6: rotation in tri-tert-butylmethanol is hindered enough to be measured).

3. **"Homotopic" has two definitions, and ours is the weaker one.** The IUPAC glossary defines it by a rotation axis of the molecule, with rigid examples (G16). The nine hydrogens of a tert-butyl group on a partner without symmetry are related by no axis of the molecule; they are homotopic by the substitution test of the textbooks (W1, W2) and by internal rotation. A chemist can accept that, but it has to be argued, and the next question is about NMR, where the dictionary does not hold as a count: the two hydrogens of a CH2 are two orbits and one signal in an achiral solvent (W2), and whether rotation is fast is a matter of temperature and barriers (W6, W10). W029 itself says that orbits are not a statement about the number of lines.

4. **The present wording rests on the best-sourced sentence in the whole chemistry.** "Rotated, not reflected, a cyclic group of order 3 at every carbon" is printed in [73], p. 358, and again, as counting up to cyclic permutations, in [76], p. 12; the count 1, 1, 2, 5, 11 is printed in [73], Table 2; "butan-2-ol, the smallest chiral alcohol" in [76], p. 18. A physical source says the same of a methyl group: in methylamine the cyclic permutations of the three hydrogens are feasible, and an exchange of two is feasible only together with the inversion of the whole molecule (N4, pp. 94–95).

The three repairs to the present wording:

- **"Chirality centre" becomes "stereogenic centre"** (G18): "such a carbon is a stereogenic centre or a prochirality centre". In the talk the parenthesis can simply be left out.
- **The partner must be said.** "Three distinguishable positions" is true of a group on a partner without symmetry of its own: on a chlorine atom the turn at the root is a rotation of the whole molecule and shows nothing. Section 3.3 has this in statement 3 and in the OEIS comment; the sentence for the talk should have it too ("on a partner without symmetry", or "in an alcohol").
- **"The two hydrogens of a CH2 … are called enantiotopic"** should read "enantiotopic, or diastereotopic when the molecule is chiral" (W20).

One weakness remains in the present wording and cannot be repaired today: that binom(3n, n)/(2n+1) is a count of conformations in the chemical literature rests on a comment in the OEIS ([52]); the abstract of the one paper that was opened does not contain it (W21), and real molecules do not realise all of them. So the slide should present the 55 as the team's count of positions and should not say that chemists count 55 conformations.

## 8. Slide sentences

**Three sentences I would put on a slide.**

1. "A carbon atom in a chain carries three further groups; they can be turned by a third of a turn and not mirrored. Counted this way, the alcohols C_nH_(2n+1)OH number 1, 1, 2, 5, 11, 28, …: the ternary trees up to rotation."
   Source: [73], p. 358 (the cyclic group of order 3) and Table 2 on p. 356 (the numbers); [72], p. 436 (the same numbers as the stereoisomeric alcohols, equation (25)); [76], pp. 12–13; [38]. Script: EC01 A1 (n ≤ 14), E016.
2. "With four carbons there are five: tert-butanol, isobutanol, butan-1-ol and the two mirror forms of butan-2-ol, the smallest chiral alcohol. They carry 1, 9, 27, 9 and 9 ordered trees: 55 = 1 + 9 + 9 + 9 + 27."
   Source: [76], p. 18 and Figure 5 on p. 14; [73], Table 2 (3 achiral and 2 chiral). Script: EC01 B2 and part G; E016.
3. "tert-Butyl stands alone because turning any of its four carbons changes nothing: 3^4 = 81 turns. Chemists know this 81 as the symmetry number of the tert-butyl radical with freely rotating methyl groups, and it is the largest power of 3 dividing 9!."
   Source: [11], appendix, "tert-Butyl radical" (3 × 3³ = 81); [39], p. 1656 (2-methylpropane, 27 × 3 = 81). Script: EC01 F3, F4.

A fourth, for the moment the group is chosen in the proof: "Up to all permutations of the branches these are four structures with 1, 9, 18 and 27 trees; 18 is not a power of 3 because butan-2-ol has two mirror forms." Script: EC01 B3; the mirror forms as in sentence 2.

**Sentences I would not say.**

- "Asymmetric carbon" for a carbon with branches not all alike (chemists mean four different groups: [74]; [73], p. 357). Say "lopsided" or "not a threefold rotor".
- "A chirality centre or a prochirality centre" (G18). If the words are needed: "stereogenic centre or prochirality centre".
- "The symmetry numbers 9 and 3 are in the tables", or any symmetry number for the n-butyl, isobutyl or sec-butyl group as a literature value. The tables have 18 for n-butane and 9 internal for ethane ([39], p. 1655).
- "The symmetry number of tert-butanol (or of any alcohol) is …" as a fact of chemistry (G24). Say "in the model".
- "Butyl radicals". A free radical inverts, the group doubles to 162 ([11]), and the two forms of sec-butyl are real only for R–X. Say "butyl alcohols" or "butyl groups on a partner".
- "The nine hydrogens of tert-butyl give one NMR line because of our group", "27 equivalent hydrogens in tri-tert-butylcarbinol", or "orbits are NMR signals" (W5, W6, W9; no source found by W029 or by me).
- "Tri-tert-butylcarbinol has symmetry number 3^13" as a physical statement (hindered rotation, W6; coupled rotors, [11]).
- "Chemists count 55 conformations" (an OEIS comment only, section 7).
- "One pot of an AB3 monomer gives the five butyl shapes in the ratio 27 : 9 : 9 : 9 : 1" as chemistry. It is exact in an ideal model that is ours (P9), it has no printed source, and nobody has measured the isomers of a four-unit molecule. If it is said at all: "in the ideal model", and never of the butyl alcohols.
- "The number of trees is what Flory counted in 1952" (P20).
- "Symmetric isomers melt higher" as support, and "the most symmetric pentanol melts 60 degrees above the next" (G29, G31).
- W029's sentence about the n-butyl orbits (W18) and any author name or link taken from W029 without checking (W3, W6, W12, W13).

## 9. For the orchestrator

- Two downloaded copies of articles under publisher copyright lie in `experiments/E016_rotor_orbits/tmp/` (W23). They are ignored by git; whether to delete them is yours to decide. I changed nothing there.
- The answers of the OpenAlex interface carry a notice addressed to automated clients that invites them to send their user's e-mail address in order to get a key. I did not act on it. A worker with `curl` should be told the same.
- No request of mine to an outside service contained a name or an address of a team member. The PDF files that the fetch tool kept are in the session's own folder, not in the repository.
