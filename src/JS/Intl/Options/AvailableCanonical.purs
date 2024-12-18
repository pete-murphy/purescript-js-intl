-- *** DO NOT EDIT! ***
-- This module is generated by `just generate-options`

module JS.Intl.Options.AvailableCanonical
  ( AvailableCanonical(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

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

fromString :: String -> Maybe AvailableCanonical
fromString = case _ of
  "calendar" -> Just Calendar
  "collation" -> Just Collation
  "currency" -> Just Currency
  "numberingSystem" -> Just NumberingSystem
  "timeZone" -> Just TimeZone
  "unit" -> Just Unit
  _ -> Nothing
