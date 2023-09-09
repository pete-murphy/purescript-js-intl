-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.Numeric
  ( Numeric(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data Numeric = Always | Auto

derive instance Eq Numeric

toString :: Numeric -> String
toString = case _ of
  Always -> "always"
  Auto -> "auto"

fromString :: String -> Maybe Numeric
fromString = case _ of
  "always" -> Just Always
  "auto" -> Just Auto
  _ -> Nothing
