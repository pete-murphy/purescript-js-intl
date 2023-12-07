module JS.LocaleSensitive.Date
  ( toLocaleString
  , toLocaleDateString
  , toLocaleTimeString
  ) where

import ConvertableOptions (class ConvertOptionsWithDefaults)
import Data.DateTime (DateTime)
import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Effect (Effect)
import Effect.Uncurried (EffectFn3)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.DateTimeFormat (DateTimeFormatOptions, ToDateTimeFormatOptions)
import JS.Intl.DateTimeFormat as DateTimeFormat
import JS.Intl.Locale (Locale)

foreign import _toLocaleString
  :: EffectFn3
       (Array Locale)
       { | DateTimeFormatOptions }
       JSDate
       String

foreign import _toLocaleDateString
  :: EffectFn3
       (Array Locale)
       { | DateTimeFormatOptions }
       JSDate
       String

foreign import _toLocaleTimeString
  :: EffectFn3
       (Array Locale)
       { | DateTimeFormatOptions }
       JSDate
       String

-- | Returns a string with a language-sensitive representation of a date and
-- | time in the user agent's timezone. 
-- | When formatting large numbers of dates, it is better to use
-- | `Intl.DateTimeFormat.format`.
toLocaleString
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDateTimeFormatOptions
       { | DateTimeFormatOptions }
       { | provided }
       { | DateTimeFormatOptions }
  => Array Locale
  -> { | provided }
  -> DateTime
  -> Effect String
toLocaleString locales providedOptions dateTime =
  Effect.Uncurried.runEffectFn3
    _toLocaleString
    locales
    (DateTimeFormat.convertOptionsWithDefaults providedOptions)
    (JSDate.fromDateTime dateTime)

-- | Returns a string with a language-sensitive representation of a date in the
-- | user agent's timezone. 
-- | When formatting large numbers of dates, it is better to use
-- | `Intl.DateTimeFormat.format`.
toLocaleDateString
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDateTimeFormatOptions
       { | DateTimeFormatOptions }
       { | provided }
       { | DateTimeFormatOptions }
  => Array Locale
  -> { | provided }
  -> DateTime
  -> Effect String
toLocaleDateString locales providedOptions dateTime =
  Effect.Uncurried.runEffectFn3
    _toLocaleDateString
    locales
    (DateTimeFormat.convertOptionsWithDefaults providedOptions)
    (JSDate.fromDateTime dateTime)

-- | Returns a string with a language-sensitive representation of a time in the
-- | user agent's timezone. 
-- | When formatting large numbers of dates, it is better to use
-- | `Intl.DateTimeFormat.format`.
toLocaleTimeString
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDateTimeFormatOptions
       { | DateTimeFormatOptions }
       { | provided }
       { | DateTimeFormatOptions }
  => Array Locale
  -> { | provided }
  -> DateTime
  -> Effect String
toLocaleTimeString locales providedOptions dateTime =
  Effect.Uncurried.runEffectFn3
    _toLocaleTimeString
    locales
    (DateTimeFormat.convertOptionsWithDefaults providedOptions)
    (JSDate.fromDateTime dateTime)