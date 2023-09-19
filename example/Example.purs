-- Assuming these imports
-- 
module Example where

import Prelude

import Data.Array as Array
import Data.Interval as Interval
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Maybe as Maybe
import Effect (Effect)
import Effect.Class.Console as Console
import JS.Intl.Collator as Collator
import JS.Intl.DateTimeFormat as DateTimeFormat
import JS.Intl.Locale as Locale
import JS.Intl.NumberFormat as NumberFormat
import JS.Intl.Options.Notation as Notation
import JS.Intl.Options.NumberFormatStyle as NumberFormatStyle
import JS.Intl.Options.UnitDisplay as UnitDisplay
import JS.Intl.Segmenter as Segmenter
import Partial.Unsafe as Unsafe

-- 
-- ### Construct a `Locale`
--
-- Use the `new` constructor (or `new_` if you don't care to pass `LocaleOptions`) 
-- to create a `Locale`
-- 
main :: Effect Unit
main = do
  en_US <- Locale.new_ "en-US"
  --
  -- This `Locale` is then passed as an argument to the various `Intl` service
  -- constructors.
  --
  -- ### Format a date
  -- 
  let
    unsafeParseDateTime string = Unsafe.unsafePartial do
      Maybe.fromJust <<< JSDate.toDateTime <$> JSDate.parse string

  july16 <- unsafeParseDateTime "07/16/2023"

  dateTimeFormat <-
    DateTimeFormat.new [ en_US ]
      { dateStyle: "full"
      , timeStyle: "full"
      , timeZone: "America/New_York"
      }
  let
    formattedDate =
      DateTimeFormat.format dateTimeFormat july16
  Console.log formattedDate -- Sunday, July 16, 2023 at 12:00:00 AM Eastern Daylight Time
  --
  -- ### Format a date range
  --
  july20 <- unsafeParseDateTime "07/20/2023"

  dateTimeRangeFormat <-
    DateTimeFormat.new [ en_US ]
      { dateStyle: "medium"
      , timeZone: "UTC"
      }
  let
    formattedDateRange =
      DateTimeFormat.formatRange dateTimeRangeFormat july16 july20
  Console.log formattedDateRange -- Jul 16 – 20, 2023
  --
  -- ### Sort a collection of strings by natural sort order
  --
  collator <- Collator.new [ en_US ] { numeric: true }
  let
    sortedStrings =
      Array.sortBy (Collator.compare collator) [ "Chapter 1", "Chapter 11", "Chapter 2" ]
  Console.logShow sortedStrings -- ["Chapter 1","Chapter 2","Chapter 11"]
  -- 
  -- ### Format a number as currency
  --
  usdCurrencyFormat <-
    NumberFormat.new [ en_US ]
      { style: "currency"
      , currency: "USD"
      }
  let
    formattedUSD = NumberFormat.format usdCurrencyFormat 123456.789
  Console.log formattedUSD -- $123,456.79
  --
  -- ### Format a number as megabytes (or whatever unit)
  -- 
  mbNumberFormat <-
    NumberFormat.new [ en_US ]
      { style: "unit"
      , unit: "megabyte"
      , maximumFractionDigits: 0
      }
  let
    formattedMB = NumberFormat.format mbNumberFormat 123456.789
  Console.log formattedMB -- 123,457 MB
  --
  -- ### Get a list of words from a sentence
  -- 
  segmenter <- Segmenter.new [ en_US ] { granularity: "word" }
  let
    sentence = "Hey! How are ya, Jim?"
    words = Segmenter.segment segmenter sentence
      # Array.mapMaybe \{ isWordLike, segment } ->
          if isWordLike then
            Just segment
          else Nothing
  Console.logShow words -- ["Hey","How","are","ya","Jim"]
  --
  -- ### Type safety and overloaded API
  --
  -- In the examples above we mostly passed string values as options to the
  -- service constructors. Many `String`-typed options only have a few valid
  -- strings that can be passed in. For example, the `style` option for
  -- `NumberFormat` only accepts the values `"currency"`, `"decimal"`,
  -- `"percent"`, and `"unit"`. Passing in any other value will throw a
  -- `RangeError` from JavaScript.
  -- ```
  -- > new Intl.NumberFormat("en-US", { style: "oops" })
  -- Uncaught:
  -- RangeError: Value oops out of range for Intl.NumberFormat options property style
  --     at new NumberFormat (<anonymous>)
  -- ```
  -- This library doesn't prevent you from passing invalid strings, and it
  -- generally won't catch any errors for you. However, for ease of
  -- discoverability of valid options, there are enums in the `JS.Intl.Options`
  -- modules for most of the option types, and the service constructors are
  -- overloaded to accept these values as well.
  secondsNumberFormat <-
    NumberFormat.new [ en_US ]
      { style: NumberFormatStyle.Unit
      , unit: Interval.Second
      , unitDisplay: UnitDisplay.Short
      , notation: Notation.Compact
      , maximumFractionDigits: 1
      }
  let
    formattedSeconds = NumberFormat.format secondsNumberFormat 123456.789
  Console.log formattedSeconds -- 123.5K sec
-- See the `ConvertOption` type class instances in each of the service
-- constructor modules to see what options are available as typed enums. Note
-- that even when using the typed enums there are still some invalid
-- combinations of options that will throw an error, like specifying `timeStyle`
-- _and_ `fractionalSecondDigits` in the `DateTimeFormat` options. Reference
-- [the official specification](https://tc39.es/ecma402) for details on valid
-- combinations.