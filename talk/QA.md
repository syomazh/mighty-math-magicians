# Questions a judge might ask, with answers you can say aloud

Written by Claude Fable 5.2 (AI), 2026-11-14, for the presenters. Answers are short on purpose. "SG n" points to exercise n of `notes/study_guide.md`.

**Status tags.** As of Saturday morning no claim is human-signed. Each answer that rests on our own claims carries the claim IDs from `CLAIMS.md`; once the grad student or professor signs a claim, strike the tag. Until then say "our argument shows" rather than "we proved".

---

## A. Motivation

**1. Why should anyone care about the power of p in a Catalan number?**
It is the simplest question you can ask about a counting sequence beyond its size, and the answer is surprisingly clean: the power of 2 in C_n is the number of ones in the binary expansion of n+1, minus one. A clean answer to a counting question deserves an explanation in terms of the objects being counted.

**2. The formula is already proved. What is the point of another proof?**
The known proof computes with factorials (Legendre's formula) and tells you the answer without telling you why base-p digits have anything to do with trees. The problem asks for a proof where the digits come out of the trees themselves. That is also the theme of this Mathathon: old problems, new proofs.

**3. What is the one-sentence reason the digit sum appears?**
The most symmetric trees are built from complete subtrees whose sizes are the base-p digits of the number of leaves, and counting them modulo p amounts to carrying in base p. (C3, C5)

**4. Is there a picture from outside mathematics?**
For p = 3 our classes of trees are exactly the stereoisomers of alkyl radicals: a carbon atom's three other bonds can be rotated but not reflected, which is our rotation. For p = 2 they are the shapes of evolutionary trees. We checked both counts against the OEIS (A000625 and A001190). (C15)

## B. The statement

**5. State the theorem.**
For a prime p and q = p^k, the number of q-ary trees with n nodes is divisible by p exactly t times, where t = (s − 1)/(p − 1) and s is the sum of the base-p digits of m = (q−1)n + 1.

**6. What is m?**
The number of leaves, that is, of empty branches. Each node adds q − 1 leaves, starting from one. (SG vocabulary)

**7. Why is t an integer?**
m − 1 is a multiple of q − 1, hence of p − 1, and a number and its base-p digit sum leave the same remainder modulo p − 1 because every power of p is 1 modulo p − 1.

**8. Give an example.**
p = q = 2, n = 6: C = 132 = 4 · 33, m = 7 = 111 in binary, s = 3, t = 2. (SG 6)

**9. Do you get more than the valuation?**
Our argument also gives the residue: C / p^t ≡ (−1)^t / (product of the factorials of the digits of m) modulo p, for every prime power q. Konvalinka states the case q = p and says the general case is much more complicated. (C7)

## C. The group and the classes

**10. What is your group action?**
Redraw each q-ary node as a complete p-ary tree of height k. Then rotate the p children at any node. On one q-ary node these rotations generate a group of order p^((q−1)/(p−1)), a Sylow p-subgroup of the symmetric group on the q branches.

**11. Why not permute all q children, as Konvalinka does?**
Then orbit sizes are multinomial coefficients, which are not powers of p, and working out which orbits have the least power of p takes him three pages and still needs the factorial formula at the end. With a p-group every orbit size is a power of p and the bookkeeping becomes counting lopsided nodes.

**12. Why not simply rotate the q children cyclically?**
For q = 4 a pattern like A, B, A, B has two rotations, neither one nor four, so sizes are no longer q to the number of asymmetric nodes. Primality is exactly what prevents this. (SG 16)

**13. What is the size of a class?**
p^d, where d is the number of asymmetric nodes: nodes whose p branches are not all equivalent. (C1; SG 2–4)

**14. Where is primality used?**
A list of p items rotated by a non-zero amount comes back to itself only if all items are equal. So at each node the p rotations of the branch classes are either all the same or all different.

**15. Does the action preserve q-ary trees?**
Yes. A rotation does not change the depth of any leaf, and a p-ary tree comes from a q-ary tree exactly when all its leaves are at depths divisible by k.

## D. The lower bound

**16. Why is d at least t?**
Induction on the tree. At an asymmetric node, d is one plus the d's of the branches, and digit sums can only go down when you add the leaf counts, by p − 1 for each carry. At a symmetric node the leaf count is multiplied by p, which does not change the digit sum, while d is multiplied by p. (C2; SG 10, 11)

**16a. Can you say that without an induction?** *(added Saturday; claim C19, proof in `notes/2026-11-14_carry_budget.md`)*
Yes. Add up the leaves of the tree in base p, node by node. A carry is one trade of p units for one unit in the next column (when you add p numbers, a column can make several). Whatever the shape of the tree, you make the same number of carries: (m − s)/(p − 1), because you start from m ones, end at the digits of m, and each carry lowers the digit sum by p − 1. A symmetric node adds p equal numbers, and that always carries. So at most (m − s)/(p − 1) nodes are symmetric. A tree has (m − 1)/(p − 1) nodes, so at least the difference, t, are asymmetric. (C19)

**16b. And when is there equality?**
When no carry is wasted: asymmetric nodes add without carrying, and each symmetric node makes exactly one carry. A symmetric node whose children have b leaves makes s_p(b) carries, so b must be a power of p, and then the children are complete trees. Those are the trees built from the digits of m. (C19, C3)

**17. Is that not Legendre's formula in disguise?**
No factorial appears. The only arithmetic fact is that adding numbers in base p lowers the total digit sum by p − 1 per carry, which is how column addition works.

**18. What does the lower bound give on its own?**
That p^t divides C. This is the part Konvalinka's orbit argument also reaches, by a longer route. Exactness is the new part.

## E. Minimal trees

**19. Which trees have d exactly t?**
Those in which no asymmetric node produces a carry and every symmetric node lies inside a complete subtree. Such a tree is a skeleton of t asymmetric nodes carrying complete subtrees, the atoms. (C3; SG 7)

**20. Why are the atoms the digits of m?**
Each atom has p^j leaves, and "no carries anywhere" means the atoms' sizes add up to m digit by digit. So there are exactly m_j atoms of size p^j. (SG 7, 9)

**21. What changes when q = p^k with k > 1?**
Only a depth condition: an atom of height j must hang at a depth congruent to −j modulo k, so that its leaves land at a depth divisible by k. (SG 12, 13)

**22. Why is t the number of skeleton nodes?**
A p-ary tree with s leaves has (s − 1)/(p − 1) nodes, and the skeleton has s leaves: one per unit of digit.

## F. Counting minimal classes modulo p

**23. Why do you make the atoms distinguishable?**
So that a cyclic group can act on the labels. It costs nothing: permutations of equal atoms never fix a tree, because a symmetry of a tree made of rotations has order a power of p, while digits are below p so those permutations have order prime to p. Hence the labelled count is the unlabelled count times the product of digit factorials. (C4; SG 15)

**24. What is the "carry is a cherry" step?**
Take p labels of the same class and cycle them. The number of labelled trees is congruent modulo p to the number of trees left fixed. A fixed tree must have those p labels as the p children of one node, in one of p − 1 cyclic orders. Collapse that node into a single leaf one level up: p atoms of one class become one atom of the next class. That is a carry. (C5; SG 14)

**25. Why exactly p − 1 orders?**
The rotation of the cherry must realise the cycle on the labels. If the rotation is by r positions, the labels must appear in steps of 1/r around the node; r can be any non-zero residue.

**26. Why does the process end at a single leaf?**
Each carry removes p − 1 labels. The quantity "sum of a_c · p^c" is unchanged modulo q − 1 by a carry and starts at m ≡ 1. When no carry is possible all a_c are below p, the quantity lies between 1 and q − 1, so it equals 1: one label of class 0. For q = 2 one argues directly.

**27. And the sign?**
Each carry multiplies the count by p − 1 ≡ −1. There are t carries because the number of labels drops from s to 1 in steps of p − 1.

**28. How does that finish the proof?**
C = sum over classes of p^d with all d ≥ t, so C / p^t is congruent modulo p to the number of minimal classes, which is ±1 divided by a product of factorials of digits: not zero modulo p. (C6)

## G. Prior work and novelty

**29. What exactly did Konvalinka do?**
He proved the valuation formula with factorials, introduced weighted versions of these numbers, and showed by an orbit argument with the full symmetric group that p^t divides every orbit size. He says explicitly that this proves divisibility and not exactness.

**30. Is the case p = 2 new?**
No. For ordinary Catalan numbers the orbit proof with exactness is due to Deutsch and Sagan, and for weighted Catalan numbers to Postnikov and Sagan. For p = 2, swapping is rotating, so our argument specialises to theirs. The same minimal trees were also found by biologists: Kersting and Fischer (2021) show that the most balanced evolutionary trees, by their symmetry nodes index, are exactly these trees built on the binary digits, and count them by the same double factorial, without mentioning Catalan numbers.

**31. Is your proof new?**
We do not know yet, and we say so. An AI worker read four related papers in full and scanned 119 citing papers by abstract; it did not find the p-group action for q = p^k, the digit skeleton with its depth condition, or the carry-cherry count. That is not a certificate of novelty. (see `references/overlap_fulltext.md`)

**32. Which later papers are closest?**
Gao and Gu (2021) strengthen Konvalinka's weighted results; Krattenthaler and Müller (2025) obtain congruences for Fuss–Catalan numbers modulo prime powers from differential equations. Both are algebraic rather than orbit-based, as far as the full-text check could tell.

**G+. What did Etherington do in 1939, and what is left for you?** *(added Saturday after reading the paper; reference 36)*
For binary trees he defined the "mutability" of a shape, the number of nodes whose two branches differ, and observed that a shape has 2^mutability ordered versions. He wrote the generating function with a second variable marking mutability and its functional equation: at y = 2 it gives the Catalan numbers, at y = 1 the count of shapes. He also showed that the number of leaves is a sum of mutability + 1 powers of two, from which our lower bound for p = 2 follows in one line. He did not ask which power of 2 divides the Catalan numbers and did not count the most symmetric shapes; that is Deutsch and Sagan (2006). What is ours, as far as we know: every prime (rotations in place of swaps), prime powers with the depth condition, the description of the most symmetric trees by base-p digits, and the count modulo p that makes the valuation exact. For p = 2 our Step 1 and the binary case of the equation in our second proof are his, and we say so.

## H. Is it "combinatorial"?

**33. You count fixed points modulo p. Is that combinatorial?**
We think so: every step is a statement about a finite set of trees and a cyclic group moving them. No valuation of a factorial or binomial coefficient is used anywhere. It is the same kind of argument as the classical combinatorial proofs of Lucas' theorem and of Wilson's theorem.

**34. Do you have a bijection instead of a congruence?**
Not for the full statement. For q = p there is an exact count of minimal classes, (pt)! / (t! · p^t · product of digit factorials), and we have a conjectured bijection between labelled cyclic trees and permutations made of p-cycles, which is not checked yet.

## I. Edge cases

**35. What happens for q = 2?**
The modulus q − 1 is 1, so the invariant says nothing, and one argues directly: each carry lowers the number of labels by one until one is left.

**36. What if m is a power of p?**
Then t = 0, the only minimal tree is the complete tree, and C is not divisible by p. For p = 2 this is "C_n is odd exactly when n + 1 is a power of 2".

**37. Does it work when q is not a prime power?**
Our proof uses q = p^k in the first step. Konvalinka shows that his weighted statement fails for q = 6. What the orbit picture gives for general q is something we have not explored.

## J. Generalisations

**38. What about weighted Fuss–Catalan numbers?**
Konvalinka's proof of his weighted theorem appears to use only that the group can move any branch to any position, which our smaller group can. If so, his theorem also becomes free of factorials. Numerical checks were started; this is not signed. (C9)

**39. Other statistics?**
Rotations preserve the number of nodes at each depth, the height, and more. So p^t should also divide the number of trees with any prescribed value of such a statistic. (C10, C11; unsigned)

**40. Higher powers of p?**
We know C / p^t modulo p. Modulo p² would need the classes with d = t + 1 as well; we have data but no formula.

## K. Use of AI

**41. Who had the idea?**
The proof strategy came from an AI model (Claude Fable 5.2) on the first evening, while reading the problem. We say this plainly. Our work as humans was to check it, break it where we could, and understand it well enough to present it.

**42. How do you know it is right?**
Four layers. Brute-force enumeration of all trees for small cases. A large test up to 400 leaves and primes up to 13 with no failures. Three different AI models asked to find errors, which found 14 defects in the write-up, all repaired, and no counterexample. And line-by-line reading by the humans on the team: (fill in who signed what).

**43. Did the AI reviewers agree with each other?**
No, and that was useful. One model alone noticed that the proof of a key lemma was false as written; another alone noticed that an argument failed for p = 2. A later reading found a false displayed equality that all three had missed. That is why the human check is the one that counts.

**44. Which tools did what?**
See `AI_USAGE.md` and the claim ledger: every claim records which model produced it and every worker run is logged with its brief and output.

## L. Weaknesses

**45. What is the weakest point of your work?**
Novelty is not established, and the proof has been in existence for less than two days. We would rather say that than overclaim.

**46. What would you do with two more months?**
Have the proof checked formally in Lean; settle the literature question with experts; write up the weighted and refined versions; and work out the residue modulo p².

## M. Other ways to see it (written and checked by computer; none human-verified yet)

*Rewritten on Saturday 2026-11-14 by Claude Fable 5.2. Claim IDs refer to `CLAIMS.md`; check the grade there before relying on an answer.*

**47. Is there an even shorter explanation?**
Label the leaves. Then every node of a tree contributes a factor −p, a tree has (m−1)/(p−1) nodes, and the m! labellings can account for only (m−s)/(p−1) of them. The difference is t. In one line: C times the product of digit factorials is ≡ (−p)^t modulo p^(t+1). This is written up in `paper/accounting_proof.pdf`; it uses the carry step of the main proof and the valuation of m!, which it derives by the same symmetry. (C12, C13)

**48. Is there a physical picture?**
Carries. Adding up the leaves of a tree in base p always makes the same number of carries; a symmetric node always carries; so the carries limit the symmetry (question 16a). In sand language: "p grains on a site topple into one grain on the next site", and the valuation is the number of topplings a ring of k sites needs minus the number a line needs. (C19, C14)

**49. An algebraic one? Did you prove it a second time?**
Yes, by algebra alone, starting only from G = x + G^q. For any series f, f^p equals f(x^p) plus p times a correction. We replace that p by a variable y. The new series still has integer coefficients; at y = p it is G. Digit sums show that the lowest power of y in the coefficient of x^m is y^t, and a derivative identity modulo p shows that its coefficient is ±1 over the digit factorials. That is the theorem again, with no tree and no factorial valuation. The two proofs share no lemma, so each checks the other. (C18; `paper/frobenius_proof.pdf`)

**50. What does the variable y mean?**
It marks asymmetric nodes. The coefficient of x^m y^d counts the classes of trees with m leaves and d asymmetric nodes. At y = 1 you count classes (tree shapes, or isomers when p = 3); at y = p you count trees, because a class with d asymmetric nodes has p^d trees; at y = 0 only the complete trees survive. Example: the 429 binary trees with 8 leaves are 1 + 4 + 56 + 112 + 192 + 64. (C18; checked by listing all classes)

**51. Why does the smallest term decide?**
Because p-adically p is small. A sum of terms p^d with different d is divisible by exactly the smallest power that occurs, unless the number of terms with that power is itself divisible by p. So we need two things: the smallest d is t, and the number of classes with d = t is not divisible by p. A physicist would say: the valuation is the ground-state energy, and we must check that the number of ground states does not vanish modulo p. (analogy; the exact statement is the theorem)

**52. What does the theorem say about molecules?**
For p = 3: the symmetries of an alkyl radical in our model form a group of order 3^(number of symmetric carbons). Chemists call the order of such a group the symmetry number; it lowers the entropy by R ln σ, and a freely rotating methyl group contributes a factor 3 (Gilson and Irikura 2010). The number of ternary trees with n nodes is prime to 3 exactly when a perfectly branched radical with n carbons exists: methyl (n = 1), tert-butyl (n = 4, 55 trees), and so on. In general the power of 3 measures how far the most symmetric radical is from perfect branching. (exact for the tree model, E011; the chemistry is from one paper read by an AI, `references/README.md` entry 11; our model keeps only the rotations of the three bonds)

**53. Is there a statement inside p-adic numbers themselves?**
Two. First, the number of ways to cut the p-adic integers into m balls is the Fuss–Catalan number, because cutting a ball into its p sub-balls is growing a node. Second, with π a (p−1)-th root of −p, the constant of Dwork's exponential, C equals π^(m−1)/m! times an integer that is 1 modulo p. (That also gives the residue the shape of Stickelberger's congruence for Gauss sums: to leading order C is −1/π times the Gauss sum of exponent m. We checked this by computer in 77 cases, E014; whether it is a known remark is a question for the professor, so do not volunteer it until he has answered.) (exact, C20 and a direct bijection; `notes/2026-11-14_crossfield_analogies.md`, B1 and B2)

**53a. Is the algebraic proof new?**
We do not know. Its first step, reducing the equation modulo p and meeting the series Σ z^(p^n), is in Kauers, Krattenthaler and Müller (2012) and Krattenthaler and Müller (2025), who use it to compute Fuss–Catalan numbers modulo fixed prime powers. The extra variable y, the weight and the carry-free product, which give the exact valuation for every m at once, we did not find in a keyword search of the literature; that is not a proof of novelty. (C18; `notes/2026-11-14_crossfield_literature.md`, item 8)

**54. Which of these would you bet on?**
The main proof is the one we present and the one the problem asks for. The algebraic proof is the independent check. The carry budget is the easiest to explain. The rest are ways of seeing the same structure.
