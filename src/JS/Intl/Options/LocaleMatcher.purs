module JS.Intl.Options.LocaleMatcher where

import Prelude

data LocaleMatcher
  = BestFit
  | Lookup

derive instance Eq LocaleMatcher

toString :: LocaleMatcher -> String
toString = case _ of
  BestFit -> "best fit"
  Lookup -> "lookup"
