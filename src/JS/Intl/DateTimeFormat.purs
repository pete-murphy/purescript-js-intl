module JS.Intl.DateTimeFormat
  -- * Types
  ( DateTimeFormat
  , DateTimeFormatOptions
  , ToDateTimeFormatOptions
  , class DateTimeLike
  , unsafeToDateTimeForeign

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
import Data.DateTime (DateTime)
import Data.DateTime.Instant as Data.DateTime.Instant
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Foreign (Foreign)
import JS.Intl.Locale (Locale)
import JS.Intl.Options.DateStyle (DateStyle)
import JS.Intl.Options.DateStyle as DateStyle
import JS.Intl.Options.Day (Day)
import JS.Intl.Options.Day as Day
import JS.Intl.Options.DayPeriod (DayPeriod)
import JS.Intl.Options.DayPeriod as DayPeriod
import JS.Intl.Options.Era (Era)
import JS.Intl.Options.Era as Era
import JS.Intl.Options.FormatMatcher (FormatMatcher)
import JS.Intl.Options.FormatMatcher as FormatMatcher
import JS.Intl.Options.Hour (Hour)
import JS.Intl.Options.Hour as Hour
import JS.Intl.Options.HourCycle (HourCycle)
import JS.Intl.Options.HourCycle as HourCycle
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Minute (Minute)
import JS.Intl.Options.Minute as Minute
import JS.Intl.Options.Month (Month)
import JS.Intl.Options.Month as Month
import JS.Intl.Options.Second (Second)
import JS.Intl.Options.Second as Second
import JS.Intl.Options.TimeStyle (TimeStyle)
import JS.Intl.Options.TimeStyle as TimeStyle
import JS.Intl.Options.TimeZoneName (TimeZoneName)
import JS.Intl.Options.TimeZoneName as TimeZoneName
import JS.Intl.Options.Weekday (Weekday)
import JS.Intl.Options.Weekday as Weekday
import JS.Intl.Options.Year (Year)
import JS.Intl.Options.Year as Year
import Unsafe.Coerce as Unsafe.Coerce

-- | Language-sensitive date and time formatting
foreign import data DateTimeFormat :: Type

type DateTimeFormatOptions =
  ( localeMatcher :: String
  , weekday :: String
  , era :: String
  , year :: String
  , month :: String
  , day :: String
  , hour :: String
  , minute :: String
  , second :: String
  , dayPeriod :: String
  , timeZoneName :: String
  , formatMatcher :: String
  , hour12 :: Boolean
  , timeZone :: String
  , hourCycle :: String
  , fractionalSecondDigits :: Int
  , dateStyle :: String
  , timeStyle :: String
  )

defaultOptions :: { | DateTimeFormatOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

convertOptionsWithDefaults
  :: forall provided all
   . ConvertOptionsWithDefaults
       ToDateTimeFormatOptions
       { | DateTimeFormatOptions }
       provided
       all
  => provided
  -> all
convertOptionsWithDefaults =
  ConvertableOptions.convertOptionsWithDefaults
    ToDateTimeFormatOptions
    defaultOptions

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | DateTimeFormatOptions }
       DateTimeFormat

new_
  :: Array Locale
  -> Effect DateTimeFormat
new_ locales =
  new locales defaultOptions

data ToDateTimeFormatOptions = ToDateTimeFormatOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDateTimeFormatOptions
       { | DateTimeFormatOptions }
       { | provided }
       { | DateTimeFormatOptions }
  => Array Locale
  -> { | provided }
  -> Effect DateTimeFormat
new locales providedOptions =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    (convertOptionsWithDefaults providedOptions)

instance ConvertOption ToDateTimeFormatOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToDateTimeFormatOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "weekday" Weekday String where
  convertOption _ _ = Weekday.toString

instance ConvertOption ToDateTimeFormatOptions "weekday" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "era" Era String where
  convertOption _ _ = Era.toString

instance ConvertOption ToDateTimeFormatOptions "era" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "year" Year String where
  convertOption _ _ = Year.toString

instance ConvertOption ToDateTimeFormatOptions "year" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "month" Month String where
  convertOption _ _ = Month.toString

instance ConvertOption ToDateTimeFormatOptions "month" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "day" Day String where
  convertOption _ _ = Day.toString

instance ConvertOption ToDateTimeFormatOptions "day" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "hour" Hour String where
  convertOption _ _ = Hour.toString

instance ConvertOption ToDateTimeFormatOptions "hour" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "minute" Minute String where
  convertOption _ _ = Minute.toString

instance ConvertOption ToDateTimeFormatOptions "minute" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "second" Second String where
  convertOption _ _ = Second.toString

instance ConvertOption ToDateTimeFormatOptions "second" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "dayPeriod" DayPeriod String where
  convertOption _ _ = DayPeriod.toString

instance ConvertOption ToDateTimeFormatOptions "dayPeriod" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "timeZoneName" TimeZoneName String where
  convertOption _ _ = TimeZoneName.toString

instance ConvertOption ToDateTimeFormatOptions "timeZoneName" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "formatMatcher" FormatMatcher String where
  convertOption _ _ = FormatMatcher.toString

instance ConvertOption ToDateTimeFormatOptions "formatMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "hour12" Boolean Boolean where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "timeZone" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "hourCycle" HourCycle String where
  convertOption _ _ = HourCycle.toString

instance ConvertOption ToDateTimeFormatOptions "hourCycle" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "fractionalSecondDigits" Int Int where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "dateStyle" DateStyle String where
  convertOption _ _ = DateStyle.toString

instance ConvertOption ToDateTimeFormatOptions "dateStyle" String String where
  convertOption _ _ = identity

instance ConvertOption ToDateTimeFormatOptions "timeStyle" TimeStyle String where
  convertOption _ _ = TimeStyle.toString

instance ConvertOption ToDateTimeFormatOptions "timeStyle" String String where
  convertOption _ _ = identity

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | DateTimeFormatOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDateTimeFormatOptions
       { | DateTimeFormatOptions }
       { | provided }
       { | DateTimeFormatOptions }
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
  supportedLocalesOf locales {}

class DateTimeLike a where
  unsafeToDateTimeForeign :: a -> Foreign

instance DateTimeLike DateTime where
  unsafeToDateTimeForeign = Unsafe.Coerce.unsafeCoerce <<< JSDate.fromDateTime

instance DateTimeLike Data.DateTime.Instant.Instant where
  unsafeToDateTimeForeign = unsafeToDateTimeForeign <<< Data.DateTime.Instant.toDateTime

instance DateTimeLike JSDate where
  unsafeToDateTimeForeign = Unsafe.Coerce.unsafeCoerce

foreign import _format
  :: Fn2
       DateTimeFormat
       Foreign
       String

-- | Formats a date according to the locale and formatting options of the
-- | `DateTimeFormat`
format
  :: forall dateTime
   . DateTimeLike dateTime
  => DateTimeFormat
  -> dateTime
  -> String
format fmt dateTime = Function.Uncurried.runFn2 _format fmt (unsafeToDateTimeForeign dateTime)

foreign import _formatRange
  :: Fn3
       DateTimeFormat
       Foreign
       Foreign
       String

-- | Formats a date range in the most concise way based on the locales and
-- | options provided for this `DateTimeFormat` instance
formatRange
  :: forall start end
   . DateTimeLike start
  => DateTimeLike end
  => DateTimeFormat
  -> start
  -> end
  -> String
formatRange fmt start end =
  Function.Uncurried.runFn3
    _formatRange
    fmt
    (unsafeToDateTimeForeign start)
    (unsafeToDateTimeForeign end)

foreign import _formatRangeToParts
  :: Fn3
       DateTimeFormat
       Foreign
       Foreign
       (Array { type :: String, value :: String })

-- | Returns an array of locale-specific tokens representing each part of the
-- | formatted date range produced by the `DateTimeFormat` instance
formatRangeToParts
  :: forall start end
   . DateTimeLike start
  => DateTimeLike end
  => DateTimeFormat
  -> start
  -> end
  -> Array { type :: String, value :: String }
formatRangeToParts fmt start end =
  Function.Uncurried.runFn3
    _formatRangeToParts
    fmt
    (unsafeToDateTimeForeign start)
    (unsafeToDateTimeForeign end)

foreign import _formatToParts
  :: Fn2
       DateTimeFormat
       Foreign
       (Array { type :: String, value :: String })

-- | Returns an array of locale-specific tokens representing each part of the
-- | formatted date produced by the `DateTimeFormat` instance
formatToParts
  :: forall dateTime
   . DateTimeLike dateTime
  => DateTimeFormat
  -> dateTime
  -> Array { type :: String, value :: String }
formatToParts fmt dateTime =
  Function.Uncurried.runFn2
    _formatToParts
    fmt
    (unsafeToDateTimeForeign dateTime)

foreign import _resolvedOptions
  :: EffectFn1
       DateTimeFormat
       Foreign

resolvedOptions
  :: DateTimeFormat
  -> Effect Foreign
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions
