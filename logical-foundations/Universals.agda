module logical-foundations.Universals where

import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; refl)
open import Data.Nat using (ℕ; zero; suc; _+_; _*_)
open import Relation.Nullary using (¬_)
open import Data.Product using (_×_; proj₁; proj₂) renaming (_,_ to ⟨_,_⟩)
open import Data.Sum using (_⊎_; inj₁; inj₂)
open import logical-foundations.Isomorphism using (_≃_; extensionality; ∀-extensionality)
open import Function using (_∘_)

-- we formalise universal quantification using the dependent function type, which has appeared throughout the book
-- for example, in: +-assoc : ∀ (m n p : ℕ) → (m + n) + p ≡ m + (n + p)
-- it is a dependent function, which given values for m, n, p returns evidence for the corresponding equation

-- In general, given a variable x of type A and a proposition B x which contains x as a free variable, the universally quantified proposition ∀ (x : A) → B x holds if for every term M of type A the proposition B M holds. Here B M stands for the proposition B x with each free occurrence of x replaced by M. Variable x appears free in B x but bound in ∀ (x : A) → B x.

-- Evidence that ∀ (x : A) → B x holds is of the form

-- λ (x : A) → N x
-- where N x is a term of type B x, and N x and B x both contain a free variable x of type A. Given a term L providing evidence that ∀ (x : A) → B x holds, and a term M of type A, the term L M provides evidence that B M holds. In other words, evidence that ∀ (x : A) → B x holds is a function that converts a term M of type A into evidence that B M holds.

-- Put another way, if we know that ∀ (x : A) → B x holds and that M is a term of type A then we may conclude that B M holds:
∀-elim : ∀ {A : Set} {B : A → Set}
  → (L : ∀ (x : A) → B x) 
  → (M : A)
  → B M
∀-elim L M = L M

-- functions arise as a special case of dependent functions, where the range does not depend on a variable drawn from the domain. When a function is viewed as evidence of implication, both its argument and result are viewed as evidence, whereas when a dependent function
-- is viewed as evidence of a universal, its argument is viewed as an element of a data type and its reuslt is viewed
-- as evidence of a proposition that depends on the argument.
-- Dependent function types are sometimes referred to as dependent products.





















