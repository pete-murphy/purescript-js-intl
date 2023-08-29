-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.DateStyle
  ( DateStyle(..)
  , toString
  ) where

import Prelude

data DateStyle = Full | Long | Medium | Short

derive instance Eq DateStyle

toString :: DateStyle -> String
toString = case _ of
  Full -> "full"
  Long -> "long"
  Medium -> "medium"
  Short -> "short"