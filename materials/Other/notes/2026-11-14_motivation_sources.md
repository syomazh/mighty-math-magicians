# Motivation: fact and source check — written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context) on 2026-11-14; NOT human-reviewed; only web pages and API records were read

Scope and method, in short:

- Items 1–15 are the original brief; items 16–21 were added by the coordinator while the work was running.
- Bibliographic fields come from the Crossref API (`api.crossref.org`), the OpenAlex API (`api.openalex.org`), the arXiv API (`export.arxiv.org`), NCBI E-utilities (PubMed), the zbMATH Open API, OEIS JSON records, RFC plain-text files, publisher landing pages, or the reference list of an opened open-access paper. Where a field was not shown by a source I opened it says **not confirmed**. Nothing is filled in from memory.
- "ar5iv" means the HTML rendering of an arXiv preprint at `ar5iv.labs.arxiv.org`; "PMC OAI" means the open-access full-text XML served by `pmc.ncbi.nlm.nih.gov/api/oai/v1/mh/`. These are preprint or author-manuscript versions unless stated.
- Statements are paraphrased. Formulas, titles and OEIS name lines are given as the sources give them. Lines marked *Our arithmetic* or *Our reading* are deductions by this subagent, not statements of a source.
- No PDF was opened or downloaded. Nothing was saved into the repository except this file. API responses, RFC text files and some HTML/XML pages were saved to the Claude session's temporary scratch folder (outside the repository) so that their text could be searched.
- Sites or tools that blocked or failed (nothing from them is used unless stated): ScienceDirect article page (HTTP 403); IUCr Online Dictionary of Crystallography `dictionary.iucr.org` (403), `it.iucr.org` (403), `www.iucr.org` CIF dictionary page (403); IRCAM `support.ircam.fr` OpenMusic manual (403); IUPAC Gold Book `goldbook.iupac.org` (403, a bot-challenge page; not bypassed); De Gruyter Brill article page (405, and an empty body on a second attempt); MDPI article page (403; the PMC copy of a different MDPI paper was used instead); the PubMed web page (cookie wall; the E-utilities API was used instead); `web.archive.org` (not reachable from the fetch tool); an Intel compiler-documentation page (redirects to a "not found" page); PMC OAI record PMC1328887 (HTTP 400); the Crossref API answered HTTP 429 to the fetch tool twice (direct API calls then worked); several arXiv API keyword queries returned no entries.
- Where a web page was read through the fetch tool, its text was summarized by a small model before I saw it. For every formula and for the RFC, OEIS, Blue Book, Unicode, ar5iv and PMC passages quoted below I also searched the raw text myself; Wikipedia pages, the OpenStax page, the kernel.org page, the NIST page, the Prime Glossary page, the LibreTexts page, the GCC manual page, the x86 reference page, the OpenMusic manual page and the Journal of Integer Sequences article were read only through such summaries.

Summary table:

| # | Item | Status |
|---|---|---|
| 1 | Cayley, trees and chemistry; Pólya | PARTLY VERIFIED (bibliography verified; "alkyl radicals" and "motivated by" only indirectly) |
| 2 | Butyl groups; A000598, A000625 | four groups VERIFIED; chirality PARTLY VERIFIED; OEIS VERIFIED |
| 3 | van Pelt et al., tree asymmetry | VERIFIED |
| 4 | Horton–Strahler order; Flajolet–Raoult–Vuillemin | PARTLY VERIFIED (definition via secondary sources; FRV content via a survey) |
| 5 | Buddy memory allocation | VERIFIED |
| 6 | CIDR address blocks | VERIFIED (halving shown by table and example, not stated as a rule) |
| 7 | UTF-8 | VERIFIED for "boundaries easily found"; "prefix code" is not stated in those words |
| 8 | Rhythm trees | PARTLY VERIFIED (paper: bibliography + abstract; tree structure from the OpenMusic manual) |
| 9 | Dyadic partitions, Thompson's group | PARTLY VERIFIED (bibliography verified; statement read in a thesis that cites the paper) |
| 10 | Dendrimers | PARTLY VERIFIED (bibliography verified; vocabulary from a review; no formula found) |
| 11 | Gentile statistics | VERIFIED |
| 12 | 1/N!; Wyckoff multiplicity | (a) VERIFIED; (b) PARTLY VERIFIED (IUCr dictionary blocked) |
| 13 | Weibel, lung | VERIFIED |
| 14 | Population count | PARTLY VERIFIED (no page on intel.com could be opened) |
| 15 | Colless index; tree balance survey | VERIFIED (bibliography); the Colless review itself was not read |
| 16 | Merkle trees, RFC 6962 | VERIFIED |
| 17 | Merkle Mountain Ranges | PARTLY VERIFIED ("one peak per 1-bit" is our deduction) |
| 18 | Fenwick tree | VERIFIED |
| 19 | Square-and-multiply | PARTLY VERIFIED (count verified; Knuth not opened) |
| 20 | Flory–Stockmayer | VERIFIED (formula from a 2022 secondary source; 1943 paper not opened) |
| 21 | Yule model, tree shapes | VERIFIED |

---

## 1. Cayley, trees and chemistry — **Status: PARTLY VERIFIED**

### Bibliographic data

- Crossref `https://api.crossref.org/works/10.1080/14786447408641058`: author "Cayley" (family name only); title "LVII. On the mathematical theory of isomers"; The London, Edinburgh, and Dublin Philosophical Magazine and Journal of Science, volume 47, issue 314, pages 444–447, June 1874; DOI 10.1080/14786447408641058. The series number is not in the record (**not confirmed**).
- Crossref `https://api.crossref.org/works/10.1017/cbo9780511703751.056`: "On the analytical forms called Trees, with application to the theory of chemical combinations", chapter in *The Collected Mathematical Papers*, Cambridge University Press, pages 427–460, DOI 10.1017/CBO9780511703751.056 (ISBN 9781108005012; the record's date, 2009, is that of the digital reissue). Crossref has **no record of the original report**. The original is given in the reference list of Rains–Sloane (below) as: Reports British Assoc. Adv. Sci. 45 (1875), 257–305 = Math. Papers, Vol. 9, pp. 427–460. So volume 45 and pages 257–305 rest on that reference list.
- Also found (Crossref): "Ueber die analytischen Figuren, welche in der Mathematik Bäume genannt werden und ihre Anwendung auf die Theorie chemischer Verbindungen", Berichte der deutschen chemischen Gesellschaft 8 (2), 1056–1059, July 1875, DOI 10.1002/cber.18750080252 (the Crossref record prints the author as "E. Cayley"); "On the Analytical Forms Called Trees", American Journal of Mathematics 4 (1/4), first page 266, 1881, DOI 10.2307/2369158; and the first tree paper, A. Cayley, "XXVIII. On the theory of the analytical forms called trees", Philosophical Magazine 13 (85), 172–176, March 1857, DOI 10.1080/14786445708642275.
- G. Pólya, "Kombinatorische Anzahlbestimmungen für Gruppen, Graphen und chemische Verbindungen", Acta Mathematica 68, 145–254, 1937, DOI 10.1007/BF02546665 (Crossref).
- G. Pólya, "Algebraische Berechnung der Anzahl der Isomeren einiger organischer Verbindungen", Zeitschrift für Kristallographie 93 (1–6), 415–443, 1936, DOI 10.1524/zkri.1936.93.1.415 (Crossref).
- English translation with commentary (Springer page `https://link.springer.com/book/10.1007/978-1-4612-4664-0`): G. Pólya, R. C. Read, *Combinatorial Enumeration of Groups, Graphs, and Chemical Compounds*, Springer New York, © 1987, VIII + 148 pages, DOI 10.1007/978-1-4612-4664-0. Chapter titles: Introduction; Groups; Graphs; Chemical Compounds (pp. 58–74); Asymptotic Evaluation of the Number of Combinations; and R. C. Read, "The Legacy of Pólya's Paper: Fifty Years of Pólya Theory" (pp. 96–135).

### What the sources say

- E. M. Rains and N. J. A. Sloane, "On Cayley's Enumeration of Alkanes (or 4-Valent Trees)", Journal of Integer Sequences 2 (1999), Article 99.1.1 (HTML article `https://cs.uwaterloo.ca/journals/JIS/cayley.html`; arXiv:math/0207176, abstract page opened). It says Cayley's 1875 note enumerated the alkanes C_nH_(2n+2), i.e. n-node unlabeled trees with every node of degree at most 4, split into centered and bicentered trees, for n up to 13; that the note is unclear and has misprints; that Herrmann (1880) already pointed out errors (totals 355 and 802 for n = 12, 13, where Cayley has 357 and 799); and that the centroid method was apparently first applied to alkanes by Pólya (1936, 1937). **The article does not mention alkyl radicals.**
- Alkyl radicals: OEIS A000598 (rooted ternary trees = alkyl radicals, see item 2) lists "A. Cayley, On the mathematical theory of isomers" among its references with the annotation "(a(6) is wrong)", and N. L. Biggs et al., *Graph Theory 1736–1936*, Oxford, 1976, p. 62, annotated as quoting Cayley, who is wrong. *Our reading:* this implies the 1874 paper contains a table of this sequence with an error at n = 6; no source I opened says in a sentence what the 1874 paper counted. The paper itself was not opened.
- Pólya: Wikipedia, "Pólya enumeration theorem" (pointer) says the theorem was first published by J. Howard Redfield in 1927 and rediscovered by Pólya in 1937, who popularized it by applying it to many counting problems, in particular chemical compounds. The same page has a worked example counting rooted ternary trees by the cycle index of S_3 (values 1, 1, 1, 2, 4, 8, 17, 39, …, i.e. A000598).

### Against what we believed

- "Pólya's 1937 paper was **motivated** by counting chemical compounds" was not found in those words. What is supported: chemical compounds are in the title and form a chapter of the 1937 paper; a 1936 paper by Pólya is entirely about counting isomers; Wikipedia says he applied the theorem to chemical compounds. Redfield (1927) has priority for the theorem.
- OEIS A000598 cites the 1874 paper as "Phil. Mag. vol. 67"; the publisher's record (Crossref) says volume 47. Use 47.
- Cayley's counts contain errors (1874: one value, per OEIS; 1875: n = 12 and 13, per Rains–Sloane). Do not say he counted them correctly.

---

## 2. Butyl groups; OEIS A000598 and A000625 — **Status: four groups VERIFIED; chirality PARTLY VERIFIED; OEIS VERIFIED**

### Chemistry

- John McMurry, *Organic Chemistry*, OpenStax (Houston, Texas), page dated September 20, 2023, section 3.3 "Alkyl Groups", `https://openstax.org/books/organic-chemistry/pages/3-3-alkyl-groups`. It says four different four-carbon alkyl groups are possible, named butyl, sec-butyl, isobutyl and tert-butyl, and explains sec/tert by the number of carbons attached to the branching carbon. It does not mention chirality.
- IUPAC, *Nomenclature of Organic Chemistry. IUPAC Recommendations and Preferred Names 2013*, prepared for publication by Henri A. Favre and Warren H. Powell, Royal Society of Chemistry, ISBN 978-0-85404-182-4; web version of chapter P-2 at `https://iupac.qmul.ac.uk/BlueBook/P2.html`, sections P-29.6.1 and P-29.6.3. It keeps tert-butyl as a preferred prefix, and lists isobutyl and sec-butyl among prefixes that were still in the 1993 recommendations but are **no longer recommended**; the preferred prefixes are 2-methylpropyl and butan-2-yl. This document does not state the number of butyl groups or discuss chirality (chapter P-9 was also searched: no butan-2-yl stereo example found).
- Chirality of sec-butyl: stated on Wikipedia, "Butyl group" (pointer; the sentence has no citation and the page carries a "needs more citations" banner): the butan-2-yl group is chiral, carbon 2 is a stereocentre, the two forms are (2R) and (2S). No IUPAC or textbook-publisher page stating this was found. It is confirmed numerically by the OEIS entries below.

### OEIS (JSON records `https://oeis.org/search?q=id:A000598&fmt=json`, same for A000625, A000620, A000621)

- **A000598**, Name: "Number of rooted ternary trees with n nodes; number of n-carbon alkyl radicals C(n)H(2n+1) ignoring stereoisomers." Offset 0; a(0) = 1; **a(1..6) = 1, 1, 2, 4, 8, 17**. Comments: each node has out-degree at most 3; "ignoring stereoisomers" means the children of a node are unordered.
- **A000625**, Name: "Number of n-node steric rooted ternary trees; number of n carbon alkyl radicals C(n)H(2n+1) taking stereoisomers into account." Offset 0; a(0) = 1; **a(1..6) = 1, 1, 2, 5, 11, 28**. Comment: "steric" means the children of a node are taken in a cyclic order; rotating them gives the same tree, any other permutation a different one. Links include Blair and Henze, J. Amer. Chem. Soc. 54 (3) (1932), 1098–1106, DOI 10.1021/ja01342a036; Pólya 1936 (Eq. (25)); R. W. Robinson, F. Harary, A. T. Balaban, "Numbers of chiral and achiral alkanes and monosubstituted alkanes", Tetrahedron 32 (3) (1976), 355–361, DOI 10.1016/0040-4020(76)80049-X (Crossref title begins "The numbers of…" and misprints Harary as "Harry").
- A000621 and A000620 (monosubstituted alkanes that are not / are stereoisomers; these two entries are indexed by carbons + 1): for 4 carbons the values are 3 and 2. So 5 = 3 + 2: three achiral butyl groups and one mirror-image pair. This matches 4 constitutional groups of which exactly one (sec-butyl) is chiral.

*Our reading, worth a human check:* a tree counted by A000625 is a carbon with three ordered slots, each empty (hydrogen) or holding a subtree, taken up to cyclic rotation at every node. That is a ternary tree with n internal nodes up to rotating the three subtrees at each node — the object of our theorem for p = 3. Orbit count check for n = 3: 12 ternary trees fall into orbits of sizes 9 and 3, and a(3) = 2.

### Against what we believed

- Nothing contradicts "four butyl groups, sec-butyl chiral". But "sec-butyl" and "isobutyl" are traditional names that IUPAC no longer recommends; and the chirality statement has no authoritative page behind it in this check.

---

## 3. Neuroscience: tree asymmetry — **Status: VERIFIED**

Crossref (DOI 10.1007/BF02459929), the Springer page `https://link.springer.com/article/10.1007/BF02459929` (meta tags) and PubMed (PMID 1638259, via E-utilities):

- Jaap Van Pelt, Harry B. M. Uylings, Ronald W. H. Verwer, Roberta J. Pentney, Michael J. Woldenberg
- "Tree asymmetry—A sensitive and practical measure for binary topological trees"
- Bulletin of Mathematical Biology 54 (5), 759–784, September 1992. DOI 10.1007/BF02459929. (Crossref also holds a duplicate record under DOI 10.1016/S0092-8240(05)80142-9.)
- Affiliations on the Springer page: Netherlands Institute for Brain Research, Amsterdam (first three authors); Department of Anatomical Sciences, State University of New York, Buffalo (Pentney); Department of Geography, State University of New York, Buffalo (Woldenberg).

Abstract (paraphrase): the topological structure of a binary tree is summarized by one number, the tree asymmetry, defined as the mean of the asymmetries of the tree's partitions (*our gloss, the abstract does not define the word:* a partition is the way a branch point divides the terminal segments below it between its two subtrees). Studied with a growth model, the measure is sensitive to topological differences and its expected value is almost independent of tree size; it is applied to three sets of neuronal branching patterns. The formula for the asymmetry of a single partition is not in the abstract (**not confirmed**).

Useful detail: the reference list (Springer meta tags) includes river-network papers (Shreve 1966; Smart 1969; Werner and Smart 1973) and Harding 1971 (see item 21), and one author is a geographer. Nothing contradicts what we believed.

---

## 4. Horton–Strahler order; Flajolet–Raoult–Vuillemin — **Status: PARTLY VERIFIED**

### Definition

- Wikipedia, "Strahler number" (pointer): a leaf has number 1; a node with one child of number i and all other children smaller has number i; a node with two or more children of the maximal number i has number i + 1. For rivers: two first-order streams make a second-order stream; a lower-order tributary does not change the order of the stream it joins.
- H. Prodinger's survey (below), Section 2, defines the register function of a binary tree the same way (empty tree 0; the maximum of the two subtree values if they differ, one more if they are equal) and says these are the Horton–Strahler numbers of river-network studies.
- Horton's and Strahler's own papers were not opened.

### Bibliographic data as the sources give them

- Crossref: Robert E. Horton, "Erosional development of streams and their drainage basins; hydrophysical approach to quantitative morphology", Geological Society of America Bulletin 56 (3), first page 275, 1945, DOI 10.1130/0016-7606(1945)56[275:EDOSAT]2.0.CO;2. Last page 370 only from Wikipedia's citation.
- Crossref: Arthur N. Strahler, "Hypsometric (area-altitude) analysis of erosional topography", Geological Society of America Bulletin 63 (11), first page 1117, 1952, DOI 10.1130/0016-7606(1952)63[1117:HAAOET]2.0.CO;2. Last page 1142 only from Wikipedia's citation.
- Crossref: "Quantitative analysis of watershed geomorphology", Eos, Transactions American Geophysical Union 38 (6), 913–920, December 1957, DOI 10.1029/TR038i006p00913. The Crossref record has no author field; Wikipedia attributes it to Strahler. Its abstract lists stream order numbers and bifurcation ratios among the dimensionless properties of drainage basins.

### Other branching structures

- Lungs: C. C. W. Hsia, D. M. Hyde, E. R. Weibel, "Lung Structure and the Intrinsic Challenges of Gas Exchange", Comprehensive Physiology 6 (2), 827–895, 2016, DOI 10.1002/cphy.c150028, PMCID PMC5026132 (volume and issue from the PubMed record PMID 27065169, pages also from Crossref; full text read via PMC OAI). It says airway branches are also grouped by an ascending ordering system used for rivers (the Strahler system), starting from the smallest peripheral branches as order 1, and that this suits irregular dichotomy.
- Dendrites: A. Vormberg, F. Effenberger, J. Muellerleile, H. Cuntz, "Universal features of dendrites through centripetal branch ordering", PLOS Computational Biology 13 (7), e1005615, 2017, DOI 10.1371/journal.pcbi.1005615 (Crossref; PubMed abstract PMID 28671947). The abstract says they apply the Horton–Strahler order, a centripetal ordering originally developed for river networks, to dendritic trees.
- Botanical trees: Rolf Borchert, Norman A. Slade, "Bifurcation Ratios and the Adaptive Geometry of Trees", Botanical Gazette 142 (3), 394–401, September 1981, DOI 10.1086/337238 (Crossref; OpenAlex abstract). **Caution:** the abstract discusses branching ratios from centripetal branch ordering in trees but concludes that bifurcation ratios are unsuited as indicators of a tree's adaptive geometry. It shows the method was used in botany; it is not an endorsement.
- Keith Horsfield, "Some mathematical properties of branching trees with application to the respiratory system", Bulletin of Mathematical Biology 38 (3), 305–315, 1976, DOI 10.1007/BF02459562 (Crossref; no abstract available, content not read).

### Flajolet–Raoult–Vuillemin

- Crossref: P. Flajolet, J. C. Raoult, J. Vuillemin, "The number of registers required for evaluating arithmetic expressions", Theoretical Computer Science 9 (1), 99–125, July 1979, DOI 10.1016/0304-3975(79)90009-4. Conference version: "On the average number of registers required for evaluating arithmetic expressions", 18th Annual Symposium on Foundations of Computer Science (sfcs 1977), 196–205, DOI 10.1109/SFCS.1977.19. No abstract in Crossref or OpenAlex; the ScienceDirect page returned 403. **The paper itself was not read.**
- Content, from Helmut Prodinger, "Philippe Flajolet's early work in combinatorics", Enumerative Combinatorics and Applications 2:1, Article #S1H1, DOI 10.54550/ECA2022V2S1H1 (Crossref: published online 2021-05-28); arXiv:2103.15791 (ar5iv read, Section 2). It says (its equation (1), checked in the page's TeX): the quantity from which the average register function of binary trees with n nodes is computed is [z^n] Σ_{p≥1} p·R_p(z) = Σ_{k≥1} v_2(k) · [C(2n, n+1−k) − 2·C(2n, n−k) + C(2n, n−1−k)], where R_p is the generating function of trees with register value p and v_2(k) is the number of trailing zeros of k in binary (v_2(2k) = 1 + v_2(k), v_2(2k+1) = 0); the asymptotic value of the average is log_4 n + D(log_4 n) + o(1) with D periodic; the binary sum-of-digits function enters through S_2(n) = n − Σ_{k≤n} v_2(k), with a reference to H. Delange, "Sur la fonction sommatoire de la fonction 'somme des chiffres'", Enseign. Math. (2) 21 (1), 31–47, 1975; R. Kemp obtained equivalent results independently (Acta Inform. 11 (4), 363–372, 1978/79). These two reference entries are as printed in the survey.

So: yes, a source says the analysis runs through the 2-adic valuation and the binary digit sum. *Our remark:* S_2(n) = n − Σ_{k≤n} v_2(k) is Legendre's formula v_2(n!) = n − s_2(n).

Nothing contradicts what we believed; the Crossref record prints "J.C. Raoult".

---

## 5. Buddy memory allocation — **Status: VERIFIED**

- Crossref and OpenAlex: Kenneth C. Knowlton (Bell Telephone Labs, Inc., Murray Hill, NJ), "A fast storage allocator", Communications of the ACM 8 (10), 623–624, October 1965, DOI 10.1145/365628.365655. No abstract available; the paper was not read.
- Chapter 6, "Physical Page Allocation", of a book on the Linux virtual memory manager hosted at `https://www.kernel.org/doc/gorman/html/understand/understand009.html`. Neither this page nor the index page shows the book's title, author or date (**not confirmed**; the URL path contains "gorman"). It credits the binary buddy allocator to Knowlton [Kno65], with a further description by Knuth [Knu68]; memory is kept in blocks of a power-of-two number of pages; when no block of the requested size is free, a larger block is split in half and the two halves are buddies; when a block is freed and its buddy is also free, the two are merged, and the check repeats one size up.
- NIST Dictionary of Algorithms and Data Structures, entry "buddy system", Paul E. Black, entry modified 24 August 2017, `https://xlinux.nist.gov/dads/HTML/buddysystem.html`: a memory allocation strategy that recursively divides allocatable blocks into pairs of adjacent equal-sized blocks called buddies.
- Primary abstracts (Crossref): Kenneth K. Shen, James L. Peterson, "A weighted buddy method for dynamic storage allocation", Communications of the ACM 17 (10), 558–562, October 1974, DOI 10.1145/355620.361164 — says the original buddy method allowed only block sizes 2^k. James L. Peterson, Theodore A. Norman, "Buddy systems", Communications of the ACM 20 (6), 421–431, June 1977, DOI 10.1145/359605.359626 — treats binary, Fibonacci and weighted buddy systems as a class defined by recurrences on block sizes.

Nothing contradicts what we believed.

---

## 6. CIDR address blocks — **Status: VERIFIED** (with two nuances)

Source: `https://www.rfc-editor.org/rfc/rfc4632.txt`, read as plain text.

- RFC 4632 (BCP 122), "Classless Inter-domain Routing (CIDR): The Internet Address Assignment and Aggregation Plan", V. Fuller (Cisco Systems), T. Li (Tropos Networks), August 2006, Best Current Practice, obsoletes RFC 1519.
- RFC 1519 (`https://www.rfc-editor.org/rfc/rfc1519.txt`): "Classless Inter-Domain Routing (CIDR): an Address Assignment and Aggregation Strategy", V. Fuller (BARRNet), T. Li (cisco), J. Yu (MERIT), K. Varadhan (OARnet), September 1993, Standards Track, obsoletes RFC 1338.

What RFC 4632 says:

- Section 3.1: a prefix is written as a 4-octet quantity, a slash, and a number between 0 and 32 giving the number of significant bits; those bits are the network part, the rest number the end systems. Prefixes can describe any power-of-two-sized block of between one and 2^32 addresses.
- Section 3.1, table: for every prefix length from /32 to /0, the number of addresses per block and the number of such blocks. Going from length n to n + 1 the first column halves and the second doubles. The rows /24, /16, /8 are labelled legacy Class C, B, A; the text gives 172.16.0.0/16 and 192.168.99.0/24 as examples of legacy Class B and Class C networks.
- Section 2: the three classes with their leading bit patterns and network counts (128 Class A, 16384 Class B, 2097152 Class C).
- Section 6.1 (example): a /23 is written as "2 x /24", a /22 as "4 x /24", and so on, and the block 10.24.0.0/13 is carved into such pieces.

Nuances:

- The rule "a block of length n splits into two blocks of length n + 1" is **not stated as a sentence**; it is what the table and the examples show.
- Section 2 prints the Class A leading bits as '00'. RFC Errata ID 3485 (status Verified; `https://errata.rfc-editor.org/rfc4632`) corrects this to a single leading bit '0'.

---

## 7. UTF-8 — **Status: VERIFIED** for boundaries; "prefix code" is not stated in those words

- RFC 3629 (STD 63), "UTF-8, a transformation format of ISO 10646", F. Yergeau (Alis Technologies), November 2003, Standards Track, obsoletes RFC 2279; `https://www.rfc-editor.org/rfc/rfc3629.txt`, read as plain text. Section 1 lists as properties: the first octet of a multi-octet sequence indicates the number of octets in the sequence; US-ASCII octet values occur only as US-ASCII characters; and "Character boundaries are easily found from anywhere in an octet stream". Section 3: in a sequence of n > 1 octets the first octet starts with n one-bits followed by a zero, and every following octet starts with the bits 10. The RFC does **not** say that no sequence is a prefix of another, and does not use the word "self-synchronizing".
- *The Unicode Standard*, Version 16.0, Chapter 2, Section 2.5 "Encoding Forms", `https://www.unicode.org/versions/Unicode16.0.0/core-spec/chapter-2/`. Under "Non-overlap": the encoding forms are designed so that code unit values for lead, trail and single units do not overlap; character boundaries are found by local examination, never by scanning back indefinitely, a property sometimes called self-synchronization; in UTF-8 a pointer at a byte of the form 10xxxxxx needs one to three steps back to reach the start of the character. Under 2.5.3 "Variable Width": one range of byte values is reserved for leading bytes and a disjoint range for trailing bytes.

*Our one-line deduction:* since the first octet fixes the length, no encoded character is a proper prefix of another, so UTF-8 is a prefix code on bytes. State this as our remark, with the two sources above for the facts it rests on.

---

## 8. Rhythm trees in music — **Status: PARTLY VERIFIED**

- Crossref (DOI 10.1109/WDM.2002.1176200): C. Agon, K. Haddad, G. Assayag, "Representation and rendering of rhythm structures", in Second International Conference on Web Delivering of Music, 2002. WEDELMUSIC 2002. Proceedings., pages 109–113, IEEE Comput. Soc. The Crossref record has no publication date; OpenAlex gives 2003-06-26; the year 2002 is that of the conference title.
- Abstract (OpenAlex, paraphrase): the paper proposes a format and tools for rendering computer music notation, implemented in the OpenMusic environment in CLOS, and presents itself as a generalization after the fact of that implementation. **The abstract does not use the words "rhythm tree".** The paper was not read.
- The tree structure itself, from the OpenMusic user manual, page "Rhythm Trees Structure", `https://openmusic-project.github.io/openmusic/doc/om-manual/RT1` (no author or date shown): a rhythm tree is a nested list consisting of a duration followed by a list of subdivisions; the subdivisions are proportions (so (1 1 1 1) and (2 2 2 2) give the same rhythm); a proportion may itself be a group with its own list of proportions, which is how tuplets and nested divisions are written.
- Related title only (Crossref; no abstract, not read): Florent Jacquemard, Pierre Donat-Bouillud, Jean Bresson, "A Structural Theory of Rhythm Notation Based on Tree Representations and Term Rewriting", in *Mathematics and Computation in Music*, Lecture Notes in Computer Science, Springer, 2015, pages 3–15, DOI 10.1007/978-3-319-20603-5_1.

Against what we believed: the 2002 paper can be cited for OpenMusic's rhythm notation format; that it speaks of "rhythm trees" is not confirmed from its abstract.

---

## 9. Dyadic partitions and Thompson's group — **Status: PARTLY VERIFIED**

- zbMATH Open (`https://api.zbmath.org`, Zbl 0880.20027): J. W. Cannon, W. J. Floyd, W. R. Parry, "Introductory notes on Richard Thompson's groups", Enseign. Math., II. Sér. 42, No. 3–4, 215–256 (1996). Crossref has no record of this paper; no DOI confirmed. The paper (a PDF) was **not opened**. The zbMATH review says the notes cover Thompson's groups F, T, V, and Thurston's interpretation of F and T as groups of piecewise integral projective homeomorphisms.
- The statement, from James Belk, "Thompson's Group F", Ph.D. thesis, Cornell University (arXiv:0708.3609; ar5iv read), Sections 1.1–1.2: a dyadic subdivision of [0,1] is obtained by repeatedly cutting intervals in half; equivalently it is a partition of [0,1] into standard dyadic intervals [k/2^n, (k+1)/2^n]; such subdivisions correspond to finite binary trees (root = [0,1], leaves = the intervals of the subdivision); an element of F is given by a pair of such trees. Belk refers to [CFP] for this traditional tree-diagram approach; his reference list prints the title as "Introductory Notes to Richard Thompson's Groups", L'Enseignement Mathématique 42 (1996), 215–256.

Against what we believed: nothing; cite Cannon–Floyd–Parry for the correspondence only after someone has looked at the paper itself.

---

## 10. Dendrimers — **Status: PARTLY VERIFIED**

- Crossref and OpenAlex (DOI 10.1295/polymj.17.117): D. A. Tomalia, H. Baker, J. Dewald, M. Hall, G. Kallos, S. Martin, J. Roeck, J. Ryder, P. Smith, "A New Class of Polymers: Starburst-Dendritic Macromolecules", Polymer Journal 17 (1), 117–132, January 1985. No abstract available; that this paper *introduced* the term is **not confirmed** from an opened source (the title uses it). A second paper by the same authors: "Dendritic macromolecules: synthesis of starburst dendrimers", Macromolecules 19 (9), 2466–2468, September 1986, DOI 10.1021/ma00163a029.
- IUPAC terminology (Crossref; abstract only, the article page was blocked): Alain Fradet, Jiazhong Chen, Karl-Heinz Hellwich, Kazuyuki Horie, Jaroslav Kahovec, Werner Mormann, Robert F. T. Stepto, Jiří Vohlídal, Edward S. Wilks, "Nomenclature and terminology for dendrimers with regular dendrons and for hyperbranched polymers (IUPAC Recommendations 2017)", Pure and Applied Chemistry 91 (3), 523–561, 2019, DOI 10.1515/pac-2016-1217. The abstract says it gives definitions of terms and structure-based nomenclature for dendrimers with regular dendrons and for hyperbranched polymers. The definitions themselves were not read.
- Vocabulary, from an open-access review read via PMC OAI: Elham Abbasi et al., "Dendrimers: synthesis, applications, and properties", Nanoscale Research Letters 9, article 247, 2014, DOI 10.1186/1556-276X-9-247, PMCID PMC4074873. It says a dendrimer starts from a central atom or group called the core, from which branches called dendrons grow; each synthetic cycle adds a generation and the number of surface groups grows exponentially; its Figure 1 is a generation-4 dendrimer with an ethylenediamine core and 64 amino groups at the periphery.

A formula for a perfect dendrimer of generation g with branching multiplicity b was **not found** in an opened source. *Our arithmetic:* 64 = 4 · 2^4 for the example above, which is what a core of multiplicity 4 and a doubling at each of four generations would give; the review does not state this formula. A search-engine snippet (page not opened) suggests that IUPAC numbers generations of a dendron starting from the unit bearing the free valence, which may differ from the common convention; check before quoting a generation number.

---

## 11. Gentile statistics — **Status: VERIFIED**

- Crossref (DOI 10.1007/BF02960187): G. Gentile j., "Osservazioni sopra le statistiche intermedie", Il Nuovo Cimento 17 (10), 493–497, December 1940. (The Crossref and OpenAlex title field has a stray prefix: "itOsservazioni…".) A later paper: Giovanni Gentile, "Le Statistiche Intermedie e le Proprietà Dell'elio Liquido", Il Nuovo Cimento 19 (4), 109–125, April 1942, DOI 10.1007/BF02960192. Neither was read.
- Content, from Wu-Sheng Dai, Mi Xie, "Gentile statistics with a large maximum occupation number", Annals of Physics 309 (2), 295–305, February 2004, DOI 10.1016/j.aop.2003.08.018; arXiv:cond-mat/0310066 (abstract and introduction read on ar5iv). The introduction says quantum statistics is either Bose–Einstein or Fermi–Dirac, and that Gentile proposed an intermediate statistics in which the maximum number of particles in any quantum state is neither 1 nor ∞ but a finite number n; its reference for this is "G. Gentile, Nuovo Cim. 17 (1940) 493–497".

Nuance: the same paper shows that letting n reach the total particle number N recovers Bose–Einstein statistics only for fugacity z < 1. "d = ∞ gives Bose" is fine; "d = N gives Bose" is not always true.

---

## 12. Correct Boltzmann counting; site multiplicity

### 12(a) The factor 1/N! — **Status: VERIFIED**

- Daan Frenkel, "Why colloidal systems can be described by statistical mechanics: some not very original comments on the Gibbs paradox", Molecular Physics 112 (17), 2325–2329, 2014, DOI 10.1080/00268976.2014.904051 (Crossref); arXiv:1312.0206 (abstract). The abstract says statistical mechanics gives extensive thermodynamic properties if the configurational integral of N particles is divided by N!, and that many textbooks justify the N! by the indistinguishability of identical particles — an argument that does not apply to colloids, which are distinguishable.
- Wikipedia, "Gibbs paradox" (pointer): dividing the phase-space volume by N! for identical particles removes the non-extensive term of the entropy and, with Stirling's formula, gives the Sackur–Tetrode equation; the page uses the phrase "correct Boltzmann counting".

Nuance for the talk: Frenkel's point is that the 1/N! is needed even for distinguishable particles, so "1/N! because the particles are identical" is the textbook reason, not the only one.

### 12(b) Multiplicity of a Wyckoff position — **Status: PARTLY VERIFIED**

The IUCr Online Dictionary could not be opened (403 on three IUCr hosts). Sources opened instead:

- Jennifer Cano, Barry Bradlyn, Zhijun Wang, L. Elcoro, M. G. Vergniory, C. Felser, M. I. Aroyo, B. Andrei Bernevig, "Building blocks of topological quantum chemistry: Elementary band representations", Physical Review B 97 (3), article 035139, 2018, DOI 10.1103/PhysRevB.97.035139; arXiv:1709.01935 (ar5iv read, Section II, Definition 2). Two sites whose site-symmetry groups are conjugate lie in the same Wyckoff position; the multiplicity is the number of sites of the orbit in one unit cell, with the **primitive** cell used throughout; in their example (plane group p6mm, positions 1a, 2b, 3c, 6d, 6e, 12f) the multiplicity is the index of the stabilizer group in the point group C_6v.
- Gordon J. Miller, *Chemical Group Theory*, section 3.7 "Volume A of the International Tables of Crystallography", Chemistry LibreTexts (CC BY 4.0), `https://chem.libretexts.org/Bookshelves/Inorganic_Chemistry/Chemical_Group_Theory_(Miller)/03%3A_Space_Groups/3.07%3A_Volume_A_of_the_International_Tables_of_Crystallography`: the general position has the highest multiplicity, equal to the order of the point group times the number of lattice points in the unit cell; special positions lie on symmetry elements and have lower multiplicity.
- Wikipedia, "Wyckoff positions" (pointer): a general position is fixed only by the identity; a special position has a non-trivial site-symmetry group.

**Correction to what we believed:** "multiplicity = order of the point group / order of the site-symmetry group" is right when the multiplicity is counted per primitive cell (or for a point group). The multiplicities printed in the International Tables refer to the conventional cell, so for centred lattices there is an extra factor, the number of lattice points per cell.

---

## 13. Lungs — **Status: VERIFIED**

- Springer page `https://link.springer.com/book/10.1007/978-3-642-87553-3` and Crossref: Ewald R. Weibel, *Morphometry of the Human Lung*, Springer Berlin, Heidelberg, © 1963, XI + 151 pages, 176 b/w illustrations, DOI 10.1007/978-3-642-87553-3 (eBook ISBN 978-3-642-87553-3; softcover reprint ISBN 978-3-642-87555-7). One chapter is titled "Geometric and Dimensional Airway Models of Conductive, Transitory and Respiratory Zones of the Human Lung" (pp. 136–142). Crossref also has chapter records of an Elsevier edition with the same title and year (ISBN 9781483200767). The book was not read.
- Primary statement of the number: E. R. Weibel, D. M. Gomez, "Architecture of the Human Lung", Science 137 (3530), 577–585, 24 August 1962, DOI 10.1126/science.137.3530.577 (Crossref; PubMed abstract PMID 14005590). The abstract says the airways have on average "23 generations of dichotomous branching".
- The symmetric model: Hsia, Hyde, Weibel 2016 (bibliographic data in item 4; full text via PMC OAI), sections "Design and morphometry of the human airway tree" and "Typical path models of the human airway tree". Model A assumes regular dichotomy and so defines a symmetric typical-path model; it is bounded by the average number of generations, estimated as 23, so that the airways end in about 8 million (2^23) alveolar sacs. The same text says the real number of generations to reach the alveolar sacs varies from about 18 to 30, and that model B describes the asymmetric branching.

Nothing contradicts what we believed; say "on average 23" and mention the 18–30 range if asked.

---

## 14. Population count — **Status: PARTLY VERIFIED** (no intel.com page opened)

- `https://www.felixcloutier.com/x86/popcnt`, an unofficial HTML copy of the Intel 64 and IA-32 Architectures Software Developer's Manual (the page describes itself as unofficial and non-verified): the instruction POPCNT, titled "Return the Count of Number of Bits Set to 1", counts the 1-bits of the source operand and writes the count to the destination register; support is indicated by CPUID.01H:ECX.POPCNT (bit 23).
- GCC manual, "Bit Operation Builtins", `https://gcc.gnu.org/onlinedocs/gcc/Bit-Operation-Builtins.html`: `__builtin_popcount` returns the number of 1-bits of its argument; `__builtin_ctz` returns the number of trailing 0-bits (the 2-adic valuation, undefined for 0); `__builtin_parity` returns the number of 1-bits modulo 2.
- Wikipedia, "Hamming weight" (pointer): for a binary word the Hamming weight is the number of 1 bits, also called population count, popcount or sideways sum; it lists hardware support, including POPCNT on AMD (2007) and Intel (2008) processors, and notes that J. W. L. Glaisher used it in 1899 for the number of odd binomial coefficients in a row of Pascal's triangle. The Intel and AMD lines carry no citation on that page.

Nothing contradicts what we believed.

---

## 15. Phylogenetics: Colless index and the survey — **Status: VERIFIED** (bibliography); the Colless review itself was not read

- Colless: Crossref (DOI 10.2307/2413420): title "Phylogenetics: The Theory and Practice of Phylogenetic Systematics.", Systematic Zoology 31 (1), first page 100, March 1982; the record lists "Donald H. Colless; E. O. Wiley" as authors (Wiley is the author of the reviewed book — an artefact of the record). Pages 100–104 and the form 'D. Colless, Review of "Phylogenetics: The theory and practice of phylogenetic systematics", Systematic Zoology 31(1):100–104, 1982' come from the reference list of the Fischer et al. preprint below. The abstract shown by OpenAlex for this DOI is unrelated text (a blurb for a later edition of the book); ignore it.
- What the index is, from the abstract of T. M. Coronado, A. Mir, F. Rosselló, "Squaring within the Colless index yields a better balance index", arXiv:2007.14731 (published, per Crossref, in Mathematical Biosciences 331, article 108503, 2021, DOI 10.1016/j.mbs.2020.108503, where K. Bartoszek is listed as first author): the Colless index of a bifurcating tree is the sum, over internal nodes, of the absolute difference between the numbers of leaves under the two children; introduced by Colless (1982). So it is an index defined in a book review.
- The survey: Mareike Fischer, Lina Herbst, Sophie Kersting, Annemarie Luise Kühn, Kristina Wicke, *Tree Balance Indices: A Comprehensive Survey*, Springer Cham, 2023, XV + 404 pages, DOI 10.1007/978-3-031-39800-1, hardcover ISBN 978-3-031-39799-8, eBook ISBN 978-3-031-39800-1 (Springer page `https://link.springer.com/book/10.1007/978-3-031-39800-1`; Crossref). Preprint: arXiv:2109.12281. It gives formal definitions of balance and imbalance indices, reviews the established ones with their combinatorial and statistical properties, proves new results and lists open problems; an R package `treebalance` accompanies it. The arXiv abstract says 19 established indices; the Springer page says more than twenty.

---

## 16. Merkle trees in Certificate Transparency — **Status: VERIFIED**

Source: `https://www.rfc-editor.org/rfc/rfc6962.txt`, read as plain text.

- RFC 6962, "Certificate Transparency", B. Laurie, A. Langley, E. Kasper (Google), June 2013, category Experimental.
- Section 2.1 "Merkle Hash Trees", for an ordered list of n inputs D[n] = {d(0), …, d(n−1)}:
  - MTH({}) = SHA-256().
  - MTH({d(0)}) = SHA-256(0x00 || d(0)).
  - For n > 1, let k be the largest power of two smaller than n (i.e. k < n <= 2k); then MTH(D[n]) = SHA-256(0x01 || MTH(D[0:k]) || MTH(D[k:n])), where D[k1:k2] is the sub-list d(k1), …, d(k2−1).
  - The text adds that n need not be a power of two, that the tree may then be unbalanced, and that "its shape is uniquely determined by the number of leaves".
- RFC 9162, "Certificate Transparency Version 2.0", B. Laurie, E. Messeri (Google), R. Stradling (Sectigo), December 2021, Experimental, obsoletes RFC 6962 (`https://www.rfc-editor.org/rfc/rfc9162.txt`). Section 2.1.1 restates the same definition with a generic hash function HASH in place of SHA-256; the split rule is word for word the same.

This is exactly what we believed. *Our remark:* since k is the largest power of two below n, the left subtree is always perfect; unrolling the recursion along the right spine gives one perfect subtree for each 1-bit of n (when n is a power of two the whole tree is perfect).

---

## 17. Merkle Mountain Ranges — **Status: PARTLY VERIFIED**

- OpenTimestamps server documentation, "Merkle Mountain Ranges", `https://github.com/opentimestamps/opentimestamps-server/blob/master/doc/merkle-mountain-range.md` (raw text read; the file shows no author line or date; the Grin document below attributes it to Peter Todd). It says digests are hashed into the largest possible perfect binary trees as they arrive; if the number of digests does not fill one perfect tree, several trees ("mountains") exist; its running example shows two subtrees being merged when a new one of the same height appears; a single digest is obtained by building a Merkle tree over the list of peaks, an operation it calls bagging the peaks.
- Grin documentation, "Merkle Mountain Ranges", `https://github.com/mimblewimble/grin/blob/master/doc/mmr.md` (raw text read; no author or date shown in the file). It describes an MMR as a list of perfectly balanced binary trees, append-only, where a parent is added as soon as two children exist; its example has 11 leaves and 19 nodes; since an MMR has no single root by construction, one is computed by "bagging the peaks", hashing the peaks together from the right.
- Zcash Improvement Proposal 221, "FlyClient - Consensus-Layer Changes", owner Jack Grigg, original authors Ying Tong Lai, James Prestwich, Georgios Konstantopoulos, status Final, created 2019-03-30, `https://zips.z.cash/zip-0221`. Its example: 11 leaves give three mountains of altitudes 3, 1 and 0; its append pseudocode merges the new leaf with the rightmost peak while the two have the same number of leaves.

"One peak for each 1-bit of n" is **not stated in those words** in any of the three. *Our deduction:* the peaks are perfect trees of distinct sizes 2^h summing to n, hence they sit at the 1-bits of n; the examples agree (11 = 1011 in binary, altitudes 3, 1, 0). Appending a leaf is then binary increment, a merge being a carry — the same remark as for binomial heaps.

---

## 18. Fenwick tree — **Status: VERIFIED**

- Crossref (DOI 10.1002/spe.4380240306): Peter M. Fenwick, "A new data structure for cumulative frequency tables", Software: Practice and Experience 24 (3), 327–336, March 1994. A one-page follow-up note carrying the paper's title exists: Software: Practice and Experience 24 (7), 677, July 1994, DOI 10.1002/spe.4380240706 (not read; presumably a correction — check before quoting details of the paper).
- Abstract (Crossref, paraphrase): the "binary indexed tree" maintains cumulative frequencies by decomposing them into portions that parallel the binary representation of the index of the table element; traversal uses the binary coding of the index; access time is constant or proportional to the logarithm of the table size. That is our statement, from the primary source's abstract.
- Wikipedia, "Fenwick tree" (pointer): a prefix sum is computed by adding the stored value at index i and then moving to index i − lsb(i), where lsb(i) = i & −i is the lowest set bit, until 0 is reached. *Our reading:* each step removes one 1-bit, so a prefix of length n is the sum of exactly s_2(n) stored blocks.

Attribution nuance (Wikipedia): the structure was proposed earlier by Boris Ryabko (1989; modified 1992) and described by Fenwick in 1994. Crossref for the 1992 paper: B. Y. Ryabko, "A fast on-line adaptive code", IEEE Transactions on Information Theory 38 (4), 1400–1404, July 1992, DOI 10.1109/18.144725 (Wikipedia prints the volume and issue differently). Say "known as the Fenwick tree" rather than "invented by Fenwick".

---

## 19. Square-and-multiply — **Status: PARTLY VERIFIED** (the count is verified; Knuth was not opened)

- OEIS A014701 (`https://oeis.org/search?q=id:A014701&fmt=json`), Name: "Number of multiplications to compute n-th power by the Chandah-sutra method." Formula line: a(n) = floor(log_2(n)) + (number of 1's in binary representation of n) − 1. A comment identifies the method with left-to-right binary exponentiation; another says the right-to-left method uses the same number of operations: A000523(n) squarings and A000120(n) − 1 multiplications, i.e. floor(log_2 n) squarings and (number of 1-bits) − 1 multiplications.
- Wikipedia, "Exponentiation by squaring", section "Computational complexity" (pointer, no citation attached): floor(log_2 n) squarings and a number of multiplications one less than the number of ones in the binary expansion of n.
- The Prime Glossary (PrimePages, `https://t5k.org/glossary/page.php?sort=BinaryExponentiation`), entry "binary exponentiation": gives the multiplication count of the right-to-left method as the number of binary digits of n, minus 2, plus the number of 1 bits (the same total), attributes the left-to-right method to Pingala's Chandah-sutra and the right-to-left one to al-Kashi (1427), and cites "D. E. Knuth, Seminumerical algorithms, 3rd edition, The Art of Computer Programming Vol. 2, Addison-Wesley, 1997", section 4.6.3.
- Wikipedia, "Addition-chain exponentiation" (pointer): cites Knuth, *The Art of Computer Programming*, Volume 2: *Seminumerical Algorithms*, 3rd edition, §4.6.3, Addison-Wesley, 1998, and gives the example x^15: 6 multiplications by the binary method, 5 by the shortest addition chain. (The two pages give different years, 1997 and 1998, for the third edition.)

**Where exactly the statement is in Knuth: not confirmed.** No publisher page shows the text; the section number 4.6.3 rests on the two citations above. Safest: state the count with OEIS A014701 as the checkable source and add "see Knuth, TAOCP vol. 2, §4.6.3" after someone has opened the book.

*Our remark:* the total is floor(log_2 n) + s_2(n) − 1, and the method is not optimal (n = 15).

---

## 20. Flory–Stockmayer theory — **Status: VERIFIED** (formula from a secondary source)

### Bibliographic data (Crossref)

- Walter H. Stockmayer, "Theory of Molecular Size Distribution and Gel Formation in Branched-Chain Polymers", The Journal of Chemical Physics 11 (2), 45–55, February 1943, DOI 10.1063/1.1723803. Abstract (paraphrase): most probable size distributions are computed for certain branched-chain polymers, extending Flory's work, which showed that very large molecules appear suddenly at a critical extent of reaction close to the observed gel point; the liquid–gel transition is likened to the condensation of a saturated vapour.
- Walter H. Stockmayer, "Theory of Molecular Size Distribution and Gel Formation in Branched Polymers II. General Cross Linking", The Journal of Chemical Physics 12 (4), 125–131, April 1944, DOI 10.1063/1.1723922.
- Paul J. Flory, "Molecular Size Distribution in Three Dimensional Polymers. I. Gelation", Journal of the American Chemical Society 63 (11), 3083–3090, November 1941, DOI 10.1021/ja01856a061.
- Paul J. Flory, "… II. Trifunctional Branching Units", same journal and issue, 3091–3096, DOI 10.1021/ja01856a062.
- Paul J. Flory, "… III. Tetrafunctional Branching Units", same journal and issue, 3096–3100, DOI 10.1021/ja01856a063.

None of these five papers was opened.

### The combinatorial factor

Source: Fumihiko Tanaka, "Comparative Study on the Models of Thermoreversible Gelation", International Journal of Molecular Sciences 23 (18), article 10325, 2022, DOI 10.3390/ijms231810325, PMCID PMC9499641 (full text read via PMC OAI; the MathML was checked for the exponent).

It considers combining l identical f-functional molecules into a single Cayley tree (cycles neglected), cites Stockmayer 1943 and 1944 and Chapter XII of Flory's textbook for the classical tree statistics, and writes the entropy of combination as ΔS_l^comb = k_B ln[ f^l ω_l ], where, as its equation (42),

    ω_l ≡ (fl − l)! / ( l! (fl − 2l + 2)! )

which it calls "Stockmayer's combinatorial factor". So the quantity f^l (fl − l)! / (l! (fl − 2l + 2)!) is the statistical weight (number of ways, with the l! for identical molecules) of forming one tree-like l-mer; the factor without f^l is the one that carries Stockmayer's name there. This agrees with what we believed, including the remark on conventions.

*Our arithmetic (not from the source):*

- With q = f − 1 and the Fuss–Catalan number C_l^(q) = (ql)! / (l! ((q−1)l + 1)!), one has ω_l = C_l^(f−1) / ((f − 2)l + 2). The divisor (f − 2)l + 2 = fl − 2(l − 1) is the number of unreacted functional groups of a tree-like l-mer. Checks: f = 3, l = 2 gives ω = 4!/(2!·4!) = 1/2 = C_2^(2)/4; f = 3, l = 3 gives ω = 6!/(3!·5!) = 1 = C_3^(2)/5.
- f^l ω_l is not an integer in general (f = 3, l = 2 gives 9/2); the integer count is for labelled units, f^l (fl − l)!/(fl − 2l + 2)! (f = 3: 9 for l = 2, 162 for l = 3, both confirmed by direct counting). Say "a Fuss–Catalan number divided by the number of free groups", not "a Fuss–Catalan number".

Other sources looked at: Wikipedia, "Flory–Stockmayer theory" (pointer) gives the assumptions (equal reactivity, no intramolecular reactions) and the gel point α_c = 1/(f − 1), but no size-distribution formula. C. Wen, R. Odle, S. Cheng, "Molecular Weight Distribution of Branched Polymers: Comparison between Monte Carlo Simulation and Flory-Stockmayer Theory", Polymers 15 (7), article 1791, 2023, DOI 10.3390/polym15071791 (PMC10097263) prints the general multi-component Stockmayer formula, a ratio of factorials of the same type, not the single-monomer form.

---

## 21. Yule model and tree shapes — **Status: VERIFIED**

Source: Mike Steel, "Neutral phylogenetic models and their role in tree-based biodiversity measures", Philosophical Transactions of the Royal Society B: Biological Sciences 380 (1919), article 20230308, 2025, DOI 10.1098/rstb.2023.0308 (Crossref); arXiv:2405.17833 (HTML of version 2 read at `https://arxiv.org/html/2405.17833v2`; the published version was not opened).

It says, for the Yule–Harding (YH) distribution on tree shapes with n leaves:

- for any tree shape τ with n leaves there are exactly n!/2^(s(τ)) binary phylogenetic (leaf-labelled) trees of that shape, where s(τ) is the number of symmetry vertices, i.e. interior vertices whose two descendant subtrees have isomorphic shape;
- Harding described the probability p(τ) recursively, and it has the explicit form

      p(τ) = 2^(n − 1 − s(τ)) / ∏_{v ∈ IV_τ} n_τ(v)

  where IV_τ is the set of interior vertices and n_τ(v) is the number of leaves descending from v **minus 1**;
- example: the five-leaf shape of Harding's 1971 paper has probability 2^(5−1−3)/(4 × 3 × 1 × 1) = 1/6, and each labelled tree of that shape has probability 1/90.

This is exactly the formula we believed (our n_v − 1 is Steel's n_τ(v)).

Consistent second source, for labelled trees: Fischer, Herbst, Kersting, Kühn, Wicke, arXiv:2109.12281 (ar5iv, Section 2, equation (2)): P_{Y,n}(𝒯) = (2^(n−1)/n!) · ∏_{v ∈ V̊(T)} 1/(n_v − 1), with a reference to Steel 2016. Multiplying by n!/2^s gives the shape formula.

Bibliographic data of the older sources:

- E. F. Harding, "The probabilities of rooted tree-shapes generated by random bifurcation", Advances in Applied Probability 3 (1), 44–77, 1971, DOI 10.2307/1426329 (Crossref). Abstract (paraphrase): enumerates rooted trees generated by random bifurcation at terminal nodes and determines their probability distribution through a recurrence; the most probable shape of given size is conjectured for labelled trees and left open for unlabelled shapes.
- As printed in the reference list of Fischer et al. (not opened by me): M. Steel, *Phylogeny: Discrete and random processes in evolution*, Society for Industrial and Applied Mathematics, Philadelphia PA, 2016, ISBN 161197447X; C. Semple and M. Steel, *Phylogenetics*, Oxford Lecture Series in Mathematics and its Applications, Oxford University Press, 2003, ISBN 0198509421. Chapter or page of the formula in either book: **not confirmed**.

*Our remark:* the exponent of 2 in the Yule probability of a shape is n − 1 − s minus the 2-adic valuations of the factors n_v − 1; the number s of symmetry vertices is the same statistic as in our theorem for p = 2 and in Kersting–Fischer.

---

## Corrections to what we believed

1. **Cayley 1874, volume.** Philosophical Magazine volume **47** (issue 314, pp. 444–447), per the publisher's Crossref record; OEIS A000598 prints "vol. 67". Do not copy the OEIS citation.
2. **Cayley 1875, source of the page numbers.** Crossref has only the Collected Papers reprint (pp. 427–460). "Report of the British Association 45 (1875), 257–305" rests on the reference list of Rains–Sloane.
3. **Cayley's counts are partly wrong** (one value in 1874 according to OEIS; n = 12 and 13 in 1875 according to Rains–Sloane). That Cayley counted *alkyl radicals* is supported only indirectly (OEIS reference annotations); that he counted *alkanes* as trees of valency at most 4 is stated by Rains–Sloane.
4. **Pólya.** "Motivated by chemistry" was not found in those words. Supported: chemical compounds in the title and as a chapter of the 1937 paper; a 1936 paper on isomer counts; Redfield (1927) published the theorem first (Wikipedia).
5. **Butyl names.** IUPAC's 2013 recommendations no longer recommend "isobutyl" and "sec-butyl" (preferred: 2-methylpropyl, butan-2-yl); "tert-butyl" is retained. The chirality of sec-butyl is backed here only by an uncited Wikipedia sentence and by the OEIS counts (5 = 3 achiral + one mirror pair).
6. **Borchert–Slade 1981** argues that bifurcation ratios are *unsuited* as indicators for trees; cite it only as evidence that Strahler-type ordering was used in botany.
7. **CIDR.** The halving rule is shown by the table and the "2 x /24" example, not stated as a sentence. RFC 4632 Section 2 misprints the Class A leading bits as '00' (Verified Errata ID 3485: '0').
8. **UTF-8.** Neither RFC 3629 nor the Unicode Standard says "prefix code" or "no sequence is a prefix of another". They say the first octet gives the length, lead and trail byte ranges are disjoint, and boundaries are found locally. The prefix property is a one-line deduction of ours.
9. **Rhythm trees.** The abstract of Agon–Haddad–Assayag does not mention rhythm trees; the tree structure is documented in the OpenMusic manual. Year 2002 comes from the proceedings title (OpenAlex says 2003).
10. **Cannon–Floyd–Parry** has no Crossref record; data from zbMATH. The paper was not opened; the tree/dyadic-partition statement was read in Belk's thesis.
11. **Dendrimers.** No formula for a perfect dendrimer was found in an opened source; IUPAC's definitions could not be opened.
12. **Gentile statistics.** The Bose limit is d = ∞; taking d equal to the particle number does not always recover Bose statistics (Dai–Xie).
13. **Wyckoff multiplicity.** The quotient (point-group order)/(site-symmetry order) is the multiplicity per primitive cell; tabulated multiplicities for centred cells contain an extra factor (lattice points per cell). The IUCr dictionary could not be opened.
14. **1/N!.** Frenkel's paper stresses that the factor is needed even for distinguishable (colloidal) particles; "because the particles are identical" is the textbook justification.
15. **Weibel.** The earliest statement of "23 generations" found is Weibel and Gomez, Science 1962; it is an average, with a real range of about 18–30.
16. **Colless 1982.** The Crossref record lists E. O. Wiley as a co-author (he wrote the reviewed book) and gives only the first page; the OpenAlex abstract is unrelated text. Pages 100–104 come from the survey's reference list.
17. **Merkle Mountain Ranges.** "One peak per 1-bit of n" is not written in the three documents read; it follows from their definitions and matches their examples.
18. **Fenwick tree.** Wikipedia credits Ryabko (1989, 1992) with the earlier proposal. A one-page note on Fenwick's paper appeared in the same journal, 24 (7), 677.
19. **Square-and-multiply.** The count is confirmed (OEIS A014701, Wikipedia, Prime Glossary), but Knuth's text was not opened, so the exact place in §4.6.3 is not confirmed; sources disagree on the year of the third edition (1997 or 1998).
20. **Stockmayer's factor.** Confirmed as ω_l = (fl − l)!/(l!(fl − 2l + 2)!), with f^l ω_l as the weight of an l-mer, from Tanaka (2022), not from the 1943 paper. It equals a Fuss–Catalan number with parameter f − 1 **divided by (f − 2)l + 2** (our arithmetic), and f^l ω_l is generally not an integer.
21. **Yule shape probability.** Confirmed exactly as believed (Steel 2025 / arXiv:2405.17833); note that Steel's n_τ(v) already means "leaves below v minus 1".
