module JS.Intl.Options.CaseFirst where

import Prelude

data CaseFirst
  = Upper
  | Lower
  | False

derive instance Eq CaseFirst

toString :: CaseFirst -> String
toString = case _ of
  Upper -> "upper"
  Lower -> "lower"
  False -> "false"
