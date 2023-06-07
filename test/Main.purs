module Test.Main where

import Prelude

import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Effect (Effect)
import Effect.Class.Console as Console
import Record as Record
import Test.Assert as Test
import Web.Intl.DateTimeFormat as DateTimeFormat

main :: Effect Unit
main = do
  test_DateTimeFormat

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

  format <- DateTimeFormat.new_ [ "en-US" ]
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
    , expected: "12/21/2012 – 8/23/2013"
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
        ]
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
        , timeZone: "America/New_York"
        , year: "numeric"
        , month: "numeric"
        , day: "numeric"
        }
    }

