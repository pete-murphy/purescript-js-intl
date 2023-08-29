<!-- This file was generated using `script/generate-readme.sh` -->

# `js-intl`

Low-level bindings for the ECMA 402 specification for the `Intl` object https://tc39.es/ecma402/#intl-object (MDN Documentation: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl)

> :warning: _Note:_ implementations of the specification vary across platforms. For example `Intl.supportedValuesOf` will return different values when run in Node compared to Chrome or Firefox, etc., and are also likely to vary across versions of the same platform. Some areas of the API only have partial support—like `Segmenter` or `NumberFormat.formatRange` at time of writing.

## How to use this library


Assuming these imports

```purs
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
import JS.Intl.Options.DateStyle as DateStyle
import JS.Intl.Options.NumberFormatStyle as NumberFormatStyle
import Partial.Unsafe as Unsafe

```

we can construct a `Locale` using the `new` or `new_` constructors.

```purs
main :: Effect Unit
main = do
  en_US <- Locale.new_ "en-US"
```

All service constructors take a non-empty array of locales as first argument.

```purs
  let locales = NonEmpty.singleton en_US
```

Now we can use the `Collator` module to sort a collection of strings by
[natural sort order](https://en.wikipedia.org/wiki/Natural_sort_order),

```purs
  collator <- Collator.new locales { numeric: true }
  let
    sortedStrings =
      Array.sortBy (Collator.compare collator) [ "Chapter 1", "Chapter 11", "Chapter 2" ]
  Console.logShow sortedStrings -- [ "Chapter 1", "Chapter 2", "Chapter 11" ]
```

or we can format a range of dates using `DateTimeFormat`,

```purs
  dateTimeFormat <- DateTimeFormat.new locales { dateStyle: DateStyle.Medium, timeZone: "UTC" }

  maybeDate1 <- JSDate.toDateTime <$> JSDate.parse "07/16/2023"
  maybeDate2 <- JSDate.toDateTime <$> JSDate.parse "07/20/2023"
  let
    formattedDateRange = Unsafe.unsafePartial case maybeDate1, maybeDate2 of
      Just date1, Just date2 -> DateTimeFormat.formatRange dateTimeFormat date1 date2
  Console.logShow formattedDateRange -- "Jul 16 – 20, 2023"
```

or use `NumberFormat` for formatting currencies for example.

```purs
  numberFormat <- NumberFormat.new locales { style: NumberFormatStyle.Currency, currency: "USD" }
  let
    formattedNumber = NumberFormat.format numberFormat 123456.789
  Console.logShow formattedNumber -- "$123,456.79"
```


More examples are in the `Test.Main` module.

