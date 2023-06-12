module Web.Intl
  ( module AvailableCanonical
  , getCanonicalLocales
  , supportedValuesOf
  ) where

import Data.Function.Uncurried (Fn1, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Data.Maybe (Maybe(..))
import Web.Intl.AvailableCanonical (AvailableCanonical(..)) as AvailableCanonical
import Web.Intl.AvailableCanonical (AvailableCanonical)
import Web.Intl.Internal.Class.StringArg as StringArg

foreign import _getCanonicalLocales
  :: Fn3
       (forall x. x -> Maybe x)
       (forall x. Maybe x)
       (Array String)
       (Maybe (Array String))

-- | Returns an array containing the canonical locale names. Duplicates will be
-- | omitted and elements will be validated as structurally valid language tags.
getCanonicalLocales :: Array String -> Maybe (Array String)
getCanonicalLocales =
  Function.Uncurried.runFn3 _getCanonicalLocales Just Nothing

foreign import _supportedValuesOf
  :: Fn1
       String
       (Array String)

supportedValuesOf :: AvailableCanonical -> Array String
supportedValuesOf availableCanonical =
  Function.Uncurried.runFn1 _supportedValuesOf (StringArg.from availableCanonical)