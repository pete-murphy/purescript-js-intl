-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.Numeric
  ( Numeric(..)
  , toString
  ) where

import Prelude

data Numeric = Always | Auto

derive instance Eq Numeric

toString :: Numeric -> String
toString = case _ of
  Always -> "always"
  Auto -> "auto"