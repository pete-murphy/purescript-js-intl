-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.CompactDisplay
  ( CompactDisplay(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data CompactDisplay = Short | Long

derive instance Eq CompactDisplay

toString :: CompactDisplay -> String
toString = case _ of
  Short -> "short"
  Long -> "long"

fromString :: String -> Maybe CompactDisplay
fromString = case _ of
  "short" -> Just Short
  "long" -> Just Long
  _ -> Nothing
