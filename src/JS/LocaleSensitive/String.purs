module JS.LocaleSensitive.String
  ( localeCompare
  , toLocaleLowerCase
  , toLocaleUpperCase
  ) where

import Prelude

import ConvertableOptions (class ConvertOptionsWithDefaults)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn4)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Collator (CollatorOptions, ToCollatorOptions)
import JS.Intl.Collator as Collator
import JS.Intl.Locale (Locale)

foreign import _localeCompare
  :: EffectFn4
       (Array Locale)
       { | CollatorOptions }
       String
       String
       Number

foreign import _toLocaleLowerCase
  :: EffectFn2
       (Array Locale)
       String
       String

foreign import _toLocaleUpperCase
  :: EffectFn2
       (Array Locale)
       String
       String

-- | Returns an `Ordering` indicating whether this string comes before, or after,
-- | or is the same as the given string in sort order.
-- | When comparing large numbers of strings, such as in sorting large arrays,
-- | it is better to use `Intl.Collator.compare` instead.
localeCompare
  :: forall provided
   . ConvertOptionsWithDefaults
       ToCollatorOptions
       { | CollatorOptions }
       { | provided }
       { | CollatorOptions }
  => Array Locale
  -> { | provided }
  -> String
  -> String
  -> Effect Ordering
localeCompare locales providedOptions x y =
  compare
    <$> Effect.Uncurried.runEffectFn4 _localeCompare locales options x y
    <*> pure 0.0
  where
  options :: { | CollatorOptions }
  options = Collator.convertOptionsWithDefaults providedOptions

-- | Returns the input string converted to lower case, according to any
-- | locale-specific case mappings.
toLocaleLowerCase
  :: Array Locale
  -> String
  -> Effect String
toLocaleLowerCase =
  Effect.Uncurried.runEffectFn2 _toLocaleLowerCase

-- | Returns the input string converted to upper case, according to any
-- | locale-specific case mappings.
toLocaleUpperCase
  :: Array Locale
  -> String
  -> Effect String
toLocaleUpperCase =
  Effect.Uncurried.runEffectFn2 _toLocaleUpperCase
