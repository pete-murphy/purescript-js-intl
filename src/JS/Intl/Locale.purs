module JS.Intl.Locale
  ( Locale
  , LocaleOptions
  , ToLocaleOptions
  , baseName
  , calendar
  , caseFirst
  , collation
  , hourCycle
  , language
  , maximize
  , minimize
  , new
  , new_
  , numberingSystem
  , numeric
  , region
  , script
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Options.CaseFirst (CaseFirst)
import JS.Intl.Options.CaseFirst as CaseFirst
import JS.Intl.Options.Collation (Collation)
import JS.Intl.Options.Collation as Collation
import JS.Intl.Options.HourCycle (HourCycle)
import JS.Intl.Options.HourCycle as HourCycle
import JS.Intl.Options.Internal.Unsafe as Unsafe
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

instance ConvertOption ToLocaleOptions "collation" Collation String where
  convertOption _ _ = Collation.toString

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
  :: Locale
  -> String

-- | Returns basic, core information about the `Locale` in the form of a
-- | substring of the complete data string
baseName
  :: Locale
  -> String
baseName =
  _baseName

foreign import _calendar
  :: Locale
  -> Nullable String

-- | Returns the calendar type for this locale
calendar
  :: Locale
  -> Maybe String
calendar =
  _calendar >>> Nullable.toMaybe

foreign import _caseFirst
  :: Locale
  -> Nullable String

-- | Returns whether case is taken into account for this locale's collation
-- | rules
caseFirst
  :: Locale
  -> Maybe CaseFirst
caseFirst =
  _caseFirst
    >>> Nullable.toMaybe
    >>> map (Unsafe.fromString CaseFirst.fromString)

foreign import _collation
  :: Locale
  -> Nullable String

-- | Returns the collation type for this locale, which is used to order strings
-- | according to the locale's rules
collation
  :: Locale
  -> Maybe Collation
collation =
  _collation
    >>> Nullable.toMaybe
    >>> map (Unsafe.fromString Collation.fromString)

foreign import _hourCycle
  :: Locale
  -> Nullable String

-- | Returns the hour cycle for this locale
hourCycle
  :: Locale
  -> Maybe HourCycle
hourCycle =
  _hourCycle
    >>> Nullable.toMaybe
    >>> map (Unsafe.fromString HourCycle.fromString)

foreign import _numeric
  :: Locale
  -> Boolean

-- | Returns whether this locale has special collation handling for numeric
-- | characters
numeric
  :: Locale
  -> Boolean
numeric =
  _numeric

foreign import _numberingSystem
  :: Locale
  -> Nullable String

-- | Returns the numeral system for this locale
numberingSystem
  :: Locale
  -> Maybe String
numberingSystem =
  _numberingSystem >>> Nullable.toMaybe

foreign import _language
  :: Locale
  -> String

-- | Returns the language associated with this locale
language
  :: Locale
  -> String
language =
  _language

foreign import _script
  :: Locale
  -> Nullable String

-- | Returns the script used for writing the particular language used in this
-- | locale
script
  :: Locale
  -> Maybe String
script =
  _script >>> Nullable.toMaybe

foreign import _region
  :: Locale
  -> Nullable String

-- | Returns the region of the world (usually a country) associated with this
-- | locale
region
  :: Locale
  -> Maybe String
region =
  _region >>> Nullable.toMaybe

foreign import _maximize
  :: Locale
  -> Locale

-- | Gets the most likely values for the language, script, and region of the
-- | locale based on existing values
maximize :: Locale -> Locale
maximize =
  _maximize

foreign import _minimize
  :: Locale
  -> Locale

-- | Attempts to remove information about the locale that would be added by
-- | calling `maximize`
minimize
  :: Locale
  -> Locale
minimize =
  _minimize
