module Test.Main (main) where

import Prelude

import Data.Array as Array
import Data.DateTime (DateTime(..))
import Data.DateTime as DateTime
import Data.Enum as Enum
import Data.Foldable as Foldable
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Maybe as Maybe
import Data.String (Pattern(..), Replacement(..))
import Data.String as String
import Effect (Effect)
import Effect.Class.Console as Console
import Foreign as Foreign
import JS.Intl as Intl
import JS.Intl.Collator as Collator
import JS.Intl.DateTimeFormat as DateTimeFormat
import JS.Intl.DisplayNames as DisplayNames
import JS.Intl.ListFormat as ListFormat
import JS.Intl.Locale as Locale
import JS.Intl.NumberFormat as NumberFormat
import JS.Intl.Options.AvailableCanonical as AvailableCanonical
import JS.Intl.Options.CaseFirst as CaseFirst
import JS.Intl.Options.Collation as Collation
import JS.Intl.Options.DateStyle as DateStyle
import JS.Intl.Options.HourCycle as HourCycle
import JS.Intl.Options.LocaleMatcher (LocaleMatcher(..))
import JS.Intl.Options.NumberFormatStyle as NumberFormatStyle
import JS.Intl.Options.PluralCategory (PluralCategory(..))
import JS.Intl.Options.PluralCategory as PluralCategory
import JS.Intl.Options.RelativeTimeUnit (RelativeTimeUnit(..))
import JS.Intl.Options.Sensitivity (Sensitivity(..))
import JS.Intl.Options.TimeStyle as TimeStyle
import JS.Intl.Options.Usage (Usage(..))
import JS.Intl.PluralRules as PluralRules
import JS.Intl.RelativeTimeFormat as RelativeTimeFormat
import JS.Intl.Segmenter as Segmenter
import JS.LocaleSensitive.Date as LocaleSensitive.Date
import JS.LocaleSensitive.Number as LocaleSensitive.Number
import JS.LocaleSensitive.String as LocaleSensitive.String
import Partial.Unsafe as Unsafe
import Test.Assert.Extended as Test
import Unsafe.Coerce as Unsafe.Coerce

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

  test_LocaleSensitive

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
  en_US <- Locale.new_ "en-US"
  es_MX <- Locale.new_ "es-MX"

  Console.log "Collator.supportedLocalesOf"
  Test.assertEqual
    { actual: Collator.supportedLocalesOf [ en_US ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Test.assertEqual
    { actual: Collator.supportedLocalesOf [ en_US, es_MX ] { localeMatcher: "best fit" }
    , expected: [ "en-US", "es-MX" ]
    }

  Console.log "Collator.supportedLocalesOf_"
  Test.assertEqual
    { actual: Collator.supportedLocalesOf_ [ en_US ]
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: Collator.supportedLocalesOf_ [ en_US, es_MX ]
    , expected: [ "en-US", "es-MX" ]
    }

  do
    collator <- Collator.new [ en_US ] { sensitivity: "base" }

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
    collator <- Collator.new [ en_US ] { sensitivity: "base" }

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

  do
    collator <- Collator.new [ en_US ] { sensitivity: Base, localeMatcher: Lookup, usage: Search }

    Console.log "Collator.resolvedOptions"
    resolvedOptions <- Collator.resolvedOptions collator
    Test.assertEqual
      { actual: resolvedOptions
      , expected:
          { locale: "en-US"
          , usage: "search"
          , sensitivity: "base"
          , ignorePunctuation: false
          , collation: "default"
          , numeric: false
          , caseFirst: "false"
          }
      }

test_DateTimeFormat :: Effect Unit
test_DateTimeFormat = do
  en_US <- Locale.new_ "en-US"
  es_MX <- Locale.new_ "es-MX"

  Console.log "DateTimeFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf [ en_US ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf [ en_US, es_MX ] { localeMatcher: "best fit" }
    , expected: [ "en-US", "es-MX" ]
    }

  Console.log "DateTimeFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf_ [ en_US ]
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf_ [ en_US, es_MX ]
    , expected: [ "en-US", "es-MX" ]
    }

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

  do
    format <- DateTimeFormat.new [ en_US ] { timeZone: "UTC" }

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
      { actual: (Foreign.unsafeFromForeign resolvedOptions)
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

  do
    format <- DateTimeFormat.new [ en_US ]
      { timeZone: "UTC"
      , dateStyle: DateStyle.Full
      , timeStyle: TimeStyle.Full
      }

    Console.log "DateTimeFormat.format"
    Test.assertEqual
      { actual: DateTimeFormat.format format date1
      , expected: "Friday, December 21, 2012 at 12:00:00 AM Coordinated Universal Time"
      }

    Console.log "DateTimeFormat.formatRange"
    Test.assertEqual
      { actual: DateTimeFormat.formatRange format date1 date1
      , expected: "Friday, December 21, 2012 at 12:00:00 AM Coordinated Universal Time"
      }
    Test.assertEqual
      { actual: DateTimeFormat.formatRange format date1 date2
          # replaceThinSpaces
      , expected: "Friday, December 21, 2012 at 12:00:00 AM Coordinated Universal Time – Friday, August 23, 2013 at 12:00:00 AM Coordinated Universal Time"
          # replaceThinSpaces
      }

    Console.log "DateTimeFormat.formatRangeToParts"
    Test.assertEqual
      { actual: DateTimeFormat.formatRangeToParts format date1 date1
      , expected:
          [ { type: "weekday", value: "Friday" }
          , { type: "literal", value: ", " }
          , { type: "month", value: "December" }
          , { type: "literal", value: " " }
          , { type: "day", value: "21" }
          , { type: "literal", value: ", " }
          , { type: "year", value: "2012" }
          , { type: "literal", value: " at " }
          , { type: "hour", value: "12" }
          , { type: "literal", value: ":" }
          , { type: "minute", value: "00" }
          , { type: "literal", value: ":" }
          , { type: "second", value: "00" }
          , { type: "literal", value: " " }
          , { type: "dayPeriod", value: "AM" }
          , { type: "literal", value: " " }
          , { type: "timeZoneName", value: "Coordinated Universal Time" }
          ]
      }

    Test.assertEqual
      { actual: DateTimeFormat.formatRangeToParts format date1 date2
          <#> \part -> part { value = replaceThinSpaces part.value }
      , expected:
          [ { type: "weekday", value: "Friday" }
          , { type: "literal", value: ", " }
          , { type: "month", value: "December" }
          , { type: "literal", value: " " }
          , { type: "day", value: "21" }
          , { type: "literal", value: ", " }
          , { type: "year", value: "2012" }
          , { type: "literal", value: " at " }
          , { type: "hour", value: "12" }
          , { type: "literal", value: ":" }
          , { type: "minute", value: "00" }
          , { type: "literal", value: ":" }
          , { type: "second", value: "00" }
          , { type: "literal", value: " " }
          , { type: "dayPeriod", value: "AM" }
          , { type: "literal", value: " " }
          , { type: "timeZoneName", value: "Coordinated Universal Time" }
          , { type: "literal", value: " – " }
          , { type: "weekday", value: "Friday" }
          , { type: "literal", value: ", " }
          , { type: "month", value: "August" }
          , { type: "literal", value: " " }
          , { type: "day", value: "23" }
          , { type: "literal", value: ", " }
          , { type: "year", value: "2013" }
          , { type: "literal", value: " at " }
          , { type: "hour", value: "12" }
          , { type: "literal", value: ":" }
          , { type: "minute", value: "00" }
          , { type: "literal", value: ":" }
          , { type: "second", value: "00" }
          , { type: "literal", value: " " }
          , { type: "dayPeriod", value: "AM" }
          , { type: "literal", value: " " }
          , { type: "timeZoneName", value: "Coordinated Universal Time" }
          ] <#> \part -> part { value = replaceThinSpaces part.value }
      }

    Console.log "DateTimeFormat.formatToParts"
    Test.assertEqual
      { actual: DateTimeFormat.formatToParts format date1
      , expected:
          [ { type: "weekday", value: "Friday" }
          , { type: "literal", value: ", " }
          , { type: "month", value: "December" }
          , { type: "literal", value: " " }
          , { type: "day", value: "21" }
          , { type: "literal", value: ", " }
          , { type: "year", value: "2012" }
          , { type: "literal", value: " at " }
          , { type: "hour", value: "12" }
          , { type: "literal", value: ":" }
          , { type: "minute", value: "00" }
          , { type: "literal", value: ":" }
          , { type: "second", value: "00" }
          , { type: "literal", value: " " }
          , { type: "dayPeriod", value: "AM" }
          , { type: "literal", value: " " }
          , { type: "timeZoneName", value: "Coordinated Universal Time" }
          ]
      }

    Console.log "DateTimeFormat.resolvedOptions"
    resolvedOptions <- DateTimeFormat.resolvedOptions format
    Test.assertEqual
      { actual: (Foreign.unsafeFromForeign resolvedOptions)
      , expected:
          { locale: "en-US"
          , calendar: "gregory"
          , numberingSystem: "latn"
          , timeZone: "UTC"
          , hourCycle: "h12"
          , hour12: true
          , dateStyle: "full"
          , timeStyle: "full"
          }
      }

test_DisplayNames :: Effect Unit
test_DisplayNames = do
  en_US <- Locale.new_ "en-US"

  Console.log "DisplayNames.supportedLocalesOf"
  Test.assertEqual
    { actual: DisplayNames.supportedLocalesOf [ en_US ] { type: "language" }
    , expected: [ "en-US" ]
    }

  displayNames <- DisplayNames.new [ en_US ] { type: "language" }

  Console.log "DisplayNames.of_"
  Test.assertEqual
    { actual: DisplayNames.of_ displayNames "en-US"
    , expected: Just "American English"
    }

test_ListFormat :: Effect Unit
test_ListFormat = do
  en_US <- Locale.new_ "en-US"

  Console.log "List.supportedLocalesOf"
  Test.assertEqual
    { actual: ListFormat.supportedLocalesOf [ en_US ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "List.supportedLocalesOf_"
  Test.assertEqual
    { actual: ListFormat.supportedLocalesOf_ [ en_US ]
    , expected: [ "en-US" ]
    }

  format <- ListFormat.new [ en_US ] { style: "long", type: "conjunction" }

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
  do
    locale <- Locale.new_ "en-US"
    Test.assertEqual
      { actual: Locale.baseName locale
      , expected: "en-US"
      }

  Console.log "Locale.calendar"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqual
      { actual: Locale.calendar en_US
      , expected: Nothing
      }
    fr_FR_u_ca_buddhist <- Locale.new_ "fr-FR-u-ca-buddhist"
    Test.assertEqual
      { actual: Locale.calendar fr_FR_u_ca_buddhist
      , expected: Just "buddhist"
      }
    fr_FR' <- Locale.new "fr-FR" { calendar: "buddhist" }
    Test.assertEqual
      { actual: Locale.calendar fr_FR'
      , expected: Just "buddhist"
      }

  Console.log "Locale.caseFirst"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqualWith (show <<< map CaseFirst.toString)
      { actual: Locale.caseFirst en_US
      , expected: Nothing
      }
  Foldable.for_ [ CaseFirst.False, CaseFirst.Lower, CaseFirst.Upper ] \caseFirst -> do
    en_US <-
      Locale.new "en-US" { caseFirst }
    Test.assertEqualWith (show <<< map CaseFirst.toString)
      { actual: Locale.caseFirst en_US
      , expected: Just caseFirst
      }

  Console.log "Locale.caseFirst"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqualWith (show <<< map Collation.toString)
      { actual: Locale.collation en_US
      , expected: Nothing
      }
  Foldable.for_ [ Collation.Compat, Collation.Default, Collation.Dict, Collation.Emoji, Collation.Phonebk ] \collation -> do
    en_US <-
      Locale.new "en-US" { collation }
    Test.assertEqualWith (show <<< map Collation.toString)
      { actual: Locale.collation en_US
      , expected: Just collation
      }

  Console.log "Locale.hourCycle"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqualWith (show <<< map HourCycle.toString)
      { actual: Locale.hourCycle en_US
      , expected: Nothing
      }
  Foldable.for_ [ HourCycle.H11, HourCycle.H12, HourCycle.H23, HourCycle.H24 ] \hourCycle -> do
    en_US <-
      Locale.new "en-US" { hourCycle }
    Test.assertEqualWith (show <<< map HourCycle.toString)
      { actual: Locale.hourCycle en_US
      , expected: Just hourCycle
      }

  Console.log "Locale.numeric"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqual
      { actual: Locale.numeric en_US
      , expected: false
      }
    en_US' <- Locale.new "en-US" { numeric: true }
    Test.assertEqual
      { actual: Locale.numeric en_US'
      , expected: true
      }

  Console.log "Locale.numberingSystem"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqual
      { actual: Locale.numberingSystem en_US
      , expected: Nothing
      }
    en_US' <- Locale.new "en-US" { numberingSystem: "latn" }
    Test.assertEqual
      { actual: Locale.numberingSystem en_US'
      , expected: Just "latn"
      }

  Console.log "Locale.language"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqual
      { actual: Locale.language en_US
      , expected: "en"
      }
    en_US' <- Locale.new "en-US" { language: "fr" }
    Test.assertEqual
      { actual: Locale.language en_US'
      , expected: "fr"
      }

  Console.log "Locale.script"
  do
    en_US <- Locale.new_ "en-US"
    Test.assertEqual
      { actual: Locale.script en_US
      , expected: Nothing
      }
    en_US' <- Locale.new "en-US" { script: "Latn" }
    Test.assertEqual
      { actual: Locale.script en_US'
      , expected: Just "Latn"
      }

  Console.log "Locale.region"
  do
    en <- Locale.new_ "en"
    Test.assertEqual
      { actual: Locale.region en
      , expected: Nothing
      }
    en_US <- Locale.new_ "en-US"
    Test.assertEqual
      { actual: Locale.region en_US
      , expected: Just "US"
      }
    en_US' <- Locale.new "en-US" { region: "FR" }
    Test.assertEqual
      { actual: Locale.region en_US'
      , expected: Just "FR"
      }

test_NumberFormat :: Effect Unit
test_NumberFormat = do
  en_US <- Locale.new_ "en-US"

  Console.log "NumberFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: NumberFormat.supportedLocalesOf [ en_US ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "NumberFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: NumberFormat.supportedLocalesOf_ [ en_US ]
    , expected: [ "en-US" ]
    }

  format <- NumberFormat.new [ en_US ] { style: "currency", currency: "USD" }

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
    { actual: (Unsafe.Coerce.unsafeCoerce resolvedOptions)
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
  en_US <- Locale.new_ "en-US"

  Console.log "PluralRules.supportedLocalesOf"
  Test.assertEqual
    { actual: PluralRules.supportedLocalesOf [ en_US ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "PluralRules.supportedLocalesOf_"
  Test.assertEqual
    { actual: PluralRules.supportedLocalesOf_ [ en_US ]
    , expected: [ "en-US" ]
    }

  pluralRules <- PluralRules.new [ en_US ] { type: "ordinal" }

  Console.log "PluralRules.select"
  Test.assertEqualWith PluralCategory.toString
    { actual: PluralRules.select pluralRules 1
    , expected: One
    }

  Console.log "PluralRules.resolvedOptions"
  resolvedOptions <- PluralRules.resolvedOptions pluralRules
  Test.assertEqualWith (show <<< \opts -> opts { pluralCategories = map PluralCategory.toString opts.pluralCategories })
    { actual: resolvedOptions
    , expected:
        { locale: "en"
        , pluralCategories: [ Few, One, Two, Other ]
        , type: "ordinal"
        }
    }

test_RelativeTimeFormat :: Effect Unit
test_RelativeTimeFormat = do
  en_US <- Locale.new_ "en-US"

  Console.log "RelativeTimeFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: RelativeTimeFormat.supportedLocalesOf [ en_US ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "RelativeTimeFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: RelativeTimeFormat.supportedLocalesOf_ [ en_US ]
    , expected: [ "en-US" ]
    }

  format <- RelativeTimeFormat.new [ en_US ] { numeric: "auto" }

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
  en_US <- Locale.new_ "en-US"

  Console.log "Segmenter.supportedLocalesOf"
  Test.assertEqual
    { actual: Segmenter.supportedLocalesOf [ en_US ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "Segmenter.supportedLocalesOf_"
  Test.assertEqual
    { actual: Segmenter.supportedLocalesOf_ [ en_US ]
    , expected: [ "en-US" ]
    }

  segmenter <- Segmenter.new [ en_US ] { granularity: "word" }

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

test_LocaleSensitive :: Effect Unit
test_LocaleSensitive = do
  en_US <- Locale.new_ "en-US"
  dec4 <- unsafeParseDateTime "2020-12-04T00:00:00Z"

  Console.log "LocaleSensitive.Date.toLocaleString"
  do
    actual <- LocaleSensitive.Date.toLocaleString [ en_US ] { timeZone: "UTC" } dec4
    Test.assertEqual
      { actual
      , expected: "12/4/2020, 12:00:00 AM"
      }

  Console.log "LocaleSensitive.Date.toLocaleDateString"
  do
    actual <- LocaleSensitive.Date.toLocaleDateString [ en_US ] { timeZone: "UTC" } dec4
    Test.assertEqual
      { actual
      , expected: "12/4/2020"
      }

  Console.log "LocaleSensitive.Date.toLocaleTimeString"
  do
    actual <- LocaleSensitive.Date.toLocaleTimeString [ en_US ] { timeZone: "UTC" } dec4
    Test.assertEqual
      { actual
      , expected: "12:00:00 AM"
      }

  Console.log "LocaleSensitive.String.localeCompare"
  do
    actual <- LocaleSensitive.String.localeCompare [ en_US ] {} "ä" "b"
    Test.assertEqual
      { actual
      , expected: LT
      }
  do
    actual <- LocaleSensitive.String.localeCompare [ en_US ] {} "a" "a"
    Test.assertEqual
      { actual
      , expected: EQ
      }
  do
    actual <- LocaleSensitive.String.localeCompare [ en_US ] { numeric: false } "12" "100"
    Test.assertEqual
      { actual
      , expected: GT
      }
  do
    actual <- LocaleSensitive.String.localeCompare [ en_US ] { numeric: true } "12" "100"
    Test.assertEqual
      { actual
      , expected: LT
      }

  Console.log "LocaleSensitive.String.toLocaleLowerCase"
  do
    actual <- LocaleSensitive.String.toLocaleLowerCase [ en_US ] "İstanbul"
    Test.assertEqual
      { actual
      , expected: "i̇stanbul"
      }
  do
    tr <- Locale.new_ "tr"
    actual <- LocaleSensitive.String.toLocaleLowerCase [ tr ] "İstanbul"
    Test.assertEqual
      { actual
      , expected: "istanbul"
      }

  Console.log "LocaleSensitive.String.toLocaleUpperCase"
  do
    actual <- LocaleSensitive.String.toLocaleUpperCase [ en_US ] "istanbul"
    Test.assertEqual
      { actual
      , expected: "ISTANBUL"
      }
  do
    tr <- Locale.new_ "tr"
    actual <- LocaleSensitive.String.toLocaleUpperCase [ tr ] "istanbul"
    Test.assertEqual
      { actual
      , expected: "İSTANBUL"
      }

  Console.log "LocaleSensitive.Number.toLocaleString"
  do
    actual <- LocaleSensitive.Number.toLocaleString [ en_US ] {} 123456.789
    Test.assertEqual
      { actual
      , expected: "123,456.789"
      }
  do
    ar_EG <- Locale.new_ "ar-EG"
    actual <- LocaleSensitive.Number.toLocaleString [ ar_EG ] {} 123456.789
    Test.assertEqual
      { actual
      , expected: "١٢٣٬٤٥٦٫٧٨٩"
      }
  do
    actual <- LocaleSensitive.Number.toLocaleString [ en_US ] { style: NumberFormatStyle.Currency, currency: "USD", maximumSignificantDigits: 3 } 123456.789
    Test.assertEqual
      { actual
      , expected: "$123,000"
      }

unsafeParseDateTime :: String -> Effect DateTime
unsafeParseDateTime string = Unsafe.unsafePartial do
  Maybe.fromJust <<< JSDate.toDateTime <$> JSDate.parse string
