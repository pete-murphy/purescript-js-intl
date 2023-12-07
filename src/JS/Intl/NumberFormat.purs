module JS.Intl.NumberFormat
  -- * Types
  ( NumberFormat
  , NumberFormatOptions
  , ToNumberFormatOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , format
  , formatRange
  , formatRangeToParts
  , formatToParts
  , resolvedOptions

  -- * Options
  , convertOptionsWithDefaults
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Data.Interval (DurationComponent(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Foreign (Foreign)
import Foreign as Foreign
import JS.Intl.Locale (Locale)
import JS.Intl.Options.CompactDisplay (CompactDisplay)
import JS.Intl.Options.CompactDisplay as CompactDisplay
import JS.Intl.Options.CurrencyDisplay (CurrencyDisplay)
import JS.Intl.Options.CurrencyDisplay as CurrencyDisplay
import JS.Intl.Options.CurrencySign (CurrencySign)
import JS.Intl.Options.CurrencySign as CurrencySign
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Notation (Notation)
import JS.Intl.Options.Notation as Notation
import JS.Intl.Options.NumberFormatStyle (NumberFormatStyle)
import JS.Intl.Options.NumberFormatStyle as NumberFormatStyle
import JS.Intl.Options.RoundingIncrement (RoundingIncrement)
import JS.Intl.Options.RoundingIncrement as RoundingIncrement
import JS.Intl.Options.RoundingMode (RoundingMode)
import JS.Intl.Options.RoundingMode as RoundingMode
import JS.Intl.Options.RoundingPriority (RoundingPriority)
import JS.Intl.Options.RoundingPriority as RoundingPriority
import JS.Intl.Options.SignDisplay (SignDisplay)
import JS.Intl.Options.SignDisplay as SignDisplay
import JS.Intl.Options.TrailingZeroDisplay (TrailingZeroDisplay)
import JS.Intl.Options.TrailingZeroDisplay as TrailingZeroDisplay
import JS.Intl.Options.UnitDisplay (UnitDisplay)
import JS.Intl.Options.UnitDisplay as UnitDisplay
import JS.Intl.Options.UseGrouping (UseGrouping)
import JS.Intl.Options.UseGrouping as UseGrouping
import Unsafe.Coerce as Unsafe.Coerce

-- | Language-sensitive number formatting
foreign import data NumberFormat :: Type

-- | Options to pass to the `NumberFormat` constructor (`new` or `new_`)
-- |
-- | **Note:** Not all combinations of options are valid. See the specification
-- | (https://tc39.es/ecma402/#sec-intl.numberformat) or the MDN reference
-- | (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat/NumberFormat)
type NumberFormatOptions =
  ( localeMatcher :: String
  , numberingSystem :: String
  , compactDisplay :: String
  , style :: String
  , currency :: String
  , currencyDisplay :: String
  , currencySign :: String
  , notation :: String
  , signDisplay :: String
  , unit :: String
  , unitDisplay :: String
  , useGrouping :: Foreign
  , roundingMode :: String
  , roundingIncrement :: Int
  , roundingPriority :: String
  , trailingZeroDisplay :: String
  , minimumIntegerDigits :: Int
  , minimumFractionDigits :: Int
  , maximumFractionDigits :: Int
  , minimumSignificantDigits :: Int
  , maximumSignificantDigits :: Int
  )

defaultOptions :: { | NumberFormatOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

convertOptionsWithDefaults
  :: forall provided all
   . ConvertOptionsWithDefaults
       ToNumberFormatOptions
       { | NumberFormatOptions }
       provided
       all
  => provided
  -> all
convertOptionsWithDefaults =
  ConvertableOptions.convertOptionsWithDefaults
    ToNumberFormatOptions
    defaultOptions

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | NumberFormatOptions }
       NumberFormat

data ToNumberFormatOptions = ToNumberFormatOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToNumberFormatOptions
       { | NumberFormatOptions }
       { | provided }
       { | NumberFormatOptions }
  => Array Locale
  -> { | provided }
  -> Effect NumberFormat
new locales providedOptions =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    (convertOptionsWithDefaults providedOptions)

instance ConvertOption ToNumberFormatOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToNumberFormatOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "numberingSystem" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "compactDisplay" CompactDisplay String where
  convertOption _ _ = CompactDisplay.toString

instance ConvertOption ToNumberFormatOptions "compactDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "style" NumberFormatStyle String where
  convertOption _ _ = NumberFormatStyle.toString

instance ConvertOption ToNumberFormatOptions "style" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "currency" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "currencyDisplay" CurrencyDisplay String where
  convertOption _ _ = CurrencyDisplay.toString

instance ConvertOption ToNumberFormatOptions "currencyDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "currencySign" CurrencySign String where
  convertOption _ _ = CurrencySign.toString

instance ConvertOption ToNumberFormatOptions "currencySign" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "notation" Notation String where
  convertOption _ _ = Notation.toString

instance ConvertOption ToNumberFormatOptions "notation" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "signDisplay" SignDisplay String where
  convertOption _ _ = SignDisplay.toString

instance ConvertOption ToNumberFormatOptions "signDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "unit" DurationComponent String where
  convertOption _ _ = case _ of
    Second -> "second"
    Minute -> "minute"
    Hour -> "hour"
    Day -> "day"
    Week -> "week"
    Month -> "month"
    Year -> "year"

else instance ConvertOption ToNumberFormatOptions "unit" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "unitDisplay" UnitDisplay String where
  convertOption _ _ = UnitDisplay.toString

instance ConvertOption ToNumberFormatOptions "unitDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "useGrouping" UseGrouping Foreign where
  convertOption _ _ = Foreign.unsafeToForeign <<< UseGrouping.toString

instance ConvertOption ToNumberFormatOptions "useGrouping" String Foreign where
  convertOption _ _ = Foreign.unsafeToForeign

instance ConvertOption ToNumberFormatOptions "useGrouping" Boolean Foreign where
  convertOption _ _ = Foreign.unsafeToForeign

instance ConvertOption ToNumberFormatOptions "useGrouping" Foreign Foreign where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "roundingMode" RoundingMode String where
  convertOption _ _ = RoundingMode.toString

instance ConvertOption ToNumberFormatOptions "roundingMode" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "roundingIncrement" RoundingIncrement Int where
  convertOption _ _ = RoundingIncrement.toInt

instance ConvertOption ToNumberFormatOptions "roundingIncrement" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "roundingPriority" RoundingPriority String where
  convertOption _ _ = RoundingPriority.toString

instance ConvertOption ToNumberFormatOptions "roundingPriority" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "trailingZeroDisplay" TrailingZeroDisplay String where
  convertOption _ _ = TrailingZeroDisplay.toString

instance ConvertOption ToNumberFormatOptions "trailingZeroDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "minimumIntegerDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "minimumFractionDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "maximumFractionDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "minimumSignificantDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToNumberFormatOptions "maximumSignificantDigits" Int Int where
  convertOption _ _ = identity

new_
  :: Array Locale
  -> Effect NumberFormat
new_ locales =
  new locales defaultOptions

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | NumberFormatOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToNumberFormatOptions
       { | NumberFormatOptions }
       { | provided }
       { | NumberFormatOptions }
  => Array Locale
  -> { | provided }
  -> Array String
supportedLocalesOf locales providedOptions =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    locales
    (convertOptionsWithDefaults providedOptions)

supportedLocalesOf_
  :: Array Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales defaultOptions

foreign import _format
  :: Fn2
       NumberFormat
       Number
       String

-- | Formats a number according to the locale and formatting options of the
-- | `NumberFormat`
format :: NumberFormat -> Number -> String
format = Function.Uncurried.runFn2 _format

foreign import _formatRange
  :: Fn3
       NumberFormat
       Number
       Number
       String

-- | Formats a range of numbers according to the locale and formatting options
-- | of the `NumberFormat`
formatRange :: NumberFormat -> Number -> Number -> String
formatRange = Function.Uncurried.runFn3 _formatRange

foreign import _formatRangeToParts
  :: Fn3
       NumberFormat
       Number
       Number
       (Array { type :: String, value :: String })

-- | Returns an array of objects containing the locale-specific tokens from
-- | which it is possible to build custom strings while preserving the
-- | locale-specific parts
formatRangeToParts :: NumberFormat -> Number -> Number -> Array { type :: String, value :: String }
formatRangeToParts = Function.Uncurried.runFn3 _formatRangeToParts

foreign import _formatToParts
  :: Fn2
       NumberFormat
       Number
       (Array { type :: String, value :: String })

-- | Allows locale-aware formatting of strings produced by the `NumberFormat`
formatToParts :: NumberFormat -> Number -> Array { type :: String, value :: String }
formatToParts = Function.Uncurried.runFn2 _formatToParts

type ResolvedOptions =
  { locale :: String
  , numberingSystem :: String
  , style :: String
  , currency :: String
  , currencyDisplay :: String
  , currencySign :: String
  , minimumIntegerDigits :: Int
  , minimumFractionDigits :: Int
  , maximumFractionDigits :: Int
  , useGrouping :: Foreign
  , notation :: String
  , signDisplay :: String
  }

foreign import _resolvedOptions
  :: EffectFn1
       NumberFormat
       ResolvedOptions

resolvedOptions
  :: NumberFormat
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions
