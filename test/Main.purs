module Test.Main where

import Prelude

import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Effect (Effect)
import Effect.Class.Console as Console
import Foreign.Object as Foreign.Object
import Record as Record
import Test.Assert as Test
import Web.Intl.DateTimeFormat as DateTimeFormat

main :: Effect Unit
main = do

  Console.log "DateTimeFormat.supportedLocalesOf"
  Test.assert (DateTimeFormat.supportedLocalesOf [ "en-US" ] { localeMatcher: "best fit" } == [ "en-US" ])
  Test.assert (DateTimeFormat.supportedLocalesOf [ "en-US", "es-MX" ] { localeMatcher: "best fit" } == [ "en-US", "es-MX" ])

  Console.log "DateTimeFormat.supportedLocalesOf_"
  Test.assert (DateTimeFormat.supportedLocalesOf_ [ "en-US" ] == [ "en-US" ])
  Test.assert (DateTimeFormat.supportedLocalesOf_ [ "en-US", "es-MX" ] == [ "en-US", "es-MX" ])

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
  Test.assert (DateTimeFormat.format format date == "12/21/2012")

  Console.log "DateTimeFormat##formatRange"
  Test.assert (DateTimeFormat.formatRange format date date == "12/21/2012")
  Test.assert (DateTimeFormat.formatRange format date date' == "12/21/2012 – 8/23/2013")

  Console.log "DateTimeFormat##formatRangeToParts"
  Test.assert do
    DateTimeFormat.formatRangeToParts format date date ==
      [ { type: "month", value: "12" }
      , { type: "literal", value: "/" }
      , { type: "day", value: "21" }
      , { type: "literal", value: "/" }
      , { type: "year", value: "2012" }
      ]
  Test.assert do
    DateTimeFormat.formatRangeToParts format date date' ==
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

  Console.log "DateTimeFormat##formatToParts"
  Test.assert do
    DateTimeFormat.formatToParts format date ==
      [ { type: "month", value: "12" }
      , { type: "literal", value: "/" }
      , { type: "day", value: "21" }
      , { type: "literal", value: "/" }
      , { type: "year", value: "2012" }
      ]

  Console.log "DateTimeFormat##resolvedOptions"
  Test.assert =<< do
    DateTimeFormat.resolvedOptions format <#>
      ( _ == Foreign.Object.fromHomogeneous
          { locale: "en-US"
          , calendar: "gregory"
          , numberingSystem: "latn"
          , timeZone: "America/New_York"
          , year: "numeric"
          , month: "numeric"
          , day: "numeric"
          }
      )
