module logical-foundations.Induction where

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl; cong; sym)
open Eq.≡-Reasoning using (begin_; _≡⟨⟩_; step-≡; _∎)
open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _∸_;_^_)

-- associativity:

_ : (3 + 4) + 5 ≡ 3 + (4 + 5)
_ =
  begin
    (3 + 4) + 5
  ≡⟨⟩
    (7 + 5)
  ≡⟨⟩
    12
  ≡⟨⟩
    3 + 9
  ≡⟨⟩
    3 + (4 + 5)
  ∎

-- proof of associativity by induction

-- proofs by induction need to proof the base case and the inductive case. For example, for nats, we need to proof (base case) that the property holds for zero, and then (inductive) we assume the prop holds for an arbitrary bat m and we show it must hold for suc .

-- -------
--  P zero

--  P m
-- -----------
--  P (suc m)

-- proof that (m + n) + p ≡ m + (n + p)

-- ----------------------------------
--  (zero + n) + p ≡ zero + (n + p)

-- (m + n) + p ≡ m + (n + p)
-- ---------------------------------
-- (suc m + n) + p ≡ suc m + (n + p)


-- returns evidence for the corresponding instance of equation (receiving 3 nats that bind to m n and p)
+-assoc : ∀ (m n p : ℕ) → (m + n) + p ≡ m + (n + p)
-- base case holds trivially (n + p ≡ n + p)
+-assoc zero n p =
    begin
        (zero + n) + p 
    ≡⟨⟩
        n + p 
    ∎

-- a relation is said to be a congruence for a fn if it preserves by applying that function. If e is evidence that x ≡ y, then cong f e is evidence that f x ≡  f y for any f.
-- That said, we use conf suc to show that f x ≡ f y for any x and y and suc if x ≡ y.
+-assoc (suc m) n p =
    begin
        (suc m + n) + p 
    ≡⟨⟩
        suc(m + n) + p 
    ≡⟨⟩
        suc((m + n) + p)
    -- we recursively invocate the assoc function defined. We proof associativity of larger numbers in terms of associativity of smaller numbers.
    ≡⟨ cong suc (+-assoc m n p)⟩ 
        suc (m + (n + p))
    ≡⟨⟩
        suc m + (n + p)
    ∎

-- induction as recursion: concrete example of computation
+-assoc-0 : ∀ (n p : ℕ) → (0 + n) + p ≡ 0 + (n + p)
+-assoc-0 n p =
  begin
    (0 + n) + p
  ≡⟨⟩
    n + p
  ≡⟨⟩
    0 + (n + p)
  ∎

+-assoc-1 : ∀ (n p : ℕ) → (1 + n) + p ≡ 1 + (n + p)
+-assoc-1 n p =
  begin
    (1 + n) + p
  ≡⟨⟩
    suc (0 + n) + p
  ≡⟨⟩
    suc ((0 + n) + p)
  ≡⟨ cong suc (+-assoc-0 n p) ⟩
    suc (0 + (n + p))
  ≡⟨⟩
    1 + (n + p)
  ∎

+-assoc-2 : ∀ (n p : ℕ) → (2 + n) + p ≡ 2 + (n + p)
+-assoc-2 n p =
  begin
    (2 + n) + p
  ≡⟨⟩
    suc (1 + n) + p
  ≡⟨⟩
    suc ((1 + n) + p)
  ≡⟨ cong suc (+-assoc-1 n p) ⟩
    suc (1 + (n + p))
  ≡⟨⟩
    2 + (n + p)
  ∎


-- Ordinary functions are just a special case of dependent functions. The signatures:
-- _+_ : ℕ → ℕ → ℕ
-- _+_ : ∀ (m n : ℕ) → ℕ
-- _+_ : ∀ (m : ℕ) → ∀ (n : ℕ) → ℕ
-- are all the same

-- proving commutativity
-- m + n ≡ n + m

-- base case: zero + n ≡ n and m + zero ≡ m

-- here we define the identifier identity which provides evidence for the proposition forall m : nat...
+-identityʳ : ∀ (m : ℕ) → m + zero ≡ m 
+-identityʳ zero =
     begin
        zero + zero
      ≡⟨⟩
        zero
      ∎
+-identityʳ (suc m) =
    begin
        suc m + zero
    ≡⟨⟩
    -- simplify using inductive case of addition
        suc (m + zero)
    ≡⟨ cong suc (+-identityʳ m) ⟩
        suc m
    ∎

-- second lemma: the inductive case of addition pushes suc on the first arg to the outside:
-- suc m + n ≡ suc(m + n)
-- and our second lemma does the same for suc on the second arg
-- m + suc n ≡ suc(m + n)

-- 2nd lemma:
+-suc : ∀ (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc zero n =
  begin
    zero + suc n
  ≡⟨⟩
    suc n
  ≡⟨⟩
    suc (zero + n)
  ∎
+-suc (suc m) n =
  begin
    suc m + suc n
  ≡⟨⟩
    suc (m + suc n)
  ≡⟨ cong suc (+-suc m n) ⟩
    suc (suc (m + n))
  ≡⟨⟩
    suc (suc m + n)
  ∎

-- the evidence for our proposition is a function that accepts two nats, binds them to m and m and returns evidence for the corresponding instance of the equation. Proof is by induction on m.
-- Here, the recursive invocation +-suc m n has as its type the induction hypothesis, and cong suc prefaces suc to each side to yield the needed equation. This completes the second lemma.

-- finally, we have our proposition's statement and proof
+-comm : ∀ (m n : ℕ) → m + n ≡ n + m
+-comm m zero =
  begin
    m + zero
  ≡⟨ +-identityʳ m ⟩
    m
  ≡⟨⟩
    zero + m
  ∎
+-comm m (suc n) =
  begin
    m + suc n
    -- m + suc n ≡ suc(m + n) is justified by +- suc m n
  ≡⟨ +-suc m n ⟩
    suc (m + n)
    -- and here we justify suc(m + n) ≡ suc(n + m) using congruence and induction hypothesis, completing the proof.
  ≡⟨ cong suc (+-comm m n) ⟩
    suc (n + m)
  ≡⟨⟩
    suc n + m
  ∎

  -- Evidence for the proposition is a function that accepts two natural numbers, binds them to m and n, and returns evidence for the corresponding instance of the equation. The proof is by induction on n. (Not on m this time!)
  -- Agda requires that identifiers are defined before they are used, so we must present the lemmas before the main proposition, as we have done above. In practice, one will often attempt to prove the main proposition first, and the equations required to do so will suggest what lemmas to prove.

-- our first corollary: rearranging
-- we can apply associativity to rearrange parentheses however we like:
+-rearrange : ∀ (m n p q : ℕ) → (m + n) + (p + q) ≡ m + (n + p) + q
+-rearrange m n p q =
  begin
    (m + n) + (p + q)
  ≡⟨ sym (+-assoc (m + n) p q) ⟩
    ((m + n) + p) + q
  ≡⟨ cong (_+ q) (+-assoc m n p) ⟩
    (m + (n + p)) + q
  ∎

-- we use sym to interchange the sides of an equation. Proposition +-assoc (m + n) p q shifts parentheses from left to right:
-- ((m + n) + p) + q ≡ (m + n) + (p + q)

-- To shift them the other way, we use sym (+-assoc (m + n) p q):
-- (m + n) + (p + q) ≡ ((m + n) + p) + q

-- In general, if e provides evidence for x ≡ y then sym e provides evidence for y ≡ x.

-- Third, Agda supports a variant of the section notation introduced by Richard Bird. We write (_+ y) for the function that applied to x returns x + y. Thus, applying the congruence cong (_+ q) to assoc m n p takes the equation:
-- (m + n) + p  ≡  m + (n + p)
-- into the equation:
-- ((m + n) + p) + q  ≡  (m + (n + p)) + q
-- Similarly, we write (x +_) for the function that applied to y returns x + y; the same works for any infix operator.


-- associativity with rewrite
-- another proof of associativity using rewrite rather than chains of equations

+-assoc´ : ∀ (m n p : ℕ) → (m + n) + p ≡ m + (n + p)
+-assoc´ zero n p = refl
+-assoc´ (suc m) n p rewrite +-assoc´ m n p = refl

-- Rewriting by a given equation is indicated by the keyword rewrite followed by a proof of that equation. Rewriting replaces each occurrence of the left-hand side of the equation in the goal by the right-hand side. In this case, after rewriting by the inductive hypothesis our goal becomes

-- suc (m + (n + p)) ≡ suc (m + (n + p))
-- and the proof is again given by refl. Rewriting avoids not only chains of equations but also the need to invoke cong.

-- commutativity with rewrite
+-identity′ : ∀ (n : ℕ) → n + zero ≡ n
+-identity′ zero = refl
+-identity′ (suc n) rewrite +-identity′ n = refl

+-suc′ : ∀ (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc′ zero n = refl
+-suc′ (suc m) n rewrite +-suc′ m n = refl

+-comm′ : ∀ (m n : ℕ) → m + n ≡ n + m
+-comm′ m zero rewrite +-identity′ m = refl
+-comm′ m (suc n) rewrite +-suc′ m n | +-comm′ m n = refl

-- Exercise +-swap where swap : m + (n + p) ≡ n + (m + p)

+-swap : ∀ (m n p : ℕ) → m + (n + p) ≡ n + (m + p)
+-swap m n p =
  begin
    m + (n + p)
  ≡⟨ sym (+-assoc m n p) ⟩
    (m + n) + p 
  ≡⟨ cong (_+ p) (+-comm m n) ⟩
    (n + m) + p 
  ≡⟨ +-assoc n m p ⟩
    n + (m + p)
  ∎

*-distrib-+ : ∀ (m n p : ℕ) → (m + n) * p ≡ m * p + n * p
*-distrib-+ zero n p = refl
*-distrib-+ (suc m) n p rewrite *-distrib-+ m n p = sym(+-assoc p (m * p) (n * p))

*-assoc : (m n p : ℕ) → (m * n) * p ≡ m * (n * p)
*-assoc zero n p = refl
*-assoc (suc m) n p rewrite *-distrib-+ n (m * n) p | *-assoc m n p = refl

n*0≡0 : (n : ℕ) → n * 0 ≡ 0
n*0≡0 zero = refl
n*0≡0 (suc n) = n*0≡0 n

-- *-comm : ∀(m n : ℕ) → m * n ≡ n * m
*-comm : ∀ (m n : ℕ) → m * n ≡ n * m
*-comm zero zero = refl
*-comm zero (suc n) =
  begin
    zero * (suc n)
  ≡⟨⟩
    zero
  ≡⟨⟩
    zero + (zero * n)
  ≡⟨ *-comm zero n ⟩
    zero + (n * zero)
  ≡⟨⟩
    (suc n) * zero
  ∎
*-comm (suc m) zero =
  begin
    (suc m) * zero
  ≡⟨⟩
    zero + (m * zero)
  ≡⟨ *-comm m zero ⟩
    (zero * m)
  ≡⟨⟩
    zero
  ≡⟨⟩
    zero * (suc m)
  ∎
*-comm (suc m) (suc n) =
  begin
    (suc m) * (suc n)
  ≡⟨⟩
    (suc n) + (m * (suc n))
  ≡⟨ cong ((suc n) +_) (*-comm m (suc n)) ⟩
    (suc n) + ((suc n) * m)
  ≡⟨⟩
    (suc n) + (m + (n * m))
  ≡⟨ +-swap (suc n) m (n * m) ⟩
    m + ((suc n) + (n * m))
  ≡⟨ sym (+-assoc m (suc n) (n * m)) ⟩
    (m + (suc n)) + (n * m)
  ≡⟨ cong (_+ (n * m)) (+-suc m n) ⟩
    suc (m + n) + (n * m)
  ≡⟨ cong suc (+-assoc m n (n * m)) ⟩
    (suc m) + (n + (n * m))
  ≡⟨ cong (λ m*n → (suc m) + (n + m*n)) (*-comm n m) ⟩
    (suc m) + (n + (m * n))
  ≡⟨⟩
    (suc m) + ((suc m) * n)
  ≡⟨ cong ((suc m) +_) (*-comm ((suc m)) n) ⟩
    (suc m) + (n * (suc m))
  ≡⟨⟩
    (suc n) * (suc m)
  ∎

-- show that zero ∸ n ≡ zero
0∸n≡0 : ∀ n → (zero ∸ n) ≡ 0
0∸n≡0 zero = refl
0∸n≡0 (suc n) =
  begin
    zero ∸ (suc n)
  ≡⟨⟩
    zero
  ∎  

∸-+-assoc : ∀ (m n p : ℕ) → m ∸ n ∸ p ≡ m ∸ (n + p)
∸-+-assoc m zero p =
  begin
    m ∸ zero ∸ p
  ≡⟨⟩
    m ∸ p
  ≡⟨⟩
    m ∸ (zero + p)
  ∎

∸-+-assoc m n zero =
  begin
    m ∸ n ∸ zero
  ≡⟨⟩
    m ∸ n 
  ≡⟨⟩
    m ∸ (zero + n)
  ≡⟨ cong (m ∸_) (+-comm zero n) ⟩
    m ∸ (n + zero)
  ∎ 

∸-+-assoc zero n p =
  begin
    zero ∸ n ∸ p
  ≡⟨ cong (_∸ p) (0∸n≡0 n)⟩
    zero ∸ p 
  ≡⟨ 0∸n≡0 p ⟩
    zero
  ≡⟨ sym (0∸n≡0 (n + p)) ⟩
    zero ∸ (n + p)
  ∎

∸-+-assoc (suc m) (suc n) p =
  begin
    (suc m) ∸ (suc n) ∸ p
  ≡⟨⟩
    m ∸ n ∸ p
  ≡⟨ ∸-+-assoc m n p ⟩
    m ∸ (n + p)
  ≡⟨⟩
    (suc m) ∸ ((suc n) + p)
  ∎

zero∸n : (n : ℕ) → (zero ∸ n) ≡ zero
zero∸n zero = refl
zero∸n (suc zero) = refl
zero∸n (suc (suc n)) = refl

-- or
-- 0∸n≡0 : ∀ n → 0 ∸ n ≡ 0
-- 0∸n≡0 zero = refl
-- 0∸n≡0 (suc n) = refl

*-identityˡ : ∀ (n : ℕ) → 1 * n ≡ n
*-identityˡ zero    = refl
*-identityˡ (suc n) =
  begin
    1 * (suc n)
  ≡⟨⟩
    (suc n) + (zero * (suc n))
  ≡⟨⟩
    (suc n) + zero
  ≡⟨ +-identityʳ (suc n) ⟩
    (suc n)
  ∎

*-swap : ∀ (m n p : ℕ) → m * n * p ≡ m * p * n
*-swap m n p =
  begin
    (m * n) * p
  ≡⟨ *-assoc m n p ⟩
    m * (n * p)
  ≡⟨ cong (m *_) (*-comm n p) ⟩
    m * (p * n)
  ≡⟨ sym (*-assoc m p n) ⟩
    (m * p) * n
  ∎

-- +*^ : 
  -- show the three laws:  
-- m ^ (n + p) ≡ (m ^ n) * (m ^ p)  (^-distribˡ-+-*)
^-distribˡ-+-* : ∀ (m n p : ℕ) → m ^ (n + p) ≡ (m ^ n) * (m ^ p)
^-distribˡ-+-* m zero p =
  begin
    m ^ (zero + p)
  ≡⟨⟩
    m ^ p
  ≡⟨ sym (*-identityˡ (m ^ p)) ⟩
    1 * (m ^ p)
  ≡⟨⟩
    (m ^ zero) * (m ^ p)
  ∎

^-distribˡ-+-* zero (suc n) p = 
  begin 
    zero ^ ((suc n) + p)
  ≡⟨⟩
    zero * (zero ^ (n + p))
  ≡⟨⟩
    zero
  ≡⟨⟩
    (zero ^ (suc n)) * (zero ^ p)
  ∎

^-distribˡ-+-* (suc m) (suc n) p = 
  begin
    (suc m) ^ ((suc n) + p)
  ≡⟨⟩
    (suc m) * ((suc m) ^ (n + p))
  ≡⟨ cong ((suc m) *_) (^-distribˡ-+-* ((suc m)) n p) ⟩
    (suc m) * (((suc m) ^ n) * ((suc m) ^ p))
  ≡⟨ sym (*-assoc (suc m) (suc m ^ n) (suc m ^ p)) ⟩
    ((suc m) * ((suc m) ^ n)) * ((suc m) ^ p)
  ≡⟨⟩
    ((suc m) ^ (suc n)) * ((suc m) ^ p)
  ∎
--  (m * n) ^ p ≡ (m ^ p) * (n ^ p)  (^-distribʳ-*)
^-distribʳ-* : ∀ (m n p : ℕ) → (m * n) ^ p ≡ (m ^ p) * (n ^ p)

^-distribʳ-* m n zero =
  begin
    (m * n) ^ zero
  ≡⟨⟩
    1 
  ≡⟨⟩
    (m ^ zero) * (n ^ zero)
  ∎

^-distribʳ-* m n (suc p) = 
  begin
    (m * n) ^ (suc p)
  ≡⟨⟩
    (m * n) * ((m * n) ^ p)

  ≡⟨ cong ((m * n) *_) (^-distribʳ-* m n p) ⟩
    (m * n) * ((m ^ p) * (n ^ p))
  ≡⟨ sym (*-assoc (m * n) (m ^ p) (n ^ p)) ⟩
    ((m * n) * (m ^ p)) * (n ^ p)
  ≡⟨ cong (_* (n ^ p)) (*-swap m n (m ^ p)) ⟩
    ((m * (m ^ p)) * n) * (n ^ p)
  ≡⟨⟩
    ((m ^ (suc p)) * n) * (n ^ p)
  ≡⟨ *-assoc (m * (m ^ p)) n (n ^ p) ⟩
    (m ^ (suc p)) * (n * (n ^ p))

  ≡⟨⟩
    (m ^ (suc p)) * (n ^ (suc p))
  ∎

--  (m ^ n) ^ p ≡ m ^ (n * p)        (^-*-assoc)
^-*-assoc : ∀ (m n p : ℕ) → (m ^ n) ^ p ≡ m ^ (n * p)
^-*-assoc m n zero = 
  begin
    (m ^ n) ^ zero
  ≡⟨⟩
    1
  ≡⟨⟩
    m ^ (zero * n)
  ≡⟨ cong (m ^_) (*-comm zero n) ⟩
    m ^ (n * zero)
  ∎

--  (m ^ n) ^ p ≡ m ^ (n * p)  
^-*-assoc m n (suc p) =
  begin
    (m ^ n) ^ (suc p)
  ≡⟨⟩
    (m ^ n) * ((m ^ n) ^ p)
  ≡⟨ cong ((m ^ n) *_) (^-*-assoc m n p) ⟩
    (m ^ n) * (m ^ (n * p))
  ≡⟨ sym (^-distribˡ-+-* m n (n * p)) ⟩
    m ^ (n + (n * p))
  ≡⟨ cong (λ p*n → m ^ (n + p*n)) (*-comm n p) ⟩
    m ^ (n + (p * n))
  ≡⟨⟩
    m ^ ((suc p) * n)
  ≡⟨ cong (m ^_) (*-comm (suc p) n) ⟩
    m ^ (n * (suc p))
  ∎

-- -----------------
data Bin : Set where
  ⟨⟩ : Bin
  _O : Bin → Bin
  _I : Bin → Bin

inc : Bin → Bin
inc ⟨⟩ = ⟨⟩ I
inc (_O n) = _I n
inc (_I n) = _O (inc n)

to : ℕ → Bin
to zero = ⟨⟩
to (suc x) = inc (to x)

from : Bin → ℕ
from ⟨⟩ = zero
from (x O) = 2 * from(x)
from (x I) = 2 * from(x) + 1

2*n≡n+n : ∀ (n : ℕ) → 2 * n ≡ n + n
2*n≡n+n n =
  begin
    2 * n
  ≡⟨⟩
    n + (1 * n)
  ≡⟨⟩
    n + (n + (0 * n))
  ≡⟨⟩
    n + (n + 0)
  ≡⟨ cong (n +_) (+-identityʳ n) ⟩
    n + n
  ∎

+-suc-suc : ∀ (m n : ℕ) → (suc m) + (suc n) ≡ suc (suc (m + n))
+-suc-suc m n =
  begin
    (suc m) + (suc n)
  ≡⟨ +-suc (suc m) n ⟩
    suc ((suc m) + n)
  ≡⟨ cong suc (sym (+-assoc 1 m n)) ⟩
    suc (suc (m + n))
  ∎

-- Bin-laws. Consider the following laws, where n ranges over naturals and b over bitstrings:
-- n : ℕ  and b : Bin

incBinEqSucNat : ∀(b : Bin) → from (inc b) ≡ suc (from b)
incBinEqSucNat ⟨⟩ = 
  begin
    from (inc ⟨⟩)
  ≡⟨⟩
    from (⟨⟩ I)
  ≡⟨⟩
    suc zero
  ≡⟨⟩
    suc(from ⟨⟩)
  ∎

incBinEqSucNat (b O) =
  begin
    from (inc (b O))
  ≡⟨⟩
    from (b I)
  ≡⟨⟩
    2 * (from b) + 1
  ≡⟨⟩
   from (b O) + 1
  ≡⟨ +-suc (from (b O)) zero ⟩
    suc (from (b O) + zero)
  ≡⟨ cong suc (+-identityʳ (from (b O))) ⟩
    suc(from (b O))
  ∎

incBinEqSucNat (b I) =
   begin
    from (inc (b I))
  ≡⟨⟩
    from ((inc b) O)
  ≡⟨⟩
    2 * (from (inc b))
  ≡⟨ cong (2 *_) (incBinEqSucNat b) ⟩
    2 * (suc (from b))
  ≡⟨ 2*n≡n+n (suc (from b)) ⟩
    (suc (from b)) + (suc (from b))
  ≡⟨ +-suc-suc (from b) (from b) ⟩
    suc (suc ((from b) + (from b)))
  ≡⟨ cong (λ 2*fromb → suc (suc 2*fromb)) (sym (2*n≡n+n (from b))) ⟩
    suc (suc (2 * (from b)))
  ≡⟨ cong suc (+-comm 1 (2 * (from b))) ⟩
    suc (2 * (from b) + 1)
  ≡⟨⟩
    suc (from (b I))
  ∎

-- toFromEquiv : ∀ (b : Bin) → to (from b) ≡ b
-- toFromEquiv ⟨⟩ = 
--   begin
--     to (from ⟨⟩)
--   ≡⟨⟩
--     to (zero)
--   ≡⟨⟩
--     ⟨⟩ -> not true because to (zero) is encoded in ⟨⟩ O
--   ∎

-- toFromEquiv (b O) = 
--   begin 
--     to (from (b O)) 
--   ≡⟨⟩
--     to (2 * (from b))
--   ≡⟨⟩
--     (b O)
--   ∎
-- from (to n) ≡ n   
-- if a law holds, prove. If not, give a counterexample. 
fromTo : ∀ (n : ℕ) → from (to n) ≡ n
fromTo zero = 
  begin
    from (to zero)
  ≡⟨⟩
    from ( ⟨⟩ O )
  ≡⟨⟩
    2 * (from ⟨⟩)
  ≡⟨⟩
    2 * zero
  ≡⟨⟩
    zero
  ∎

fromTo (suc n) = 
  begin
    from (to (suc n))
  ≡⟨⟩
    from (inc (to n))
  ≡⟨ incBinEqSucNat (to n) ⟩
    suc (from (to n))
  ≡⟨ cong suc (fromTo n) ⟩
    (suc n)
  ∎
