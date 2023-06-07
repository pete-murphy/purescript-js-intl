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

import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.LocaleOptions (LocaleOptions)

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

foreign import data NumberFormat :: Type

foreign import _new
  :: EffectFn2
       (Array String)
       (Record NumberFormatOptions)
       NumberFormat

new
  :: forall options options'
   . Union options options' NumberFormatOptions
  => Array String
  -> Record options
  -> Effect NumberFormat
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

new_
  :: Array String
  -> Effect NumberFormat
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array String)
       (Record LocaleOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' LocaleOptions
  => Array String
  -> Record options
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2 _supportedLocalesOf locales (Unsafe.Coerce.unsafeCoerce options)

supportedLocalesOf_
  :: Array String
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales {}

foreign import _format
  :: Fn2
       NumberFormat
       Number
       String

format :: NumberFormat -> Number -> String
format = Function.Uncurried.runFn2 _format

foreign import _formatRange
  :: Fn3
       NumberFormat
       Number
       Number
       String

formatRange :: NumberFormat -> Number -> Number -> String
formatRange = Function.Uncurried.runFn3 _formatRange

foreign import _formatRangeToParts
  :: Fn3
       NumberFormat
       Number
       Number
       (Array { type :: String, value :: String })

formatRangeToParts :: NumberFormat -> Number -> Number -> Array { type :: String, value :: String }
formatRangeToParts = Function.Uncurried.runFn3 _formatRangeToParts

foreign import _formatToParts
  :: Fn2
       NumberFormat
       Number
       (Array { type :: String, value :: String })

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

resolvedOptions :: NumberFormat -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions