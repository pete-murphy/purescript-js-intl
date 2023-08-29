module JS.Intl.Locale
  -- * Types
  ( Locale
  , LocaleOptions
  , ToLocaleOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , baseName
  , maximize
  , minimize
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Function.Uncurried (Fn1)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Options.CaseFirst (CaseFirst)
import JS.Intl.Options.CaseFirst as CaseFirst
import JS.Intl.Options.HourCycle (HourCycle)
import JS.Intl.Options.HourCycle as HourCycle
import Unsafe.Coerce as Unsafe.Coerce

-- | Represents a Unicode locale identifier
foreign import data Locale :: Type

type LocaleOptions =
  ( calendar :: String
  , collation :: String
  , hourCycle :: String
  , caseFirst :: String
  , numeric :: Boolean
  , numberingSystem :: String
  , language :: String
  , script :: String
  , region :: String
  )

defaultOptions :: { | LocaleOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

foreign import _new
  :: EffectFn2
       String
       { | LocaleOptions }
       Locale

new_
  :: String
  -> Effect Locale
new_ locales =
  new locales defaultOptions

data ToLocaleOptions = ToLocaleOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToLocaleOptions
       { | LocaleOptions }
       { | provided }
       { | LocaleOptions }
  => String
  -> { | provided }
  -> Effect Locale
new locales provided =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    options
  where
  options :: { | LocaleOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToLocaleOptions defaultOptions provided

instance ConvertOption ToLocaleOptions "calendar" String String where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "collation" String String where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "hourCycle" HourCycle String where
  convertOption _ _ = HourCycle.toString

instance ConvertOption ToLocaleOptions "hourCycle" String String where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "caseFirst" CaseFirst String where
  convertOption _ _ = CaseFirst.toString

instance ConvertOption ToLocaleOptions "caseFirst" String String where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "numeric" Boolean Boolean where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "numberingSystem" String String where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "language" String String where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "script" String String where
  convertOption _ _ = identity

instance ConvertOption ToLocaleOptions "region" String String where
  convertOption _ _ = identity

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
