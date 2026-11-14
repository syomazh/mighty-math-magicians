# Literature scan — exact Fuss–Catalan valuations and tree symmetries

Produced by worker W004, `moonshotai/kimi-k3.1-pro`, 2026-11-13.

## Scope and headline

I checked the three seed citations against the returned Crossref records, retrieved all OpenAlex records returned by `filter=cites:<id>` for those seeds, and screened the titles and available abstracts of those records and the returned OpenAlex keyword-search results. I did not find an abstract in these responses that states the target exact valuation formula for prime-power `q` and derives it by a tree-symmetry or `p`-group argument. **This is not a proof of novelty**: I did not read the full texts of the papers below, the arXiv API was unavailable, and three broad OpenAlex searches returned more than the single result page I screened.

The highest-priority item for full-text checking is **Gao–Gu (2021)**, followed by the weighted-Dyck-path approach of **Postnikov–Sagan (2007)**. For ordinary Catalan numbers, these are directly about valuations and combinatorial proofs. For Fuss–Catalan congruences modulo arbitrary prime powers, **Krattenthaler–Müller (2025)** requires a full-text check, but its abstract describes an algebraic-differential-equation method, not tree symmetries. The closest explicit group-action/Fuss–Catalan abstract found is **Stier–Wellman–Xu (2021)**, on cyclic/dihedral sieving; its abstract says Raney numbers occur through symmetric polygons and an evaluation of `q,t`-Fuss–Catalan numbers, rather than a valuation formula.

## Method and sources

- Generic `User-Agent: MightyMathMagicians-LiteratureScan/1.0`; no email, personal information, API key or `mailto` parameter was sent; successful requests were spaced at least one second apart.
- Crossref: three DOI endpoints under `https://api.crossref.org/works/`, saved in `raw/crossref_*.json`.
- OpenAlex: seed lookup by DOI, citing works with `filter=cites:<id>`, `per-page=200` and all pages indicated by the returned metadata; one page of `per-page=100` for each keyword search. Raw responses are named `raw/openalex_*.json`; the query URLs are in `raw/request_log.json`.
- OpenAlex inverted abstract indices were reconstructed by sorting word positions. Where an abstract was missing, Semantic Scholar's public paper-by-DOI endpoint was queried; raw responses are `raw/s2_*.json`.
- ArXiv was queried at the instructed `http://export.arxiv.org/api/query`. The first Fuss–Catalan query returned HTTP 503 after repeated attempts; subsequent attempts and an HTTPS retry timed out. A one-result probe also timed out. No arXiv query returned usable results, so the arXiv portion of task 3 was attempted but not completed. OpenAlex does index some arXiv preprints, and those records are included where returned. Semantic Scholar records supplied arXiv identifiers for some papers below. No relevant claim is based on the original failed collector; all entries below were checked against responses saved under `raw/`.
- Citations in the shortlist reproduce the fields quoted from the indicated API response (year is `publication_year` in OpenAlex unless explicitly labeled Semantic Scholar). Titles, author order, venue and page fields are not silently reconciled across databases. The overlap assessments are **based on title and abstract only**. Missing abstracts are explicitly labeled; a risk rating without an abstract is necessarily tentative.

## 1. Verification of the three given references

| Reference in `references/README.md` | Crossref title, authors, journal, volume, issue, pages, year, DOI | Result |
|---|---|---|
| Matjaž Konvalinka, “Divisibility of generalized Catalan numbers” | “Divisibility of generalized Catalan numbers”; Matjaž Konvalinka (serialized accent is malformed in the API response); *Journal of Combinatorial Theory, Series A* **114**, no. 6, 1089–1100; 2007; `10.1016/j.jcta.2006.11.003` | **All requested fields agree.** The API accent encoding is an artifact, not a substantive mismatch. |
| Emeric Deutsch and Bruce E. Sagan, “Congruences for Catalan and Motzkin numbers and related sequences” | “Congruences for Catalan and Motzkin numbers and related sequences”; Emeric Deutsch; Bruce E. Sagan; *Journal of Number Theory* **117**, no. 1, 191–215; 2006; `10.1016/j.jnt.2005.06.005` | **All requested fields agree.** |
| Alexander Postnikov and Bruce E. Sagan, “What power of two divides a weighted Catalan number?” | “What power of two divides a weighted Catalan number?”; Alexander Postnikov; Bruce E. Sagan; *Journal of Combinatorial Theory, Series A* **114**, no. 5, 970–977; 2007; `10.1016/j.jcta.2006.09.007` | **All requested fields agree.** |

No bibliographic discrepancy was found. This validates those fields against Crossref, not every field of the published papers.

## 2. Ranked shortlist of possible overlap

### 2.1 Yibo Gao; Andrew Gu — “Arithmetic of weighted Catalan numbers”

**Full citation exactly in the salient OpenAlex fields:** Yibo Gao; Andrew Gu. “Arithmetic of weighted Catalan numbers” (2021), *Journal of Number Theory*, volume 226, pp. 213–242; issue not supplied. DOI/URL: https://doi.org/10.1016/j.jnt.2021.03.007. OpenAlex: https://openalex.org/W3155756897. Source: `raw/citing_konvalinka_2007_page1.json`.

**Abstract excerpt (Semantic Scholar; OpenAlex supplied no abstract):** “We obtain the same result under weaker conditions by considering a map from a class of functions to $2$-adic integers. These methods are also extended to $q$-weighted Catalan numbers, strengthening a previous result by Konvalinka.” The abstract begins: “In this paper, we study arithmetic properties of weighted Catalan numbers.”

**Overlap risk: high for weighted arithmetic extensions; medium for the unweighted tree-symmetry goal.** The title and abstract directly concern arithmetic and a strengthening of Konvalinka's weighted results. The abstract's stated mechanisms are weaker conditions, `2`-adic functions and extensions to `q`-weights; it does not mention tree symmetries or the target exact unweighted formula. Based on title and abstract only; full-text reading is essential before a novelty claim.

### 2.2 Alexander Postnikov; Bruce E. Sagan — “What power of two divides a weighted Catalan number?”

**Full citation exactly as returned by Crossref:** Alexander Postnikov; Bruce E. Sagan. “What power of two divides a weighted Catalan number?” *Journal of Combinatorial Theory, Series A* 114 (2007), issue 5, pages 970–977. DOI: https://doi.org/10.1016/j.jcta.2006.09.007. Source: `raw/crossref_postnikov_sagan_2007.json`.

**Abstract excerpt (Semantic Scholar; mathematical typography lightly normalized):** “We give a condition on b which implies that [the base-two exponent of the weighted Catalan number equals the base-two exponent of the ordinary Catalan number]. In the special case [of the square weights], this settles a conjecture of Postnikov about the number of plane Morse links. Our proof generalizes the recent combinatorial proof of Deutsch and Sagan of the classical formula for [the base-two exponent of the ordinary Catalan number].”

**Overlap risk: high for combinatorial valuation methods in the `q=2`, weighted setting; medium for exact prime-power Fuss–Catalan valuations.** It explicitly advertises a combinatorial proof of the ordinary Catalan valuation and a weighted generalization. It does not, in its abstract, claim prime-power branching factors or a Sylow/tree-orbit argument. Based on title and abstract only.

### 2.3 Christian Krattenthaler; Thomas W. Müller — “A method for determining the mod-$$p^k$$ behaviour of recursive sequences”

**Full citation exactly in the salient OpenAlex fields:** Christian Krattenthaler; Thomas W. Müller. “A method for determining the mod-$$p^k$$ behaviour of recursive sequences” (2025), *Aequationes Mathematicae* **99**, issue 6, pp. 2505–2547. DOI: https://doi.org/10.1007/s00010-025-01195-0. OpenAlex: https://openalex.org/W4414052458. Source: the seed citing lists and `raw/openalex_search_fuss_catalan_padic.json`.

**Abstract excerpt (OpenAlex):** “We present a method for obtaining congruences modulo powers of a prime number p for combinatorial sequences whose generating function satisfies an algebraic differential equation. … Our applications include congruences for numbers of non-crossing graphs and numbers of Kreweras walks modulo powers of 3, as well as congruences for Fuß–Catalan numbers and blossom-tree numbers modulo powers of arbitrary primes.”

**Overlap risk: high for prime-power residues; low for a symmetry proof.** It explicitly includes Fuss–Catalan numbers modulo arbitrary prime powers, so the full paper must be inspected before stating the residue problem is new. Its abstract's method is differential equations and recurrences, not group actions or the exact valuation via trees. Based on title and abstract only.

### 2.4 Manuel Kauers; Christian Krattenthaler; Thomas W. Müller — “A Method for Determining the Mod-$2^k$ Behaviour of Recursive Sequences, with Applications to Subgroup Counting”

**Full citation exactly in the salient OpenAlex fields:** Manuel Kauers; Christian Krattenthaler; Thomas W. Müller. “A Method for Determining the Mod-$2^k$ Behaviour of Recursive Sequences, with Applications to Subgroup Counting” (2012), *The Electronic Journal of Combinatorics* **18**, issue 2; no pages supplied. DOI: https://doi.org/10.37236/2433. OpenAlex: https://openalex.org/W2949582468. Source: `raw/citing_postnikov_sagan_2007_page1.json`.

**Abstract excerpt (OpenAlex):** “We present a method to obtain congruences modulo powers of $2$ for sequences given by recurrences of finite depth with polynomial coefficients. We apply this method to Catalan numbers, Fuß--Catalan numbers, and to subgroup counting functions associated with Hecke groups and their lifts.”

**Overlap risk: medium for prime-power congruences; low for the tree-symmetry method.** This directly covers `2`-power congruences for Fuss–Catalan numbers, but the abstract attributes them to recurrences. The phrase “subgroup counting” refers to Hecke groups, not an announced action on trees. Based on title and abstract only.

### 2.5 Zachar Stier; Julian Wellman; Zixuan Xu — “Dihedral sieving on cluster complexes”

**Full citation exactly in the salient OpenAlex fields:** Zachar Stier; Julian Wellman; Zixuan Xu. “Dihedral sieving on cluster complexes” (2021), *Enumerative Combinatorics and Applications* **2**, issue 2, “Article #S2R9”. DOI: https://doi.org/10.54550/eca2022v2s2r9. OpenAlex: https://openalex.org/W3211076206. Source: `raw/openalex_search_fuss_catalan_padic.json`.

**Abstract excerpt (OpenAlex):** “The cyclic sieving phenomenon of Reiner, Stanton, and White characterizes the stabilizers of cyclic group actions on finite sets using q-analogue polynomials. … In the type A case, we show that the Raney numbers count both reflection-symmetric k-angulations of an n-gon and a particular evaluation of the q,t-Fuss-Catalan numbers.”

**Overlap risk: medium for cyclic group actions and the Fuss–Catalan/Raney setting; low for the target valuation as stated in the abstract.** It is the clearest returned abstract involving group actions and Fuss–Catalan objects. It concerns cluster complexes, polygon symmetries and cyclic sieving, not an exact digit-sum valuation or a wreath-product action on `q`-ary trees. Based on title and abstract only; the bibliography and full text should still be checked for relevant valuation arguments.

### 2.6 Jacob Bobrowski; Tian-Xiao He; Peter J.-S. Shiue — “Divisibility of Generalized Catalan Numbers and Raney Numbers”

**Full citation exactly in the salient OpenAlex fields:** Jacob Bobrowski; Tian-Xiao He; Peter J.-S. Shiue. “Divisibility of Generalized Catalan Numbers and Raney Numbers” (2019), *Journal of Computational Analysis and Applications* **26**, issue 6, first page 1047; no last page or DOI supplied. URL: https://digitalscholarship.unlv.edu/math_fac_articles/57/. OpenAlex: https://openalex.org/W2809841890. Source: `raw/openalex_search_generalized_catalan_divisibility.json`.

**Abstract:** no abstract available.

**Overlap risk: medium, based on title only.** The title directly covers generalized-Catalan and Raney divisibility. Without an abstract I cannot assess whether it treats exact valuations, prime powers or symmetry arguments; no abstract is available. This is a mandatory full-text check, not evidence either for or against the candidate proof.

### 2.7 Guoce Xin; Jing-Feng Xu — “A Short Approach to Catalan Numbers Modulo $2^r$”

**Full citation exactly in the salient OpenAlex fields:** Guoce Xin; Jing-Feng Xu. “A Short Approach to Catalan Numbers Modulo $2^r$” (2011), *The Electronic Journal of Combinatorics* **18**, issue 1; no pages supplied. DOI: https://doi.org/10.37236/664. OpenAlex: https://openalex.org/W1540387088. Source: all three OpenAlex citing lists.

**Abstract excerpt (OpenAlex):** “This recursion is ideal for the study of the congruences of $C_n$ modulo $2^r$ … Moreover, by using connections between weighted Dyck paths and Motzkin paths, we find new classes of combinatorial sequences whose $2$-adic order is equal to that of $C_n$, which is one less than the sum of the digits of the binary expansion of $n+1$.”

**Overlap risk: medium for weighted/binary extensions; low for general Fuss–Catalan tree actions.** The exact ordinary-Catalan digit formula and weighted paths are directly related, but only ordinary Catalan congruences and a recursion are claimed in the abstract. Based on title and abstract only.

### 2.8 Shu-chung Liu; Jean C.-C. Yeh — “Catalan Numbers Modulo 2^k”

**Full citation exactly in the salient OpenAlex fields:** Shu-chung Liu; Jean C.-C. Yeh. “Catalan Numbers Modulo 2^k”. OpenAlex supplies no year, venue or DOI; `biblio` fields are null. URL: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.183.9744. OpenAlex: https://openalex.org/W2103798576. Source: the Deutsch–Sagan and Postnikov–Sagan citing lists.

**Abstract excerpt (OpenAlex):** “In this paper, we develop a systematic tool to calculate the congruences of some combinatorial numbers involving n!. Using this tool, we re-prove Kummer’s and Lucas’ theorems in a unique concept, and classify the congruences of the Catalan numbers cn (mod 64). … a general formula with powers of 2 and 5 can evaluate cn (mod 2 k) for any k.”

**Overlap risk: low for the demanded group-action proof; medium for residue background.** The methods advertised use factorial congruences and Kummer/Lucas re-proofs, not tree symmetries. It concerns ordinary Catalan residues, not the general Fuss–Catalan formula. Based on title and abstract only.

### 2.9 B. Sury — “Generalized Catalan Numbers: Linear Recursion and Divisibility”

**Full citation exactly in the salient OpenAlex fields:** B. Sury. “Generalized Catalan Numbers: Linear Recursion and Divisibility” (2009). No venue, DOI, volume, issue or pages supplied. URL: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.189.1227. OpenAlex: https://openalex.org/W83515202. Source: `raw/openalex_search_generalized_catalan_divisibility.json`.

**Abstract excerpt (OpenAlex):** “We prove a linear recursion for the generalized Catalan numbers … As a consequence, we show p | Cp(n) if and only if … Using certain beautiful results of Kummer and Legendre, we give a second proof of the divisibility result for Cp(n). We also give suitably formulated inductive proofs of Kummer’s and Legendre’s formulae which are different from the standard proofs.”

**Overlap risk: low for a tree-symmetry proof of the full exact formula; medium for elementary divisibility criteria.** Its abstract offers only a prime-divisibility criterion and recursion/Kummer/Legendre proofs. No complete valuation formula or tree action is claimed there. Based on title and abstract only.

### 2.10 Michelle Bodnar; Brendon Rhoades — “Cyclic Sieving and Rational Catalan Theory”

**Full citation exactly in the salient OpenAlex fields:** Michelle Bodnar; Brendon Rhoades. “Cyclic Sieving and Rational Catalan Theory” (2016), *The Electronic Journal of Combinatorics* **23**, issue 2; no pages supplied. DOI: https://doi.org/10.37236/5681. OpenAlex: https://openalex.org/W2268812832. Source: `raw/openalex_search_fuss_catalan_divisibility.json`.

**Abstract excerpt (OpenAlex):** “Confirming a conjecture of Armstrong et. al., we prove that [the rational noncrossing partitions] are closed under rotation and prove an instance of the cyclic sieving phenomenon for this rotational action. We also define a rational generalization of the … noncrossing parking functions …”

**Overlap risk: low for the arithmetic target; medium as a neighboring cyclic-action method.** It establishes a cyclic action on rational noncrossing partitions, not a divisibility or valuation formula. Based on title and abstract only.

### 2.11 Sen‐Peng Eu; Zai-Ting Huang; Louis Kao — “Zero-Run Spectra of the $(3,2)$ Raney numbers Modulo Primes”

**Full citation exactly in the salient OpenAlex fields:** Sen‐Peng Eu; Zai-Ting Huang; Louis Kao. “Zero-Run Spectra of the $(3,2)$ Raney numbers Modulo Primes” (2026), *arXiv (Cornell University)*; no volume, issue, pages or DOI supplied. URL: https://arxiv.org/abs/2609.25742. OpenAlex: https://openalex.org/W7214245973. Source: `raw/openalex_search_raney_padic.json` and other searches.

**Abstract excerpt (OpenAlex):** “We study the zero-run structure of the $(3,2)$-Raney numbers modulo a prime $p$. … For $p=3$, we characterize exactly the nonzero terms and determine their residues. For $p\ge 5$, the zero runs are governed by a multiscale system of residue intervals modulo powers of $p$ …”

**Overlap risk: medium for specialized Raney-number residues; low for the exact general Fuss–Catalan valuation by tree symmetries.** The abstract addresses the particular `(3,2)` sequence and zero runs, not the general valuation formula or group actions. It is recent and should not be overlooked in a residue discussion. Based on title and abstract only.

### 2.12 Dixy Msapato — “Modular Fuss-Catalan numbers” (screened and distinguished from valuation work)

**Full citation exactly in the salient OpenAlex fields:** Dixy Msapato. “Modular Fuss-Catalan numbers” (2021), *Discrete Mathematics* **345**, issue 2, article 112704. DOI: https://doi.org/10.1016/j.disc.2021.112704. OpenAlex: https://openalex.org/W3039593090. Source: `raw/openalex_search_fuss_catalan_valuation.json`.

**Abstract excerpt (Semantic Scholar; OpenAlex supplied no abstract):** “The modular Catalan numbers $C_{k,n}$ … count equivalence classes of parenthesizations … where $*$ is a binary $k$-associative operation. … In this paper we introduce modular Fuss-Catalan numbers $C_{k,n}^{m}$ which count equivalence classes of parenthesizations … where $*$ is an $m$-ary $k$-associative operation for $m \geq 2$.”

**Overlap risk: low for the stated problem.** “Modular” describes associativity equivalence classes, not modular arithmetic, the exact valuation or a group action on trees. Based on title and abstract only.

### Results of the Kummer and tree-action searches

The broad OpenAlex query `Kummer theorem combinatorial proof group actions` returned 1,253 hits dominated by Kummer surfaces/Galois theory in its first 100 records; no title-and-abstract candidate for the target proof appeared among the records I inspected. The arXiv-specific version did not complete. Likewise, the query for binary-tree group-actions and 2-adic Catalan valuations (18 hits) returned the Gao–Gu paper but no additional direct symmetry/valuation candidate. The Raney-number p-adic search (34 hits) did not have “Raney” in any returned title, so it did not replace the related searches that found the papers above. This is evidence of what these queries surfaced, not a comprehensive negative literature result.

### Query coverage

Every OpenAlex response is saved under `raw/`; the actual count and number screened are:

| OpenAlex `search` string | Returned count | Records screened |
|---|---:|---:|
| `Fuss Catalan p-adic` | 36 | 36 |
| `Fuss Catalan valuation` | 63 | 63 |
| `Fuss Catalan divisibility` | 189 | first 100 |
| `"generalized Catalan numbers" divisibility` | 94 | 94 |
| `"generalized Catalan numbers" prime power` | 56 | 56 |
| `Raney numbers p-adic` | 34 | 34 |
| `Kummer theorem combinatorial proof group actions` | 1253 | first 100 |
| `2-adic valuation Catalan numbers group actions binary trees` | 18 | 18 |
| `Sylow wreath product trees Catalan numbers` | 5 | 5 |
| `weighted Catalan numbers divisibility` | 397 | first 100 |
| `Catalan numbers modulo prime powers` | 724 | first 100 |

The parallel arXiv queries included the corresponding named terms, including group actions, binary trees, Sylow/wreath products, generalized Catalan prime powers, Raney numbers and weighted Catalan divisibility. **All arXiv API attempts failed.** The OpenAlex searches are relevance-ranked keyword searches, not exact-phrase filters; therefore a zero appearance of a term is not by itself evidence that no relevant work exists.

## 3. Complete OpenAlex citing-work lists

The counts are the numbers actually returned: **12 + 84 + 23 = 119 seed-specific records**, each retrieved in a single page (so there are no omitted citing pages). Duplicate OpenAlex records across seed lists are intentionally retained. Papers citing each other are included as OpenAlex returned them. Year here means OpenAlex `publication_year`, which can be the online year rather than the Crossref print year; these are not silently corrected.

### Works citing Matjaž Konvalinka

OpenAlex `cites:` returned 12 records, captured in one page. This list is reproduced exactly as returned (including duplicates between seeds and seed papers citing one another).

| Title (OpenAlex `display_name`) | Authors (OpenAlex) | Year (OpenAlex) | Venue (OpenAlex `primary_location.source.display_name`) | DOI |
|---|---|---|---:|---|
| Some Combinatorial Interpretations and Applications of Fuss-Catalan Numbers | Chin-Hung Lin | 2011 | ISRN Discrete Mathematics | https://doi.org/10.5402/2011/534628 |
| A Short Approach to Catalan Numbers Modulo $2^r$ | Guoce Xin; Jing-Feng Xu | 2011 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/664 |
| What power of two divides a weighted Catalan number? | Alexander Postnikov; Bruce E. Sagan | 2006 | Journal of Combinatorial Theory Series A | https://doi.org/10.1016/j.jcta.2006.09.007 |
| A Lucas-type congruence for q-Delannoy numbers | Hao Pan | 2022 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2022.113260 |
| A combinatorial approach to the power of 2 in the number of involutions | Dongsu Kim; Jang Soo Kim | 2009 | Journal of Combinatorial Theory Series A | https://doi.org/10.1016/j.jcta.2009.08.002 |
| Chase-escape with death on trees | Erin Beckman; Keisha Cook; Nicole Eikmeier; Saraí Hernández-Torres; Matthew Junge | 2021 | The Annals of Probability | https://doi.org/10.1214/21-aop1514 |
| A Stern-type congruence for the Schröder numbers | Hui-Qin Cao; Hao Pan | 2017 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2016.11.013 |
| Arithmetic of weighted Catalan numbers | Yibo Gao; Andrew Gu | 2021 | Journal of Number Theory | https://doi.org/10.1016/j.jnt.2021.03.007 |
| A q-analogue of Wilson's congruence | Hao Pan; Yu-Chen Sun | 2021 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2021.102228 |
| Combinatorial enumeration of weighted Catalan numbers | Junkyu An | 2010 | DSpace@MIT (Massachusetts Institute of Technology) | not supplied |
| Perfect powers in Catalan and Narayana numbers | Sara Checcoli; Michele D’Adderio | 2013 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1306.5929 |
| Enumerative proof of a curious congruence for Eulerian numbers | Xiangzi Meng; Hao Pan | 2025 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2025.102977 |

### Works citing Emeric Deutsch and Bruce E. Sagan

OpenAlex `cites:` returned 84 records, captured in one page. This list is reproduced exactly as returned (including duplicates between seeds and seed papers citing one another).

| Title (OpenAlex `display_name`) | Authors (OpenAlex) | Year (OpenAlex) | Venue (OpenAlex `primary_location.source.display_name`) | DOI |
|---|---|---|---:|---|
| Supercongruences for polynomial analogs of the Apéry numbers | Armin Straub | 2018 | Proceedings of the American Mathematical Society | https://doi.org/10.1090/proc/14301 |
| Permutation patterns and statistics | Theodore Dokos; Tim Dwyer; Bryan P. Johnson; Bruce E. Sagan; Kimberly Selsor | 2012 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2012.05.014 |
| Automatic congruences for diagonals of rational functions | Eric Rowland; Reem Yassawi | 2015 | Journal de Théorie des Nombres de Bordeaux | https://doi.org/10.5802/jtnb.901 |
| q-Congruences, with applications to supercongruences and the cyclic sieving phenomenon | Ofir Gorodetsky | 2019 | International Journal of Number Theory | https://doi.org/10.1142/s1793042119501069 |
| Generalized Fibonacci Polynomials and Fibonomial Coefficients | Tewodros Amdeberhan; Xi Chen; Victor H. Moll; Bruce E. Sagan | 2014 | Annals of Combinatorics | https://doi.org/10.1007/s00026-014-0242-9 |
| Catalan and Motzkin numbers modulo 4 and 8 | Sen‐Peng Eu; Shu‐Chung Liu; Yeong‐Nan Yeh | 2007 | European Journal of Combinatorics | https://doi.org/10.1016/j.ejc.2007.06.019 |
| Inversion polynomials for 321-avoiding permutations | Szu-En Cheng; Sergi Elizalde; Anisse Kasraoui; Bruce E. Sagan | 2013 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2013.07.026 |
| Divisibility properties of sporadic Apéry-like numbers | Amita Malik; Armin Straub | 2016 | Research in Number Theory | https://doi.org/10.1007/s40993-016-0036-8 |
| New Representations for all Sporadic Apéry-Like Sequences, With Applications to Congruences | Ofir Gorodetsky | 2021 | Experimental Mathematics | https://doi.org/10.1080/10586458.2021.1982080 |
| A Serre spectral sequence for the moduli space of tropical curves | Christin Bibby; Melody Chan; Nir Gadish; Claudia He Yun | 2017 | Journal of Combinatorial Algebra | https://doi.org/10.4171/jca/121 |
| A method for determining the mod-$$p^k$$ behaviour of recursive sequences | Christian Krattenthaler; Thomas W. Müller | 2025 | Aequationes Mathematicae | https://doi.org/10.1007/s00010-025-01195-0 |
| Skew Dyck paths | Emeric Deutsch; Emanuele Munarini; Simone Rinaldi | 2010 | Journal of Statistical Planning and Inference | https://doi.org/10.1016/j.jspi.2010.01.015 |
| On Some Quadratic Algebras I 1/2: Combinatorics of Dunkl and Gaudin Elements, Schubert, Grothendieck, Fuss-Catalan, Universal Tutte and Reduced Polynomials | Anatol N. Kirillov | 2016 | Symmetry Integrability and Geometry Methods and Applications | https://doi.org/10.3842/sigma.2016.002 |
| Supercongruences for Apéry-like numbers | Robert Osburn; Brundaban Sahu | 2011 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2011.03.002 |
| Elliptic Curves Arising from the Spectral Zeta Function for Non-Commutative Harmonic Oscillators and Γ0(4)-Modular Forms | K. KIMOTO; Masato Wakayama | 2006 | WORLD SCIENTIFIC eBooks | https://doi.org/10.1142/9789812772398_0011 |
| Riordan graphs I: Structural properties | Gi‐Sang Cheon; Ji-Hwan Jung; Sergey Kitaev b; Seyed Ahmad Mojallal | 2019 | Linear Algebra and its Applications | https://doi.org/10.1016/j.laa.2019.05.033 |
| A Short Approach to Catalan Numbers Modulo $2^r$ | Guoce Xin; Jing-Feng Xu | 2011 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/664 |
| Generalized Lucas congruences and linear p-schemes | Joel Henningsen; Armin Straub | 2022 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2022.102409 |
| On congruence schemes for constant terms and their applications | Armin Straub | 2022 | Research in Number Theory | https://doi.org/10.1007/s40993-022-00337-6 |
| Riordan graphs II: Spectral properties | Gi‐Sang Cheon; Ji-Hwan Jung; Sergey Kitaev b; Seyed Ahmad Mojallal | 2019 | Linear Algebra and its Applications | https://doi.org/10.1016/j.laa.2019.04.011 |
| On the Congruences of Some Combinatorial Numbers | Sen‐Peng Eu; Shu‐Chung Liu; Yeong‐Nan Yeh | 2005 | Studies in Applied Mathematics | https://doi.org/10.1111/j.1467-9590.2006.00337.x |
| What power of two divides a weighted Catalan number? | Alexander Postnikov; Bruce E. Sagan | 2006 | Journal of Combinatorial Theory Series A | https://doi.org/10.1016/j.jcta.2006.09.007 |
| Divisibility of generalized Catalan numbers | Matjaž Konvalinka | 2006 | Journal of Combinatorial Theory Series A | https://doi.org/10.1016/j.jcta.2006.11.003 |
| Motzkin numbers and related sequences modulo powers of 2 | Christian Krattenthaler; Thomas W. Müller | 2018 | European Journal of Combinatorics | https://doi.org/10.1016/j.ejc.2018.05.004 |
| Arithmetic properties of Apéry-like numbers | Éric Delaygue | 2017 | Compositio Mathematica | https://doi.org/10.1112/s0010437x17007552 |
| A Lucas-type congruence for q-Delannoy numbers | Hao Pan | 2022 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2022.113260 |
| Uniform Recurrence in the Motzkin Numbers and Related Sequences mod $p$ | Nadav Kohen | 2025 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/13089 |
| Some general results in combinatorial enumeration | Martin Klazar | 2010 | Cambridge University Press eBooks | https://doi.org/10.1017/cbo9780511902499.002 |
| A combinatorial approach to the power of 2 in the number of involutions | Dongsu Kim; Jang Soo Kim | 2009 | Journal of Combinatorial Theory Series A | https://doi.org/10.1016/j.jcta.2009.08.002 |
| Right-jumps and pattern avoiding permutations | Cyril Banderier; Jean-Luc Baril; Céline Moreira dos Santos | 2017 | Discrete Mathematics & Theoretical Computer Science | https://doi.org/10.46298/dmtcs.1344 |
| ON DIVISIBILITY PROPERTIES OF SOME DIFFERENCES OF THE CENTRAL BINOMIAL COEFFICIENTS AND CATALAN NUMBERS | Tamás Lengyel | 2014 | De Gruyter eBooks | https://doi.org/10.1515/9783110298161.129 |
| A note on divisors of multinomial coefficients | Josef Rukavicka | 2015 | Archiv der Mathematik | https://doi.org/10.1007/s00013-015-0770-5 |
| On some conjectures of P. Barry | Jean‐Paul Allouche; Guo-Niu Han; Jeffrey O. Shallit | 2021 | Journal of Number Theory | https://doi.org/10.1016/j.jnt.2021.03.015 |
| The Lagrange Inversion Formula and Divisibility Properties | Wen-Jin Woan | 2007 | not supplied | not supplied |
| Catalan numbers, primes, and twin primes | Christian Aebi; Grant Cairns | 2008 | Elemente der Mathematik | https://doi.org/10.4171/em/103 |
| EXACT p-ADIC ORDERS FOR DIFFERENCES OF MOTZKIN NUMBERS | Tamás Lengyel | 2013 | International Journal of Number Theory | https://doi.org/10.1142/s1793042113501157 |
| A Stern-type congruence for the Schröder numbers | Hui-Qin Cao; Hao Pan | 2017 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2016.11.013 |
| On the Parity of Certain Coefficients for a $q$-Analogue of the Catalan Numbers | Kendra Killpatrick | 2012 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/2313 |
| ON THE GROUP STRUCTURE OF [ S2, Y] | M. Golasi ski; Daciberg Lima Gonçalves; Peter N.-S. Wong | 2014 | The Quarterly Journal of Mathematics | https://doi.org/10.1093/qmath/hau023 |
| A Representation Theorem for Holonomic Sequences Based on Counting Lattice Paths | Tomer Kotek; Johann A. Makowsky | 2012 | Fundamenta Informaticae | https://doi.org/10.3233/fi-2012-696 |
| On divisibility properties of some differences of Motzkin numbers | Tamás Lengyel | 2012 | Acta Biologica Plantarum Agriensis (Eszterházy Károly University, Hungary) | not supplied |
| Generalised Apéry numbers modulo 9 | Christian Krattenthaler; Thomas W. Müller | 2014 | Journal of Number Theory | https://doi.org/10.1016/j.jnt.2014.08.016 |
| Extreme Palindromes | Kathy Q. Ji; Herbert S. Wilf | 2008 | American Mathematical Monthly | https://doi.org/10.1080/00029890.2008.11920548 |
| The Gram determinant for plane curves | Józef H. Przytycki; Xiaoqi Zhu | 2010 | Involve a Journal of Mathematics | https://doi.org/10.2140/involve.2010.3.149 |
| On the group structure of $$[J(X), \Omega (Y)]$$ | Marek Golasiński; Daciberg Lima Gonçalves; Peter N.-S. Wong | 2016 | Journal of Homotopy and Related Structures | https://doi.org/10.1007/s40062-016-0145-z |
| Diameter of Io-Decomposable Riordan Graphs of the Bell Type | Ji-Hwan Jung | 2021 | Graphs and Combinatorics | https://doi.org/10.1007/s00373-021-02427-1 |
| The Fractal Nature of the Fibonomial Triangle | Chen, X.; Bruce E. Sagan | 2014 | not supplied | https://doi.org/10.5281/zenodo.10429106 |
| Arithmetic of weighted Catalan numbers | Yibo Gao; Andrew Gu | 2021 | Journal of Number Theory | https://doi.org/10.1016/j.jnt.2021.03.007 |
| A q-analogue of Wilson's congruence | Hao Pan; Yu-Chen Sun | 2021 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2021.102228 |
| Odd Catalan Numbers Modulo | Hsueh-Yung Lin | 2011 | Integers | https://doi.org/10.1515/integ.2011.093 |
| Congruence Properties of Combinatorial Sequences via Walnut and the Rowland-Yassawi-Zeilberger Automaton | Narad Rampersad; Jeffrey O. Shallit | 2022 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/10799 |
| Congruences of Finite Summations of the Coefficients in certain Generating Functions | Po-Yi Huang; Shu‐Chung Liu; Yeong‐Nan Yeh | 2014 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/3693 |
| The On-Line Encyclopedia of Integer Sequences | Neil J.A. Sloane | 2007 | Lecture notes in computer science | https://doi.org/10.1007/978-3-540-73086-6_12 |
| Lucas' theorem: its generalizations, extensions and applications (1878--2014) | Romeo Meštrović | 2014 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1409.3820 |
| Overview of some general results in combinatorial enumeration | Martin Klazar | 2008 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.0803.4292 |
| Counting With Irrational Tiles | Scott Garrabrant; Igor Pak | 2014 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1407.8222 |
| On divisibility of Narayana numbers by primes | Miklós Bóna; Bruce E. Sagan | 2005 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.math/0505382 |
| Arithmetic properties of Apéry-like numbers | Éric Delaygue | 2013 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1310.4131 |
| Catalan Numbers Modulo 2^k | Shu-chung Liu; Jean C.-C. Yeh | not supplied | not supplied | not supplied |
| Some elementary observations on Narayana polynomials and related topics | Johann Cigler | 2016 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1611.05252 |
| Structure and asymptotics for Motzkin numbers modulo small primes using automata | Burns, Rob | 2016 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1612.08146 |
| ODD CATALAN NUMBERS MODULO 2 k | Hsueh-Yung Lin | 2011 | not supplied | not supplied |
| Structure and asymptotics for Catalan numbers modulo primes using automata | Burns, Rob | 2017 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1701.02975 |
| Combinatorial enumeration of weighted Catalan numbers | Junkyu An | 2010 | DSpace@MIT (Massachusetts Institute of Technology) | not supplied |
| The fractal nature of the Fibonomial triangle | Xi Chen; Bruce E. Sagan | 2013 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1306.2377 |
| Asymptotic density of Motzkin numbers modulo small primes | Burns, Rob | 2016 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1611.04910 |
| Legendre's formula and $p$-adic analysis | Gennady Eremin | 2019 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1907.11902 |
| Perfect powers in Catalan and Narayana numbers | Sara Checcoli; Michele D’Adderio | 2013 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1306.5929 |
| Inversion polynomials for 321-avoiding permutations: addendum | Szu-En Cheng; Sergi Elizalde; Anisse Kasraoui; Bruce E. Sagan | 2013 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1305.3845 |
| A short proof of the Deutsch-Sagan congruence for connected non crossing graphs | Ira M. Gessel | 2014 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1403.7656 |
| Asymptotic density of Catalan numbers modulo 3 and powers of 2 | Burns, Rob | 2016 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1611.03705 |
| Improved Lower Bounds for Property B | Karl Grill; Daniel Linzmayer; TU Wien | 2024 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.2403.05674 |
| ARITHMETIC PROPERTIES FOR AP ´ ERY-LIKE NUMBERS | Dermot McCarthy; Robert Osburn; Brundaban Sahu | 2009 | arXiv (Cornell University) | not supplied |
| The odd Catalan numbers modulo 2^k | Hsueh-Yung Lin | 2010 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1012.1756 |
| Factoring Catalan numbers | Gennady Eremin | 2019 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1908.03752 |
| On the period mod $m$ of polynomially-recursive sequences: a case study | Cyril Banderier; Florian Luca | 2019 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1903.01986 |
| The central component of a triangulation | Alon Regev | 2012 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1210.3349 |
| On a conjecture of Deutsch, Sagan, and Wilson | Jean‐Paul Allouche | 2006 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.math/0606670 |
| P-Recursive Integer Sequences and Automata Theory | Scott Garrabrant | 2015 | eScholarship (California Digital Library) | not supplied |
| Partition asymptotics; zeros of zeta functions; and Apéry-like numbers | Amita Malik | 2017 | Illinois Digital Environment for Access to Learning and Scholarship (University of Illinois at Urbana-Champaign) | not supplied |
| Walking in the OEIS: From Motzkin numbers to Fibonacci numbers. The "shadows" of Motzkin numbers | Gennady Eremin | 2021 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.2108.10676 |
| Lattice Paths With a First Return Decomposition Constrained by the Maximal Height of a Pattern | Jean-Luc Baril; Sergey Kirgizov | 2021 | Discrete Mathematics Letters | https://doi.org/10.47443/dml.2021.0108 |
| Discovering the Fascinating Pattern in the Geometric Representation of Non-intersecting Chords on the Circle within the Motzkin Sequence | Haslinda Ibrahim; Maizon Mohd Darus; Sharmila Binti Karim | 2025 | JOIV International Journal on Informatics Visualization | https://doi.org/10.62527/joiv.9.2.2766 |
| Enumerative proof of a curious congruence for Eulerian numbers | Xiangzi Meng; Hao Pan | 2025 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2025.102977 |

### Works citing Alexander Postnikov and Bruce E. Sagan

OpenAlex `cites:` returned 23 records, captured in one page. This list is reproduced exactly as returned (including duplicates between seeds and seed papers citing one another).

| Title (OpenAlex `display_name`) | Authors (OpenAlex) | Year (OpenAlex) | Venue (OpenAlex `primary_location.source.display_name`) | DOI |
|---|---|---|---:|---|
| A realization of graph associahedra | Satyan L. Devadoss | 2008 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2007.12.092 |
| Permutation patterns and statistics | Theodore Dokos; Tim Dwyer; Bryan P. Johnson; Bruce E. Sagan; Kimberly Selsor | 2012 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2012.05.014 |
| Marked tubes and the graph multiplihedron | Satyan L. Devadoss; Stefan Forcey | 2008 | Algebraic & Geometric Topology | https://doi.org/10.2140/agt.2008.8.2081 |
| A Method for Determining the Mod-$2^k$ Behaviour of Recursive Sequences, with Applications to Subgroup Counting | Manuel Kauers; Christian Krattenthaler; Thomas W. Müller | 2012 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/2433 |
| A Short Approach to Catalan Numbers Modulo $2^r$ | Guoce Xin; Jing-Feng Xu | 2011 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/664 |
| Divisibility of generalized Catalan numbers | Matjaž Konvalinka | 2006 | Journal of Combinatorial Theory Series A | https://doi.org/10.1016/j.jcta.2006.11.003 |
| Identities on Extended Catalan Numbers and Their q-Analogs | Roberta Rui Zhou; Wenchang Chu | 2016 | Graphs and Combinatorics | https://doi.org/10.1007/s00373-016-1694-y |
| p -Regularity of the p -Adic Valuation of the Fibonacci Sequence | Luis A. Medina; Eric Rowland | 2015 | The Fibonacci Quarterly | https://doi.org/10.1080/00150517.2015.12428269 |
| A Lucas-type congruence for q-Delannoy numbers | Hao Pan | 2022 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2022.113260 |
| On the p-adic valuation of stirling numbers of the first kind | Paolo Leonetti; Carlo Sanna | 2016 | Acta Mathematica Academiae Scientiarum Hungaricae | https://doi.org/10.1007/s10474-016-0680-4 |
| A combinatorial approach to the power of 2 in the number of involutions | Dongsu Kim; Jang Soo Kim | 2009 | Journal of Combinatorial Theory Series A | https://doi.org/10.1016/j.jcta.2009.08.002 |
| Chase-escape with death on trees | Erin Beckman; Keisha Cook; Nicole Eikmeier; Saraí Hernández-Torres; Matthew Junge | 2021 | The Annals of Probability | https://doi.org/10.1214/21-aop1514 |
| On the k -regularity of the k -adic valuation of Lucas sequences | Nadir Murru; Carlo Sanna | 2018 | Journal de Théorie des Nombres de Bordeaux | https://doi.org/10.5802/jtnb.1025 |
| A Stern-type congruence for the Schröder numbers | Hui-Qin Cao; Hao Pan | 2017 | Discrete Mathematics | https://doi.org/10.1016/j.disc.2016.11.013 |
| Arithmetic of weighted Catalan numbers | Yibo Gao; Andrew Gu | 2021 | Journal of Number Theory | https://doi.org/10.1016/j.jnt.2021.03.007 |
| A q-analogue of Wilson's congruence | Hao Pan; Yu-Chen Sun | 2021 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2021.102228 |
| Congruences of Finite Summations of the Coefficients in certain Generating Functions | Po-Yi Huang; Shu‐Chung Liu; Yeong‐Nan Yeh | 2014 | The Electronic Journal of Combinatorics | https://doi.org/10.37236/3693 |
| Catalan Numbers Modulo 2^k | Shu-chung Liu; Jean C.-C. Yeh | not supplied | not supplied | not supplied |
| Polynomial Coefficient Enumeration | Tewodros Amdeberhan; Richard P. Stanley | 2008 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.0811.3652 |
| Combinatorial enumeration of weighted Catalan numbers | Junkyu An | 2010 | DSpace@MIT (Massachusetts Institute of Technology) | not supplied |
| Legendre's formula and $p$-adic analysis | Gennady Eremin | 2019 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1907.11902 |
| Perfect powers in Catalan and Narayana numbers | Sara Checcoli; Michele D’Adderio | 2013 | arXiv (Cornell University) | https://doi.org/10.48550/arxiv.1306.5929 |
| Enumerative proof of a curious congruence for Eulerian numbers | Xiangzi Meng; Hao Pan | 2025 | Advances in Applied Mathematics | https://doi.org/10.1016/j.aam.2025.102977 |



## 4. What I could not check

1. **Full text and novelty.** I did not download or read the full text of any shortlist paper. I cannot certify that the target formula, a tree-symmetry proof, a residue of the unit modulo `p`, or a weighted extension is absent from these papers. Gao–Gu, Postnikov–Sagan, Krattenthaler–Müller (2012/2025), Bobrowski–He–Shiue and Stier–Wellman–Xu are the most urgent full-text checks.
2. **ArXiv search.** The failed requests and timeouts mean there is **no completed arXiv-API coverage**. OpenAlex/Semantic Scholar records include some arXiv items but are not a substitute for executing those searches.
3. **Exhaustive keyword coverage.** I examined one OpenAlex page per search; for the broad “Kummer theorem combinatorial proof group actions” query, many first-page results concerned unrelated Kummer objects. Later pages could conceal relevant material. No other databases (MathSciNet, zbMATH, Google Scholar, the OEIS, journals' own full-text search) were searched.
4. **Second-generation citations.** I used the three seed works' direct citing lists, but did not page forward through citations of every promising item such as Gao–Gu (2021) or Stier–Wellman–Xu (2021).
5. **Database accuracy and equivalence.** OpenAlex covers neither every publication nor every citation; some records are incomplete. I reported data from returned records, without treating two API records as distinct papers unless they were independently returned. Journal-metadata discrepancies across OpenAlex, Crossref and Semantic Scholar were not exhaustively reconciled except for the three seed works against Crossref.
6. **Failed collection attempts.** My first broad collection script repeatedly retried arXiv HTTP 503s and was stopped after metadata reads began to stall. It was replaced with an OpenAlex-only collector. The completed raw responses and request log were checked; the failed arXiv requests may be incompletely represented in that log. Only the raw records actually received and then checked are used above.
7. **Machine-readable verification.** No script checked that all prose in the shortlist agrees with the saved APIs; I manually checked the key citation fields and quoted abstract excerpts against those saved records. The full citing table was generated from the saved citing JSON and re-read. No novelty conclusion should be drawn without human full-text review.
