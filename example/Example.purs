-- Assuming these imports
-- 
module Example where

import Prelude

import Data.Array as Array
import Data.Interval (DurationComponent(..))
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
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
  -- ### Format a date
  -- 
  { date1, date2 } <- Unsafe.unsafePartial do
    maybeDate1 <- JSDate.toDateTime <$> JSDate.parse "07/16/2023"
    maybeDate2 <- JSDate.toDateTime <$> JSDate.parse "07/20/2023"
    case maybeDate1, maybeDate2 of
      Just date1, Just date2 -> pure { date1, date2 }

  dateTimeFormat <-
    DateTimeFormat.new [ en_US ]
      { dateStyle: "long"
      , timeStyle: "long"
      , timeZone: "UTC"
      }
  let
    formattedDate =
      DateTimeFormat.format dateTimeFormat date1
  Console.logShow formattedDate -- "July 16, 2023 at 4:00:00 AM UTC"
  --
  -- ### Format a date range
  --
  dateTimeRangeFormat <-
    DateTimeFormat.new [ en_US ]
      { dateStyle: "medium"
      , timeZone: "UTC"
      }
  let
    formattedDateRange =
      DateTimeFormat.formatRange dateTimeRangeFormat date1 date2
  Console.logShow formattedDateRange -- "Jul 16 – 20, 2023"
  --
  -- ### Sort a collection of strings by natural sort order
  --
  collator <- Collator.new [ en_US ] { numeric: true }
  let
    sortedStrings =
      Array.sortBy (Collator.compare collator) [ "Chapter 1", "Chapter 11", "Chapter 2" ]
  Console.logShow sortedStrings -- [ "Chapter 1", "Chapter 2", "Chapter 11" ]
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
  Console.logShow formattedUSD -- "$123,456.79"
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
  Console.logShow formattedMB -- "123,457 MB"
  --
  -- ### Get a list of words from a sentence
  -- 
  segmenter <- Segmenter.new [ en_US ] { granularity: "word" }
  let
    words = "Hey! How are ya, Jim?"
    segments = Segmenter.segment segmenter words
      # Array.mapMaybe \{ isWordLike, segment } -> case isWordLike of
          true -> Just segment
          false -> Nothing
  Console.logShow (segments :: Array _) -- ["Hey", "How", "are", "ya", "Jim"]
  --
  -- ### Overloaded API
  --
  -- In the examples above we mostly passed `String` values as options to the
  -- service constructors. For many `String`-typed options there are only a few
  -- valid `String` values that can be passed in. For example, the `style`
  -- option for `NumberFormat` only accepts the values `"currency"`,
  -- `"decimal"`, `"percent"`, and `"unit"`. For ease of discoverability,
  -- these options are typed as enums in the `JS.Intl.Options` modules, and the API 
  -- for the service constructors are overloaded:
  -- * the `style` option will also a `NumberFormatStyle` value
  -- * `unit` will accept a `DurationComponent`
  -- * `unitDisplay` will accept a `UnitDisplay`
  -- * and so on
  secondsNumberFormat <-
    NumberFormat.new [ en_US ]
      { style: NumberFormatStyle.Unit
      , unit: Second
      , unitDisplay: UnitDisplay.Short
      , notation: Notation.Compact
      , maximumFractionDigits: 1
      }
  let
    formattedSeconds = NumberFormat.format secondsNumberFormat 123456.789
  Console.logShow formattedSeconds -- "123.5K sec"  

