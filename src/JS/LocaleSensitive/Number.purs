module JS.LocaleSensitive.Number
  ( toLocaleString
  ) where

import ConvertableOptions (class ConvertOptionsWithDefaults)
import Effect (Effect)
import Effect.Uncurried (EffectFn3)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.NumberFormat (NumberFormatOptions, ToNumberFormatOptions)
import JS.Intl.NumberFormat as NumberFormat

foreign import _toLocaleString
  :: EffectFn3
       (Array Locale)
       { | NumberFormatOptions }
       Number
       String

-- | Returns a string with a language-sensitive representation of this number.
-- | When formatting large numbers of numbers, it is better to use
-- | `Intl.NumberFormat.format` instead.
toLocaleString
  :: forall provided
   . ConvertOptionsWithDefaults
       ToNumberFormatOptions
       { | NumberFormatOptions }
       { | provided }
       { | NumberFormatOptions }
  => Array Locale
  -> { | provided }
  -> Number
  -> Effect String
toLocaleString locales providedOptions =
  Effect.Uncurried.runEffectFn3
    _toLocaleString
    locales
    (NumberFormat.convertOptionsWithDefaults providedOptions)
