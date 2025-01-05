-- *** DO NOT EDIT! ***
-- This module is generated by `just generate-options`

module JS.Intl.Options.MillisecondsDisplay
  ( MillisecondsDisplay(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data MillisecondsDisplay = Always | Auto

derive instance Eq MillisecondsDisplay

toString :: MillisecondsDisplay -> String
toString = case _ of
  Always -> "always"
  Auto -> "auto"

fromString :: String -> Maybe MillisecondsDisplay
fromString = case _ of
  "always" -> Just Always
  "auto" -> Just Auto
  _ -> Nothing