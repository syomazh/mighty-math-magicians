Written by Moonshot AI Kimi K3.1 Pro (Open Math OS), 2026-11-14; not human-reviewed.

# Physical search: threefold rotors against the tree model

## Verdict in five lines

1. **Exact, sourced local match:** a complete open paper on methylamine displays cyclic methyl-proton permutations as feasible and the corresponding starred operations in its permutation-inversion group; open full texts also give methyl three-state tunnelling and A/E levels.
2. **Exact, sourced stereochemical test:** replacement by deuterium identifies ethanol's methyl protons as homotopic and its two CH2 protons as enantiotopic, whereas the latter are two separate orbits in the rooted rotor model.
3. **The rotational symmetry-number and reaction-path ratios are genuine powers or ratios of symmetry numbers**, but they concern whole-molecule rotations as well as internal ones and therefore do not identify the tree group with all chemical equivalences.
4. **Confirmed but only abstract-level chemistry:** diamond-lattice alkanoids represent staggered conformers, and solid tri-tert-butylmethanol has hindered dynamic-NMR behaviour; neither the textually requested 9H/27H singlet nor the general proper-rotation homotopicity theorem was retrieved.
5. **No verified literature was found connecting this chemistry to the power of three dividing the Fuss–Catalan number.** The enumeration and leaf-orbit computation passed, but it is a finite combinatorial check, not an experimental chemical test.

Terminology below: **source text** means something stated in a source actually opened during W029. **Model deduction** means my mathematical or chemical interpretation, not a quotation or a result established by the cited source. All searches were made on 2026-11-14 with curl against public interfaces. Links are to the actual opened pages or records; DOIs give the scholarly records.

## L1. NMR equivalence, substitution, homotopicity, and the hindered 27-H group

### What was read

- **Tim Soderberg, §3.12, “Prochirality,” full HTML section**, [LibreTexts, Organic Chemistry with a Biological Emphasis](https://chem.libretexts.org/Bookshelves/Organic_Chemistry/Book%3A_Organic_Chemistry_with_a_Biological_Emphasis_v2.0_(Soderberg)/03%3A_Conformations_and_Stereochemistry/3.12%3A_Prochirality). Replacing either of ethanol's prochiral CH2 hydrogens by D produces opposite R/S configurations and enantiomeric products; those hydrogens are **enantiotopic**. In an already chiral glyceraldehyde-3-phosphate the analogous products are diastereomers, and the hydrogens **diastereotopic**. The three methyl hydrogens of ethanol (and of any methyl group) are **homotopic**. The IUPAC Gold Book proper/improper-operation definition was **not** obtained, so the requested symmetry-operation version of the classification remains unsourced here.
- **Steven Farmer, Dietmar Kennepohl and Lauren Reutenauer, §5.4, “Types of Protons,” full HTML section**, [LibreTexts, Introduction to Organic Spectroscopy](https://chem.libretexts.org/Bookshelves/Organic_Chemistry/Introduction_to_Organic_Spectroscopy/05%3A_Proton_Nuclear_Magnetic_Resonance_Spectroscopy_(NMR)/5.04%3A_Types_of_Protons). Its substitution test gives homotopic protons for identical products. Enantiotopic protons have the same chemical shift in normally used achiral solvents. Diastereotopic protons in its 2-bromo-2-chlorobutane example give two different CH2 absorptions. Rapid cyclohexane chair inversion, much faster than NMR except at extremely low temperature, averages axial and equatorial hydrogens.
- **John D. Roberts, §3.9, “Spin-Spin Splitting and Molecular Asymmetry,” full HTML section**, [LibreTexts, Basic Principles of Organic Chemistry](https://chem.libretexts.org/Bookshelves/Organic_Chemistry/Basic_Principles_of_Organic_Chemistry_(Roberts_and_Caserio)/03%3A_Organic_Conformations_and_Configurations/3.09%3A_Spin-Spin_Splitting_and_Molecular_Asymmetry). It discusses C–C rotation, unequal residence times in staggered conformers, and average methylene NMR environments. It cautions against treating a simple propeller diagram as fully describing molecular asymmetry. It does **not** prove that any particular alkyl hydrogen set is exchanged by a free C3 rotation.
- **PubChem's tert-butanol spectral record, record plus supplied raster spectrum inspected** ([record](https://pubchem.ncbi.nlm.nih.gov/rest/pug_view/data/compound/6386/JSON?heading=1H+NMR+Spectra), [SpectraBase thumbnail](https://pubchem.ncbi.nlm.nih.gov/image/imgsrv.fcgi?spectrabaseid=JawuYK1yBhH)); spectrum labelled “tert-BUTYL ALCOHOL”, Bruker AC-300, with separate hydroxyl and methyl-region peaks. This is an open database example of tert-butyl methyl protons giving a methyl-region peak, **not** a retrieved statement literally saying “9H singlet”; integration and multiplicity were not verified.
- **A. J. Barrie and M. R. Anderson, “A dynamic NMR study of sterically hindered trialkylmethanols in the solid phase,” abstract only**, doi [10.1039/p29920002031](https://doi.org/10.1039/p29920002031); [OpenAlex abstract actually read](https://api.openalex.org/works/https://doi.org/10.1039/p29920002031). It reports temperature-dependent solid-state 13C CP/MAS NMR for tri-tert-butylmethanol and says the barriers are 20–30% higher than in solution, attributed to lattice constraints. The journal landing page returned 403. **No 27-proton equivalence or singlet statement was obtained.**

### Dictionary and its failure

**Model deduction.** A leaf orbit under feasible local cyclic permutations is a set of hydrogens connected by the model's rotor operations. Adjacent H and CH3 leaves on a CH2-bearing carbon are reversed only under a reflection/interchange of the other two subtrees, a possibility absent from the directed tree. Hence CH3–CH2–X gives orbit sizes (3,1,1). The source's substitution test calls the two singleton CH2 hydrogens enantiotopic, and the NMR source gives them the same shift in an achiral solvent. They are **not** claimed to be homotopic.

With a chiral reference centre X, the same two leaves have the appropriate diastereotopic interpretation, and the model keeps them separate. This agrees with the source's substitution criterion for the sec-butyl example below. But the tree does not specify bond lengths, neighbouring substituents, barrier heights, electronic shielding, temperature or measurement timescale. Consequently **leaf orbits are not, by themselves, a theorem about the number of NMR lines**. A coherent dictionary is: model orbit -> proper local cyclic substitution/rotation relation; omitted reflection -> possible enantiotopic identification; rapid motion -> possible time averaging that must be assessed separately.

For tert-butyl the complete tree gives one size-9 orbit. For a tri-tert-butylmethyl group the complete three-level tree gives one size-27 orbit. These are valid **model** deductions. They are not upgraded into experimental signal claims without a source. The abstract's hindered solid-phase dynamics is important precisely because fast, effectively free internal rotation is not automatic.

**Picture:** the three children of a tetrahedral node as a three-bladed directed propeller; an enantiotopic pair as two leaves joined by a dotted reflection edge, explicitly not one of the solid rotation edges.

## L2. Feasible permutations and methyl quantum rotors

### Sources read

- **L. Sztraka, “Determination of the nuclear spin statistical weights for the rotation–internal rotation–inversion levels of methylamine,” full PDF text and figures/tables inspected**, Periodica Polytechnica, Chemical Engineering 31(1–2), pp. 93ff; [open PDF](https://pp.bme.hu/ch/article/download/2806/1911), received 1986. Section 2 defines permutation–inversion (PI) operations. It displays `(567)` and `(576)` as cyclic permutations of the methyl hydrogens, and operations with `*` as `P E* = E* P`, where `E*` is inversion of all particles through the centre of mass. Table I lists the feasible `(567)/(576)` and `(56)*/(57)*/(67)*` operations, with their equivalent rotations plus internal rotation/inversion; Table II separately lists unstarred two-proton exchanges and starred cyclic operations among infeasible operations requiring proton interchange. Feasibility means achievable during the experiment and depends on tunnelling barriers and energy, not merely on static point-group symmetry. This is a full-text nonrigid-molecule example, but is **methylamine**, not a universal theorem for every threefold alkyl rotor. The original Longuet-Higgins paper itself was not obtained.
- **M. Šimėnas et al., “Magnetic excitation and readout of methyl group tunnel coherence,” full-text XML paragraphs relevant to the rotor**, Science Advances 6 (2020), eaba1517, doi [10.1126/sciadv.aba1517](https://doi.org/10.1126/sciadv.aba1517), [full text at Europe PMC](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC7195165/fullTextXML). Above the barrier, methyl reorientation is classical and stochastic; at low temperature the three localized states overlap through the barriers. Their splitting gives a symmetric **A** ground state and degenerate **EA, EB** excited states. Its subspace Hamiltonians explicitly permute hyperfine coupling positions between **0°, 120° and 240°**. It also records the importance of different proton-spin symmetry in the ground and excited tunnelling states for QRIP.
- **K. Grohmann and H. Leibscher, abstract only**, doi [10.1063/1.3425880](https://doi.org/10.1063/1.3425880); [Crossref record/abstract actually read](https://api.crossref.org/works/10.1063/1.3425880). It concerns nuclear-spin isomers of nitromethane and permutation symmetry of its methyl group. This is abstract-level support for the existence of such spin isomers, not a derivation of their level weights.
- **H. L. Welsh et al., abstract only**, doi [10.1021/acs.jpclett.6c00128](https://doi.org/10.1021/acs.jpclett.6c00128); [OpenAlex abstract actually read](https://api.openalex.org/works/https://doi.org/10.1021/acs.jpclett.6c00128). It distinguishes **AA/EE** tunnelling states from **AE/EA** states in a coupled methyl-rotor spectrum. No broader claim was taken from this abstract.

**Dictionary:** the methylamine subspace generated by `(567),(576)` together with `E` is C3; a local root cycle in the model has precisely this algebraic form. Quantum tunnelling makes the word “feasible” time- and barrier-dependent; it does not erase the discrete three-well permutation structure. The mismatch is that a real rotor generally is not an isolated bare alkyl with symmetric X: methylamine has an amine rotor, two other protons and inversion coordinates as well.

**Picture:** three localized wavefunctions around a triangle, with cyclic arrows and a split A/E level diagram.

## L3. Symmetry numbers and nuclear-spin statistics

**Source read:** [Fernández-Ramos et al. full text PDF](https://link.springer.com/content/pdf/10.1007/s00214-007-0328-0.pdf), A. Fernández-Ramos, B. A. Ellingson, R. Meana-Pañeda, J. M. C. Marques and D. G. Truhlar, “Symmetry numbers and chemical reaction rates,” Theor. Chem. Acc. 118 (2007) 813–826, doi [10.1007/s00214-007-0328-0](https://doi.org/10.1007/s00214-007-0328-0). Relevant material on pp. 814–816 and its equations (2)–(5) was directly inspected, not just the previously existing reference entry.

**Source text.** Equation (2) contains the classical factor `1/sigma_rot` in the rotational partition function. For 16O2, nuclear-spin statistics removes half the rotational levels; in the classical limit, replacing a level sum with an integral therefore decreases Q_rot by two. For methane, quantum nuclear-spin restrictions give, on average, 1/12 the states expected without antisymmetrization. Low temperature and few populated levels invalidate the classical approximation. On p. 814, section 2 describes labelled permutations and asks which cannot be superposed by rotation or translation of the **whole molecule**. Equation (5) is

    sigma_rot = m! / n_d,

where `m!` is the number of permutations of `m` equivalent atoms and `n_d` is the number of configurations still different under rotation. Page 815 then identifies sigma_rot with the order of the molecule's rotational point group in appropriate cases. For methane it explicitly obtains 4! configurations, 2 distinct rotations classes and sigma_rot=12, agreeing with Td's 12 proper rotations.

**Dictionary and failure.** Both this source and the model turn identical configurations into equivalence classes and divide out an appropriate group. **But the complete internal local-C3 group is not generally the whole-molecule rotational point group.** Whole translations, reflection/inversion, finite-point rotations and feasible internal motions are all potentially different operations. A power of 3 from the model is therefore not automatically the number in eq. (2) or eq. (5).

**Picture:** overlay all labelled rotations of one ice-blue configuration; for a separate torsion wheel, use a second colour rather than suggesting the two kinds of operation coincide.

## L4. Deuterium substitution and computed orbits

**Sourced substitution rule.** The full L1 Soderberg and “Types of Protons” sections show that separate replacement of two H nuclei by D produces identical structures, enantiomers, or diastereomers according to homotopic, enantiotopic or diastereotopic status. **Model deduction:** to enumerate *constitutional/chiral* monodeuterated products for a fixed rooted alkyl, use leaf orbits before allowing an omitted reflection. Counting orbits under the full point group can merge enantiomeric products. Thus “one orbit = one monodeuterated chemical species” needs a stated chiral/nonchiral quotient.

### Complete numerical results

Run: `uv run python experiments/E016_rotor_orbits/run.py`; output in `output.txt`. A dot `.` is a leaf and `(...)` an internal node. Every triple `(a,b,c)` has three ordered children; equivalences are only cyclic rotations of child subtrees. The program explicitly forms the leaf-permutation generators, closes them under composition, checks bijectivity, orbit partition and the advertised formula, and uses no external library.

| n | class | terse tree | d | log3|G| | leaf orbit sizes |
|---:|---:|---|---:|---:|---|
| 1 | 1 | `(...)` | 0 | 1 | **3** |
| 2 | 1 | `((...)..)` | 1 | 1 | **3,1,1** |
| 3 | 1 | `(((...)..)..)` | 2 | 1 | 3,1,1,1,1 |
| 3 | 2 | `((...)(...).)` | 1 | 2 | **3,3,1** |
| 4 | 1 | `((((...)..)..)..)` | 3 | 1 | 3,1,1,1,1,1,1 |
| 4 | 2 | `(((...)(...).)..)` | 2 | 2 | 3,3,1,1,1 |
| 4 | 3 | `(((...)..)(...).)` | 2 | 2 | 3,3,1,1,1 |
| 4 | 4 | `(((...)..).(...))` | 2 | 2 | 3,3,1,1,1 |
| 4 | 5 | `((...)(...)(...))` | 0 | 4 | **9** |
| 5 | 1 | `(((((...)..)..)..)..)` | 4 | 1 | 3,1,1,1,1,1,1,1,1 |
| 5 | 2 | `((((...)(...).)..)..)` | 3 | 2 | 3,3,1,1,1,1,1 |
| 5 | 3 | `((((...)..)(...).)..)` | 3 | 2 | 3,3,1,1,1,1,1 |
| 5 | 4 | `((((...)..).(...))..)` | 3 | 2 | 3,3,1,1,1,1,1 |
| 5 | 5 | `((((...)..)..)(...).)` | 3 | 2 | 3,3,1,1,1,1,1 |
| 5 | 6 | `((((...)..)..).(...))` | 3 | 2 | 3,3,1,1,1,1,1 |
| 5 | 7 | `(((...)(...)(...))..)` | 1 | 4 | **9,1,1** |
| 5 | 8 | `(((...)(...).)(...).)` | 2 | 3 | 3,3,3,1,1 |
| 5 | 9 | `(((...)(...).).(...))` | 2 | 3 | 3,3,3,1,1 |
| 5 | 10 | `(((...)..)((...)..).)` | 3 | 2 | 3,3,1,1,1,1,1 |
| 5 | 11 | `(((...)..)(...)(...))` | 2 | 3 | 3,3,3,1,1 |

Bold lines are the maximum order at their n. The class counts are 1,1,2,5,11 for n=1,...,5. All computed group orders are `3^(n-d)`, each `m=2n+1` leaf set is permuted bijectively and closed under composition, and each orbit size is a power of 3. The largest group order is `3^v`, `v=v3(m!)`; orbit multiplicities among bold lines are precisely the nonzero digits in ternary notation. For n=5, `11=102_3`, hence 9,1,1. An additional passed assertion is `sum(3^d)=binom(3n,n)/(2n+1)`.

### Four carbons: the five butyl stereoisomer classes

**Model dictionary, using the definitions in the brief and the source substitution examples provided**

1. n=4,1: n-butyl, root X–CH2–CH2–CH2–CH3. Model orbits 3,3,1,1,1; each asymmetric CH2 pair consists of singleton orbits.
2. n=4,2: isobutyl, root X–CH2–CH(CH3)2. Model orbits 3,3,1,1,1. The two methyls are distinct ordered child positions; proper rotations inside them do not interchange them.
3. n=4,3 and 4: the two directed root orderings representing the R/S sec-butyl pair. Both have 3,3,1,1,1. The CH2 leaves are distinct orbits. The L1 sources show that in a molecule having a chiral centre such prochiral substitution gives diastereomers; applied here, the CH2 hydrogens of a fixed sec-butyl stereoisomer are diastereotopic. The assignment of the printed first tree rather than the second to “R” depends on an external coordinate orientation and is **not** made.
4. n=4,5: tert-butyl, X–C(CH3)3, orbit 9. The model's root C3 permutes three identical methyl children; its child C3 operations permute each methyl H triple.

For the unrooted butane Skeleton or free butyl radical, point group or radical reorganization may add further symmetry; the rooted, stereochemistry-preserving X attachment in this experiment deliberately excludes such additions. Distinguish this from an ordinary achiral-solvent spectrum of an ethyl-like chain, whose enantiotopic CH2 leaves merge.

**Picture:** all five n=4 trees with their leaf orbit sizes in coloured discs, the 3+4 mirror forms framed together.

## L5. The papers behind A121179 and lattice conformers

- **S. J. Cyvin, J. Brunvoll, B. N. Cyvin and W. Lüttke, “Enumeration of the Staggered Conformers of Alkanes,” abstract only**, [Crossref record with abstract](https://api.crossref.org/works/10.1515/zna-1995-0911), Z. Naturforsch. A 50 (1995) 857–863, doi [10.1515/zna-1995-0911](https://doi.org/10.1515/zna-1995-0911). The abstract defines **alkanoid systems** as chemical graphs embeddable in the diamond lattice that correspond to staggered alkane conformers. It explicitly defines overlapping and non-overlapping systems. It gives a generating-function reformulation for unbranched alkanoids, computer enumeration of non-overlapping branched/unbranched cases, and combinatorial construction of small overlapping unbranched examples. **Therefore overlaps are genuinely an additional physical embedding issue.** The abstract does not itself identify the ordered-tree quotient, mention the phrase “without C3 symmetry”, or contain `binom(3n,n)/(2n+1)`.
- The other specified Cyvin, Wang–Cao–Li and 1997 conformers articles were searched by exact title/metadata phrases. No full text was opened that justifies a more exact convention. I therefore **do not** assign a chemical name to the Fuss–Catalan total and do not assert that A121179 divides out precisely the same rotations.

**Model deduction and possible dictionary:** choose each C–C bond's staggered torsion relative to its parent. An abstract ordered tree is a torsion-coordinate model of an embedded alkyl. Whether it is realizable without overlap depends on descendants' geometry, not only the tree. The three cyclic children are a natural discrete abstraction of the three staggered positions. The source label “chemical graph embeddable in the diamond lattice” is a stronger embedding requirement than the unlabelled torsion-tree description alone.

**Picture:** a tree attached to a diamond-lattice path, with one local torsion wheel highlighted and an overlapping distant atom pair marked with an X.

## L6. Reaction-path degeneracy and statistical factors

The same **Fernández-Ramos et al. full-text PDF as in L3**, pp. 813–817, was used.

**Source text.** In simple cases the reaction-path symmetry number is the ratio of reactant to transition-state rotational symmetry numbers:

    sigma = sigma_rot,R / sigma_rot,TS          [source eq. (4), p. 814].

The article emphasizes that this usually, not always, accounts for nuclear indistinguishability. Its eq. (6), p. 817, gives the factor **12/3 = 4** for H abstraction from methane by F, agreeing with the four equivalent H atoms. Replacing F by CF3 in eq. (7) gives **3·12/3 = 12**, and the discussion explicitly states that the extra factor of three is *unrelated to the internal rotation of the CH3 fragment*. Section 3.5 treats internal rotation separately. This is a direct relationship between symmetry and rate factors, but **not direct evidence that the tree's power 3^(n-d) is an observable kinetic exponent**.

**Model deduction:** an orbit of equivalent H abstraction sites can contribute an integer statistical factor when the transition state retains only part of the symmetry. But the details of the transition state's point group, conformers and internal rotors change the quotient. For a specific tert-butyl abstraction factor, no example was retrieved.

**Picture:** a reactant propeller of three equivalent H sites, an arrow to an asymmetric transition state, and a simple ratio beside it.

The earlier 1978 Pollak–Pechukas paper was cited in the inspected 2007 text, but its original full text was not opened in W029; no further statement is attributed to it here.

## L7. Other branching cyclic-group examples

No additional, precise source-backed example was established. Abstract-level methyl/nuclear-spin rotor studies and staggered-lattice chemistry are covered in L2 and L5 rather than counted as independent L7 links. **No claim was made that a measured or tabulated power of three in a general branching molecule corresponds to the tree group order.** This negative result is limited to the queries and sources actually tried below, not a proof that no such field exists.

## Searches that found nothing, access failures, and unverified leads

### Queries with no retrieved answer

- LibreTexts `@api/deki/site/query`: `"9H singlet" "tert-butyl"`; `"tert-butyl" "singlet"`; `"nine equivalent hydrogens"`; `"proton equivalence" "symmetry operation"`; `homotopic enantiotopic proper rotation improper`. Search results, a Google-like record scan or substitutions are not reported as evidence when the relevant page text was unavailable. The search engine did not retrieve a textual 9H annotation.
- PubChem `name/tert-butyl alcohol/property` and `pug_view/.../6386/JSON?heading=1H+NMR+Spectra`: an actual spectrum was retrieved, but no literal “9H singlet” annotation was present.
- Crossref/OpenAlex/Europe PMC: `tri-tert-butylmethanol NMR`, `tri-tert-butylmethanol`, `tri-tert-butylmethyl hindered rotation`, and trialkylmethanol/dynamic-NMR title searches. No textual 27-H singlet or full equivalence demonstration was found.
- Europe PMC: `"methyl tunneling" AND OPEN_ACCESS:Y`, `"nuclear spin isomers" methyl`, `"permutation-inversion" methyl`. Abstract-only modern examples were obtained, not the Longuet-Higgins proof.
- Crossref/OpenAlex: `aliphatic substitution by deuterium ... homotopic enantiotopic`; `prochirality review homotopic enantiotopic symmetry`; exact Cyvin title/year/author queries; `"without C3 symmetry"` with alkyl conformers. None opened the missing definitions or Fuss–Catalan connection.

### Not accessible; not bypassed

- IUPAC Gold Book JSON/term pages: Cloudflare bot challenge. No definition quoted from it.
- Semantic Scholar: HTTP 429; not repeatedly retried to evade rate limiting.
- Cyvin De Gruyter PDF: web application firewall challenge, empty invalid PDF; `znaturforsch.com` HTTPS host failed certificate validation, and HTTP archive path returned 404. TLS verification was not disabled.
- OpenAlex `content.openalex.org` PDF path: HTTP 401.
- Longuet-Higgins publisher PDF and RSC trialkylmethanol landing page: HTTP 403.
- DigitalCommons Soderberg PDF: 403; guessed Caltech book-chapter URL: 404.
- LibreTexts raw-content/API page endpoints used initially: 403. Normal readable HTML pages and the site search API were used instead. Several guessed page slugs returned 404 and were replaced with actual search-result URIs.
- Europe PMC first broader request: timeout; one full-text endpoint request: 503. No claim was sourced from either failed retrieval.

### Leads not verified (not asserted from memory)

1. General IUPAC wording **homotopic = interchangeable by a proper rotation**, **enantiotopic = only an improper operation**, including precisely what this means in a nonrigid molecule. Only substitution-test and achiral-NMR statements are established above.
2. Longuet-Higgins's original general statement that a methyl's feasible proton permutations are the cyclic ones and that an odd permutation occurs together with inversion. Sztraka's full methylamine account is a concrete verification of part of this structural picture, not a substitute for the original theorem.
3. Full 1995 Cyvin enumeration and the three related papers: exact labelled/free/ordered quotient, exclusion of overlaps, precise meaning of a substituent lacking C3 symmetry, and whether `binom(3n,n)/(2n+1)` is explicitly called anything chemical. None of those details are inferred from the mere existence of A121179.
4. An explicit 9H singlet table and an actual tri-tert-butylmethyl 27-H equivalent-proton observation; the latter's free rotations and actual fast-NMR averaging still require a suitable solution-phase spectrum.
5. Specific methyl nuclear-spin isomer level weights from the original permutation-group calculation. The included sources establish A/E splitting, cyclic permutation structure and examples of spin symmetry, not all weights.
6. Reaction factors for tert-butyl H abstraction, and any direct connection of reaction-path or internal symmetry numbers to Fuss–Catalan divisibility.

## Worker scope and verification summary

I created `notes/2026-11-14_physical_search_rotors_W029.md` and the three-file experiment `experiments/E016_rotor_orbits/{run.py,README.md,output.txt}`. The script was run successfully with `uv run python`; it tests the leaf-permutation groups and base-3 assertions only for n=1,...,5. Sources explicitly described above as abstracts or records were not read as full papers. No person or repository names were included in external queries. Downloaded research PDFs are deleted after producing this note; only report/code/output remain as the requested result. No general chemical assertion about embedded tetrahedral trees is established by the combinatorial program alone.
