-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.LanguageDisplay
  ( LanguageDisplay(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data LanguageDisplay = Dialect | Standard

derive instance Eq LanguageDisplay

toString :: LanguageDisplay -> String
toString = case _ of
  Dialect -> "dialect"
  Standard -> "standard"

fromString :: String -> Maybe LanguageDisplay
fromString = case _ of
  "dialect" -> Just Dialect
  "standard" -> Just Standard
  _ -> Nothing
