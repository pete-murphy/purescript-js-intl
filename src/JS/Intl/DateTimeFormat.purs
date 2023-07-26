module JS.Intl.DateTimeFormat
  -- * Types
  ( DateTimeFormat
  , DateTimeFormatOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , format
  , formatRange
  , formatRangeToParts
  , formatToParts
  , resolvedOptions
  ) where

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.DateTime (DateTime)
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Data.JSDate (JSDate)
import Data.JSDate as JSDate
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce

-- | Language-sensitive date and time formatting
foreign import data DateTimeFormat :: Type

type DateTimeFormatOptions =
  ( localeMatcher :: String
  , weekday :: String
  , era :: String
  , year :: String
  , month :: String
  , day :: String
  , hour :: String
  , minute :: String
  , second :: String
  , timeZoneName :: String
  , formatMatcher :: String
  , hour12 :: Boolean
  , timeZone :: String
  , hourCycle :: String
  , dateStyle :: String
  , timeStyle :: String
  )

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record DateTimeFormatOptions)
       DateTimeFormat

new
  :: forall options options'
   . Union options options' DateTimeFormatOptions
  => NonEmptyArray Locale
  -> Record options
  -> Effect DateTimeFormat
new locales options =
  Effect.Uncurried.runEffectFn2
    _new
    (NonEmpty.toArray locales)
    (Unsafe.Coerce.unsafeCoerce options)

new_
  :: NonEmptyArray Locale
  -> Effect DateTimeFormat
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record DateTimeFormatOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' DateTimeFormatOptions
  => NonEmptyArray Locale
  -> Record options
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    (NonEmpty.toArray locales)
    (Unsafe.Coerce.unsafeCoerce options)

supportedLocalesOf_
  :: NonEmptyArray Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales {}

foreign import _format
  :: Fn2
       DateTimeFormat
       JSDate
       String

-- | Formats a date according to the locale and formatting options of the
-- | `DateTimeFormat`
format
  :: DateTimeFormat
  -> DateTime
  -> String
format fmt dateTime = Function.Uncurried.runFn2 _format fmt (JSDate.fromDateTime dateTime)

foreign import _formatRange
  :: Fn3
       DateTimeFormat
       JSDate
       JSDate
       String

-- | Formats a date range in the most concise way based on the locales and
-- | options provided for this `DateTimeFormat` instance
formatRange
  :: DateTimeFormat
  -> DateTime
  -> DateTime
  -> String
formatRange fmt dateTime1 dateTime2 =
  Function.Uncurried.runFn3
    _formatRange
    fmt
    (JSDate.fromDateTime dateTime1)
    (JSDate.fromDateTime dateTime2)

foreign import _formatRangeToParts
  :: Fn3
       DateTimeFormat
       JSDate
       JSDate
       (Array { type :: String, value :: String })

-- | Returns an array of locale-specific tokens representing each part of the
-- | formatted date range produced by the `DateTimeFormat` instance
formatRangeToParts
  :: DateTimeFormat
  -> DateTime
  -> DateTime
  -> Array { type :: String, value :: String }
formatRangeToParts fmt dateTime1 dateTime2 =
  Function.Uncurried.runFn3
    _formatRangeToParts
    fmt
    (JSDate.fromDateTime dateTime1)
    (JSDate.fromDateTime dateTime2)

foreign import _formatToParts
  :: Fn2
       DateTimeFormat
       JSDate
       (Array { type :: String, value :: String })

-- | Returns an array of locale-specific tokens representing each part of the
-- | formatted date produced by the `DateTimeFormat` instance
formatToParts
  :: DateTimeFormat
  -> DateTime
  -> Array { type :: String, value :: String }
formatToParts fmt dateTime =
  Function.Uncurried.runFn2
    _formatToParts
    fmt
    (JSDate.fromDateTime dateTime)

type ResolvedOptions =
  { locale :: String
  , calendar :: String
  , numberingSystem :: String
  , timeZone :: String
  , year :: String
  , month :: String
  , day :: String
  }

foreign import _resolvedOptions
  :: EffectFn1
       DateTimeFormat
       ResolvedOptions

resolvedOptions
  :: DateTimeFormat
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions