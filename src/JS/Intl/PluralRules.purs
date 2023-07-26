module JS.Intl.PluralRules
  -- * Types
  ( PluralRules
  , PluralRulesOptions

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

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import Prim.Row (class Union)
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

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record PluralRulesOptions)
       PluralRules

new
  :: forall options options'
   . Union options options' PluralRulesOptions
  => NonEmptyArray Locale
  -> Record options
  -> Effect PluralRules
new locales options =
  Effect.Uncurried.runEffectFn2 _new (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

new_ :: NonEmptyArray Locale -> Effect PluralRules
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record PluralRulesOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' PluralRulesOptions
  => NonEmptyArray Locale
  -> Record options
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2 _supportedLocalesOf (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

supportedLocalesOf_
  :: NonEmptyArray Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales {}

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