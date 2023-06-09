module Test.Assert.Extended
  ( module Test
  , assertContains
  ) where

import Prelude

import Data.Foldable (class Foldable)
import Data.Foldable as Foldable
import Effect (Effect)
import Test.Assert
  ( assert
  , assert'
  , assertEqual
  , assertEqual'
  , assertFalse
  , assertFalse'
  , assertThrows
  , assertThrows'
  , assertTrue
  , assertTrue'
  ) as Test

assertContains
  :: forall t a
   . Foldable t
  => Eq a
  => { actual :: t a, expected :: t a }
  -> Effect Unit
assertContains { actual, expected } = do
  Foldable.for_ expected \item -> do
    Test.assert (item `Foldable.elem` actual)

