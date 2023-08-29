-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.PluralRulesType
  ( PluralRulesType(..)
  , toString
  ) where

import Prelude

data PluralRulesType = Cardinal | Ordinal

derive instance Eq PluralRulesType

toString :: PluralRulesType -> String
toString = case _ of
  Cardinal -> "cardinal"
  Ordinal -> "ordinal"
