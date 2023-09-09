-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.RelativeTimeUnit
  ( RelativeTimeUnit(..)
  , fromString
  , toString
  ) where

import Prelude

import Data.Maybe (Maybe(..))

data RelativeTimeUnit
  = Seconds
  | Minutes
  | Hours
  | Days
  | Weeks
  | Months
  | Quarters
  | Years

derive instance Eq RelativeTimeUnit

toString :: RelativeTimeUnit -> String
toString = case _ of
  Seconds -> "seconds"
  Minutes -> "minutes"
  Hours -> "hours"
  Days -> "days"
  Weeks -> "weeks"
  Months -> "months"
  Quarters -> "quarters"
  Years -> "years"

fromString :: String -> Maybe RelativeTimeUnit
fromString = case _ of
  "seconds" -> Just Seconds
  "minutes" -> Just Minutes
  "hours" -> Just Hours
  "days" -> Just Days
  "weeks" -> Just Weeks
  "months" -> Just Months
  "quarters" -> Just Quarters
  "years" -> Just Years
  _ -> Nothing
