-- Assuming these imports
-- 
module Example where

import Prelude

import Data.Array as Array
import Data.Array.NonEmpty as NonEmpty
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console as Console
import JS.Intl.Collator as Collator
import JS.Intl.DateTimeFormat as DateTimeFormat
import JS.Intl.Locale as Locale
import JS.Intl.NumberFormat as NumberFormat
import Partial.Unsafe as Unsafe

-- 
-- we can construct a `Locale` using the `new` or `new_` constructors.
-- 
main :: Effect Unit
main = do
  en_US <- Locale.new_ "en-US"
  -- 
  -- All service constructors take a non-empty array of locales as first argument.
  -- 
  let locales = NonEmpty.singleton en_US
  --
  -- Now we can use the `Collator` module to sort a collection of strings by
  -- [natural sort order](https://en.wikipedia.org/wiki/Natural_sort_order),
  --
  collator <- Collator.new locales { numeric: true }
  let
    sortedStrings =
      Array.sortBy (Collator.compare collator) [ "Chapter 1", "Chapter 11", "Chapter 2" ]
  Console.logShow sortedStrings -- [ "Chapter 1", "Chapter 2", "Chapter 11" ]
  --
  -- or we can format a range of dates using `DateTimeFormat`,
  --
  dateTimeFormat <- DateTimeFormat.new locales { dateStyle: "medium", timeZone: "UTC" }
  let
    maybeDate1 = JSDate.toDateTime (JSDate.fromTime 1689500000000.0)
    maybeDate2 = JSDate.toDateTime (JSDate.fromTime 1689832837416.0)
    formattedDateRange = Unsafe.unsafePartial case maybeDate1, maybeDate2 of
      Just date1, Just date2 -> DateTimeFormat.formatRange dateTimeFormat date1 date2
  Console.logShow formattedDateRange -- "Jul 16 – 20, 2023"
  --
  -- or use `NumberFormat` for formatting currencies for example.
  --
  numberFormat <- NumberFormat.new locales { style: "currency", currency: "USD" }
  let
    formattedNumber = NumberFormat.format numberFormat 123456.789
  Console.logShow formattedNumber -- "$123,456.79"