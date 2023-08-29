-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.Sensitivity
  ( Sensitivity(..)
  , toString
  ) where

import Prelude

data Sensitivity = Base | Accent | Case | Variant

derive instance Eq Sensitivity

toString :: Sensitivity -> String
toString = case _ of
  Base -> "base"
  Accent -> "accent"
  Case -> "case"
  Variant -> "variant"