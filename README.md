# `web-intl`

Low-level bindings for the ECMA 402 specification for the `Intl` object https://tc39.es/ecma402/#intl-object

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
import Partial.Unsafe as Unsafe
import Web.Intl.Collator as Collator
import Web.Intl.DateTimeFormat as DateTimeFormat
import Web.Intl.Locale as Locale
import Web.Intl.NumberFormat as NumberFormat

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

Now we can use the `Collator` module to sort a collection of strings by [natural sort order](https://en.wikipedia.org/wiki/Natural_sort_order),

```purs
  collator <- Collator.new locales { numeric: true }
  let
    sortedStrings =
      Array.sortBy (Collator.compare collator) [ "Chapter 1", "Chapter 11", "Chapter 2" ]
  Console.logShow sortedStrings -- [ "Chapter 1", "Chapter 2", "Chapter 11" ]
```

or we can format a range of dates using `DateTimeFormat`,

```purs
  dateTimeFormat <- DateTimeFormat.new locales { dateStyle: "full", timeZone: "UTC" }
  let
    maybeDate1 = JSDate.toDateTime (JSDate.fromTime 0.0)
    maybeDate2 = JSDate.toDateTime (JSDate.fromTime 1689832837416.0)
    formattedDateRange = Unsafe.unsafePartial case maybeDate1, maybeDate2 of
      Just date1, Just date2 -> DateTimeFormat.formatRange dateTimeFormat date1 date2
  Console.logShow formattedDateRange -- "Thursday, January 1, 1970 – Thursday, July 20, 2023"
```

or use `NumberFormat` for formatting currencies for example.

```purs
  numberFormat <- NumberFormat.new locales { style: "currency", currency: "USD" }
  let
    formattedNumber = NumberFormat.format numberFormat 123456.789
  Console.logShow formattedNumber -- "$123,456.79"
```

More examples are in the `Test.Main` module.

