-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.TrailingZeroDisplay
  ( TrailingZeroDisplay(..)
  , toString
  ) where

import Prelude

data TrailingZeroDisplay = Auto | StripIfInteger

derive instance Eq TrailingZeroDisplay

toString :: TrailingZeroDisplay -> String
toString = case _ of
  Auto -> "auto"
  StripIfInteger -> "stripIfInteger"
