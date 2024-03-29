-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.LocaleMatcher
  ( LocaleMatcher(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data LocaleMatcher = BestFit | Lookup

derive instance Eq LocaleMatcher

toString :: LocaleMatcher -> String
toString = case _ of
  BestFit -> "best fit"
  Lookup -> "lookup"

fromString :: String -> Maybe LocaleMatcher
fromString = case _ of
  "best fit" -> Just BestFit
  "lookup" -> Just Lookup
  _ -> Nothing
