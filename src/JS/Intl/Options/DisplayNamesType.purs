-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.DisplayNamesType
  ( DisplayNamesType(..)
  , toString
  ) where

import Prelude

data DisplayNamesType
  = Language
  | Region
  | Script
  | Currency
  | Calendar
  | DateTimeField

derive instance Eq DisplayNamesType

toString :: DisplayNamesType -> String
toString = case _ of
  Language -> "language"
  Region -> "region"
  Script -> "script"
  Currency -> "currency"
  Calendar -> "calendar"
  DateTimeField -> "dateTimeField"
