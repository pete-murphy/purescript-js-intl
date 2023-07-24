module Test.Main (main) where

import Prelude

import Data.Array as Array
import Data.Array.NonEmpty as NonEmpty
import Data.DateTime (DateTime(..))
import Data.DateTime as DateTime
import Data.Enum as Enum
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..))
import Data.String as String
import Effect (Effect)
import Effect.Class.Console as Console
import Partial.Unsafe as Unsafe
import Test.Assert.Extended as Test
import Web.Intl as Intl
import Web.Intl.AvailableCanonical as AvailableCanonical
import Web.Intl.Collator as Collator
import Web.Intl.DateTimeFormat as DateTimeFormat
import Web.Intl.DisplayNames as DisplayNames
import Web.Intl.ListFormat as ListFormat
import Web.Intl.Locale as Locale
import Web.Intl.NumberFormat as NumberFormat
import Web.Intl.PluralRules as PluralRules
import Web.Intl.RelativeTimeFormat as RelativeTimeFormat
import Web.Intl.RelativeTimeUnit (RelativeTimeUnit(..))
import Web.Intl.Segmenter as Segmenter

main :: Effect Unit
main = do
  test_Intl

  test_Collator
  test_DateTimeFormat
  test_DisplayNames
  test_ListFormat
  test_Locale
  test_NumberFormat
  test_PluralRules
  test_RelativeTimeFormat
  test_Segmenter

-- NOTE: There are inconsistencies across platforms with how
-- `DateTimeFormat.formatRange`, `DateTimeFormat.formatRangeToParts`,
-- `NumberFormat.formatRange`, and `NumberFormat.formatRangeToParts` render the
-- range separator. I'm using an M1 Mac, and locally I see thin spaces (U+2009)
-- surrounding an en dash (U+2013), but in CI running `ubuntu-latest` there are
-- regular spaces surrounding the en dash. To pass the tests in both
-- environments, I'm replacing the thin spaces with regular spaces before
-- comparing the actual and expected values.
replaceThinSpaces :: String -> String
replaceThinSpaces = String.replaceAll (Pattern "\x2009") (Replacement " ")

test_Intl :: Effect Unit
test_Intl = do
  Console.log "Intl.getCanonicalLocales"
  do
    let actual = Intl.getCanonicalLocales [ "EN-US" ]
    Test.assertEqual
      { actual
      , expected: Just [ "en-US" ]
      }
  do
    let actual = Intl.getCanonicalLocales [ "EN-US", "Fr" ]
    Test.assertEqual
      { actual
      , expected: Just [ "en-US", "fr" ]
      }
  do
    let actual = Intl.getCanonicalLocales [ "EN_US" ]
    Test.assertEqual
      { actual
      , expected: Nothing
      }

  Console.log "Intl.supportedValuesOf"
  do
    let actual = Intl.supportedValuesOf AvailableCanonical.Calendar
    Test.assertContains
      { actual
      , expected: [ "iso8601" ]
      }
  do
    let actual = Intl.supportedValuesOf AvailableCanonical.Collation
    Test.assertContains
      { actual
      , expected:
          [ "compat"
          , "dict"
          , "emoji"
          , "eor"
          , "phonebk"
          , "phonetic"
          , "pinyin"
          , "searchjl"
          , "stroke"
          , "trad"
          , "unihan"
          , "zhuyin"
          ]
      }

test_Collator :: Effect Unit
test_Collator = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"
  es_MX <- NonEmpty.singleton <$> Locale.new_ "es-MX"

  Console.log "Collator.supportedLocalesOf"
  Test.assertEqual
    { actual: Collator.supportedLocalesOf en_US { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Test.assertEqual
    { actual: Collator.supportedLocalesOf (en_US <> es_MX) { localeMatcher: "best fit" }
    , expected: [ "en-US", "es-MX" ]
    }

  Console.log "Collator.supportedLocalesOf_"
  Test.assertEqual
    { actual: Collator.supportedLocalesOf_ en_US
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: Collator.supportedLocalesOf_ (en_US <> es_MX)
    , expected: [ "en-US", "es-MX" ]
    }

  do
    collator <- Collator.new en_US { sensitivity: "base" }

    Console.log "Collator.compare"
    Test.assertEqual
      { actual: Collator.compare collator "a" "b"
      , expected: LT
      }

    Test.assertEqual
      { actual: Collator.compare collator "a" "a"
      , expected: EQ
      }

    Test.assertEqual
      { actual: Collator.compare collator "b" "a"
      , expected: GT
      }

  do
    collator <- Collator.new en_US { sensitivity: "base" }

    Console.log "Collator.resolvedOptions"
    resolvedOptions <- Collator.resolvedOptions collator
    Test.assertEqual
      { actual: resolvedOptions
      , expected:
          { locale: "en-US"
          , usage: "sort"
          , sensitivity: "base"
          , ignorePunctuation: false
          , collation: "default"
          , numeric: false
          , caseFirst: "false"
          }
      }

test_DateTimeFormat :: Effect Unit
test_DateTimeFormat = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"
  es_MX <- NonEmpty.singleton <$> Locale.new_ "es-MX"

  Console.log "DateTimeFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf en_US { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf (en_US <> es_MX) { localeMatcher: "best fit" }
    , expected: [ "en-US", "es-MX" ]
    }

  Console.log "DateTimeFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf_ en_US
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf_ (en_US <> es_MX)
    , expected: [ "en-US", "es-MX" ]
    }

  format <- DateTimeFormat.new en_US { timeZone: "UTC" }

  let
    mkDate :: { year :: Int, month :: Int, day :: Int } -> DateTime
    mkDate { year, month, day } = do
      let
        maybeDate =
          DateTime.canonicalDate
            <$> Enum.toEnum year
            <*> Enum.toEnum month
            <*> Enum.toEnum day
        maybeDateTime =
          maybeDate <#> \date -> DateTime date bottom
      Unsafe.unsafePartial case maybeDateTime of
        Just dateTime -> dateTime

  let
    date1 = mkDate { month: 12, day: 21, year: 2012 }
    date2 = mkDate { month: 8, day: 23, year: 2013 }

  Console.log "DateTimeFormat.format"
  Test.assertEqual
    { actual: DateTimeFormat.format format date1
    , expected: "12/21/2012"
    }

  Console.log "DateTimeFormat.formatRange"
  Test.assertEqual
    { actual: DateTimeFormat.formatRange format date1 date1
    , expected: "12/21/2012"
    }
  Test.assertEqual
    { actual: DateTimeFormat.formatRange format date1 date2
        # String.replaceAll (Pattern "\x2009") (Replacement " ")
    , expected: "12/21/2012 – 8/23/2013"
        # String.replaceAll (Pattern "\x2009") (Replacement " ")
    }

  Console.log "DateTimeFormat.formatRangeToParts"
  Test.assertEqual
    { actual: DateTimeFormat.formatRangeToParts format date1 date1
    , expected:
        [ { type: "month", value: "12" }
        , { type: "literal", value: "/" }
        , { type: "day", value: "21" }
        , { type: "literal", value: "/" }
        , { type: "year", value: "2012" }
        ]
    }

  Test.assertEqual
    { actual: DateTimeFormat.formatRangeToParts format date1 date2
        <#> \part -> part { value = replaceThinSpaces part.value }
    , expected:
        [ { type: "month", value: "12" }
        , { type: "literal", value: "/" }
        , { type: "day", value: "21" }
        , { type: "literal", value: "/" }
        , { type: "year", value: "2012" }
        , { type: "literal", value: " – " }
        , { type: "month", value: "8" }
        , { type: "literal", value: "/" }
        , { type: "day", value: "23" }
        , { type: "literal", value: "/" }
        , { type: "year", value: "2013" }
        ] <#> \part -> part { value = replaceThinSpaces part.value }
    }

  Console.log "DateTimeFormat.formatToParts"
  Test.assertEqual
    { actual: DateTimeFormat.formatToParts format date1
    , expected:
        [ { type: "month", value: "12" }
        , { type: "literal", value: "/" }
        , { type: "day", value: "21" }
        , { type: "literal", value: "/" }
        , { type: "year", value: "2012" }
        ]
    }

  Console.log "DateTimeFormat.resolvedOptions"
  resolvedOptions <- DateTimeFormat.resolvedOptions format
  Test.assertEqual
    { actual: resolvedOptions
    , expected:
        { locale: "en-US"
        , calendar: "gregory"
        , numberingSystem: "latn"
        , timeZone: "UTC"
        , year: "numeric"
        , month: "numeric"
        , day: "numeric"
        }
    }

test_DisplayNames :: Effect Unit
test_DisplayNames = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"

  Console.log "DisplayNames.supportedLocalesOf"
  Test.assertEqual
    { actual: DisplayNames.supportedLocalesOf en_US { type: "language" }
    , expected: [ "en-US" ]
    }

  displayNames <- DisplayNames.new en_US { type: "language" }

  Console.log "DisplayNames.of_"
  Test.assertEqual
    { actual: DisplayNames.of_ displayNames "en-US"
    , expected: Just "American English"
    }

test_ListFormat :: Effect Unit
test_ListFormat = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"

  Console.log "List.supportedLocalesOf"
  Test.assertEqual
    { actual: ListFormat.supportedLocalesOf en_US { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "List.supportedLocalesOf_"
  Test.assertEqual
    { actual: ListFormat.supportedLocalesOf_ en_US
    , expected: [ "en-US" ]
    }

  format <- ListFormat.new en_US { style: "long", type: "conjunction" }

  Console.log "ListFormat.format"
  Test.assertEqual
    { actual: ListFormat.format format [ "foo", "bar", "baz" ]
    , expected: "foo, bar, and baz"
    }

  Console.log "ListFormat.formatToParts"
  Test.assertEqual
    { actual: ListFormat.formatToParts format [ "foo", "bar", "baz" ]
    , expected:
        [ { type: "element", value: "foo" }
        , { type: "literal", value: ", " }
        , { type: "element", value: "bar" }
        , { type: "literal", value: ", and " }
        , { type: "element", value: "baz" }
        ]
    }

  Console.log "ListFormat.resolvedOptions"
  resolvedOptions <- ListFormat.resolvedOptions format
  Test.assertEqual
    { actual: resolvedOptions
    , expected:
        { locale: "en-US"
        , type: "conjunction"
        , style: "long"
        }
    }

test_Locale :: Effect Unit
test_Locale = do
  Console.log "Locale.baseName"
  locale <- NonEmpty.singleton <$> Locale.new_ "en-US"
  Test.assertEqual
    { actual: Locale.baseName (NonEmpty.head locale)
    , expected: "en-US"
    }

test_NumberFormat :: Effect Unit
test_NumberFormat = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"

  Console.log "NumberFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: NumberFormat.supportedLocalesOf en_US { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "NumberFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: NumberFormat.supportedLocalesOf_ en_US
    , expected: [ "en-US" ]
    }

  format <- NumberFormat.new en_US { style: "currency", currency: "USD" }

  Console.log "NumberFormat.format"
  Test.assertEqual
    { actual: NumberFormat.format format 123456.789
    , expected: "$123,456.79"
    }

  Console.log "NumberFormat.formatToParts"
  Test.assertEqual
    { actual: NumberFormat.formatToParts format 123456.789
    , expected:
        [ { type: "currency", value: "$" }
        , { type: "integer", value: "123" }
        , { type: "group", value: "," }
        , { type: "integer", value: "456" }
        , { type: "decimal", value: "." }
        , { type: "fraction", value: "79" }
        ]
    }

  Console.log "NumberFormat.resolvedOptions"
  resolvedOptions <- NumberFormat.resolvedOptions format

  Test.assertEqual
    { actual: resolvedOptions
    , expected:
        { locale: "en-US"
        , numberingSystem: "latn"
        , style: "currency"
        , currency: "USD"
        , currencyDisplay: "symbol"
        , useGrouping: true
        , minimumIntegerDigits: 1
        , minimumFractionDigits: 2
        , maximumFractionDigits: 2
        , currencySign: "standard"
        , notation: "standard"
        , signDisplay: "auto"
        }
    }

-- TODO: Not yet supported in Node

-- Console.log "NumberFormat.formatRange"
-- Test.assertEqual
--   { actual: NumberFormat.formatRange format 123456.789 987654.321
--       # replaceThinSpaces
--   , expected: "$123,456.79–$987,654.32"
--       # replaceThinSpaces
--   }

-- Console.log "NumberFormat.formatRangeToParts"
-- Test.assertEqual
--   { actual: NumberFormat.formatRangeToParts format 123456.789 987654.321
--       <#> \part -> part { value = replaceThinSpaces part.value }
--   , expected:
--       [ { type: "currency", value: "$" }
--       , { type: "integer", value: "123" }
--       , { type: "group", value: "," }
--       , { type: "integer", value: "456" }
--       , { type: "decimal", value: "." }
--       , { type: "fraction", value: "79" }
--       , { type: "literal", value: "–" }
--       , { type: "currency", value: "$" }
--       , { type: "integer", value: "987" }
--       , { type: "group", value: "," }
--       , { type: "integer", value: "654" }
--       , { type: "decimal", value: "." }
--       , { type: "fraction", value: "32" }
--       ]
--         <#> \part -> part { value = replaceThinSpaces part.value }
--   }

test_PluralRules :: Effect Unit
test_PluralRules = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"

  Console.log "PluralRules.supportedLocalesOf"
  Test.assertEqual
    { actual: PluralRules.supportedLocalesOf en_US { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "PluralRules.supportedLocalesOf_"
  Test.assertEqual
    { actual: PluralRules.supportedLocalesOf_ en_US
    , expected: [ "en-US" ]
    }

  pluralRules <- PluralRules.new en_US { type: "ordinal" }

  Console.log "PluralRules.select"
  Test.assertEqual
    { actual: PluralRules.select pluralRules 1
    , expected: "one"
    }

  Console.log "PluralRules.resolvedOptions"
  resolvedOptions <- PluralRules.resolvedOptions pluralRules
  Test.assertEqual
    { actual: resolvedOptions
    , expected:
        { locale: "en"
        , pluralCategories: [ "few", "one", "two", "other" ]
        , type: "ordinal"
        }
    }

test_RelativeTimeFormat :: Effect Unit
test_RelativeTimeFormat = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"

  Console.log "RelativeTimeFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: RelativeTimeFormat.supportedLocalesOf en_US { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "RelativeTimeFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: RelativeTimeFormat.supportedLocalesOf_ en_US
    , expected: [ "en-US" ]
    }

  format <- RelativeTimeFormat.new en_US { numeric: "auto" }

  Console.log "RelativeTimeFormat.format"
  Test.assertEqual
    { actual: RelativeTimeFormat.format format (-1) Days
    , expected: "yesterday"
    }

  Console.log "RelativeTimeFormat.formatToParts"
  Test.assertEqual
    { actual: RelativeTimeFormat.formatToParts format (-1) Days
    , expected:
        [ { type: "literal", value: "yesterday" }
        ]
    }

  Console.log "RelativeTimeFormat.resolvedOptions"
  resolvedOptions <- RelativeTimeFormat.resolvedOptions format
  Test.assertEqual
    { actual: resolvedOptions
    , expected:
        { locale: "en-US"
        , numberingSystem: "latn"
        , numeric: "auto"
        , style: "long"
        }
    }

test_Segmenter :: Effect Unit
test_Segmenter = do
  en_US <- NonEmpty.singleton <$> Locale.new_ "en-US"

  Console.log "Segmenter.supportedLocalesOf"
  Test.assertEqual
    { actual: Segmenter.supportedLocalesOf en_US { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "Segmenter.supportedLocalesOf_"
  Test.assertEqual
    { actual: Segmenter.supportedLocalesOf_ en_US
    , expected: [ "en-US" ]
    }

  segmenter <- Segmenter.new en_US { granularity: "word" }

  Console.log "Segmenter.segment"
  Test.assertEqual
    { actual: Segmenter.segment segmenter "Hello, world!"
        # Array.mapMaybe \{ segment, isWordLike } ->
            if isWordLike then Just segment else Nothing
    , expected:
        [ "Hello", "world" ]
    }

  Console.log "Segmenter.resolvedOptions"
  resolvedOptions <- Segmenter.resolvedOptions segmenter
  Test.assertEqual
    { actual: resolvedOptions
    , expected:
        { locale: "en-US"
        , granularity: "word"
        }
    }
