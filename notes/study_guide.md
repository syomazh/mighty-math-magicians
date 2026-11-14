# Study guide: learn the proof by doing it

Written by Claude Fable 5.2 (AI), 2026-11-13/14, for the presenters. Every number below is recomputed by `notes/study_guide_check.py` (output in `notes/study_guide_check_output.txt`). The mathematics is the team's **candidate** proof: as of this writing no human has signed it. If an exercise does not come out the way the solution says, that is important: tell the team.

**How to use it.** Read the ten sentences. Then do the exercises with pencil and paper before looking at the solutions. Exercises 2, 4, 7 and 14 are the ones a judge is most likely to ask you to reproduce.

Notation for trees in this guide: `o` is a leaf, `(A B)` is a node with children A and B. So `((o o) (o o))` is the balanced binary tree with 3 nodes and 4 leaves.

---

## The whole proof in ten sentences

1. The Fuss–Catalan number C counts q-ary trees with n nodes; such a tree has m = (q−1)n + 1 leaves.
2. We want the exact power of p dividing C when q = p^k, and the claim is that it is t = (s − 1)/(p − 1), where s is the sum of the base-p digits of m.
3. Redraw every q-ary node as a small complete p-ary tree of height k; now every tree is p-ary, and "q" only means "all leaves sit at depths divisible by k".
4. Allow one move: rotate the p children of a node cyclically. Trees you can reach from each other form a **class**.
5. A class contains exactly p^d trees, where d is the number of **asymmetric** nodes (nodes whose p branches are not all alike); this is where p being prime is used.
6. Therefore C = the sum over classes of p^d.
7. Every tree has d ≥ t (an induction in which carries in base p appear), so p^t divides C.
8. The trees with d = t are exactly these: t asymmetric nodes forming a "skeleton", carrying complete trees ("atoms"), one atom for each unit of each base-p digit of m.
9. To count those minimal classes modulo p, make the atoms distinguishable and let Z_p cycle p of the labels: the only trees left fixed are those where the p labels are siblings (a "cherry"); collapsing the cherry is a carry in base p, and each carry contributes a factor −1.
10. After t carries a single leaf is left, so the number of minimal classes is ≡ ±1/(product of digit factorials), not 0, modulo p; hence C/p^t is not divisible by p, and the power of p in C is exactly t.

---

## Vocabulary, each with a tiny example

- **p-adic valuation v_p(N):** how many times p divides N. v_2(12) = 2, v_3(12) = 1, v_2(132) = 2.
- **Digit sum s_p(m):** add the base-p digits. 17 = 122 in base 3, so s_3(17) = 5. 7 = 111 in base 2, so s_2(7) = 3.
- **Carry:** what happens in column addition when a column reaches p. In base 2, 3 + 3 = 11 + 11 = 110 has two carries.
- **q-ary tree:** every node has q ordered branches, each empty or another q-ary tree. For q = 2 these are binary trees.
- **Leaf:** an empty branch. A q-ary tree with n nodes has (q−1)n + 1 leaves. A binary tree with 3 nodes has 4 leaves.
- **Complete tree of height h:** all leaves at depth h. It has p^h leaves. Height 0 is a single leaf.
- **Rotation:** cyclically shift the p children of one node. For p = 2 it is swapping left and right.
- **Class:** all trees obtainable from one tree by rotations at any nodes.
- **Symmetric node:** its p branches are all in the same class. **Asymmetric node:** otherwise. d(T) = number of asymmetric nodes.
- **Atom:** a complete subtree hanging from an asymmetric node. An atom of height j has p^j leaves.
- **Skeleton:** the asymmetric nodes of a minimal tree, with the atoms as its leaves.
- **Cherry:** p leaves that are the p children of one node.

---

## Exercises

### 1. The pattern
Compute C_n = binom(2n, n)/(n+1) for n = 1..8, the power of 2 in each, and the number of 1s in the binary expansion of n + 1.

**Solution.**

| n | C_n | power of 2 | n+1 in binary | ones − 1 |
|---|---|---|---|---|
| 1 | 1 | 0 | 10 | 0 |
| 2 | 2 | 1 | 11 | 1 |
| 3 | 5 | 0 | 100 | 0 |
| 4 | 14 | 1 | 101 | 1 |
| 5 | 42 | 1 | 110 | 1 |
| 6 | 132 | 2 | 111 | 2 |
| 7 | 429 | 0 | 1000 | 0 |
| 8 | 1430 | 1 | 1001 | 1 |

The last two columns agree. Here q = p = 2, so m = n + 1 and t = s_2(n+1) − 1.

### 2. Five trees, two classes
Draw the 5 binary trees with 3 nodes and sort them into classes.

**Solution.** One class of size 1: `((o o) (o o))`. One class of size 4: `(o (o (o o)))`, `(o ((o o) o))`, `((o (o o)) o)`, `(((o o) o) o)`. Check: 1 + 4 = 5.

### 3. Count asymmetric nodes
Compute d for `((o o) (o o))` and for `(o (o (o o)))`.

**Solution.** In `((o o) (o o))` every node has two equal branches: d = 0, class size 2^0 = 1. In `(o (o (o o)))`: the root has branches `o` and `(o (o o))`, different, so it is asymmetric; the middle node has `o` and `(o o)`, asymmetric; the bottom node `(o o)` is symmetric. d = 2, class size 2^2 = 4. Here m = 4 = 100 in binary, t = 0, and indeed C_3 = 5 is odd because exactly one class has d = 0.

### 4. Fourteen trees
The 14 binary trees with 4 nodes fall into classes. Find the classes, their sizes, and the smallest d.

**Solution.** Three classes:
- size 2 (d = 1): `(o ((o o) (o o)))` and its mirror image;
- size 4 (d = 2): `((o o) (o (o o)))` and three more;
- size 8 (d = 3): the eight "caterpillars" such as `(o (o (o (o o))))`.

2 + 4 + 8 = 14. Smallest d is 1. m = 5 = 101 in binary, s = 2, t = 1, and v_2(14) = 1. There is exactly one class with d = 1, an odd number, which is why 14/2 = 7 is odd.

### 5. The identity C = Σ p^d
For binary trees with 5 nodes the classes by d are: one with d = 1, two with d = 2, two with d = 3, one with d = 4. Check the identity and read off v_2(C_5).

**Solution.** 2 + 2·4 + 2·8 + 16 = 42 = C_5. The smallest term is 2^1 and it occurs once, so v_2(42) = 1. (m = 6 = 110, s = 2, t = 1.)

### 6. Six nodes
For 6 nodes there are 11 classes: three with d = 2, three with d = 3, four with d = 4, one with d = 5. Check, and explain why v_2(132) = 2.

**Solution.** 3·4 + 3·8 + 4·16 + 32 = 132. Divide by 4: 3 + 3·2 + 4·4 + 8; modulo 2 only the first term survives, and 3 is odd. So 132/4 = 33 is odd and v_2(132) = 2.

### 7. The three minimal trees for n = 6
m = 7 = 4 + 2 + 1. Find the trees with d = 2 and their atoms.

**Solution.** The atoms are complete trees with 1, 2 and 4 leaves. One representative per class:
- `(o ((o o) ((o o) (o o))))`: atoms 1 | (2, 4)
- `((o o) (o ((o o) (o o))))`: atoms 2 | (1, 4)
- `((o (o o)) ((o o) (o o)))`: atoms (1, 2) | 4

These are the three ways to build a binary tree on three labelled leaves {1, 2, 4}: choose which label stands alone at the root. Each has exactly 2 asymmetric nodes.

### 8. Ternary trees with 2 nodes
List them, find the classes, compare with the formula.

**Solution.** Three trees: `(o o (o o o))`, `(o (o o o) o)`, `((o o o) o o)`: one class of size 3 = 3^1. m = 5 = 12 in base 3, s = 3, t = (3−1)/2 = 1, and C = 3. The atoms: one of height 1 (3 leaves) and two of height 0 (single leaves): the digits 1 and 2 of "12".

### 9. Ternary trees with 3 nodes
There are 12. Find the classes.

**Solution.** Two classes: size 3 (d = 1), represented by `(o (o o o) (o o o))`; size 9 (d = 2), represented by `(o o (o o (o o o)))`. 3 + 9 = 12, v_3(12) = 1. m = 7 = 21 in base 3, s = 3, t = 1. The minimal class has atoms 1, 3, 3: digits 2 (two atoms of height 1) and 1 (one atom of height 0).

### 10. Carries and digit sums
(a) In base 2 add 1 + 2 + 4. (b) In base 2 add 3 + 3. (c) In base 3 add 5 + 5 + 5. In each case count carries and compare digit sums.

**Solution.** (a) 1 + 10 + 100 = 111, no carries; digit sums 1 + 1 + 1 = 3 = s(7). (b) 11 + 11 = 110, two carries; digit sums 2 + 2 = 4 against s(6) = 2; the difference 2 equals (p−1) × carries = 1 × 2. (c) 12 + 12 + 12 = 120; the units column gives 6 = 0 carry 2, the next gives 3 + 2 = 5 = 2 carry 1: three carries; digit sums 9 against s(15) = 3; difference 6 = (3−1) × 3. In general: **sum of digit sums − digit sum of the sum = (p − 1) × (number of carries)**.

### 11. Why a lopsided tree is wasteful
For `(o (o (o o)))` (4 leaves) compare d with t and find the carries.

**Solution.** d = 2, t = 0. At the root the leaf counts are 1 and 3: 1 + 11 = 100 in binary, two carries. At the middle node they are 1 and 2: no carry. Two carries, and d exceeds t by two. A minimal tree is one where no node ever carries (and symmetric nodes sit only inside complete subtrees).

### 12. A prime power: q = 4, two nodes
There are 4 quaternary trees with 2 nodes. Redraw them as binary trees and find the atoms.

**Solution.** A quaternary node becomes a binary node with two binary children (height 2). The four trees form one class of size 4 = 2^2, represented by `((o o) (o ((o o) (o o))))`. m = 7 = 111, t = 2, C = 4. Atoms: 2 | (1, 4). Depth condition (height + depth must be even, because k = 2): the atom with 2 leaves has height 1 and sits at depth 1; the atom with 1 leaf has height 0 at depth 2; the atom with 4 leaves has height 2 at depth 2. All even. The other two arrangements from Exercise 7 fail: in 1 | (2, 4) the single leaf would be at depth 1.

### 13. q = 4, four nodes
C = 140. The classes have d = 2, 3, 4, 4, 5, 6. Check, and find the minimal one.

**Solution.** 4 + 8 + 16 + 16 + 32 + 64 = 140, v_2(140) = 2. m = 13 = 1101 in binary, s = 3, t = 2. The single minimal class has atoms (1, 4) | 8: the atom 8 (height 3) at depth 1, the atoms 1 and 4 (heights 0 and 2) at depth 2.

### 14. Do a carry by hand
(a) p = 2. There are 3 binary trees with unordered children on labelled leaves {1, 2, 3}. Which are unchanged when labels 1 and 2 are swapped?
(b) p = 3. There are 40 cyclic ternary trees on 5 labelled leaves and 2 on 3 labelled leaves. Check the carry rule.
(c) p = 2, k = 2, two labels of class 0 and one of class 1. Follow the carries.

**Solution.** (a) The trees are 3 | (1 2), 2 | (1 3), 1 | (2 3). Swapping 1 and 2 fixes only 3 | (1 2), the one where 1 and 2 form a cherry, and exchanges the other two. So 3 ≡ 1 (mod 2). Collapse the cherry (1 2) into one new leaf: a tree on 2 leaves, of which there is 1. Collapse again: a single leaf. Two carries, sign (−1)^2 = +1, and 3 is indeed odd.
(b) The rule says T(5) ≡ (3−1)·T(3) and T(3) ≡ (3−1)·T(1) modulo 3. Indeed 40 ≡ 1 and 2·2 = 4 ≡ 1; and 2 ≡ 2·1. Two carries: 40 ≡ (−1)^2 = 1 (mod 3).
(c) Start with (2, 1). A carry in class 0 turns two class-0 labels into one class-1 label: (0, 2). A carry in class 1 turns two class-1 labels into one label of class 1 + 1 = 0 (classes are read modulo k = 2): (1, 0), a single leaf. The counts are T(2,1) = 1, T(0,2) = 1, T(1,0) = 1, consistent. This is the case m = 13 of Exercise 13.

### 15. Why making atoms distinguishable costs nothing
For p = 3, m = 5 the atoms are one of height 1 and two equal ones of height 0. How many labelled cyclic trees are there, and how many unlabelled?

**Solution.** With three different labels x, y, z around one node there are 2 cyclic orders: (x y z) and (x z y). Swapping the two equal atoms y and z exchanges them, so neither is fixed: the swap acts freely, and the unlabelled count is 2/2! = 1, which is the single minimal class of Exercise 8. In general a symmetry that fixed a tree would have to come from rotations, whose orders are powers of p, while permutations of equal atoms have order prime to p because each digit is less than p.

### 16. Why p must be prime
Take four children with classes A, B, A, B. How many different rotations does this word have?

**Solution.** Two: ABAB and BABA. For a prime p a word of length p has either 1 rotation (all letters equal) or p (otherwise); for length 4 there is an in-between case, and "class size = p^d" breaks. This is why for q = 4 we do not rotate the four children of a node. We rotate at the binary nodes of the refinement instead, which gives a group of order 8 = 2^3 on the four branches.

---

## Six things people get wrong

1. **Nodes versus leaves.** n counts nodes; the digits are those of m = (q−1)n + 1, the number of leaves.
2. **Classes versus trees.** C is a sum over classes of p^d. "Minimal" refers to classes with the smallest d; we count those classes, not the trees in them.
3. **Which group.** Only rotations, and on the p-ary refinement. Not all permutations of the children (that is Konvalinka's group), and not rotations of the q children.
4. **Asymmetric does not mean "all different".** A node is asymmetric as soon as its p branches are not all alike.
5. **The lower bound is not the theorem.** d ≥ t gives "p^t divides C". Exactness needs the number of minimal classes to be non-zero modulo p.
6. **Two different carries.** In the lower bound, carries happen when adding leaf counts. In the counting step, a carry is p labels of one class becoming one label of the next class, with classes read modulo k.

---

## Spoken summaries

**One minute.** "The Catalan number C_n is odd exactly when n+1 is a power of two, and in general the power of two in it is the number of ones in n+1, minus one. The analogue for q-ary trees and a prime p is known, but only by computing with factorials. We prove it from the trees. We let each node rotate its children, which sorts the trees into classes of size p to the number of lopsided nodes. The most symmetric classes turn out to be trees built on the base-p digits of the number of leaves, and counting them modulo p comes down to collapsing sibling leaves, which is exactly carrying in base p. So the digit sum appears because the trees themselves do base-p arithmetic."

**Five minutes.** Use the ten sentences as your outline, with the running example n = 6: 132 trees, 11 classes, 132 = 3·4 + 3·8 + 4·16 + 32, three minimal classes built on the atoms 1, 2, 4, and 3 is odd because of the cherry argument in Exercise 14(a).
