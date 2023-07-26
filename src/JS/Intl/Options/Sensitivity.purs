module JS.Intl.Options.Sensitivity where

import Prelude

data Sensitivity
  = Case
  | Accent
  | Variant
  | Base

derive instance Eq Sensitivity

toString :: Sensitivity -> String
toString = case _ of
  Case -> "case"
  Accent -> "accent"
  Variant -> "variant"
  Base -> "base"
