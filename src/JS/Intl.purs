module JS.Intl
  ( module AvailableCanonical
  , getCanonicalLocales
  , supportedValuesOf
  ) where

import Data.Function.Uncurried (Fn1, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Data.Maybe (Maybe(..))
import JS.Intl.AvailableCanonical (AvailableCanonical(..)) as AvailableCanonical
import JS.Intl.AvailableCanonical (AvailableCanonical)
import JS.Intl.Internal.Class.StringArg as StringArg

foreign import _getCanonicalLocales
  :: Fn3
       (forall a. Maybe a)
       (forall a. a -> Maybe a)
       (Array String)
       (Maybe (Array String))

-- | Returns an array containing the canonical locale names. Duplicates will be
-- | omitted and elements will be validated as structurally valid language tags
-- | (returns `Nothing` if input contains invalid tags).
getCanonicalLocales :: Array String -> Maybe (Array String)
getCanonicalLocales =
  Function.Uncurried.runFn3 _getCanonicalLocales Nothing Just

foreign import _supportedValuesOf
  :: Fn1
       String
       (Array String)

-- | Returns an array containing the supported calendar, collation, currency,
-- | numbering systems, or unit values supported by the implementation.
-- |
-- | ```purs
-- | > take 4 (supportedValuesOf Calendar)
-- | ["buddhist","chinese","coptic","dangi"]
-- | ````
supportedValuesOf :: AvailableCanonical -> Array String
supportedValuesOf availableCanonical =
  Function.Uncurried.runFn1 _supportedValuesOf (StringArg.from availableCanonical)