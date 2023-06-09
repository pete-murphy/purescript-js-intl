module Test.Main where

import Prelude

import Data.Either (Either(..))
import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Data.String (Pattern(..), Replacement(..))
import Data.String as String
import Effect (Effect)
import Effect.Class.Console as Console
import Effect.Exception as Exception
import Record as Record
import Test.Assert as Test
import Web.Intl as Intl
import Web.Intl.Collator as Collator
import Web.Intl.DateTimeFormat as DateTimeFormat
import Web.Intl.NumberFormat as NumberFormat
import Web.Intl.PluralRules as PluralRules
import Web.Intl.RelativeTimeFormat as RelativeTimeFormat

main :: Effect Unit
main = do
  test_Intl

  test_Collator
  test_DateTimeFormat
  test_NumberFormat
  test_PluralRules
  test_RelativeTimeFormat

test_Intl :: Effect Unit
test_Intl = do
  Console.log "Intl.getCanonicalLocales"
  do
    actual <- Intl.getCanonicalLocales [ "EN-US" ]
    Test.assertEqual
      { actual
      , expected: [ "en-US" ]
      }
  do
    actual <- Intl.getCanonicalLocales [ "EN-US", "Fr" ]
    Test.assertEqual
      { actual
      , expected: [ "en-US", "fr" ]
      }
  do
    actual <- Exception.catchException (pure <<< Left <<< Exception.name) do
      Right <$> Intl.getCanonicalLocales [ "EN_US" ]
    Test.assertEqual
      { actual
      , expected: Left "RangeError"
      }

  Console.log "Intl.supportedValuesOf"
  do
    actual <- Intl.supportedValuesOf "calendar"
    Test.assertEqual
      { actual
      , expected:
          [ "buddhist"
          , "chinese"
          , "coptic"
          , "dangi"
          , "ethioaa"
          , "ethiopic"
          , "gregory"
          , "hebrew"
          , "indian"
          , "islamic"
          , "islamic-civil"
          , "islamic-rgsa"
          , "islamic-tbla"
          , "islamic-umalqura"
          , "iso8601"
          , "japanese"
          , "persian"
          , "roc"
          ]
      }
  do
    actual <- Intl.supportedValuesOf "collation"
    Test.assertEqual
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
  do
    actual <- Exception.catchException (pure <<< Left <<< Exception.name) do
      Right <$> Intl.supportedValuesOf "someInvalidKey"
    Test.assertEqual
      { actual
      , expected: Left "RangeError"
      }

test_Collator :: Effect Unit
test_Collator = do
  Console.log "Collator.supportedLocalesOf"
  Test.assertEqual
    { actual: Collator.supportedLocalesOf [ "en-US" ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Test.assertEqual
    { actual: Collator.supportedLocalesOf [ "en-US", "es-MX" ] { localeMatcher: "best fit" }
    , expected: [ "en-US", "es-MX" ]
    }

  Console.log "Collator.supportedLocalesOf_"
  Test.assertEqual
    { actual: Collator.supportedLocalesOf_ [ "en-US" ]
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: Collator.supportedLocalesOf_ [ "en-US", "es-MX" ]
    , expected: [ "en-US", "es-MX" ]
    }

  collator <- Collator.new [ "en-US" ] { sensitivity: "base" }

  Console.log "Collator##compare"
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

  Console.log "Collator##resolvedOptions"
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
  Console.log "DateTimeFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf [ "en-US" ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf [ "en-US", "es-MX" ] { localeMatcher: "best fit" }
    , expected: [ "en-US", "es-MX" ]
    }

  Console.log "DateTimeFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf_ [ "en-US" ]
    , expected: [ "en-US" ]
    }
  Test.assertEqual
    { actual: DateTimeFormat.supportedLocalesOf_ [ "en-US", "es-MX" ]
    , expected: [ "en-US", "es-MX" ]
    }

  format <- DateTimeFormat.new [ "en-US" ] { timeZone: "UTC" }
  let
    mkDate :: { month :: Number, day :: Number, year :: Number } -> JSDate
    mkDate = JSDate.jsdate <<< Record.merge
      { hour: 12.0
      , millisecond: 0.0
      , minute: 0.0
      , second: 0.0
      }
    date = mkDate { month: 11.0, day: 21.0, year: 2012.0 }
    date' = mkDate { month: 7.0, day: 23.0, year: 2013.0 }

  Console.log "DateTimeFormat##format"
  Test.assertEqual
    { actual: DateTimeFormat.format format date
    , expected: "12/21/2012"
    }

  Console.log "DateTimeFormat##formatRange"
  Test.assertEqual
    { actual: DateTimeFormat.formatRange format date date
    , expected: "12/21/2012"
    }
  Test.assertEqual
    { actual: DateTimeFormat.formatRange format date date'
        # String.replaceAll (Pattern "\x2009") (Replacement " ")
    , expected: "12/21/2012 – 8/23/2013"
        # String.replaceAll (Pattern "\x2009") (Replacement " ")
    }

  Console.log "DateTimeFormat##formatRangeToParts"
  Test.assertEqual
    { actual: DateTimeFormat.formatRangeToParts format date date
    , expected:
        [ { type: "month", value: "12" }
        , { type: "literal", value: "/" }
        , { type: "day", value: "21" }
        , { type: "literal", value: "/" }
        , { type: "year", value: "2012" }
        ]
    }

  Test.assertEqual
    { actual: DateTimeFormat.formatRangeToParts format date date'
        <#> \part -> part { value = String.trim part.value }
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
        ] <#> \part -> part { value = String.trim part.value }
    }

  Console.log "DateTimeFormat##formatToParts"
  Test.assertEqual
    { actual: DateTimeFormat.formatToParts format date
    , expected:
        [ { type: "month", value: "12" }
        , { type: "literal", value: "/" }
        , { type: "day", value: "21" }
        , { type: "literal", value: "/" }
        , { type: "year", value: "2012" }
        ]
    }

  Console.log "DateTimeFormat##resolvedOptions"
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

test_NumberFormat :: Effect Unit
test_NumberFormat = do
  Console.log "NumberFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: NumberFormat.supportedLocalesOf [ "en-US" ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "NumberFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: NumberFormat.supportedLocalesOf_ [ "en-US" ]
    , expected: [ "en-US" ]
    }

  format <- NumberFormat.new [ "en-US" ] { style: "currency", currency: "USD" }

  Console.log "NumberFormat##format"
  Test.assertEqual
    { actual: NumberFormat.format format 123456.789
    , expected: "$123,456.79"
    }

  Console.log "NumberFormat##formatToParts"
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

  Console.log "NumberFormat##resolvedOptions"
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

-- Console.log "NumberFormat##formatRange"
-- Test.assertEqual
--   { actual: NumberFormat.formatRange format 123456.789 987654.321
--       # String.replaceAll (Pattern "\x2009") (Replacement " ")
--   , expected: "$123,456.79–$987,654.32"
--       # String.replaceAll (Pattern "\x2009") (Replacement " ")
--   }

-- Console.log "NumberFormat##formatRangeToParts"
-- Test.assertEqual
--   { actual: NumberFormat.formatRangeToParts format 123456.789 987654.321
--       <#> \part -> part { value = String.trim part.value }
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
--         <#> \part -> part { value = String.trim part.value }
--   }

test_PluralRules :: Effect Unit
test_PluralRules = do
  Console.log "PluralRules.supportedLocalesOf"
  Test.assertEqual
    { actual: PluralRules.supportedLocalesOf [ "en-US" ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "PluralRules.supportedLocalesOf_"
  Test.assertEqual
    { actual: PluralRules.supportedLocalesOf_ [ "en-US" ]
    , expected: [ "en-US" ]
    }

  pluralRules <- PluralRules.new [ "en-US" ] { type: "ordinal" }

  Console.log "PluralRules##select"
  Test.assertEqual
    { actual: PluralRules.select pluralRules 1
    , expected: "one"
    }

  Console.log "PluralRules##resolvedOptions"
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
  Console.log "RelativeTimeFormat.supportedLocalesOf"
  Test.assertEqual
    { actual: RelativeTimeFormat.supportedLocalesOf [ "en-US" ] { localeMatcher: "best fit" }
    , expected: [ "en-US" ]
    }

  Console.log "RelativeTimeFormat.supportedLocalesOf_"
  Test.assertEqual
    { actual: RelativeTimeFormat.supportedLocalesOf_ [ "en-US" ]
    , expected: [ "en-US" ]
    }

  format <- RelativeTimeFormat.new [ "en-US" ] { numeric: "auto" }

  Console.log "RelativeTimeFormat##format"
  Test.assertEqual
    { actual: RelativeTimeFormat.format format (-1) "day"
    , expected: "yesterday"
    }

  Console.log "RelativeTimeFormat##formatToParts"
  Test.assertEqual
    { actual: RelativeTimeFormat.formatToParts format (-1) "day"
    , expected:
        [ { type: "literal", value: "yesterday" }
        ]
    }

  Console.log "RelativeTimeFormat##resolvedOptions"
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