<!-- This file was generated using `script/generate-readme.sh` -->

# js-intl

[![Latest release](http://img.shields.io/github/release/pete-murphy/purescript-js-intl.svg)](https://github.com/pete-murphy/purescript-js-intl/releases)
[![Build status](https://github.com/pete-murphy/purescript-js-intl/workflows/CI/badge.svg?branch=main)](https://github.com/pete-murphy/purescript-js-intl/actions?query=workflow%3ACI+branch%3Amain)
[![Pursuit](https://pursuit.purescript.org/packages/purescript-js-intl/badge)](https://pursuit.purescript.org/packages/purescript-js-intl)

Type definitions and low-level bindings for the `Intl` object.

## Installation

```
spago install js-intl
```

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-js-intl).

See also: the ECMA-402 specification published [here](https://tc39.es/ecma402/), MDN documentation for `Intl` [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl).

## How to use this library


Assuming these imports

```purs
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
import JS.Intl.Options.PluralCategory (PluralCategory(..))
import JS.Intl.Options.UnitDisplay as UnitDisplay
import JS.Intl.PluralRules as PluralRules
import JS.Intl.Segmenter as Segmenter
import Partial.Unsafe as Unsafe

```

### Construct a `Locale`

Use the `new` constructor (or `new_` if you don't care to pass `LocaleOptions`) 
to create a `Locale`

```purs
main :: Effect Unit
main = do
  en_US <- Locale.new_ "en-US"
```

This `Locale` is then passed as an argument to the various `Intl` service
constructors.

### Format a date

```purs
  let
    unsafeParseDateTime string = Unsafe.unsafePartial do
      Maybe.fromJust <<< JSDate.toDateTime <$> JSDate.parse string

  sep22 <- unsafeParseDateTime "2023-09-22T14:30-04:00"

  dateTimeFormat <-
    DateTimeFormat.new [ en_US ]
      { weekday: "long"
      , hour: "numeric"
      , minute: "numeric"
      , timeZone: "America/New_York"
      }

  let
    formattedDate =
      DateTimeFormat.format dateTimeFormat sep22

  Console.log formattedDate -- Friday 2:30 PM
```

### Format a date range

```purs
  sep30 <- unsafeParseDateTime "2023-09-30"

  dateTimeRangeFormat <-
    DateTimeFormat.new [ en_US ]
      { dateStyle: "medium"
      , timeZone: "UTC"
      }

  let
    formattedDateRange =
      DateTimeFormat.formatRange dateTimeRangeFormat sep22 sep30

  Console.log formattedDateRange -- Sep 22 – 30, 2023
```

### Sort a collection of strings by natural sort order

```purs
  collator <- Collator.new [ en_US ] { numeric: true }

  let
    sortedStrings =
      Array.sortBy (Collator.compare collator) [ "Chapter 1", "Chapter 11", "Chapter 2" ]

  Console.logShow sortedStrings -- ["Chapter 1","Chapter 2","Chapter 11"]
```

### Format a number as currency

```purs
  usdCurrencyFormat <-
    NumberFormat.new [ en_US ]
      { style: "currency"
      , currency: "USD"
      }

  let
    formattedUSD = NumberFormat.format usdCurrencyFormat 123456.789

  Console.log formattedUSD -- $123,456.79
```

### Format a number as megabytes (or whatever unit)

```purs
  mbNumberFormat <-
    NumberFormat.new [ en_US ]
      { style: "unit"
      , unit: "megabyte"
      , maximumFractionDigits: 0
      }

  let
    formattedMB = NumberFormat.format mbNumberFormat 123456.789

  Console.log formattedMB -- 123,457 MB
```

### Get a list of words from a sentence

```purs
  segmenter <- Segmenter.new [ en_US ] { granularity: "word" }

  let
    sentence = "Hey! How are ya, Jim?"
    words = Segmenter.segment segmenter sentence
      # Array.mapMaybe \{ isWordLike, segment } ->
          if isWordLike then
            Just segment
          else Nothing

  Console.logShow words -- ["Hey","How","are","ya","Jim"]
```

### Format numbers as ordinal (1st, 2nd, 3rd, etc.)

```purs
  let
    ordinalSuffix :: PluralCategory -> String
    ordinalSuffix = case _ of
      Zero -> "th"
      One -> "st"
      Two -> "nd"
      Few -> "rd"
      Many -> "th"
      Other -> "th"

  pluralRules <- PluralRules.new [ en_US ] { type: "ordinal" }

  let
    numbers = [ 1, 2, 3, 8, 21 ]
    formattedOrdinals = numbers <#> \number -> do
      let
        suffix = ordinalSuffix (PluralRules.select pluralRules number)
      show number <> suffix

  Console.logShow formattedOrdinals -- ["1st","2nd","3rd","8th","21st"]
```

### Type safety and overloaded API

In the examples above we mostly passed string values as options to the
service constructors. Many `String`-typed options only have a few valid
strings that can be passed in. For example, the `style` option for
`NumberFormat` only accepts the values `"currency"`, `"decimal"`,
`"percent"`, and `"unit"`. Passing in any other value will throw a
`RangeError` from JavaScript.
```
> new Intl.NumberFormat("en-US", { style: "oops" })
Uncaught:
RangeError: Value oops out of range for Intl.NumberFormat options property style
at new NumberFormat (<anonymous>)
```
This library doesn't prevent you from passing invalid strings, and it
generally won't catch any errors for you. However, for ease of
discoverability of valid options, there are enums in the `JS.Intl.Options`
modules for most of the option types, and the service constructors are
overloaded to accept these values as well.
```purs
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
```
See the `ConvertOption` type class instances in each of the service
constructor modules to see what options are available as typed enums. Note
that even when using the typed enums there are still some invalid
combinations of options that will throw an error, like specifying `timeStyle`
_and_ `fractionalSecondDigits` in the `DateTimeFormat` options. Reference
[the official specification](https://tc39.es/ecma402) for details on valid
combinations.


More examples are in the `Test.Main` module.

