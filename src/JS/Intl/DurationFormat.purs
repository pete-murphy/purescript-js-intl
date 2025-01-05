module JS.Intl.DurationFormat
  -- * Types
  ( DurationFormat
  , DurationFormatOptions
  , ToDurationFormatOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , format
  , formatToParts
  , resolvedOptions

  -- * Options
  , convertOptionsWithDefaults
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Function.Uncurried (Fn2)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Foreign (Foreign)
import JS.Intl.Locale (Locale)
import JS.Intl.Options.Days (Days)
import JS.Intl.Options.Days as Days
import JS.Intl.Options.DaysDisplay (DaysDisplay)
import JS.Intl.Options.DaysDisplay as DaysDisplay
import JS.Intl.Options.DurationFormatStyle (DurationFormatStyle)
import JS.Intl.Options.DurationFormatStyle as DurationFormatStyle
import JS.Intl.Options.Hours (Hours)
import JS.Intl.Options.Hours as Hours
import JS.Intl.Options.HoursDisplay (HoursDisplay)
import JS.Intl.Options.HoursDisplay as HoursDisplay
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Microseconds (Microseconds)
import JS.Intl.Options.Microseconds as Microseconds
import JS.Intl.Options.MicrosecondsDisplay (MicrosecondsDisplay)
import JS.Intl.Options.MicrosecondsDisplay as MicrosecondsDisplay
import JS.Intl.Options.Milliseconds (Milliseconds)
import JS.Intl.Options.Milliseconds as Milliseconds
import JS.Intl.Options.MillisecondsDisplay (MillisecondsDisplay)
import JS.Intl.Options.MillisecondsDisplay as MillisecondsDisplay
import JS.Intl.Options.Minutes (Minutes)
import JS.Intl.Options.Minutes as Minutes
import JS.Intl.Options.MinutesDisplay (MinutesDisplay)
import JS.Intl.Options.MinutesDisplay as MinutesDisplay
import JS.Intl.Options.Months (Months)
import JS.Intl.Options.Months as Months
import JS.Intl.Options.MonthsDisplay (MonthsDisplay)
import JS.Intl.Options.MonthsDisplay as MonthsDisplay
import JS.Intl.Options.Nanoseconds (Nanoseconds)
import JS.Intl.Options.Nanoseconds as Nanoseconds
import JS.Intl.Options.NanosecondsDisplay (NanosecondsDisplay)
import JS.Intl.Options.NanosecondsDisplay as NanosecondsDisplay
import JS.Intl.Options.Seconds (Seconds)
import JS.Intl.Options.Seconds as Seconds
import JS.Intl.Options.SecondsDisplay (SecondsDisplay)
import JS.Intl.Options.SecondsDisplay as SecondsDisplay
import JS.Intl.Options.Weeks (Weeks)
import JS.Intl.Options.Weeks as Weeks
import JS.Intl.Options.WeeksDisplay (WeeksDisplay)
import JS.Intl.Options.WeeksDisplay as WeeksDisplay
import JS.Intl.Options.Years (Years)
import JS.Intl.Options.Years as Years
import JS.Intl.Options.YearsDisplay (YearsDisplay)
import JS.Intl.Options.YearsDisplay as YearsDisplay
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce

-- | Language-sensitive duration formatting
foreign import data DurationFormat :: Type

-- | Options to pass to the `DurationFormat` constructor (`new` or `new_`)
-- |
-- | **Note:** Not all combinations of options are valid. See the specification
-- | (https://tc39.es/proposal-intl-duration-format/#durationformat-objects) or the MDN reference
-- | (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DurationFormat/DurationFormat)
type DurationFormatOptions =
  ( localeMatcher :: String
  , numberingSystem :: String
  , style :: String
  , years :: String
  , yearsDisplay :: String
  , months :: String
  , monthsDisplay :: String
  , weeks :: String
  , weeksDisplay :: String
  , days :: String
  , daysDisplay :: String
  , hours :: String
  , hoursDisplay :: String
  , minutes :: String
  , minutesDisplay :: String
  , seconds :: String
  , secondsDisplay :: String
  , milliseconds :: String
  , millisecondsDisplay :: String
  , microseconds :: String
  , microsecondsDisplay :: String
  , nanoseconds :: String
  , nanosecondsDisplay :: String
  , fractionalDigits :: Int
  )

defaultOptions :: { | DurationFormatOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

convertOptionsWithDefaults
  :: forall provided all
   . ConvertOptionsWithDefaults
       ToDurationFormatOptions
       { | DurationFormatOptions }
       provided
       all
  => provided
  -> all
convertOptionsWithDefaults =
  ConvertableOptions.convertOptionsWithDefaults
    ToDurationFormatOptions
    defaultOptions

data ToDurationFormatOptions = ToDurationFormatOptions

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | DurationFormatOptions }
       DurationFormat

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDurationFormatOptions
       { | DurationFormatOptions }
       { | provided }
       { | DurationFormatOptions }
  => Array Locale
  -> { | provided }
  -> Effect DurationFormat
new locales providedOptions =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    (convertOptionsWithDefaults providedOptions)

new_
  :: Array Locale
  -> Effect DurationFormat
new_ locales =
  new locales defaultOptions

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | DurationFormatOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDurationFormatOptions
       { | DurationFormatOptions }
       { | provided }
       { | DurationFormatOptions }
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

type Duration =
  ( years :: Number
  , months :: Number
  , weeks :: Number
  , days :: Number
  , hours :: Number
  , minutes :: Number
  , seconds :: Number
  , milliseconds :: Number
  , microseconds :: Number
  , nanoseconds :: Number
  )

foreign import _format
  :: forall duration
   . Fn2
       DurationFormat
       { | duration } -- TODO
       String

-- | Format a duration
format :: forall duration r. Union duration r Duration => DurationFormat -> { | duration } -> String
format = Function.Uncurried.runFn2 _format

foreign import _formatToParts
  :: forall duration
   . Fn2
       DurationFormat
       { | duration } -- TODO
       (Array { type :: String, value :: String })

-- | Allows locale-aware formatting of strings produced by the `DurationFormat`
formatToParts :: forall duration r. Union duration r Duration => DurationFormat -> { | duration } -> Array { type :: String, value :: String }
formatToParts = Function.Uncurried.runFn2 _formatToParts

foreign import _resolvedOptions
  :: EffectFn1
       DurationFormat
       ResolvedOptions

resolvedOptions
  :: DurationFormat
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions

type ResolvedOptions =
  { locale :: String
  , style :: String
  , years :: String
  , yearsDisplay :: String
  , months :: String
  , monthsDisplay :: String
  , weeks :: String
  , weeksDisplay :: String
  , days :: String
  , daysDisplay :: String
  , hours :: String
  , hoursDisplay :: String
  , minutes :: String
  , minutesDisplay :: String
  , seconds :: String
  , secondsDisplay :: String
  , milliseconds :: String
  , millisecondsDisplay :: String
  , microseconds :: String
  , microsecondsDisplay :: String
  , nanoseconds :: String
  , nanosecondsDisplay :: String
  , numberingSystem :: String
  , fractionalDigits :: Int
  }

-- { locale: "en"
--         , style: "short"
--         , years: "short"
--         , yearsDisplay: "auto"
--         , months: "short"
--         , monthsDisplay: "auto"
--         , weeks: "short"
--         , weeksDisplay: "auto"
--         , days: "short"
--         , daysDisplay: "auto"
--         , hours: "short"
--         , hoursDisplay: "auto"
--         , minutes: "short"
--         , minutesDisplay: "auto"
--         , seconds: "short"
--         , secondsDisplay: "auto"
--         , milliseconds: "short"
--         , millisecondsDisplay: "auto"
--         , microseconds: "short"
--         , microsecondsDisplay: "auto"
--         , nanoseconds: "short"
--         , nanosecondsDisplay: "auto"
--         , numberingSystem: "latn"
--         , fractionalDigits: ""
--         }

instance ConvertOption ToDurationFormatOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToDurationFormatOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "numberingSystem" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "style" DurationFormatStyle String where
  convertOption _ _ = DurationFormatStyle.toString

instance ConvertOption ToDurationFormatOptions "style" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "years" Years String where
  convertOption _ _ = Years.toString

instance ConvertOption ToDurationFormatOptions "years" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "yearsDisplay" YearsDisplay String where
  convertOption _ _ = YearsDisplay.toString

instance ConvertOption ToDurationFormatOptions "yearsDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "months" Months String where
  convertOption _ _ = Months.toString

instance ConvertOption ToDurationFormatOptions "months" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "monthsDisplay" MonthsDisplay String where
  convertOption _ _ = MonthsDisplay.toString

instance ConvertOption ToDurationFormatOptions "monthsDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "weeks" Weeks String where
  convertOption _ _ = Weeks.toString

instance ConvertOption ToDurationFormatOptions "weeks" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "weeksDisplay" WeeksDisplay String where
  convertOption _ _ = WeeksDisplay.toString

instance ConvertOption ToDurationFormatOptions "weeksDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "days" Days String where
  convertOption _ _ = Days.toString

instance ConvertOption ToDurationFormatOptions "days" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "daysDisplay" DaysDisplay String where
  convertOption _ _ = DaysDisplay.toString

instance ConvertOption ToDurationFormatOptions "daysDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "hours" Hours String where
  convertOption _ _ = Hours.toString

instance ConvertOption ToDurationFormatOptions "hours" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "hoursDisplay" HoursDisplay String where
  convertOption _ _ = HoursDisplay.toString

instance ConvertOption ToDurationFormatOptions "hoursDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "minutes" Minutes String where
  convertOption _ _ = Minutes.toString

instance ConvertOption ToDurationFormatOptions "minutes" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "minutesDisplay" MinutesDisplay String where
  convertOption _ _ = MinutesDisplay.toString

instance ConvertOption ToDurationFormatOptions "minutesDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "seconds" Seconds String where
  convertOption _ _ = Seconds.toString

instance ConvertOption ToDurationFormatOptions "seconds" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "secondsDisplay" SecondsDisplay String where
  convertOption _ _ = SecondsDisplay.toString

instance ConvertOption ToDurationFormatOptions "secondsDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "milliseconds" Milliseconds String where
  convertOption _ _ = Milliseconds.toString

instance ConvertOption ToDurationFormatOptions "milliseconds" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "millisecondsDisplay" MillisecondsDisplay String where
  convertOption _ _ = MillisecondsDisplay.toString

instance ConvertOption ToDurationFormatOptions "millisecondsDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "nanoseconds" Nanoseconds String where
  convertOption _ _ = Nanoseconds.toString

instance ConvertOption ToDurationFormatOptions "nanoseconds" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "nanosecondsDisplay" NanosecondsDisplay String where
  convertOption _ _ = NanosecondsDisplay.toString

instance ConvertOption ToDurationFormatOptions "nanosecondsDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "microseconds" Microseconds String where
  convertOption _ _ = Microseconds.toString

instance ConvertOption ToDurationFormatOptions "microseconds" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "microsecondsDisplay" MicrosecondsDisplay String where
  convertOption _ _ = MicrosecondsDisplay.toString

instance ConvertOption ToDurationFormatOptions "microsecondsDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDurationFormatOptions "fractionalDigits" Int Int where
  convertOption _ _ = identity
