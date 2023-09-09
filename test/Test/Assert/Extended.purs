module Test.Assert.Extended
  ( module Test
  , assertContains
  , assertEqualWith
  ) where

import Prelude

import Data.Foldable (class Foldable)
import Data.Foldable as Foldable
import Effect (Effect)
import Effect.Console as Console
import Test.Assert (assert, assert', assertEqual, assertEqual', assertFalse, assertFalse', assertThrows, assertThrows', assertTrue, assertTrue') as Test

assertContains
  :: forall t a
   . Foldable t
  => Eq a
  => { actual :: t a, expected :: t a }
  -> Effect Unit
assertContains { actual, expected } = do
  Foldable.for_ expected \item -> do
    Test.assert (item `Foldable.elem` actual)

assertEqualWith
  :: forall a
   . Eq a
  => (a -> String)
  -> { actual :: a, expected :: a }
  -> Effect Unit
assertEqualWith toString { actual, expected } = do
  unless result (Console.error message)
  Test.assert' message result
  where
  message =
    "Expected: "
      <> toString expected
      <> "\nActual:   "
      <> toString actual
  result = actual == expected
