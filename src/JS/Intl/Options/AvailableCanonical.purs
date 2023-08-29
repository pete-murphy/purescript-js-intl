-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.AvailableCanonical
  ( AvailableCanonical(..)
  , toString
  ) where

import Prelude

data AvailableCanonical
  = Calendar
  | Collation
  | Currency
  | NumberingSystem
  | TimeZone
  | Unit

derive instance Eq AvailableCanonical

toString :: AvailableCanonical -> String
toString = case _ of
  Calendar -> "calendar"
  Collation -> "collation"
  Currency -> "currency"
  NumberingSystem -> "numberingSystem"
  TimeZone -> "timeZone"
  Unit -> "unit"