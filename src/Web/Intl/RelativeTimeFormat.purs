module Web.Intl.RelativeTimeFormat
  -- * Types
  ( RelativeTimeFormat
  , RelativeTimeFormatOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , format
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
import Web.Intl.Internal.Class.StringArg as StringArg
import Web.Intl.Locale (Locale)
import Web.Intl.RelativeTimeUnit (RelativeTimeUnit)

foreign import data RelativeTimeFormat :: Type

type RelativeTimeFormatOptions =
  ( localeMatcher :: String
  , numeric :: String
  , style :: String
  )

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record RelativeTimeFormatOptions)
       RelativeTimeFormat

new
  :: forall options options'
   . Union options options' RelativeTimeFormatOptions
  => Array Locale
  -> Record options
  -> Effect RelativeTimeFormat
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

new_
  :: Array Locale
  -> Effect RelativeTimeFormat
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record RelativeTimeFormatOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' RelativeTimeFormatOptions
  => Array Locale
  -> Record options
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2 _supportedLocalesOf locales (Unsafe.Coerce.unsafeCoerce options)

supportedLocalesOf_
  :: Array Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales {}

foreign import _format
  :: Fn3
       RelativeTimeFormat
       Int
       String
       String

format
  :: RelativeTimeFormat
  -> Int
  -> RelativeTimeUnit
  -> String
format relativeTimeFormat n relativeTimeUnit =
  Function.Uncurried.runFn3 _format relativeTimeFormat n (StringArg.from relativeTimeUnit)

foreign import _formatToParts
  :: Fn3
       RelativeTimeFormat
       Int
       String
       (Array { type :: String, value :: String })

formatToParts
  :: RelativeTimeFormat
  -> Int
  -> RelativeTimeUnit
  -> Array { type :: String, value :: String }
formatToParts relativeTimeFormat n relativeTimeUnit =
  Function.Uncurried.runFn3 _formatToParts relativeTimeFormat n (StringArg.from relativeTimeUnit)

type ResolvedOptions =
  { locale :: String
  , style :: String
  , numeric :: String
  , numberingSystem :: String
  }

foreign import _resolvedOptions
  :: EffectFn1
       RelativeTimeFormat
       ResolvedOptions

resolvedOptions
  :: RelativeTimeFormat
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions