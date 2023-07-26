module JS.Intl.Locale
  -- * Types
  ( Locale
  , LocaleOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , baseName
  , maximize
  , minimize
  ) where

import Data.Function.Uncurried (Fn1)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce

-- | Represents a Unicode locale identifier
foreign import data Locale :: Type

type LocaleOptions =
  ( baseName :: String
  , calendar :: String
  , caseFirst :: String
  , collation :: String
  , hourCycle :: String
  , language :: String
  , numberingSystem :: String
  , numeric :: Boolean
  , region :: String
  , script :: String
  )

foreign import _new
  :: EffectFn2
       String
       (Record LocaleOptions)
       Locale

new
  :: forall options options'
   . Union options options' LocaleOptions
  => String
  -> Record options
  -> Effect Locale
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

new_
  :: String
  -> Effect Locale
new_ locales =
  new locales {}

foreign import _baseName
  :: Fn1
       Locale
       String

-- | Returns basic, core information about the `Locale` in the form of a
-- | substring of the complete data string
baseName
  :: Locale
  -> String
baseName =
  Function.Uncurried.runFn1 _baseName

foreign import _maximize
  :: Fn1
       Locale
       Locale

-- | Gets the most likely values for the language, script, and region of the
-- | locale based on existing values
maximize :: Locale -> Locale
maximize =
  Function.Uncurried.runFn1 _maximize

foreign import _minimize
  :: Fn1
       Locale
       Locale

-- | Attempts to remove information about the locale that would be added by
-- | calling `maximize`
minimize
  :: Locale
  -> Locale
minimize =
  Function.Uncurried.runFn1 _minimize