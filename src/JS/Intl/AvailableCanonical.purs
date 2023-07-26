module JS.Intl.AvailableCanonical
  ( AvailableCanonical(..)
  ) where

import JS.Intl.Internal.Class.StringArg (class StringArg)

-- | Valid keys to pass to `Intl.supportedValuesOf`
-- | https://tc39.es/ecma402/#sec-intl.supportedvaluesof
data AvailableCanonical
  = Calendar
  | Collation
  | Currency
  | NumberingSystem
  | TimeZone
  | Unit

instance StringArg AvailableCanonical where
  from = case _ of
    Calendar -> "calendar"
    Collation -> "collation"
    Currency -> "currency"
    NumberingSystem -> "numberingSystem"
    TimeZone -> "timeZone"
    Unit -> "unit"