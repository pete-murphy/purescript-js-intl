module JS.Intl.Options.Internal.Unsafe where

import Prelude

import Data.Maybe (Maybe(..))
import Partial.Unsafe as Partial.Unsafe

fromString :: forall a. (String -> Maybe a) -> String -> a
fromString from string = case from string of
  Just a -> a
  Nothing -> Partial.Unsafe.unsafeCrashWith ("fromString: " <> string <> " is not a valid value")