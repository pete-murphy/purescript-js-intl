-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.DisplayNamesType
  ( DisplayNamesType(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

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

fromString :: String -> Maybe DisplayNamesType
fromString = case _ of
  "language" -> Just Language
  "region" -> Just Region
  "script" -> Just Script
  "currency" -> Just Currency
  "calendar" -> Just Calendar
  "dateTimeField" -> Just DateTimeField
  _ -> Nothing
