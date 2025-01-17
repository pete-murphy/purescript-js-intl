-- *** DO NOT EDIT! ***
-- This module is generated by `just generate-options`

module JS.Intl.Options.UseGrouping
  ( UseGrouping(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data UseGrouping = Min2 | Auto | Always

derive instance Eq UseGrouping

toString :: UseGrouping -> String
toString = case _ of
  Min2 -> "min2"
  Auto -> "auto"
  Always -> "always"

fromString :: String -> Maybe UseGrouping
fromString = case _ of
  "min2" -> Just Min2
  "auto" -> Just Auto
  "always" -> Just Always
  _ -> Nothing
