# Cross-field literature and fact check — written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context) on 2026-11-14; NOT human-reviewed; only web pages and API records were read

Scope and method, in short:

- Bibliographic fields come from the Crossref API (`api.crossref.org`), the OpenAlex API (`api.openalex.org`), the arXiv API (`export.arxiv.org`), publisher pages, the Library of Congress catalogue, or the reference list of an opened open-access paper. Where a field was not shown by a source I opened, it says **not confirmed**. Nothing is filled in from memory.
- "ar5iv" means the HTML rendering of an arXiv preprint at `ar5iv.labs.arxiv.org`. These are preprint versions, not the published versions.
- No prose is quoted verbatim; statements are paraphrased. Formulas and titles are given as the sources give them.
- Nothing was saved into the repository except this file. One incident to disclose: a WebFetch of `https://www.cs.princeton.edu/~wayne/cs423/lectures/heaps` turned out to be a PDF; the tool stored a copy in the Claude session's own `tool-results` folder (under the user profile, outside the repository). Its text could not be read and it is not used below.
- Sites/tools that blocked or failed (so nothing from them is used): MIT Press book page (HTTP 403), AMS Bookstore (403), IUPAC Gold Book (403), O'Reilly (403), the PubMed Central web page (reCAPTCHA; not bypassed — the public PMC OAI service was used instead), Project Euclid article page (empty response), Semantic Scholar API (HTTP 429 on every attempt, five attempts), Google Books API (quota error), `classes.cs.uchicago.edu` and `people.ksp.sk` (DNS failure), `encyclopediaofmath.org` (502), Europe PMC full-text endpoint (500).

Summary table:

| # | Item | Status |
|---|---|---|
| 1 | Binomial heaps | (a) VERIFIED; (b) PARTLY VERIFIED |
| 2 | Binary counter, amortized analysis | PARTLY VERIFIED |
| 3 | A001190 and knockout tournaments | VERIFIED (answer: no such comment in A001190) |
| 4 | δ-rings, Joyal, Buium, Bhatt–Scholze | definition VERIFIED; Joyal PARTLY VERIFIED; Buium, Bhatt–Scholze VERIFIED |
| 5 | Symmetry numbers in chemistry | reference VERIFIED; one of our three facts needs rewording |
| 6 | Ultrametricity, hierarchical model, p-adic | VERIFIED (with one nuance on Dyson's abstract) |
| 7 | Kraft equality | PARTLY VERIFIED |
| 8 | Prior-art searches | nothing found for (i), (ii), (iv); (iii) answered: yes, Σ z^(p^n) |
| 9 | Dwork exponential, Legendre | VERIFIED from secondary sources; the three named primary/textbook sources were not opened |

---

## 1. Binomial heaps

### 1(a) The paper — **Status: VERIFIED**

As returned by Crossref (`https://api.crossref.org/works/10.1145/359460.359478`) and OpenAlex (same DOI):

- Author: Jean Vuillemin (affiliation in the Crossref record: Univ. de Paris-Sud, Orsay, France). OpenAlex displays the name as Jean E. Vuillemin.
- Title: "A data structure for manipulating priority queues"
- Journal: Communications of the ACM, volume 21, issue 4, pages 309–315, April 1978. Publisher: Association for Computing Machinery (ACM).
- DOI: 10.1145/359460.359478

What the abstract says (Crossref/OpenAlex): it describes a data structure for representing a collection of priority queues, with the operations insertion, deletion, union, update and search for the item of earliest priority. The abstract does **not** contain the word "binomial".

Attribution of the name: the abstract of Mark R. Brown, "Implementation and Analysis of Binomial Queue Algorithms", SIAM Journal on Computing 7 (3), 298–319, August 1978, DOI 10.1137/0207026 (Crossref + OpenAlex) says that the binomial queue was recently discovered by Jean Vuillemin. So "introduced by Vuillemin (1978)" is supported; the term used in 1978 is binomial *queue*.

Nothing contradicts what we believed.

### 1(b) The two facts — **Status: PARTLY VERIFIED** (stated explicitly only on Wikipedia; supported by a NIST page and a Cornell course page; the textbook chapter was not opened)

Sources opened:

- NIST Dictionary of Algorithms and Data Structures, entry "binomial heap" (author of the entry: Paul E. Black), `https://xlinux.nist.gov/dads/HTML/binomialheap.html`. It defines a binomial heap as a forest of binomial trees numbered k = 0, 1, 2, …, each containing either 0 or 2^k nodes, each tree formed by linking two of its predecessors. It does not mention binary representation or binary addition. *Our one-line deduction:* since the tree sizes are distinct powers of two summing to n, the trees present are exactly those at the 1-bits of n.
- Cornell CS410 (Fall 1999) lecture notes, plain-text page `https://www.cs.cornell.edu/courses/cs410/1999fa/Lectures/lec6.txt`. It represents a binomial heap as an array whose slot i holds a tree B(i) or is empty, says trees are linked only when of the same rank, and says that merging takes O(log n) because it works like binary addition. It also gives the credit argument for O(1) amortized insertion (one credit stored on every tree; a link is paid by the credit of the tree that becomes a child).
- Wikipedia, "Binomial heap", `https://en.wikipedia.org/wiki/Binomial_heap` (pointer only). It states both facts explicitly: one binomial tree for each nonzero bit of n (example 13 = 1101 gives orders 3, 2, 0), and merging two heaps is analogous to adding the two sizes in binary from right to left, a carry corresponding to merging two trees of the same order.

Textbook reference as cited by Wikipedia (not opened by me): Cormen, Leiserson, Rivest, Stein, *Introduction to Algorithms*, 2nd ed., MIT Press and McGraw-Hill, 2001, Chapter 19 "Binomial Heaps", pp. 455–475, ISBN 0-262-03293-7. **Chapter and pages not confirmed from a publisher source.**

Useful extra (verified): Ralf Hinze, "Explaining binomial heaps", Journal of Functional Programming 9 (1), 93–104, January 1999, DOI 10.1017/S0956796899003317 (Crossref; Cambridge Core page opened). Its abstract says the paper derives binomial heaps step by step from the metaphor of a tennis tournament. This is a published link between items 1 and 3 (binomial heaps ↔ knockout tournaments). Only the abstract was read.

---

## 2. Amortized analysis of a binary counter — **Status: PARTLY VERIFIED**

**The textbook.** MIT Press's own page (`https://mitpress.mit.edu/9780262046305/introduction-to-algorithms/`) returned HTTP 403, so the publisher page could **not** be opened. What I could open:

- Library of Congress MARC record, `https://lccn.loc.gov/2021037260/marcxml`: Cormen, Thomas H.; *Introduction to algorithms* / Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein. Fourth edition. Cambridge, Massachusett[s]: The MIT Press, [2022]. xx, 1291 pages. ISBN 9780262046305. LCCN 2021037260.
- Open Library record `https://openlibrary.org/isbn/9780262046305.json`: title "Introduction to Algorithms, Fourth Edition", MIT Press, 2022, ISBN-13 9780262046305, 1332 pages. (Page counts differ between catalogues: 1291 vs 1332; a search-engine snippet of the MIT Press page said 1312. **Page count not confirmed.**)
- Chapter title. For the **third** edition: the MIT OpenCourseWare readings page for 6.046J (`https://ocw.mit.edu/courses/6-046j-introduction-to-algorithms-sma-5503-fall-2005/pages/readings/`) cites Cormen, Leiserson, Rivest, Stein, *Introduction to Algorithms*, 3rd ed., MIT Press, 2009, ISBN 9780262033848, and assigns Chapter 17 to the lecture "Amortized Algorithms, Table Doubling, Potential Method". For the **second** edition, Wikipedia's "Potential method" page cites section 17.3 "The potential method", pp. 412–416, ISBN 0-262-03293-7. For the **fourth** edition, a web-search snippet attributed to MIT Press's transition guide says amortized analysis is Chapter 16; I could not open that document. **Fourth-edition chapter number (16) not confirmed from an opened source.** Safest citation: third edition, Chapter 17 "Amortized Analysis", with the ISBN above — and check the chapter heading in a physical copy.

**The two facts.**

- University of Waterloo CS466 lecture notes by Rafael Oliveira, "Amortized Analysis", `https://cs.uwaterloo.ca/~r5olivei/courses/2025-spring-cs466/lecture-notes/lecture1/` (HTML, opened). They show that n increments of a binary counter starting at zero flip at most 2n bits in total (bound stated as T(n) ≤ 2n), take as potential the number of bits equal to 1, and get amortized cost 2 per increment because each increment turns exactly one bit from 0 to 1.
- Wikipedia "Potential method" (pointer): same potential (number of 1 bits), amortized cost 2.
- Primary source for the potential method, bibliographic data only (Crossref): Robert Endre Tarjan, "Amortized Computational Complexity", SIAM Journal on Algebraic Discrete Methods 6 (2), 306–318, April 1985, DOI 10.1137/0606031. Content not read.

**Difference from what we believed.** We wrote "fewer than 2n". The source I opened states "at most 2n". The strict inequality is true but was not found verbatim. *Our own computation (not from a source):* bit i flips ⌊n/2^i⌋ times, so the exact total is Σ_{i≥0} ⌊n/2^i⌋ = n + v_2(n!) = 2n − s_2(n). So the total number of flips is 2n minus the final potential — which is precisely the amortized identity, and it is Legendre's formula in disguise (see 9(d)). This is worth saying in the talk, but as our remark, not as a citation.

---

## 3. Knockout tournaments and OEIS — **Status: VERIFIED** (the answer is negative for A001190)

Source: `https://oeis.org/search?q=id:A001190&fmt=json` (revision 348, last modified 2026-11-13) and the same for A000625, A096351, A268289, A335833.

**A001190.** Name line: "Wedderburn-Etherington numbers: unlabeled binary rooted trees (every node has outdegree 0 or 2) with n endpoints (and 2n-1 nodes in all)."

No comment in A001190 mentions single-elimination or knockout tournaments, brackets or seedings. The only occurrence of the word "tournament" in the whole entry is the title of a reference (A. Gutiérrez-Sánchez, *Shen-colored tournaments*, thesis, UNAM, 2012), which goes with Abraham Gutiérrez's comment of Nov 12 2012 about edge-colourings of the complete graph K_n — "tournament" there is the graph-theory term, not a sports bracket.

Comments that are mathematically equivalent to "unseeded bracket shapes":

- An unsigned comment: a(n) is the number of ways to parenthesize x^n when multiplication is commutative but not associative (with a bracketed note by Jianing Song, Apr 29 2022, that the non-commutative count is A000108(n−1)). A bracket for n unnamed players is exactly such a product, but the entry does not say so.
- Geoffrey Critzer, Nov 09 2014 (corrected by Eric W. Weisstein, Oct 13 2026): for n > 1, a(n) counts unordered pairs of unlabeled full binary rooted trees with n leaves in total.
- Piet Hut, Nov 07 2003: number of ways to place n stars in a single bound stable hierarchical multiple star system.

**Where the tournament reading does appear.**

- Wikipedia, "Wedderburn–Etherington number" (pointer): lists, among interpretations, the number of ways of organizing a single-elimination tournament for n players, citing Willi Maurer, "On Most Effective Tournament Plans With Fewer Games than Competitors", The Annals of Statistics 3 (3), 717–727, 1975, DOI 10.1214/aos/1176343135 (bibliographic data confirmed by Crossref and OpenAlex). Maurer's abstract (Crossref) is about knockout ("k.o.") plans and which plan gives the best player the highest chance of winning; it does **not** mention counting plans or the Wedderburn–Etherington numbers. So the counting statement is supported only by Wikipedia's reading of that paper; I did not read the paper.
- OEIS **A096351**, Name line: "Number of meaningfully different ways to design a neutral single-elimination tournament with n teams." (author Lowell Bruce Anderson, Jun 29 2004). This counts *labelled* seedings of the balanced bracket: formulas there give a(n) = n!/2^(n−1) when n is a power of 2, and a(n) = n!/2^(A268289(n−1)) in general (Laura Monroe, Jun 11 2020).
- OEIS **A268289**, comments by Laura Monroe (Jun 11 2020 and Oct 23 2020): a(n) is the number of internal nodes of the balanced ("pairwise") tree with n+1 leaves whose two children have equally many leaves, the tree of a neutral single-elimination tournament is given as an example, and 2^a(n) is the number of automorphisms of that tree. So the OEIS already records "labelled brackets = n!/|Aut|, with |Aut| a power of 2 counted by symmetric nodes" for the balanced bracket.
- OEIS **A335833** (Laura Monroe, Jun 25 2020) tabulates full binary trees by the number of such nodes. Note the caution added there by Andrew Howroyd (Mar 25 2023): the sequence counts trees with "left has at least as many leaves as right", which is not the same as trees up to swapping children; row sums are A000992, not A001190, and they differ from n = 8 on.

**A000625.** Exact Name line: "Number of n-node steric rooted ternary trees; number of n carbon alkyl radicals C(n)H(2n+1) taking stereoisomers into account."

Its comments say that "steric" means the children of a node are taken in a cyclic order (rotating them gives the same tree, any other permutation a different one), and that A000598 is the analogous sequence without stereoisomers.

**Contradiction with what we believed:** if any note of ours says "the OEIS entry A001190 describes these numbers as tournament brackets", that is wrong. Cite Wikipedia/Maurer for the bracket reading (weak), or A096351/A268289 for the labelled balanced bracket (solid), or simply state the equivalence ourselves.

---

## 4. δ-rings / p-derivations

### Definition and sign convention — **Status: VERIFIED**

Source: Bhatt–Scholze, "Prisms and prismatic cohomology", arXiv:1905.08229 (v4), read at `https://ar5iv.labs.arxiv.org/html/1905.08229`; Definition 2.1, Remarks 1.2, 2.2, 2.4, 2.7, Example 2.6.

- Definition 2.1: a δ-ring is a pair (R, δ), R a commutative ring, δ: R → R a map of sets with δ(0) = δ(1) = 0 and
  - δ(xy) = x^p δ(y) + y^p δ(x) + p δ(x) δ(y),
  - δ(x + y) = δ(x) + δ(y) + (x^p + y^p − (x + y)^p)/p.
  The paper adds that a δ-structure is often called a p-derivation. (All rings there are Z_(p)-algebras.)
- Remark 2.2: φ(x) = x^p + p δ(x) is then a ring homomorphism lifting Frobenius on R/p; if R is p-torsion-free, every Frobenius lift φ comes from a unique δ, namely δ(x) = (φ(x) − x^p)/p. **Sign: plus p·δ, i.e. δ = (φ − x^p)/p.**
- Example 2.6: on Z_(p) (φ = identity) the unique δ is δ(x) = (x − x^p)/p; it lowers the p-adic valuation by exactly 1 on non-units, and Z_(p) is the initial δ-ring. (So with this convention δ is *minus* the expression (x^p − x)/p.)
- Remark 1.2: the name p-derivation is explained by δ lowering the p-adic order of vanishing by 1.
- Remark 2.4 (following Rezk): a δ-structure on R is the same as a ring-map section R → W_2(R), x ↦ (x, δ(x)), of the length-2 Witt vectors. Remark 2.7: the forgetful functor from δ-rings to rings has the p-typical Witt vector functor W as right adjoint, a result the paper attributes to Joyal.

### Joyal 1985 — **Status: PARTLY VERIFIED**

Only source: the reference list of Bhatt–Scholze (ar5iv page above), entry [Joy85]: A. Joyal, "δ-anneaux et vecteurs de Witt", C. R. Math. Rep. Acad. Sci. Canada 7 (1985), no. 3, 177–182. Their Remark 1.2 says the notion of δ-ring was introduced by Joyal in this paper.

Crossref and OpenAlex have **no record** of this paper (queries "Joyal delta-anneaux et vecteurs de Witt" and the title with δ returned unrelated works), so volume/issue/pages rest on Bhatt–Scholze's citation alone. No DOI found. Matches what we believed.

### Buium — **Status: VERIFIED** (bibliographic data; content only at abstract level)

- Alexandru Buium, "Differential characters of abelian varieties over p-adic fields", Inventiones Mathematicae 122 (1), 309–340, December 1995, DOI 10.1007/BF01231447 (Crossref; Springer page). No abstract is available in Crossref, OpenAlex or on the Springer page, so **what this paper says about the Fermat quotient is not confirmed**.
- Alexandru Buium, "Geometry of p-jets", Duke Mathematical Journal 82 (2), 349–367, 1 February 1996, DOI 10.1215/S0012-7094-96-08216-2 (Crossref). No abstract available.
- Alexandru Buium, "Arithmetic Analogues of Derivations", Journal of Algebra 198 (1), 290–299, December 1997, DOI 10.1006/jabr.1997.7177 (Crossref). **This is the paper Bhatt–Scholze cite** (as [Bui97]) for Buium's extensive study of δ-rings under the name p-derivations.
- Book: Alexandru Buium, *Arithmetic Differential Equations*, series Mathematical Surveys and Monographs, American Mathematical Society, published 2005-09-20, DOI 10.1090/surv/118, ISBNs 9780821838624 and 9781470413453 (Crossref). The Crossref record does not give a volume number; the DOI suffix is surv/118. The AMS Bookstore page returned 403. **Volume number 118: inferred from the DOI only.** OpenAlex lists the contents (preliminaries from algebraic geometry, outline of δ-geometry, global/local/birational theory, correspondences).
- "Derivative with respect to p / Fermat quotient": confirmed at abstract level from Buium's survey "Differential calculus with integers", arXiv:1308.5194 (abs page opened), published as a chapter in *Arithmetic and Geometry*, Cambridge University Press, 2015, pp. 139–187, DOI 10.1017/CBO9781316106877.011 (Crossref). Its abstract says that ordinary differential equations have an arithmetic analogue in which functions are replaced by numbers and the derivation operator by a Fermat quotient operator.

Correction to our wording: for "who called δ a p-derivation", the citation supported by a source is Buium 1997 (J. Algebra), via Bhatt–Scholze, not specifically the 1995 Inventiones paper. The phrase "derivative with respect to p" itself was not found verbatim in anything I opened.

### Bhatt–Scholze — **Status: VERIFIED**

Bhargav Bhatt, Peter Scholze, "Prisms and prismatic cohomology", Annals of Mathematics 196 (3), 1135–1275, 1 November 2022, DOI 10.4007/annals.2022.196.3.5 (Crossref; OpenAlex gives publication date 2022-10-30). arXiv:1905.08229. The abstract introduces prisms and the prismatic site; δ-rings are background (Section 2).

---

## 5. Symmetry numbers in chemistry

### The reference — **Status: VERIFIED**

Crossref, OpenAlex and the Springer page `https://link.springer.com/article/10.1007/s00214-007-0328-0`:

- Antonio Fernández-Ramos, Benjamin A. Ellingson, Rubén Meana-Pañeda, Jorge M. C. Marques, Donald G. Truhlar
- "Symmetry numbers and chemical reaction rates"
- Theoretical Chemistry Accounts, volume 118, issue 4, pages 813–826; published online 11 July 2007; issue date October 2007. Publisher: Springer.
- DOI: 10.1007/s00214-007-0328-0

Abstract (paraphrase): the article shows how to evaluate rotational symmetry numbers of molecular configurations and how to use them in transition state theory; in general the symmetry number of a reaction is the ratio of the reactant and transition-state rotational symmetry numbers; four situations need special care — symmetric reactions, chiral species, multiple conformers, and internal rotation of part of the system — and these are treated systematically with many examples.

**The abstract does not state any of our three facts** (product rule, methyl = 3, R ln σ). The article body is not open access and was not read. So this paper can be cited for "symmetry numbers and internal rotation matter in rate theory", not for the three facts.

### The three facts — **Status: two VERIFIED, one needs rewording**

Source actually read in full text: Michael K. Gilson and Karl K. Irikura, "Symmetry Numbers for Rigid, Flexible, and Fluxional Molecules: Theory and Applications", The Journal of Physical Chemistry B 114 (49), 16304–16317, 2010, DOI 10.1021/jp110434s (Crossref), PMCID PMC3079527; author manuscript read through the PubMed Central OAI service (`https://pmc.ncbi.nlm.nih.gov/api/oai/v1/mh/?verb=GetRecord&identifier=oai:pubmedcentral.nih.gov:3079527&metadataPrefix=pmc`). A correction exists: J. Phys. Chem. B 117 (10), 3061, 2013, DOI 10.1021/jp401194k (not read — check it before citing a specific number from this paper).

- **Entropy lowered by R ln σ: VERIFIED.** The paper says the symmetry number sits in the denominator of the molecular partition function, that the rotational partition function must be divided by σ to correct over-counting, and that this changes the entropy by −R ln(σ) without affecting heat capacity or enthalpy. Example given: benzene, σ = 12, contribution −R ln 12.
- **Methyl rotor has symmetry number 3: VERIFIED.** The paper speaks of the 3-fold interchange of hydrogens by a methyl rotation and says the internal rotation contributes a factor 3 to the symmetry number (when the rotor is treated as free/hindered rather than frozen).
- **"Total = external × product of internal": needs rewording.** The paper's rule is: the symmetry number equals the **order of the group** of atom permutations that the chosen partition function over-counts. It explicitly warns against computing it by multiplying the orders of symmetry elements (benzene: 12, not 6·2³·2³ = 384). Its worked examples: ethane with methyl torsion, group order 18; acetone, σ = 2 as a rigid rotor, σ = 18 with two independent methyl rotors, but σ = 6 if the two methyls are only allowed to rotate geared together. *Our arithmetic:* 18 = 6·3 for ethane and 18 = 2·3·3 for acetone, so the product rule holds when the internal rotors are independent, and fails (6 ≠ 18) when they are coupled.

Suggested safe wording for the talk: "the symmetry number is the order of the molecule's group of indistinguishable rearrangements; for independent internal rotors this is the external rotational symmetry number times the rotor symmetry numbers (3 per methyl group); it lowers the entropy by R ln σ." This is exactly parallel to |Aut| being a product over nodes in our setting.

---

## 6. Ultrametricity and hierarchical models

### Rammal–Toulouse–Virasoro — **Status: VERIFIED**

Crossref and OpenAlex: R. Rammal, G. Toulouse, M. A. Virasoro, "Ultrametricity for physicists", Reviews of Modern Physics 58 (3), 765–788, published 1 July 1986, American Physical Society, DOI 10.1103/RevModPhys.58.765.

Abstract (OpenAlex, paraphrase): ultrametricity is a simple topological notion new to physicists; the review gives the elementary background from mathematics, taxonomy and statistical physics, surveys spin glasses and optimization theory, covers static and dynamic aspects, and offers tentative conclusions on why ultrametric structures occur in nature.

### Dyson 1969 — **Status: VERIFIED** (bibliographic data), with a nuance

Crossref and Springer page (`https://link.springer.com/article/10.1007/BF01645907`): Freeman J. Dyson, "Existence of a phase-transition in a one-dimensional Ising ferromagnet", Communications in Mathematical Physics 12 (2), 91–107, June 1969, DOI 10.1007/BF01645907.

Abstract (Springer, paraphrase): proves a phase transition for an infinite chain of ±1 spins with positive, monotonically decreasing long-range coupling J(n) under two summability conditions; in particular for J(n) = n^(−α) with 1 < α < 2, as conjectured by Kac and Thompson.

**Nuance:** the abstract does not contain the word "hierarchical". That this paper introduced the hierarchical model is confirmed by a secondary source: Y. Meurice, "Nonlinear aspects of the renormalization group flows of Dyson's hierarchical model", Journal of Physics A: Mathematical and Theoretical 40 (23), R39–R102, 2007, DOI 10.1088/1751-8113/40/23/R01 (Crossref), arXiv:hep-th/0701191 (ar5iv read). The review says the hierarchical model was originally introduced by Dyson, citing Comm. Math. Phys. 12, 91 (1969), as a long-range ferromagnetic Ising model with couplings weaker than those of the power-law chain. (Dyson has a second 1969 paper in the same journal, "Non-existence of spontaneous magnetization in a one-dimensional Ising ferromagnet", CMP 12 (3), 212–215, DOI 10.1007/BF01661575 — do not confuse the two.)

### Lerner–Missarov — **Status: VERIFIED** (it exists; our recollection of the year was right)

Crossref, Springer page, and Math-Net.Ru record `https://www.mathnet.ru/eng/tmf4734`:

- É. Yu. Lerner, M. D. Missarov, "Scalar models of p-adic quantum field theory and hierarchical models"
- English: Theoretical and Mathematical Physics 78 (2), 177–184, February 1989, DOI 10.1007/BF01018683.
- Russian original: Teoreticheskaya i Matematicheskaya Fizika 78:2 (1989), 248–257. MathSciNet MR994155.

Abstract (Math-Net.Ru, paraphrase): scalar models of quantum field theory on the p-adic line are formulated and their connection with hierarchical models is established. The abstract says "connection", not "identity"; the stronger statement comes from Meurice's review (ar5iv, Section 6), which says it was recognized that the hierarchical model can be reformulated as a scalar model on the 2-adic fractions and cites exactly this paper.

Related, found in passing (bibliographic data from Crossref; contents not read): É. Yu. Lerner, "Hierarchical Dyson model and p-adic conformal invariance", Theor. Math. Phys. 97 (2), 1259–1266, November 1993, DOI 10.1007/BF01016871; E. Yu. Lerner, M. D. Missarov, "p-adic conformal invariance and the Bruhat–Tits tree", Letters in Mathematical Physics 22 (2), 123–129, June 1991, DOI 10.1007/BF00405176; P. M. Bleher, Ja. G. Sinai, "Investigation of the critical point in models of the type of Dyson's hierarchical models", CMP 33 (1), 23–42, March 1973, DOI 10.1007/BF01645604. A modern rigorous paper that calls the p-adic model a hierarchical model: Abdesselam, Chandra, Guadagni, arXiv:1302.5971 (ar5iv, introduction read).

---

## 7. Kraft's equality — **Status: PARTLY VERIFIED** (binary case from an opened source; general D only via Wikipedia)

What I could open:

- Jens Maßberg, "The Depth-Restricted Rectilinear Steiner Arborescence Problem is NP-complete", arXiv:1508.06792 (2015; no journal reference on arXiv), Section 2, read on ar5iv. It states, citing Kraft's thesis, that a binary tree with leaves at depths exactly d_1, …, d_n exists if and only if Σ 2^(−d_i) = 1. This is the D = 2 case of our statement, in both directions.
- Wikipedia, "Kraft–McMillan inequality" (pointer): Σ r^(−ℓ_i) ≤ 1 for an r-ary prefix code, necessary and sufficient; equality means the code is complete; codewords are leaves of an r-ary tree.
- A web-search snippet (document **not** opened, it is a PDF) attributes to MIT 6.441 lecture notes the statement that in a complete D-ary code tree, where every intermediate node has D branches, Kraft's inequality holds with equality.

Bibliographic data for the standard references:

- Leon Gordon Kraft, "A device for quantizing, grouping, and coding amplitude-modulated pulses", Thesis (M.S.), Massachusetts Institute of Technology, Dept. of Electrical Engineering, 1949. MIT DSpace record `https://dspace.mit.edu/handle/1721.1/12390` (opened); handle 1721.1/12390. The advisor is displayed there as "J. B. Weisner".
- B. McMillan, "Two inequalities implied by unique decipherability", IEEE Transactions on Information Theory 2 (4), 115–116, December 1956, DOI 10.1109/TIT.1956.1056818 (Crossref).
- Thomas M. Cover, Joy A. Thomas, *Elements of Information Theory*, Wiley, DOI 10.1002/047174882X, ISBNs 9780471241959 and 9780471748823; Crossref dates: online 2005-04-07, print 2005-09-16. Chapter "Data Compression", pp. 103–158, DOI 10.1002/047174882X.ch5. Crossref does not state the edition number; Wikipedia cites this ISBN as the 2nd edition, 2006, with the Kraft inequality on pp. 108–109. **Edition, year as printed, and the page of the equality statement: not confirmed.**

Advice: the D-ary equality for full trees is a two-line induction (replacing a leaf at depth d by D leaves at depth d+1 leaves the sum unchanged; start from the single root with sum 1). State and prove it ourselves and cite Kraft/McMillan/Cover–Thomas only for the name "Kraft inequality".

---

## 8. Prior-art searches

**Absence of hits below is not proof of novelty.** The searches are keyword searches over titles and abstracts (OpenAlex also over some full texts); a result phrased in other words, in a thesis, a book, or a paper without an abstract would be missed. Semantic Scholar could not be used at all (HTTP 429 on every attempt).

### Queries run

OpenAlex (`https://api.openalex.org/works?search=…`), 8 results inspected each:
"Catalan numbers 2-adic valuation binomial heap"; "Catalan numbers parity binary counter carries"; "Catalan numbers 2-adic valuation tournament bracket"; "binomial queue Catalan number divisibility power of two"; "knockout tournament Catalan numbers 2-adic"; "binary carries Catalan number combinatorial proof Kummer binary trees"; "single-elimination tournament automorphisms binary tree power of 2 seedings"; "Fuss-Catalan numbers p-adic valuation Frobenius lift"; "Catalan numbers p-adic valuation Witt vectors"; "Catalan numbers delta-ring p-derivation"; "Fuss-Catalan generating function Artin-Schreier modulo p"; "generating function Catalan numbers modulo p algebraic equation Frobenius lifting p-adic valuation coefficients"; "p-adic valuation Fuss-Catalan numbers digit sum combinatorial proof"; "Fuss-Catalan numbers modulo prime powers"; "Catalan numbers modulo 2^k generating function series z^(2^n)"; "Lagrange inversion p-adic valuation Frobenius functional equation x + x^p"; "p-adic valuation number of trees automorphism group order sum over isomorphism classes"; "mass formula trees automorphisms p-adic 1/|Aut| congruence"; "orbit counting p-group action trees divisibility Catalan numbers symmetry"; "symmetry number entropy trees p-adic valuation"; "tree shapes automorphism group order power of two number of labelings 2-adic"; "groupoid cardinality p-adic valuation trees"; "symmetry nodes rooted binary trees automorphism group order 2^k Catalan"; "binomial queue binary addition carry linking"; "Dyson hierarchical model p-adic field theory".

arXiv API (`http://export.arxiv.org/api/query?search_query=…`), fields "all":
Catalan AND "binomial heap" (0 hits); Catalan AND "binomial queue" (0); Catalan AND "binary counter" (0); Catalan AND heap (1, unrelated); Catalan AND tournament AND binary (0); "Catalan numbers" AND knockout (0); Catalan AND carries (27, none relevant in the first 10); "Catalan numbers" AND "2-adic" (1: Gao–Gu); Catalan AND adic AND valuation (4: Gao–Gu and three on factorial valuations); Catalan AND "Frobenius lift" (0); Catalan AND Frobenius AND congruence (0); Catalan AND Witt (2, unrelated Hopf-algebra papers); Catalan AND "delta-ring" (0); Catalan AND "Artin-Schreier" (0); "Fuss-Catalan" AND "p-adic valuation" (0); "Fuss-Catalan" AND adic (0); Raney AND adic (0); Catalan AND Newton AND polygon AND adic (0); Catalan AND automorphism AND valuation (0); trees AND "symmetry number" AND adic (0); "binary trees" AND automorphisms AND "2-adic" (0); Catalan AND orbit AND "power of 2" (0).

General web search (four queries): Catalan 2-adic valuation with "binomial heap"/"binomial queue"/"binary counter"; p-adic valuation of Catalan/Fuss–Catalan with "Frobenius lift"/"Witt vectors"/"delta-ring"/"Artin-Schreier"; Catalan numbers with tournament bracket and 2-adic divisibility; Catalan generating function modulo p with "x + x^p + x^{p^2}"/"Artin-Schreier"; p-adic valuation of tree counts via automorphism groups, "1/|Aut", "symmetry number", "mass formula".

OEIS search: "knockout tournament", "single-elimination tournament", "elimination tournament binary trees".

Semantic Scholar API: five attempts, all HTTP 429 — **not searched**.

### (i) 2-adic valuation/parity of Catalan numbers ↔ binomial heaps, binary counters, tournament brackets — **NOT FOUND**

No paper, preprint or OEIS comment was found that connects v_2(C_n) (or parity of C_n) with binomial heaps, binary counters or tournament brackets. Closest hits:

- The papers we already have (Deutsch–Sagan, Postnikov–Sagan, Gao–Gu, Konvalinka) — tree-orbit proofs, no computer-science or tournament language. The abstract of Guoce Xin, Jing-Feng Xu, "A Short Approach to Catalan Numbers Modulo 2^r", Electronic Journal of Combinatorics 18 (1), 2011, DOI 10.37236/664, restates that the 2-adic order of C_n is one less than the binary digit sum of n+1 and uses a recursion, not carries or heaps.
- Hinze 1999 (item 1): binomial heaps explained through a tennis tournament. No Catalan numbers (abstract only).
- OEIS A096351 / A268289 / A335833 and Laura Monroe, Vanessa Job, "Computationally Inequivalent Summations and Their Parenthetic Forms", arXiv:2005.05387 (abstract read): balanced tournament/summation trees, nodes with equal-sized children, the count n!/2^k of labelled trees and 2^a(n) automorphisms (item 3). Also Laura Monroe, "A Class of Trees Having Near-Best Balance", arXiv:2108.11496 (abstract read): computation trees built from the binary decomposition of the number of terms. Neither mentions Catalan numbers or valuations in the abstract. These are the nearest "computer science" neighbours of our skeleton-with-atoms picture and of Kersting–Fischer.
- Two University of Akron M.S. theses (OhioLINK record pages opened; abstracts only): Brittany Nicole Mott, "Analysis of the Generalized Catalan Orbits", 2011 (advisor James Cossey; keywords include Burnside's Lemma, p-ary trees, dissections of polygons); Joseph Thomas Auger, "Orbits of the Dissected Polygons of the Generalized Catalan Numbers", 2011 as shown on the OhioLINK page (OpenAlex says 2012). Both count orbits of p-ary trees / polygon dissections under the dihedral group with Burnside's lemma. The abstracts mention neither divisibility nor valuations. Different group, different question, but they are "orbits of generalized Catalan objects" and a judge might know them.

### (ii) Proof of the valuation via Frobenius lift, δ-rings, Witt vectors, or G = x + G^p mod p — **NOT FOUND as a proof of the valuation formula; the mod-p functional equation itself IS in print**

- No hit for Catalan/Fuss–Catalan together with Frobenius lift, δ-ring, p-derivation or Witt vectors in OpenAlex, arXiv or web search.
- **Important overlap.** Kauers–Krattenthaler–Müller and Krattenthaler–Müller (see (iii)) build everything on Φ(z) = Σ_{n≥0} z^(p^n), and their Proposition 2 states that a minimal polynomial of Φ modulo p is t^p − t + z (for p = 2: t² + t + z). That is the relation Φ^p ≡ Φ − z (mod p), i.e. the Artin–Schreier-type equation behind "x + x^p + x^(p²) + …". Their base step for Fuß–Catalan numbers expresses the generating function modulo p through Φ_{p;h}. They never use the words Frobenius, Artin–Schreier or Witt (text search of both ar5iv pages: "Artin" 0 occurrences in both; "Frobenius" only as a person's name in the 2011 paper, 0 in the 2015 one; "Witt" 0 in the 2015 one), and they derive congruences modulo prime powers, not a proof of the valuation formula. So: reducing the functional equation mod p and meeting Σ z^(p^n) is **known**; lifting it with a Frobenius/δ-structure to get the exact valuation was **not found**.
- Other near neighbours, abstracts only: Eric Rowland, Reem Yassawi, "Automatic congruences for diagonals of rational functions", Journal de Théorie des Nombres de Bordeaux 27 (1), 245–288, 2015, DOI 10.5802/jtnb.901 (finite automata for sequences modulo p^α; a second, slower method for algebraic sequences); Michael Drmota, Christian Krattenthaler, "A joint central limit theorem for the sum-of-digits function, and asymptotic divisibility of Catalan-like sequences", Proceedings of the AMS 147 (10), 4123–4133, DOI 10.1090/proc/14349 (digit sums and divisibility of factorial-quotient sequences); Francesco Veneziano, Umberto M. Zannier, "On the Disk of Convergence of Algebraic Power Series", arXiv:2512.00452 (p-adic disks of convergence of algebraic power series versus branch points — possibly relevant background for any p-adic-analytic reading of the Fuss–Catalan series; not read beyond the abstract); Sen-Peng Eu, Zai-Ting Huang, Louis Kao, "Zero-Run Spectra of the (3,2) Raney numbers Modulo Primes", 2026 arXiv preprint per OpenAlex (zero patterns of Raney numbers mod p; identifier not confirmed).
- See also the remark at the end of item 9: the shape "π^(digit sum) / product of digit factorials, with a sign" occurs in Stickelberger's congruence and the Gross–Koblitz formula.

### (iii) What method do Kauers–Krattenthaler–Müller and Krattenthaler–Müller use? — **ANSWERED: yes, polynomials in Σ z^(p^n)**

- M. Kauers, C. Krattenthaler, T. W. Müller, "A Method for Determining the Mod-2^k Behaviour of Recursive Sequences, with Applications to Subgroup Counting", The Electronic Journal of Combinatorics 18 (2), Article P37, DOI 10.37236/2433 (Crossref: published online 2012-06-20; arXiv journal reference: Electron. J. Combin. 18(2) (2012), Article P37); arXiv:1107.2015. **Read:** Crossref abstract and the ar5iv HTML (introduction, Proposition 2, Theorem 13, references). The abstract says the method gives congruences modulo powers of 2 for sequences with polynomial recurrences and is applied to Catalan numbers, Fuß–Catalan numbers and subgroup-counting functions of Hecke groups. The introduction says the generating function, reduced modulo a 2-power, is expressed as a polynomial in the "basic series" Φ(z) = Σ_{n≥0} z^(2^n) with coefficients that are Laurent polynomials in z, and that the method finds such expressions algorithmically. Theorem 13: the Catalan generating function modulo 2^(3·2^α) is a polynomial in Φ(z) of degree at most 2^(α+2) − 1. For Fuß–Catalan numbers (their Section 13, Theorem 33) a variant series Φ_h(z) replaces Φ(z).
- C. Krattenthaler, T. W. Müller, "A method for determining the mod-p^k behaviour of recursive sequences", Aequationes Mathematicae 99 (6), 2505–2547, published online 2025-09-08, DOI 10.1007/s00010-025-01195-0; arXiv:1508.02580 (v2). **Read:** Crossref abstract and parts of the ar5iv HTML (introduction, Proposition 2, Remark 5, Section 7 up to (7.10)). The abstract says the method generalizes the 2011/2012 one from p = 2 to all primes, for sequences whose generating function satisfies an algebraic differential equation, with applications including Fuß–Catalan numbers modulo powers of arbitrary primes. Basic series: Φ_p(z) = Σ_{n≥0} z^(p^n) (their (1.1)); for Fuß–Catalan numbers with parameter p^h, Φ_{p;h}(z) = Σ_{n≥0} z^(p^(nh)/(p^h−1)) (their (7.3)); Theorem 19 expresses the generating function modulo p^(p^α) as a polynomial in Φ_{p;h}. They also remark that Φ is invariant under z → z^p up to a simple additive correction, and use this.
- A paper by these authors with a title like "Fuss–Catalan numbers modulo prime powers" was **not found**; the Fuß–Catalan material is Section 7 of the Aequationes paper. Their other titles returned by Crossref: "Periodicity of free subgroup numbers modulo prime powers", Journal of Algebra 452, 372–389, 2016, DOI 10.1016/j.jalgebra.2015.12.026; "Free subgroup numbers modulo prime powers: The non-periodic case", JCTA 154, 49–76, 2018, DOI 10.1016/j.jcta.2017.08.007; "Motzkin numbers and related sequences modulo powers of 2", European Journal of Combinatorics 73, 114–137, 2018, DOI 10.1016/j.ejc.2018.05.004.

### (iv) Reading Σ 1/|Aut| p-adically; symmetry numbers or entropy versus p-adic valuations of tree counts — **NOT FOUND**

No work was found that interprets a sum over symmetry classes of trees weighted by 1/|Aut| p-adically, or that relates p-adic valuations of tree counts to chemical "symmetry numbers" or to entropy. Closest: the orbit-size papers we already have; Kersting–Fischer's symmetry nodes (already in `references/cross_field_refs.md`); the OEIS A268289 comment that 2^a(n) is the automorphism count of the balanced tree; Gilson–Irikura (item 5) for "symmetry number = order of a permutation group, entropy −R ln σ" on the chemistry side, with no number theory. The OpenAlex results for these queries were dominated by unrelated p-adic geometry and p-adic physics papers.

---

## 9. Dwork's exponential (p-adic analysis) — **Status: VERIFIED from secondary sources; Koblitz, Robert and Dwork 1960 themselves were NOT opened**

### Sources opened

- **[K]** Anatoly N. Kochubei, "Dwork–Carlitz exponential and overconvergence for additive functions in positive characteristic", International Journal of Number Theory 4 (3), 453–460, June 2008, DOI 10.1142/S1793042108001444 (Crossref); arXiv:math/0607760, introduction read on ar5iv. Its opening paragraph recalls the classical facts and cites Dwork–Gerotto–Sullivan, *An Introduction to G-Functions* (Princeton University Press, 1994) and Robert's GTM 198 for them.
- **[B]** Régis Blache, "A Stickelberger theorem for p-adic Gauss sums", Acta Arithmetica 118 (1), 11–26, 2005, DOI 10.4064/aa118-1-2 (Crossref); arXiv:math/0303226 (title spelled "Stickleberger" on arXiv), introduction and Section 1 read on ar5iv.
- **[W-GK]** Wikipedia, "Gross–Koblitz formula" (pointer). **[W-L]** Wikipedia, "Legendre's formula" (pointer).
- **[KM]** Krattenthaler–Müller, arXiv:1508.02580, Remark 5 (ar5iv) — for Legendre's formula.

### (a) π^(p−1) = −p — VERIFIED

[K]: π is a root of the equation z^(p−1) + p = 0. [W-GK]: π satisfies π^(p−1) = −p. Same statement. *Consequence (ours):* v_p(π) = 1/(p−1), with v_p(p) = 1.

### (b) Radius of convergence — VERIFIED, with the exact radius

[K]: the ordinary exponential series converges exactly for |t|_p < p^(−1/(p−1)); the Dwork exponential θ(t) = exp(π(t − t^p)), expanded as a power series in t, converges for |t|_p < p^((p−1)/p²), and the paper notes this bound is greater than 1.

*Our deduction, not a statement of the source:* since |π|_p = p^(−1/(p−1)), the series exp(πx) converges exactly for |x|_p < 1.

**Subtlety the source states and we must respect:** [K] says the closed formula exp(π(t − t^p)) is not valid outside the unit disk — only the power series in t converges there. In particular at t = 1 one may **not** substitute into the formula (that would give exp(0) = 1); θ(1) means the sum of the power series.

### (c) θ(1) is a primitive p-th root of unity; additive character — VERIFIED

[K]: the special value θ(1) is a primitive p-th root of unity.

[B], Section 1.3 and introduction: a splitting function in Dwork's sense is a power series Θ over Q_p(ζ_p) converging in a disk of radius strictly greater than 1 such that (i) x ↦ Θ(x̃), x̃ the Teichmüller representative of x ∈ F_p, is a nontrivial additive character ψ of F_p, and (ii) for every m ≥ 1 the character ψ∘Trace of F_(p^m) is given by ψ_m(x) = Π_{i=0}^{m−1} Θ(x̃^(p^i)), x̃ now the Teichmüller representative in the unramified extension. The introduction describes it as an analytic representation of an additive character of order p. [B] attributes the notion to Dwork, citing (as given in [B]'s reference list) B. M. Dwork, "On the zeta function of an hypersurface", Publ. Math. de l'I.H.E.S. 12, 5–68, 1962 — not the 1960 paper. So "θ gives a p-adic analytic formula for an additive character of F_p" is supported, with the precise meaning: θ evaluated at Teichmüller points; property (ii) is the version for F_q, q = p^m. Note that [B] gives the definition of a splitting function and Kochubei gives the properties of θ(t) = exp(π(t − t^p)); the sentence "this θ is a splitting function" (i.e. conditions (i) and (ii) for this particular series) was not found stated verbatim in a source I opened — it is the standard content of the Koblitz/Dwork references, which I could not open.

**Which root.** [K] does not say which primitive root θ(1) is. [W-GK] fixes the convention that, given π, ζ_π denotes the p-th root of unity congruent to 1 + π modulo π². So the choice of the root π of X^(p−1) = −p and the choice of the primitive p-th root of unity determine each other; the identification θ(1) = ζ_π was **not found stated in one sentence in a source I opened**. [B] works with a different normalization: his π_l are roots of the Artin–Hasse series Σ X^(p^i)/p^i (not of X^(p−1) + p), his functions are θ_l(X) = E(π_l X) with E the Artin–Hasse exponential, and he proves θ_l(1) is a primitive p^l-th root of unity with ζ − 1 ≡ π_l modulo π_l². Do not mix the two normalizations.

### (d) Legendre's formula — VERIFIED

[KM], Remark 5, equation (2.3): for d = Σ d_i p^i with 0 ≤ d_i ≤ p−1, v_p(d!) = Σ_{ℓ≥1} ⌊d/p^ℓ⌋ = (d − s(d))/(p−1), s(d) the base-p digit sum; they call it the well-known formula of Legendre and cite A. M. Legendre, *Essai sur la théorie des nombres*, 2nd ed., Courcier, Paris, 1808, p. 10. [W-L] gives the same two forms, says the formula is also named after de Polignac, and cites Legendre, *Théorie des Nombres*, Paris, Firmin Didot Frères, 1830; Victor H. Moll, *Numbers and Functions*, AMS, 2012, ISBN 978-0821887950, p. 77; and Dickson, *History of the Theory of Numbers*, vol. 1, 1919, p. 263. (The two sources cite different editions of Legendre; I opened neither. Crossref confirms Moll's book is in the AMS Student Mathematical Library, DOI prefix 10.1090/stml/065.)

*Our arithmetic:* v_p(π^n / n!) = n/(p−1) − (n − s_p(n))/(p−1) = s_p(n)/(p−1). This was not found written in this form in a source I opened; it follows in one line from (a) and (d). [B], Proposition 1.5, has the analogous statement for his normalization (the coefficients of θ_l for n ≤ p−1 are π_l^n/n!).

### Bibliographic data of the three named sources (content not opened)

- Bernard Dwork, "On the Rationality of the Zeta Function of an Algebraic Variety", American Journal of Mathematics 82 (3), first page 631, July 1960, DOI 10.2307/2372974 (Crossref and OpenAlex; both give only the first page). **Last page not confirmed.** Whether this paper uses exactly θ(t) = exp(π(t − t^p)) was not checked.
- Neal Koblitz, *p-adic Numbers, p-adic Analysis, and Zeta-Functions*, Graduate Texts in Mathematics, volume 58, edition number 2, Springer New York, 1984; XII + 153 pages; hardcover ISBN 978-0-387-96017-3, softcover 978-1-4612-7014-0, eBook 978-1-4612-1112-9; DOI 10.1007/978-1-4612-1112-9 (Springer book page opened; Crossref). Chapter titles per Crossref: I "p-adic numbers" (1–20), II "p-adic interpolation of the Riemann zeta-function" (21–51), III "Building up Ω" (52–75), IV "p-adic power series" (76–108), V "Rationality of the zeta-function of a set of equations over a finite field" (109–128). The first edition (1977) has DOI 10.1007/978-1-4684-0047-2. **Section and page of the Dwork exponential: not confirmed.**
- Alain M. Robert, *A Course in p-adic Analysis*, Graduate Texts in Mathematics, volume 198, edition number 1, Springer New York, 2000; XVI + 438 pages; hardcover ISBN 978-0-387-98669-2, softcover 978-1-4419-3150-4, eBook 978-1-4757-3254-2; DOI 10.1007/978-1-4757-3254-2 (Springer book page opened; Crossref). Chapter 7 is "Special Functions, Congruences" (pp. 366–417). **Section and page of the Dwork exponential: not confirmed.**

### A resemblance worth a human look (observation by this subagent, not a verified link)

[B] quotes Stickelberger's theorem in the form: Gauss sum of χ^a ≡ −π^(s(a)) / (a_0! a_1! ⋯ a_(m−1)!) modulo π^(s(a)+1), where a = Σ a_i p^i, s(a) is the digit sum, and π = ζ_p − 1. [W-GK] states the Gross–Koblitz formula as τ_q(r) = −π^(s_p(r)) · Π Γ_p(…) with π^(p−1) = −p. Since π^(p−1) = −p, a power π^s with s ≡ 1 mod (p−1) equals π·(−p)^((s−1)/(p−1)). So "p to the power (digit sum − 1)/(p−1), a sign (−1)^t, and a product of digit factorials in the denominator" — the shape of our valuation theorem and of our residue claim — is exactly the shape of the leading term of a Gauss sum. I found no paper relating Fuss–Catalan numbers to Gauss or Jacobi sums in this way (not specifically searched beyond the queries in item 8). If the resemblance is real it is either a known classical route to our residue formula or a nice remark; a human should decide before anything is said in the talk.

---

## Corrections to what we believed, collected

1. **Item 2:** the opened source gives "at most 2n" flips, not "fewer than 2n"; the exact count 2n − s_2(n) is our own computation. Fourth-edition CLRS chapter number (16) is not confirmed from an opened source; third edition is Chapter 17.
2. **Item 3:** OEIS A001190 has **no** tournament comment. The tournament reading is on Wikipedia (citing Maurer 1975, whose abstract does not mention counting) and, for labelled balanced brackets, in A096351/A268289.
3. **Item 4:** Bhatt–Scholze credit the name p-derivation to Buium via his 1997 Journal of Algebra paper; Joyal's paper has no Crossref/OpenAlex record, its data rests on Bhatt–Scholze's reference list. On Z_(p), δ(x) = (x − x^p)/p — mind the sign.
4. **Item 5:** the Fernández-Ramos et al. abstract supports none of the three facts directly. "Total symmetry number = external × internal" should be stated as "order of the group", which is a product only for independent rotors (acetone: 18 free, 6 geared).
5. **Item 6:** Dyson's abstract does not mention the hierarchical model; attribution is via Meurice's review. Lerner–Missarov exists exactly as recalled (1989); its abstract says "connection", Meurice says "reformulation on the 2-adic fractions".
6. **Item 8(ii):** the mod-p relation Φ^p − Φ + z ≡ 0 for Φ = Σ z^(p^n) and its use for Fuß–Catalan generating functions is already in Kauers–Krattenthaler–Müller and Krattenthaler–Müller. We must cite them if our second proof starts from G = x + G^p modulo p.
7. **Item 9:** the formula exp(π(t − t^p)) must not be evaluated by substitution at t = 1; the radius is p^((p−1)/p²); which primitive root θ(1) is depends on the choice of π.
