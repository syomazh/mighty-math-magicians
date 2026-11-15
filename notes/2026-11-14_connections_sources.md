# Sources behind the ranked connections: the two agents' reports

Reports of two fresh-context Claude Fable 5.2 agents (AI), 2026-11-14, about 16:00 to 16:30 PT, copied here unedited except that headings are moved down two levels and a list of temporary local file paths is removed. Not human-reviewed. Used by `notes/2026-11-14_connections_ranked.md` and by `references/README.md`, entries 38 onward.

- **Report A (open search).** The agent was given a description of the method (a cyclic group of prime order at each node of a tree, classes of size p^d, carries, merging p equal pieces, the depth condition) and not our list of candidates, and was asked where else this mechanism occurs.
- **Report B (source verification).** A second agent was given the specific leads and asked to open each source and say what it states, with page or section, and what could not be verified.

Where the two reports disagree, B is the later and more careful one, except where noted in the ranked note. Three points to keep in mind: (1) both agents paraphrase; wording must be taken from the sources themselves before anything is quoted in the paper or the talk; (2) "opened" means opened by an AI agent on that date, not read by a human; (3) items marked NOT VERIFIED or [snippet] must not be cited.

Added by the orchestrator after the reports: OEIS A121179 was opened by the orchestrator at 16:50 through the OEIS JSON interface. Its comment (Petros Hadjicostas, 24 July 2019) says the sequence is the number of all staggered conformers of alkyls with n carbon atoms, and that A001764(n) is the number of space positions of conformers of alkyls related to another alkyl without C_3 symmetry; formula a(n) = A001764(n)/3, plus (2/3)·A001764((n − 1)/3) when n ≡ 1 (mod 3). Links in the entry: S. J. Cyvin, J. Math. Chem. 17 (1995), 291–293, DOI 10.1007/BF01164853; Cyvin, Brunvoll, Cyvin, Lüttke, Z. Naturforsch. A 50 (9) (1995), 857–863, DOI 10.1515/zna-1995-0911; Cyvin, Wang, Brunvoll, Cao, Li, Cyvin, Wang, J. Mol. Struct. 413–414 (1997), 227–239, DOI 10.1016/S0022-2860(97)00025-2; Cyvin, Cyvin, Brunvoll, Wang, J. Mol. Struct. 445 (1998), 127–137, DOI 10.1016/S0022-2860(97)00419-5; Wang, Cao, Li, J. Math. Chem. 20 (1996), 211–212, DOI 10.1007/BF01165165; F. Hering et al., "The enumeration of stack polytopes and simplicial clusters", Discrete Math. 40 (1982), 203–217, DOI 10.1016/0012-365X(82)90121-2 (a comment by Robert A. Russell, 12 May 2024, says the generating function is F(3, t) on its page 209). None of these papers was opened.

---

## Report A: open search

### Cross-field analogues of the tree-symmetry / carry mechanism: research report

No repository file was edited. Every source marked **[opened]** was read during this task at the URL given; **[snippet]** means I saw it only in a search-result summary, so treat it as **not verified**.

One limit on format: I can give only one verbatim quotation in this report. All other anchors are paraphrases with exact locations (theorem, section, page) so a human can pull the wording.

#### Headline findings

1. **The theorem is already in print, and its lower-bound half is already proved combinatorially.** Konvalinka's *Divisibility of generalized Catalan numbers* states the exact formula as Proposition 2, proved with factorials. Its Proposition 7 proves by a group action on q-ary trees that p^ξ divides every orbit. He says himself that this is "a combinatorial proof of only a part of Proposition 2" (Konvalinka, p. 6). The exactness step is therefore the open part your Step 4 fills.
2. **Exact p = 3 twin in chemistry.** Rotation classes of ternary plane trees are the stereoisomers of alkyl radicals (OEIS A000625). The thermochemical "total symmetry number" of a branched alkane is 3^(number of symmetric rotors), computed by repeatedly collapsing symmetric rotors into "pseudo-atoms".
3. **Exact p = 2 twin in phylogenetics.** Kersting–Fischer (2021) prove that the minimum number of non-symmetry nodes of a binary tree with n leaves is wt(n) − 1, attained exactly by trees built from fully balanced trees given by the binary digits of n, and that there are (2wt(n) − 3)!! of them. This is the same statement as Deutsch–Sagan's Lemma 2.3 (2004). The phylogenetics paper's 44-item reference list does not contain Deutsch–Sagan.
4. **Carries as an operational cost.** Vuillemin's binomial-queue paper (1978) states that merging queues of sizes n and n′ costs exactly ν(n) + ν(n′) − ν(n + n′) comparisons, and building from n singletons costs n − ν(n), the number of carries.
5. **Wrap-around carries** are standard in the Internet checksum (RFC 1071) and in sequence design (Hollmann–Xiang's add-with-carry algorithm modulo 2^m − 1).

I found no literature connecting items 2–5 to the divisibility of Catalan or Fuss–Catalan numbers.

#### Prior art inside mathematics (your item 5)

- **Konvalinka**, *Divisibility of generalized Catalan numbers*. [opened] https://users.fmf.uni-lj.si/konvalinka/wcatalan.pdf (pp. 1–10 read). Journal data J. Combin. Theory Ser. A 114(6) (2007) 1089–1100 is [snippet] only.
  - Proposition 2: ξ_p(C_n^(q)) = (s_p((q−1)n+1) − 1)/(p−1) for q = p^k, by Legendre's formula.
  - Remark 3: the residue for q = p is (−1)^(…) ∏(p − a_i − 1)!, and he calls the general-q formula much more complicated. By Wilson's theorem this equals your (−1)^t/∏ m_j! (my algebra, not in the paper).
  - He uses the full symmetry group of the complete q-ary tree, not cyclic rotations. Orbit size is a product of multinomials over "white" vertices (not all branches equivalent). Lemmas 8–10 give the minimal-orbit structure: a white skeleton with complete q-ary trees attached, A_i < q of each depth.
  - He has no cherry collapse and no count of minimal orbits.
- **Deutsch & Sagan**, *Congruences for Catalan and Motzkin numbers and related sequences*, arXiv:math/0407326. [opened] https://arxiv.org/pdf/math/0407326 (pp. 1–5 read). J. Number Theory 117 (2006) 191–215 is [snippet].
  - Theorem 2.1: ω(C_n) = δ(n+1) − 1.
  - Lemma 2.2: G_h = Z_2 ≀ G_(h−1), of order 2^(2^h − 1).
  - Lemma 2.3: every orbit has 2-adic order ≥ d, with equality for exactly (2d−1)(2d−3)···1 orbits. Their eq. (3) is your class-size rule for p = 2.
- **Postnikov & Sagan**, arXiv:math/0601339. [opened, abstract] https://arxiv.org/abs/math/0601339. Weighted Catalan numbers, generalising the Deutsch–Sagan proof.
- **Gao & Gu**, *Arithmetic of weighted Catalan numbers*, arXiv:1908.03914. [opened] https://ar5iv.labs.arxiv.org/html/1908.03914. Theorem 3.1 strengthens Konvalinka for prime powers, proof only sketched; no residue of C/p^ξ beyond the congruence.
- **T. C. Li**, *On the divisibility of Catalan numbers*, Hang Lung Mathematics Awards 8 (2018) 29–46. [opened] https://hlma.hanglung.com/assets/2127BE7E-4FF5-4E68-8A75-4268DE5AEB8E/007.pdf. Arithmetic only, Catalan only.
- **Granville**, web survey *Arithmetic properties of binomial coefficients*. [opened] https://dms.umontreal.ca/~andrew/Binomial/elementary.html. It states Kummer's carry theorem and Legendre's digit-sum form, and credits the n!/p^v congruence to Anton, Stickelberger and Hensel. The formula is an image I could not read, and the author's name is not printed on the page.

Searches run for an existing link to (Fuss–)Catalan divisibility, none of which found one:
- ternary trees + 3-adic valuation + stereoisomers + A000625/A001764;
- Fuss–Catalan + p-adic valuation + group action + wreath/Sylow + cyclic rotations;
- binomial heap/queue + Catalan + 2-adic/Kummer;
- combinatorial proof of Kummer + Sylow/wreath;
- phylogenetic symmetry nodes + Catalan + 2-adic/Deutsch.

#### A. Breadth list (26 candidates)

Each entry gives: statement and how standard it is; match to (a)–(f) and Steps; source; restriction. "Link: none" means no literature tying it to Catalan divisibility was found.

**Top six (details in section B)**
1. Thermochemistry: symmetry numbers of branched alkanes, and stereo-enumeration of alkyl radicals. (a)(b)(e); Steps 1, 3, 4. p = 3.
2. Phylogenetics: symmetry nodes of tree shapes. (b)(e); Steps 1, 2, 3, and the oddness in Step 4. p = 2.
3. Data structures: binomial queues and numerical representations. (c)(d); Steps 2, 3. p = 2.
4. Permutation groups: Sylow p-subgroups of S_n as wreath products indexed by base-p digits; the adding machine. (a)(c); Steps 2, 3. All primes.
5. Wrap-around carries: Internet checksum, add-with-carry modulo 2^m − 1, McEliece/Stickelberger. (f)(e).
6. Storage and hashing: buddy allocator, Merkle mountain ranges, LSM-tree tiering. (c)(d); Steps 3, 4 as operations only.

**Moderate**

7. **Molecular spectroscopy: nonrigid-molecule symmetry groups are wreath products.** Balasubramanian represents the Longuet-Higgins permutation-inversion groups of molecules with internal rotors as (generalised) wreath products G[H]; hydrazine is S2[S2]. Established specialist method. Match (a); Step 1 group. Source: Balasubramanian, *Computer generation of the symmetry elements of non-rigid molecules*, LBL-15455 (1982) [opened] https://escholarship.org/uc/item/4g4391tp. Also Darafsheh, Ashrafi, Darafsheh, Int. J. Quantum Chem. 105(5) (2005) 485–492, DOI 10.1002/qua.20721 [opened, record only] https://profiles.wustl.edu/en/publications/computing-the-full-nonrigid-group-of-tetra-tert-butyltetrahedrane/. Longuet-Higgins, Mol. Phys. 6 (1963) 445 appears as reference 1 of the LBL report; its DOI and page range are [snippet]. Balasubramanian, J. Chem. Phys. 72, 665 (1980): **not verified**. Link: none. p = 2, 3 in practice.

8. **Hydrology / compilers: Horton–Strahler order = register function.** Two subtrees of equal order i give order i+1; otherwise the maximum. Kemp's explicit average over binary trees with n internal nodes contains 1 + v_2(k), with v_2 the number of trailing binary zeros. Textbook in both fields. Match (c) in a lossy max-plus form; Step 3 (complete binary trees are the atoms of each order); Horton pruning resembles the cherry collapse. Not a count. Sources: Flajolet, Nebel, Prodinger, *The scientific works of Rainer Kemp*, §1 [opened] https://finanz.math.tugraz.at/~prodinger/kemp_final.pdf (its journal reference not seen). It cites Flajolet–Raoult–Vuillemin, Theoret. Comput. Sci. 9 (1979) 99–125, and Yekutieli–Mandelbrot, J. Phys. A 27 (1994) 285–293; neither opened. Kovchegov & Zaliapin, arXiv:1905.02629 [opened, abstract] https://arxiv.org/abs/1905.02629. Link: v_2 appears next to Catalan trees, but for the average order, not for divisibility. p = 2.

9. **Information theory: D-ary Huffman codes.** Each merge reduces the ensemble by D − 1, so (N_1 − 1)/(D − 1) must be an integer; this is your m = (q−1)n + 1 as a design rule. Textbook. Match (d); explains the leaf count; merging D siblings into a parent is a carry in the Kraft sum (my reading). Source: Huffman, *A method for the construction of minimum-redundancy codes*, Proc. I.R.E. 1952, p. 1101, section "Generalization of the Method" [opened, page image] https://www.csd.uoc.gr/~hy474/bibliography/Huffman.pdf (volume number not seen). Link: none. Any integer D.

10. **Complexity theory: classes PPA-p.** Search problems whose solution exists by a counting argument modulo p; a Chevalley–Warning problem is complete for prime p. Active research. Match (e); the proof principle of Step 4, not trees. Sources: Göös, Kamath, Sotiraki, Zampetakis, arXiv:1912.04467 (CCC 2020) [opened, abstract] https://arxiv.org/abs/1912.04467; Hollender, Theoret. Comput. Sci. 885 (2021) 15–29, arXiv:1912.03729 [opened, abstract] https://arxiv.org/abs/1912.03729. The formal definition via Z_p actions was not on the pages I opened. Link: none. All primes.

11. **Genetics algebra / astronomy: Wedderburn–Etherington numbers.** OEIS A001190 counts binary rooted trees up to swapping children. Its comments read them as interpretations of x^n under commutative non-associative multiplication, and as ways to place n stars in a stable hierarchical multiple system. These are exactly the Step 1 classes for p = 2. Match (b); Step 1. Source: [opened] https://oeis.org/A001190; it lists Wedderburn, Ann. Math. 24 (1922–23) 121–140, and Etherington, Math. Gaz. 21 (1937) 36–39 (papers not opened). The identity Catalan = Σ over shapes of 2^(asymmetric nodes) is not on the page. p = 2.

12. **Combinatorial species: "mobiles".** OEIS A032200 counts rooted compound windmills (mobiles), trees whose branches under a node are taken up to cyclic rotation. Match (a) as an object; the name suggests the hanging sculpture, which I did not verify as a physical claim. Source: [opened] https://oeis.org/A032200; it cites Bergeron–Labelle–Leroux, p. 241 (not opened). Any arity. Link: none.

13. **DNA nanotechnology.** DNA tiles implementing the XOR automaton self-assemble into Pascal's triangle mod 2; the discussion notes that a binary counter needs four tile types. Match (c), weak: a carry is a physical tile. Source: Rothemund, Papadakis, Winfree, PLoS Biol. 2(12) (2004) e424, DOI 10.1371/journal.pbio.0020424 [opened] https://pmc.ncbi.nlm.nih.gov/articles/PMC534809. p = 2.

14. **Cellular automata.** Rule 90 from one live cell has 2^(number of 1s of n) live cells at generation n; Glaisher (1899) for odd binomial coefficients. Digit sum with a physical meaning, not carries. Weak (c). Source: [opened] https://oeis.org/A001316. p = 2 here.

15. **Puzzles: Tower of Hanoi, Gray code.** The disk moved at step n is the ruler function; its partial sums are 2n − (binary weight of n). Weak (c). Source: [opened] https://oeis.org/A001511.

16. **Mathematics education: Exploding Dots.** Tanton's "1 ← 2 machine", with 1 ← 5 and 1 ← 37 variants per a search snippet. Match (d) exactly as a teaching device. Source: [opened, partial] https://gdaymath.com/lessons/explodingdots/2-1-welcome/ names the machine; the rule's wording is [snippet] only. Any base.

**Weak, or not verified**

17. **Music theory.** Chords and rhythms are counted as orbits of the cyclic transposition group by Pólya theory. Match (b), weak: cyclic group but no trees. Source: Fripertinger, *Enumeration in Musical Theory*, Sém. Lothar. Combin. B26a (1991) [opened, record] https://www.mat.univie.ac.at/~slc/opapers/s26fripert.html.
18. **Numerical analysis / QFT: symmetry factor σ(τ) of Butcher trees.** Order of the automorphism group, with a recursive product formula. Match (b), but symmetric rather than cyclic groups. arXiv:2402.13971 abstract opened; the σ definition is [snippet]. **Not verified.**
19. **Tournament design: n!/2^(n−1) draws of a balanced knockout.** Match (b), p = 2. Horen & Riezman, Oper. Res. 33(2) (1985) 249–262 is [snippet]; the formula was not found on an opened page. **Not verified.**
20. **Graph theory: parity of the number of spanning trees** (even exactly when the graph has an Eulerian edge cut, per Eppstein's abstract). Match (e), weak. [snippet] only. **Not verified.**
21. **Mersenne-number arithmetic.** Crandall & Fagin, Math. Comp. 62 (1994) 305–324. Match (f). [snippet] only. **Not verified.**
22. **Trinomial / 2–3 heaps (Takaoka).** Possible base-3 analogue of candidate 3. [snippet] only. **Not verified.**
23. **Stereochemistry 2^n rule** for n asymmetric carbons. Match (b), p = 2. No source opened. **Not verified.**
24. **Conformer counting: 3^(rotatable bonds), terminal methyls excluded.** Match (a)(b), p = 3. Veber's definition is [snippet] only. **Not verified.**
25. **Merge games (2048, Triple Town) and mensural notation (perfect = 3, imperfect = 2).** Match (d). No source opened. **Not verified.**
26. **False friends, count only:** tree "rotations" in AVL trees and the Tamari lattice, RNA secondary structures, parenthesisations, planar Feynman diagrams. They share Catalan numbers or the word "rotation" but none of the mechanism. This is my judgment; no source opened.

#### B. Deep dives on the six best

##### B1. Chemistry (p = 3)

**Statements.**
- OEIS A000625 counts n-node steric rooted ternary trees, equivalently alkyl radicals C_nH_(2n+1) with stereoisomers. A comment says steric means the children of a node are taken in a cyclic order. Generating function: A(x) = 1 + x(A(x)^3 + 2A(x^3))/3, the cycle index of C_3. Terms: 1, 1, 1, 2, 5, 11, 28, 74, 199, 551.
- Domalski & Hearing, Appendix D (pp. 1655–1657): N(tot) = N(int) × N(ext).
  - A methyl group has a three-fold axis and contributes 3.
  - Symmetric terminal rotors are "spun" into pseudo-atoms, and the process repeats until the molecule is rigid.
  - Non-symmetrical terminal rotors do not affect N(tot).
  - Section 3 (p. 1643): S(sym) = R ln N(opt) − R ln N(tot).
  - Worked values:

| Molecule | N(int) | N(ext) | N(tot) |
|---|---|---|---|
| ethane | 9 | 2 | 18 |
| 2-methylpropane | 27 × 3 = 81 | 1 | 81 |
| 2,2-dimethylpropane | 81 | 12 | 972 |
| 2-methylbutane | 27 (no extra factor) | 1 | 27 |
| 2,2-dimethylbutane | 243 | 1 | 243 |
| 2,2,3,3-tetramethylbutane | 729 × 3 × 3 = 6561 | 2 | 13122 |

- The NIST WebBook gives the correction −R ln(σ/n). RMG's documentation gives −R ln σ and +R ln 2 for chirality, with σ including internal free rotors.

**Usage.** Standard reference-data practice (Benson group additivity; NIST; the RMG kinetics software).

**Correspondence (my dictionary, not in any source).**
- A tree with n internal nodes is a monosubstituted alkane C_nH_(2n+1)X; its leaves are the m = 2n + 1 hydrogens.
- A rotation at a node is a 120° internal rotation about the bond toward the root.
- A symmetric node is a symmetric rotor; a class is one stereoisomer.
- Class size is 3^d and N(int) = 3^(n−d).
- I checked A001764(n) = Σ over classes of 3^d by hand: 12 = 9 + 3 for n = 3, and 55 = 27 + 9 + 9 + 9 + 1 for n = 4.
- Atoms are H, methyl (3 H), tert-butyl (9 H), tri-tert-butylmethyl (27 H).
- The pseudo-atom procedure is your cherry collapse, used to compute σ rather than to count modulo 3.
- Step 2 becomes: N(int) ≤ 3^(v_3((2n+1)!)). This is my inference, checked for n ≤ 4.

**Sources.**
- [opened] https://oeis.org/A000625. It lists Pólya, Z. Krist. 93 (1936) 415–443; Read (1976); Robinson–Harary–Balaban, Tetrahedron 32 (1976) 355–361; Blair–Henze, JACS 54 (1932) 1098–1106. None of those papers was opened. Pólya's Acta Math. 68 (1937) paper is [snippet].
- Domalski & Hearing, *Estimation of the thermodynamic properties of hydrocarbons at 298.15 K*, J. Phys. Chem. Ref. Data 17, 1637 (1988), DOI 10.1063/1.555814 [opened] https://srd.nist.gov/jpcrdreprint/1.555814.pdf.
- [opened] https://webbook.nist.gov/chemistry/grp-add/s-and-p/
- [opened] https://reactionmechanismgenerator.github.io/RMG-Py/users/rmg/thermo.html
- Fernández-Ramos, Ellingson, Meana-Pañeda, Marques, Truhlar, Theor. Chem. Acc. 118 (2007) 813–826, DOI 10.1007/s00214-007-0328-0 [opened, abstract only].

**Link to Catalan divisibility:** none found; the A000625 page has no cross-reference to A001764.
**Restriction:** p = 3 only as a physical fact (2-fold for phenyl). No prime-power analogue.

##### B2. Phylogenetics (p = 2)

**Statements.**
- Bóna–Flajolet: sym(t) counts nodes whose two subtrees are identical; a shape has n!/2^sym(t) leaf labellings. Lemma 1: F(z,u) = z + ½F(z,u)² + (u − ½)F(z²,u²). The mean number of symmetry nodes is about 0.271·n for phylogenetic trees.
- Ford, Lemma 31: n!/2^k cladograms for a shape with k symmetric branch points. Proposition 32 puts 2^k/n! into shape probabilities.
- Kersting–Fischer:
  - SNI(T) = (n − 1) − s(T).
  - Theorem 3.3: the maximum is n − 2, attained only by the caterpillar.
  - Theorem 3.5: the minimum is wt(n) − 1, attained exactly by "rooted binary weight trees" (Definition 3.4: a top tree with wt(n) leaves, replaced by fully balanced trees of sizes 2^i for the 1-bits of n).
  - Theorem 3.9: there are (2wt(n) − 3)!! of them.
  - A remark gives the maximal number of symmetry nodes as n − wt(n).
  - OEIS A344852 records the count.

**Usage.** A published balance index, implemented in the CRAN package treebalance (function symNodesI).

**Correspondence.** SNI is your d; Theorem 3.5 is Steps 2–3 for p = 2, k = 1; the oddness of (2wt − 3)!! is the conclusion of Step 4. The 2^(n−1−s) count of plane embeddings is not stated in the phylogenetics papers I opened; it is Deutsch–Sagan's eq. (3).

**Sources.**
- Kersting & Fischer, arXiv:2105.00719 [opened] https://ar5iv.labs.arxiv.org/html/2105.00719. Math. Biosci. 2021, article 108690, DOI 10.1016/j.mbs.2021.108690, as given on [opened] https://search.r-project.org/CRAN/refmans/treebalance/html/symNodesI.html (volume not seen).
- [opened] https://oeis.org/A344852
- Bóna & Flajolet, arXiv:0901.0696 [opened] https://ar5iv.arxiv.org/html/0901.0696 (journal reference not shown).
- Ford, arXiv:math/0511246 [opened] https://ar5iv.labs.arxiv.org/html/math/0511246.

**Link to Catalan divisibility:** the theorem coincides with Deutsch–Sagan Lemma 2.3, but neither paper cites the other, and I found no paper making the connection.
**Restriction:** binary trees only.

##### B3. Binomial queues and numerical representations (p = 2)

**Statements.**
- Vuillemin:
  - p. 310: a binomial forest F_n has one B_i for each 1 in the binary decomposition of n.
  - p. 311: UNION follows binary addition from low to high order; a carry is the coupling of two B_i into a B_(i+1). The heap-ordered binomial tree is the contraction of a perfect tournament (Fig. 4).
  - p. 312: building F_n by n insertions costs n − ν(n) comparisons, which equals the number of carries in 1 + 1 + … + 1 and the number of edges of F_n. UNION(n, n′) costs exactly ν(n) + ν(n′) − ν(n + n′).
- Okasaki, ch. 6, pp. 61–62: inserting resembles incrementing and combining resembles adding. Simulating a carry means linking two rank-r trees into a rank-(r+1) tree; a borrow unlinks. Complete binary leaf trees, binomial trees and pennants are interchangeable families of 2^r-element trees.

**Usage.** Textbook.

**Correspondence (mine).** Read a binary tree with m leaves as a merge plan. The cost at a node with child sizes a and b is ν(a) + ν(b) − ν(a + b), Kummer's carry count. The total is always m − ν(m): your carry budget. The final forest is Step 3's atoms with multiplicities given by the digits. Linking is the reverse of the cherry collapse. There is no symmetry counting.

**Sources.**
- Vuillemin, *A data structure for manipulating priority queues*, Comm. ACM 21(4), April 1978, pp. 309 ff. [opened, pp. 309–312] https://www.cl.cam.ac.uk/teaching/1011/AlgorithII/1978-Vuillemin-queues.pdf.
- Okasaki, *Purely Functional Data Structures*, CMU-CS-96-177 (1996) [opened] https://www.cs.cmu.edu/~rwh/students/okasaki.pdf.

**Link to Catalan divisibility:** none found. OEIS A011371 (n minus binary weight = 2-adic valuation of n!) lists a reference titled *A Note on Counting Binomial Heaps*, not opened.
**Restriction:** base 2. A base-3 version (Takaoka's trinomial heaps) is not verified. For any integer base see B6.

##### B4. Sylow subgroups, wreath products, adding machine (all primes)

**Statements.**
- Kaloujnine (1948) describes the Sylow p-subgroups of symmetric groups of prime-power degree; I opened only the Numdam record.
- Giannelli–Law, §2.2: for the base-p expansion of n, the Sylow p-subgroup of S_n is the direct product over i of a_i copies of P_(p^i), each an iterated wreath product of cyclic groups of order p.
- Deutsch–Sagan Lemma 2.2 is the p = 2 case as tree automorphisms.
- Demir–Saltan: the adding machine on the p-ary rooted tree is a = (1, …, 1, a)σ with σ = (0 1 … p−1). It acts as adding one to a p-adic integer, and the closure of the group it generates is isomorphic to the p-adic integers.

**Usage.** Standard group theory.

**Correspondence.**
- The rotation stabiliser of an atom with p^j leaves is the j-fold wreath product.
- The digit multiplicities a_i are your m_j.
- The stabiliser of any tree is a p-subgroup of the symmetric group on the m leaves. This yields "number of symmetric nodes ≤ v_p(m!)", the bound behind Step 2, but only via Legendre's formula, which you want to avoid.
- In the adding machine a carry is literally "rotate the p branches cyclically and recurse into one subtree" (my reading).
- The order formula p^((n − s_p(n))/(p−1)) was not stated on any page I opened.

**Sources.**
- Kaloujnine, *La structure des p-groupes de Sylow des groupes symétriques finis*, Ann. Sci. Éc. Norm. Supér. (3) 65 (1948) 239–276, DOI 10.24033/asens.961 [opened, record] https://www.numdam.org/item/ASENS_1948_3_65__239_0.
- Giannelli & Law, arXiv:1712.02642 [opened] https://ar5iv.labs.arxiv.org/html/1712.02642.
- Demir & Saltan, arXiv:1007.0366 [opened] https://ar5iv.arxiv.org/html/1007.0366.

**Link to Catalan divisibility:** Deutsch–Sagan and Konvalinka use these groups, with the full symmetric group at each node for q > 2. I found no cyclic-rotation version.
**Restriction:** none on p.

##### B5. Wrap-around carries (f), and digit sums modulo q − 1 (e)

**Statements.**
- RFC 1071:
  - §1: the checksum is the 16-bit ones' complement sum; on two's-complement machines it needs an end-around carry, meaning overflow from the top bits is added into the bottom bits.
  - §2(B): the sum is byte-order independent because carries run from bit 15 to bit 0 and from bit 7 to bit 8, so swapping bytes only rotates the sum.
  - The RFC body never says "modulo 65535"; the appended IEN 45 uses K = 2^16 − 1.
- Hollmann–Xiang, §5.1, Lemma 3: a periodic carry sequence c_i (indices modulo m) with 2c_i = a_i + c_(i−1) exists exactly when a ≡ 0 mod 2^m − 1. They use this "modular add-with-carry algorithm" to bound binary weights of ta mod 2^m − 1, and hence cross-correlations of m-sequences. My text extraction of equations (19)–(20) was garbled, so check them in the paper.
- McEliece's theorem, as stated by Aubry–Langevin (Theorem 1): all weights of the binary irreducible cyclic code c(m, v) are divisible by 2^(θ−1), and one is not divisible by 2^θ, where θ = min over 0 < j < v of the binary digit sum S(jn), via Stickelberger.

**Usage.** An Internet standard; standard coding theory.

**Correspondence.** The cyclic carry chain indexed by Z_k is the natural analogue of your depth condition modulo k. This is plausible but I did not derive a precise dictionary. McEliece's theorem has the same shape as yours: an exact p-power divisibility of a count, governed by a digit sum, with a "one is not divisible" exactness clause.

**Sources.**
- Braden, Borman, Partridge, *Computing the Internet Checksum*, RFC 1071 (1988) [opened] https://www.rfc-editor.org/rfc/rfc1071.txt.
- Hollmann & Xiang, Finite Fields Appl. 7 (2001) 253–286, doi:10.1006/ffta.2000.0281 [opened] https://bpb-us-w2.wpmucdn.com/sites.udel.edu/dist/a/6387/files/2017/08/Welch_Niho-1hmv2kn.pdf.
- Aubry & Langevin, *On the weights of binary irreducible cyclic codes* [opened] https://www.i2m.univ-amu.fr/perso/yves.aubry/LNCS.pdf (venue not seen).
- McEliece, Discrete Math. 3 (1972) 177–192: [snippet], **not verified**.

**Link to Catalan divisibility:** none found.
**Restriction:** p = 2 in the two engineering sources; McEliece is stated for p-ary codes in its title only.

##### B6. Buddy allocator, Merkle mountain ranges, LSM tiering (d)

**Statements.**
- Buddy allocator: when a block is freed, its buddy is examined and the two are coalesced if it is free; the page credits Knowlton and Knuth.
- Grin MMR documentation: an append-only list of perfectly balanced binary trees, adding a parent as soon as two children exist. That the peaks are the 1-bits of the leaf count appears only in [snippet] implementation docs.
- RFC 9162, §2.1.1: the Merkle tree hash splits n inputs at k, the largest power of two smaller than n; the shape is determined by the number of leaves.
- Dayan–Athanassoulis–Idreos, §2: with tiering, up to T runs accumulate at a level and are then sort-merged into one run of the next level; T is the size ratio, anywhere from 2 upward.

**Usage.** Linux kernel; deployed blockchains and Certificate Transparency; production key-value stores.

**Correspondence.** State as a base-p (or base-T) expansion; atoms as perfect trees; coalescing two free buddies is literally collapsing a cherry of two equal atoms. Nothing is counted and no symmetry is involved.

**Sources.**
- [opened] https://www.kernel.org/doc/gorman/html/understand/understand009.html (chapter *Physical Page Allocation*; author not shown on the page). Knowlton, Comm. ACM 8(10) (1965) 623–625: [snippet].
- [opened] https://docs.grin.mw/wiki/chain-state/merkle-mountain-range/
- Laurie, Messeri, Stradling, RFC 9162 (2021) [opened] https://www.rfc-editor.org/rfc/rfc9162.txt.
- Dayan, Athanassoulis, Idreos, ACM Trans. Database Syst. 43(4), Article 16 (2018) [opened] https://cs-people.bu.edu/mathan/publications/tods18-dayan.pdf.

**Link to Catalan divisibility:** none.
**Restriction:** p = 2 for buddy and Merkle; any integer T ≥ 2 for LSM tiering.

#### C. Ranking of the six

1. **Chemistry symmetry numbers and steric trees (B1).** The only place I found all of (a), (b) and (e) as physical fact: a genuinely cyclic, non-reflecting group at tree nodes, a measured quantity equal to 3^(symmetric nodes), and a collapse procedure in a standard reference. Limited to p = 3; the Step 2 analogue is my inference.
2. **Phylogenetic symmetry nodes (B2).** Steps 1–3 and the minimal-class count exist verbatim as theorems in another field, in active use. Ranked second because for p = 2 rotation and reflection coincide, and because it is the already-known Deutsch–Sagan case.
3. **Binomial queues (B3).** The best operational meaning of the carry budget: exact comparison counts equal to Kummer's carries, on forests of atoms indexed by digits. No symmetry.
4. **Sylow subgroups and the adding machine (B4).** Works for every prime and explains why digits and wreath products appear. It is mathematics rather than another field, and it leans on Legendre's formula.
5. **Wrap-around carries and McEliece (B5).** The only verified home for (f), and a theorem of the same shape. The correspondence to your depth condition is conjectural on my part.
6. **Storage and hashing systems (B6).** Clean, widely deployed instances of "p equal pieces merge", including any integer base, but with no counting and no group.

Runners-up: Horton–Strahler (8) and D-ary Huffman (9).

#### D. What I could not verify

- **Not opened at all** (bibliographic data from snippets only): Pólya 1937; Longuet-Higgins 1963 (DOI and pages); Balasubramanian, J. Chem. Phys. 1980; Knowlton 1965; McEliece 1972; Horen–Riezman 1985 and the n!/2^(n−1) formula; Eppstein's spanning-tree report; Crandall–Fagin 1994; Takaoka's heaps; Veber's rotatable-bond definition; the journal data for Konvalinka, Deutsch–Sagan and Bóna–Flajolet.
- **Opened only in part**: Fernández-Ramos et al. (abstract only); Exploding Dots (machine name only); the Butcher-tree σ(τ) definition; the popcount statement for Merkle mountain ranges; the formal Z_p definition of PPA-p; the Anton–Stickelberger–Hensel congruence (image).
- **No source opened**: stereochemistry 2^n rule; merge games; mensural notation; the "false friends" judgment.
- **My own inferences, not in any source**: the chemistry dictionary and the identity A001764(n) = Σ 3^d (hand-checked for n ≤ 4); the bound N(int) ≤ 3^(v_3((2n+1)!)); the merge-tree reading of Vuillemin's costs; the link between end-around carry and the depth condition; the equivalence of Konvalinka's Remark 3 with your residue formula.

---

## Report B: source verification

#### Source-verification report (leads 1–13 + divisibility search)

**How to read this.** Everything below was opened during this task (arXiv PDFs, RFC text, OEIS text format, Numdam, university-hosted PDFs, Crossref/OpenAlex metadata). I am limited to one verbatim quotation per reply, so anchors are close paraphrases with page/section locators; the single verbatim quote is in the Konvalinka item. No repository file was edited.

**Blocked (so NOT VERIFIED where noted):** ScienceDirect, Project Euclid, IUPAC Gold Book, De Gruyter, the Z. Naturforsch. archive, Klivans' Brown-hosted PDF (certificate error), explodingdots.org.

##### Findings that change the claims
- **Problem 137's formula is Konvalinka's Proposition 2.** His proof of the exact value is arithmetic (factorial valuations); his group-action Proposition 7 proves divisibility only. Deutsch–Sagan give the fully combinatorial case p = q = 2. Details in the last section.
- **Etherington's mutability μ counts the unbalanced knots**, and 2^μ counts the non-commutative shapes of a commutative shape. So μ = (n−1) − s, not s.
- **The base-T digit statement is in Bentley–Saxe (radix-k "dual" transform, p. 323)**, not in O'Neil et al. and not in Dostoevsky.
- **Vuillemin states n − ν(n) explicitly**, and also that UNION costs exactly ν(n) + ν(n′) − ν(n+n′) comparisons (Kummer's carry count, though he does not name Kummer).
- **OEIS cites Pólya 1936**, not Pólya 1937, for A000625 and related entries.
- **Maurer 1975 could not be confirmed as a source for the tournament count**; the attribution comes from Wikipedia.

---

##### 1. Phylogenetics
(i) Sources opened:
- M. Steel, "Tracing evolutionary links between species", arXiv:1402.3771v1 (2014), https://arxiv.org/abs/1402.3771. Crossref gives the published version as Amer. Math. Monthly 121(9) (2014) 771–792, DOI 10.4169/amer.math.monthly.121.09.771 (published text not opened).
- M. Steel, "Neutral phylogenetic models and their role in tree-based biodiversity measures", arXiv:2405.17833v3 (2024). Crossref: Phil. Trans. R. Soc. B 380(1919) (2025), DOI 10.1098/rstb.2023.0308.
- T. Wu, K. P. Choi, "On joint subtree distributions under two evolutionary models", arXiv:1508.03139.
- S. Billey, M. Konvalinka, F. Matsen, "On the enumeration of tanglegrams and tangled chains", arXiv:1507.04976.

(ii) What they state:
- **n!/2^s:** Steel 2014, Section 2 (arXiv p. 5), by orbit–stabilizer: the number of trees of the shape of T is n!/|Stab(T)|, and Stab(T) has order 2^{s(T)}. Example: the 4-leaf fork has s = 3, stabilizer of order 8 (dihedral), 4!/2³ = 3 trees. He adds that Stab(T) is in general described by wreath products. Steel 2024 (arXiv p. 3) states n!/2^{s(τ)} directly.
- **(2n−3)!!:** Steel 2014, pp. 4–5: r(n) = (2n−3)·r(n−1), r(2) = 1.
- **Yule–Harding:** Steel 2014, Prop. 3.2 (p. 7): P(T) = 2^{n−1} / (n! · ∏ λ_v), λ_v = (leaves below v) − 1. Steel 2024 (p. 3): p(τ) = 2^{n−1−s(τ)} / ∏ n_τ(v), same meaning of n_τ(v); worked example 2^{5−1−3}/(4·3·1·1) = 1/6. He attributes the recursive description to Harding 1971.
- **Jordan's theorem:** Billey–Konvalinka–Matsen, p. 4: A(T) ≅ A(T₁) × A(T₂) if the subtrees differ, and A(T₁) ≀ Z₂ if they are equal.
- **Cherry:** Wu–Choi, Section 2: a cherry is a subtree with two leaves.

(iii) Corrections: none to the formulas. Harding's title per CUP/OpenAlex is "The probabilities of rooted tree-shapes generated by random bifurcation", Adv. Appl. Prob. 3 (1971) 44–77; Steel's reference list abbreviates it.

(iv) Terminology: Steel's term is *symmetry vertices*; Etherington's is *balanced* knots; Billey–Konvalinka–Matsen say *symmetries*. "Symmetric nodes" was not seen in any source opened. *Cherry* is standard.

NOT VERIFIED: McKenzie–Steel text (Crossref data only: Math. Biosci. 164(1) (2000) 81–92, DOI 10.1016/S0025-5564(99)00060-7); Semple–Steel 2003, Felsenstein 2004, Steel 2016 (book contents not opened).

##### 2. Stereochemistry and conformers
**(a) OEIS (text format, https://oeis.org/A000625 and /A000628).**
- A000625: n-node steric rooted ternary trees = n-carbon alkyl radicals C(n)H(2n+1) with stereoisomers. Children are in cyclic order: rotation gives the same tree, any other permutation a different one. G.f. A(x) = 1 + x(A(x)³ + 2A(x³))/3. Terms 1, 1, 1, 2, 5, 11, 28, 74, 199.
- A000628: n-node unrooted steric quartic trees = alkanes C(n)H(2n+2) with stereoisomers; A₄ acts at each node instead of S₄.
- References given: Blair & Henze, JACS 54 (1932) 1098–1106 and 1538–1545; Pólya, Z. Kristallogr. 93 (1936) 415–443, Eq. (25); Read 1976; Robinson, Harary, Balaban, Tetrahedron 32(3) (1976) 355–361, DOI 10.1016/0040-4020(76)80049-X; Leroux & Miloudi 1992; Percus lecture notes.

**(b) Symmetry numbers.**
- Fernández-Ramos et al., Theor. Chem. Acc. 118 (2007) 813–826, DOI 10.1007/s00214-007-0328-0 (Springer PDF). Section 3.5 (p. 821) defines σ_int for internal rotation; σ_int = 3 arises there for a torsion in the F + CH₄ transition state. The word "entropy" does not occur in the paper, and there is no general product rule. It does not support the claim as worded.
- Domalski & Hearing, "Estimation of the Thermodynamic Properties of Hydrocarbons at 298.15 K", J. Phys. Chem. Ref. Data 17(4) (1988) 1637–1678, DOI 10.1063/1.555814 (https://srd.nist.gov/jpcrdreprint/1.555814.pdf). This supports it fully:
  - Appendix D (about p. 1655): a methyl group has a three-fold axis, N(int) = 3; N(int) is the product over all rotors; N(tot) = N(int) × N(ext).
  - Section 3 (p. 1642): symmetry entropy R ln N(opt) + R ln N(tot), with the N(tot) term stated to enter negatively (the minus sign may be lost in the text layer; check the PDF).
  - Examples: ethane 3·3·2 = 18; 2-methylpropane 27·3 = 81; neopentane 81·12 = 972; 2,2-dimethylbutane 243.
  - Their recursive procedure counts a tert-butyl group as one more threefold rotor, and says non-symmetric terminal rotors do not affect N(tot).
- Gilson & Irikura, J. Phys. Chem. B 114(49) (2010) 16304–16317, DOI 10.1021/jp110434s (PMC3079527). Methyl rotation in ethane contributes a factor 3; benzene's σ = 12 contributes −R ln 12 to the entropy. The total is the order of the combined group (ethane 18, acetone 18), not phrased as a product rule.
- NOT VERIFIED: IUPAC Gold Book S06214 (search snippet only: label identical atoms, count arrangements reachable by rotation; source PAC 68 (1996) 149); Benson's book.
- Terminology: *internal / external / total symmetry number* (Domalski–Hearing); *symmetry number for internal rotation* (Fernández-Ramos).

**(c) Rotational isomeric states.** P. J. Flory, Nobel Lecture, 11 Dec 1974, "Spatial configuration of macromolecular chains" (https://www.nobelprize.org/uploads/2018/06/flory-lecture.pdf), printed pp. 167–169. Three staggered conformations trans, gauche-plus, gauche-minus; each bond is treated as being in one of three rotational isomeric states; weight matrix indexed t, g+, g−. He credits the foundations to M. V. Volkenstein and colleagues. His reference 24 is Flory, *Statistical Mechanics of Chain Molecules*, Interscience, New York, 1969 (book not opened). Flory's wording is *scheme* / *approximation*, not "model".

**(d) Conformer enumeration: literature exists.**
- OEIS A121179 (comment by Hadjicostas, 2019): number of all staggered conformers of alkyls with n carbons. G.f. 1 + (x/3)(B(x)³ + 2B(x³)), where B is the g.f. of A001764 = C(3n,n)/(2n+1). So a(n) = A001764(n)/3, plus (2/3)·A001764((n−1)/3) when n ≡ 1 mod 3.
- Papers behind it (metadata verified, full texts NOT opened):
  - Cyvin, Brunvoll, Cyvin, Lüttke, Z. Naturforsch. A 50(9) (1995) 857–863, DOI 10.1515/zna-1995-0911 (abstract: staggered conformers = graphs embeddable in the diamond lattice).
  - Cyvin, J. Math. Chem. 17 (1995) 291–293.
  - Wang, Cao, Li, J. Math. Chem. 20 (1996) 211–212.
  - Cyvin et al., J. Mol. Struct. 413–414 (1997) 227–239.
- Also: Tasi, Mizukami, Pálinkó, Csontos, Győrffy, Nair, Maeda, Toba, Niwa, Kiyozumi, Kiricsi, J. Phys. Chem. A 102(39) (1998) 7698–7703; Fărcaşiu, Walter, Sheils, J. Comput. Chem. 10(4) (1989) 520–528; OEIS A120540 (C-rotamers; Balaban 1976).
- A formula "3^(number of non-threefold rotors)" was not found stated anywhere; Domalski–Hearing's 3^(number of threefold rotors) is the complementary count.
- Unopened lead: Eriksen & Merkle, arXiv:2609.02932 (listed in A000625).

##### 3. Sylow subgroups of S_n
(i) L. Kaloujnine, Ann. Sci. École Norm. Sup. (3) 65 (1948) **239–276**, DOI 10.24033/asens.961, https://www.numdam.org/item/ASENS_1948_3_65__239_0/ (page images read).

(ii) What it states:
- Introduction, p. 239: for n = a₀ + a₁p + … + a_m p^m, a Sylow p-subgroup of S_n is isomorphic to P₁^{a₁} × … × P_m^{a_m}, with P_m the Sylow p-subgroup of S_{p^m}.
- Chapter I, p. 241: |P_m| = p^{p^{m−1} + … + p + 1}.

(iii) Corrections:
- This paper describes P_m by *tableaux* of polynomials; no wreath-product term was found in its text.
- Wreath-product form verified elsewhere: Giannelli & Law, arXiv:1712.02642, Section 2 (P_{p^i} = P_{p^{i−1}} ≀ P_p; P_n ≅ ∏ (P_{p^i})^{b_i}; p odd there; they refer to James–Kerber Ch. 4). Erdmann & Tan, arXiv:0906.5390, p. 7, state the claim's sentence almost verbatim.
- Drozd & Skuratovski, arXiv:0810.0769, cite Kaloujnine, C. R. Acad. Sci. Paris 221 (1945) 222–224, and Rotman (1995) Theorem 7.27, noting that Rotman's bibliographic reference there is wrong.
- The order p^{(n − s_p(n))/(p−1)} was not found verbatim in an opened source; it follows from Kaloujnine's two statements.
- NOT VERIFIED: Rotman, Huppert, Dixon–Mortimer.

Fixed-point congruence:
- K. Conrad, "The Sylow theorems" (https://kconrad.math.uconn.edu/blurbs/grouptheory/sylowpf.pdf), eq. (2.1): |X| ≡ |Fix(X)| mod p, used for Sylow I–III.
- McKay: Amer. Math. Monthly 66(2) (1959) 119, DOI 10.2307/2310010. An IMSc tutorial (https://www.imsc.res.in/~knr/past/KSoM_algebra_2021/tut03.pdf) presents the McKay proof: C_p shifts p-tuples with product 1, and |S| ≡ |S^C| mod p.
- Wielandt: Arch. Math. 10 (1959) 401–402, DOI 10.1007/BF01240818. Per Kammüller & Paulson (UCAM-CL-TR-452), his proof acts on subsets of size p^α and uses a divisibility property of a binomial coefficient. That is orbit counting, not the fixed-point congruence as such.

(iv) *Fixed-point congruence* is Conrad's name, not a universal one.

##### 4. Knockout tournaments
- OEIS A001190 name: Wedderburn–Etherington numbers, unlabeled binary rooted trees (outdegree 0 or 2) with n endpoints. None of its seven comments mentions tournaments, and Maurer is not among its references or links.
- W. Maurer, Ann. Statist. 3(3) (1975) 717–727, DOI 10.1214/aos/1176343135. The abstract (via OpenAlex) is about which plans maximise the best player's winning probability; it says nothing about counting. Full text NOT VERIFIED.
- Verified statements of the count:
  - T. Oshima, arXiv:2504.09003, Introduction: isomorphism classes of tournaments of n teams are counted by the n-th Wedderburn–Etherington number.
  - OEIS A096351 (L. B. Anderson, 2004): neutral single-elimination tournaments with n teams, a(n) = n!/2^{A268289(n−1)}; references David 1988, Searls 1963, Narayana & Agyepong 1979.
  - OEIS A067667: (2^n)!/2^{2^n−1} = knockout seedings with 2^n teams = heap-ordered binomial trees = largest odd divisor of (2^n)!.

##### 5. Binomial heaps
- J. Vuillemin, Comm. ACM 21(4) (1978) 309–315, DOI 10.1145/359460.359478 (https://www.cl.cam.ac.uk/teaching/1011/AlgorithII/1978-Vuillemin-queues.pdf).
  - p. 310: a forest F_n has one B_i for each 1 in the binary decomposition of n.
  - p. 311: UNION by analogy with binary addition, a carry propagated at each step.
  - p. 311: building by n INSERTs takes n − ν(n) comparisons, equal to the carries in 1 + 1 + … + 1 and to the number of edges.
  - p. 311: UNION takes exactly ν(n) + ν(n′) − ν(n+n′) comparisons.
  - His terms are *binomial queue* / *binomial forest*, and he counts comparisons.
- C. Okasaki, thesis CMU-CS-96-177 (1996), Ch. 6 "Numerical Representations", §6.2.2 (https://www.cs.cmu.edu/~rwh/students/okasaki.pdf): insertion is like incrementing a binary number and linking equal-rank trees is the carry. The count n − ν(n) was not found there. Book: CUP 1998, DOI 10.1017/CBO9780511530104, Chapter 9 "Numerical Representations", pp. 115–140 (contents page only).
- M. R. Brown, SIAM J. Comput. 7(3) (1978) 298–319, DOI 10.1137/0207026: abstract only.
- NOT VERIFIED: Cormen et al.
- OEIS A049606 (largest odd divisor of n!) carries comments that it counts binomial heaps with n nodes and Sylow 2-subgroups of S_n.

##### 6. LSM trees and the logarithmic method
- O'Neil, Cheng, Gawlick, O'Neil, Acta Inform. 33(4) (1996) 351–385, DOI 10.1007/s002360050048 (https://www.cs.umb.edu/~poneil/lsmtree.pdf): components C₀…C_K, rolling merge, sizes in geometric progression (Theorem 3.1). No tiering, no runs per level, no digits.
- Dayan & Idreos, "Dostoevsky", SIGMOD 2018, pp. 505–520, DOI 10.1145/3183713.3196927 (author copy https://nivdayan.github.io/dostoevsky.pdf), Section 2 (p. 3): with tiering, runs in a level are merged only when the level reaches capacity (credited to Jagadish et al., VLDB 1997); with leveling, whenever a new run arrives (credited to O'Neil et al.). In Fluid LSM-tree, K = Z = T−1 gives tiering. No digit or counter statement.
- Bentley & Saxe, J. Algorithms 1(4) (1980) 301–358, DOI 10.1016/0196-6774(80)90015-2 (https://www.ime.usp.br/~cris/aulas/19_1_6957/BentleyS1980-DSP.pdf):
  - §3.1, pp. 305–306: structures correspond to the one bits of N (79 → 64, 8, 4, 2, 1); insertion by binary counting.
  - p. 323: the dual ternary transform has zero, one or two structures of each power of 3, matching the ternary digit; extended to radix k.
  - Their name is *binary transform*; "logarithmic method" does not appear.

##### 7. Merkle trees
- RFC 6962 (Laurie, Langley, Kasper, June 2013), §2.1, and RFC 9162 (Laurie, Messeri, Stradling, Dec 2021, obsoletes 6962), §2.1.1: for n > 1, k is the largest power of two smaller than n, i.e. k < n ≤ 2k; MTH(D[n]) = HASH(0x01 || MTH(D[0:k]) || MTH(D[k:n])). Claim verified; note "smaller" is strict.
- Merkle mountain range: Peter Todd's note in the opentimestamps-server repository (doc/merkle-mountain-range.md) builds the largest possible perfect trees; Grin's doc/mmr.md calls it a list of perfectly balanced binary trees and cites Todd. Neither says "one per 1 bit". The miden-crypto 0.25.1 source docs do: number of set bits of the leaf count = number of peaks.

##### 8. End-around carry
RFC 1071 (Braden, Borman, Partridge, Sept 1988), §1: 16-bit one's complement sum; on a two's complement machine, overflows from the top bits are added into the low bits (*end around carry*, their term). The main text does not say "modulo 2^16 − 1". The appended IEN 45 (Plummer, 1978) does the casting-out argument: with radix 2^16 and check factor 2^16 − 1, the remainder is found by summing the 16-bit words with end-around carries. It also notes two identity elements, +0 and −0.

##### 9. Exploding Dots / chip-firing
- Global Math Project teacher guide "Adventures in Exploding Dots, Lesson 1", © 2020 James Tanton (https://gdaymath.com/wp-content/uploads/2020/09/Adventures-in-Exploding-Dots_Lesson-1.pdf): in a 1 ← 2 machine, pairs of dots in a box explode into one dot one box to the left; presented as the story of place value. Tanton's page https://gdaymath.com/lessons/explodingdots/1-5-wild-explorations/ uses the 1 ← 10 machine (code of 273 is 273). The word "carrying" was not seen.
- Borodin, Han, Ji, Khovanova, Peng, Sun, Tu, Yang, Yang, Zhang, Zhao, "Chip-Firing and Fractional Bases", arXiv:1809.09676: a chip-firing game on the integer line suggested by Propp; b dots exploding into a dots to the left is identified with Tanton's exploding dots.
- Klivans, *The Mathematics of Chip-Firing* (Chapman & Hall, 2019): the publisher's contents list (https://www.routledge.com/The-Mathematics-of-Chip-Firing/Klivans/p/book/9781138634091) has a section on the one-dimensional grid in Chapter 5 and nothing on carrying or number systems. Book text NOT VERIFIED.

##### 10. Symmetry factors
- M. Srednicki, *Quantum Field Theory*, draft © 2006 (https://web.physics.ucsb.edu/~mark/ms-qft-DRAFT.pdf; marked do-not-distribute, link only).
  - Ch. 9, p. 74: the symmetry factor is the overcounting factor from rearrangements. For the φ³ tree with four sources and two vertices (fig. 9.10), S = 2·2·2 = 8.
  - Ch. 10: the 4! labelings of that diagram fall into 3 groups of 8; labelled tree diagrams have symmetry factor 1.
  - The word "automorphism" does not occur in the draft.
- P. Etingof, "Mathematical ideas and notions of quantum field theory", arXiv:2409.03117v2, Theorem 3.5 (p. 31): each graph is weighted by 1/|Aut(Γ)|, automorphisms fixing external vertices. §3.7 gives the tree sum with the same weight.
- The "identical subtrees give a factor 2" rule was not found as a general statement; Srednicki's fig. 9.10 is an instance.
- NOT VERIFIED: Peskin–Schroeder §4.4.

##### 11. OEIS checks
- A398107 exists: array T(n,k) = number of k-ary mobiles (circular rooted trees) with n internal nodes. Andrew Howroyd, Jul 20 2026. Columns include A001190 (k=2), A000625 (k=3), A036719 (k=4).
- A398109 exists: number of 4-ary dyslexic mobiles with n internal nodes. Howroyd, Jul 20 2026. It is column 4 of A398108 (dihedral group).
- Mobiles: A032200 (rooted compound windmills (mobiles) of n nodes, Bower); A055340 (mobiles by nodes and leaves, Bower 2000); A038037 (labeled). The OEIS index has a "mobiles" section.
- Wedderburn–Etherington: A001190.
- Alkyl radicals: A000625 (with stereoisomers), A000598 (without), A000620–A000624 (Blair–Henze classes); alkanes A000628 / A000602.

##### 12. Stacked triangulations
M. Albenque, J.-F. Marckert, "Some families of increasing planar maps", arXiv:0712.0593; Crossref: Electron. J. Probab. 13 (2008) 1624–1671, DOI 10.1214/ejp.v13-563. Proposition 1 (§2.3.2, p. 10): a bijection between rooted stack-triangulations with 2K faces and ternary trees with 3K−2 nodes; internal vertices correspond to internal nodes, finite faces to leaves. That is K−1 internal vertices ↔ K−1 internal nodes, so the claim holds. They call the bijection apparently classical and cite Darrasse & Soria (2007). Their term is *stack-triangulations*. OEIS A001764 has a matching comment (Apollonian networks with a given base triangle).

##### 13. Etherington
- Scan (https://oeis.org/A000108/a000108_13.pdf): "XV.—On Non-Associative Combinations", I. M. H. Etherington; MS received 18 Oct 1938, read 1 May 1939; first page 153.
- Cambridge/Crossref: Proc. Roy. Soc. Edinburgh 59, pp. 153–162, **year 1940**, DOI 10.1017/S0370164600012244. OEIS writes "59 (Part 2, 1938–39)"; Steel cites 1940. "1939" is the reading date, not the publisher's year.
- p. 156: a knot is *balanced* if its two factors are conformal; the number of **unbalanced** knots is the *mutability* μ. A shape of mutability μ corresponds to exactly 2^μ distinct non-commutative shapes. *Pedigree*, *knot*, *altitude*, *conformal* are his terms; "arrangements" is not his word.

---

#### Divisibility literature (leads 1–10)

**Found:**
- **E. Deutsch, B. Sagan**, "Congruences for Catalan and Motzkin numbers and related sequences", arXiv:math/0407326; J. Number Theory 117(1) (2006) 191–215, DOI 10.1016/j.jnt.2005.06.005.
  - Theorem 2.1 (p. 3): the 2-adic valuation of C_n is s₂(n+1) − 1, proved combinatorially.
  - Lemma 2.2: the automorphism group G_h of the complete binary tree satisfies G_h = Z₂ ≀ G_{h−1}, of order 2^{2^h − 1}.
  - Lemma 2.3: every orbit on binary trees with n vertices has valuation ≥ d = s₂(n+1) − 1, with equality for an odd number of orbits (their (2d)!!).
- **A. Postnikov, B. Sagan**, "What power of two divides a weighted Catalan number?", arXiv:math/0601339; JCTA 114(5) (2007) 970–977, DOI 10.1016/j.jcta.2006.09.007. Extends the Deutsch–Sagan proof to weighted Catalan numbers.
- **M. Konvalinka**, "Divisibility of generalized Catalan numbers", JCTA 114(6) (2007) 1089–1100, DOI 10.1016/j.jcta.2006.11.003; author's preprint read at https://users.fmf.uni-lj.si/konvalinka/wcatalan.pdf (numbering may differ in print).
  - Proposition 2 (p. 2): for q = p^k, the p-adic valuation of C_n^(q) = C(qn,n)/((q−1)n+1) is (s_p((q−1)n+1) − 1)/(p−1). Proof by factorial valuations.
  - Proposition 7 (p. 6): every orbit of the symmetry group of the complete q-ary tree on q-ary trees with n vertices is divisible by p^ξ. He calls this "a combinatorial proof of only a part of Proposition 2".
  - Minimal orbits (pp. 7–11, Lemmas 8–10): vertices are coloured black if all branches are equivalent; exactness of the minimal orbit's valuation is taken from Proposition 2.
- **Y. Gao, A. Gu**, "Arithmetic of weighted Catalan numbers", arXiv:1908.03914; J. Number Theory 226 (2021) 213–242. Restates the structure of minimal orbits for p = 2 and strengthens Konvalinka's weighted result. It notes that An resolved Konvalinka's conjecture arithmetically.
- R. Alter, K. Kubota, JCTA 15(3) (1973) 243–256 (arithmetic); K. Ji, H. Wilf, "Extreme Palindromes", arXiv:math/0611465 (parity of Catalan numbers by a tree method).

**Searched, nothing found** linking the item to Catalan or Fuss–Catalan divisibility:
- Phylogenetic tree shapes or symmetric nodes with Catalan parity (only the papers above).
- "Sylow symmetric group Catalan" (only OEIS A049606's Sylow comment and representation-theory papers).
- Binomial heaps with Kummer or Catalan (Vuillemin's count is the only link, and he does not name Kummer).
- Knockout tournaments with Catalan parity (only A067667's odd-part comment).
- Ternary trees, alkyl stereoisomers or conformers with 3-adic divisibility.
- Chip-firing or exploding dots with Kummer or Catalan.
- Feynman symmetry factors, Merkle trees, LSM-trees or the Internet checksum with Catalan numbers.
- A later fully combinatorial proof of exactness for general p^k after Konvalinka.
