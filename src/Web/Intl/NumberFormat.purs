module Web.Intl.NumberFormat
  -- * Types
  ( NumberFormat
  , NumberFormatOptions

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
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.Locale (Locale)

-- | Language-sensitive number formatting
foreign import data NumberFormat :: Type

type NumberFormatOptions =
  ( compactDisplay :: String
  , currency :: String
  , currencyDisplay :: String
  , currencySign :: String
  , localeMatcher :: String
  , notation :: String
  , numberingSystem :: String
  , signDisplay :: String
  , style :: String
  , unit :: String
  , unitDisplay :: String
  , useGrouping :: Boolean -- TODO: Support strings & boolean
  , roundingMode :: String
  , roundingIncrement :: Int
  , roundingPriority :: String
  , trailingZeroDisplay :: String
  , minimumIntegerDigits :: Int
  , minimumFractionDigits :: Int
  , maximumFractionDigits :: Int
  , minimumSignificantDigits :: Int
  , maximumSignificantDigits :: Int
  )

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record NumberFormatOptions)
       NumberFormat

new
  :: forall options options'
   . Union options options' NumberFormatOptions
  => NonEmptyArray Locale
  -> Record options
  -> Effect NumberFormat
new locales options =
  Effect.Uncurried.runEffectFn2 _new (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

new_
  :: NonEmptyArray Locale
  -> Effect NumberFormat
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record NumberFormatOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' NumberFormatOptions
  => NonEmptyArray Locale
  -> Record options
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2 _supportedLocalesOf (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

supportedLocalesOf_
  :: NonEmptyArray Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales {}

foreign import _format
  :: Fn2
       NumberFormat
       Number
       String

-- | Formats a number according to the locale and formatting options of the
-- | `NumberFormat`
format :: NumberFormat -> Number -> String
format = Function.Uncurried.runFn2 _format

foreign import _formatRange
  :: Fn3
       NumberFormat
       Number
       Number
       String

-- | Formats a range of numbers according to the locale and formatting options
-- | of the `NumberFormat`
formatRange :: NumberFormat -> Number -> Number -> String
formatRange = Function.Uncurried.runFn3 _formatRange

foreign import _formatRangeToParts
  :: Fn3
       NumberFormat
       Number
       Number
       (Array { type :: String, value :: String })

-- | Returns an array of objects containing the locale-specific tokens from
-- | which it is possible to build custom strings while preserving the
-- | locale-specific parts
formatRangeToParts :: NumberFormat -> Number -> Number -> Array { type :: String, value :: String }
formatRangeToParts = Function.Uncurried.runFn3 _formatRangeToParts

foreign import _formatToParts
  :: Fn2
       NumberFormat
       Number
       (Array { type :: String, value :: String })

-- | Allows locale-aware formatting of strings produced by the `NumberFormat`
formatToParts :: NumberFormat -> Number -> Array { type :: String, value :: String }
formatToParts = Function.Uncurried.runFn2 _formatToParts

type ResolvedOptions =
  { locale :: String
  , numberingSystem :: String
  , style :: String
  , currency :: String
  , currencyDisplay :: String
  , currencySign :: String
  , minimumIntegerDigits :: Int
  , minimumFractionDigits :: Int
  , maximumFractionDigits :: Int
  , useGrouping :: Boolean
  , notation :: String
  , signDisplay :: String
  }

foreign import _resolvedOptions
  :: EffectFn1
       NumberFormat
       ResolvedOptions

resolvedOptions
  :: NumberFormat
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions