module JS.Intl.PluralRules
  -- * Types
  ( PluralRules
  , PluralRulesOptions
  , ToPluralRulesOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , select
  , selectRange
  , resolvedOptions
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.PluralRulesType (PluralRulesType)
import JS.Intl.Options.PluralRulesType as PluralRulesType
import Unsafe.Coerce as Unsafe.Coerce

-- | Plural-sensitive formatting and plural-related language rules
foreign import data PluralRules :: Type

type PluralRulesOptions =
  ( localeMatcher :: String
  , type :: String
  , minimumIntegerDigits :: Int
  , minimumFractionDigits :: Int
  , maximumFractionDigits :: Int
  , minimumSignificantDigits :: Int
  , maximumSignificantDigits :: Int
  )

defaultOptions :: { | PluralRulesOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | PluralRulesOptions }
       PluralRules

data ToPluralRulesOptions = ToPluralRulesOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToPluralRulesOptions
       { | PluralRulesOptions }
       { | provided }
       { | PluralRulesOptions }
  => NonEmptyArray Locale
  -> { | provided }
  -> Effect PluralRules
new locales provided =
  Effect.Uncurried.runEffectFn2
    _new
    (NonEmpty.toArray locales)
    options
  where
  options :: { | PluralRulesOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToPluralRulesOptions defaultOptions provided

instance ConvertOption ToPluralRulesOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToPluralRulesOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToPluralRulesOptions "type" PluralRulesType String where
  convertOption _ _ = PluralRulesType.toString

instance ConvertOption ToPluralRulesOptions "type" String String where
  convertOption _ _ = identity

instance ConvertOption ToPluralRulesOptions "minimumIntegerDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToPluralRulesOptions "minimumFractionDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToPluralRulesOptions "maximumFractionDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToPluralRulesOptions "minimumSignificantDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToPluralRulesOptions "maximumSignificantDigits" Int Int where
  convertOption _ _ = identity

new_ :: NonEmptyArray Locale -> Effect PluralRules
new_ locales =
  new locales defaultOptions

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | PluralRulesOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToPluralRulesOptions
       { | PluralRulesOptions }
       { | provided }
       { | PluralRulesOptions }
  => NonEmptyArray Locale
  -> { | provided }
  -> Array String
supportedLocalesOf locales provided =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    (NonEmpty.toArray locales)
    options
  where
  options :: { | PluralRulesOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToPluralRulesOptions defaultOptions provided

supportedLocalesOf_
  :: NonEmptyArray Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales defaultOptions

foreign import _select
  :: Fn2
       PluralRules
       Int
       String

type PluralCategory = String -- TODO: Should be "zero", "one", "two" "few", "many", "other"

-- | Returns a string indicating which plural rule to use for locale-aware
-- | formatting
select :: PluralRules -> Int -> PluralCategory
select =
  Function.Uncurried.runFn2 _select

foreign import _selectRange
  :: Fn3
       PluralRules
       Int
       Int
       String

-- | Receives two values and returns a string indicating which plural rule to
-- | use for locale-aware formatting
selectRange
  :: PluralRules
  -> Int
  -> Int
  -> PluralCategory
selectRange =
  Function.Uncurried.runFn3 _selectRange

type ResolvedOptions =
  { locale :: String
  , type :: String
  , pluralCategories :: Array PluralCategory
  }

foreign import _resolvedOptions
  :: EffectFn1
       PluralRules
       ResolvedOptions

resolvedOptions
  :: PluralRules
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions
