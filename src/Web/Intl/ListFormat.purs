module Web.Intl.ListFormat
  -- * Types
  ( ListFormat
  , ListFormatOptions

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

import Data.Function.Uncurried (Fn2)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.LocaleOptions (LocaleOptions)

type ListFormatOptions =
  ( localeMatcher :: String
  , type :: String
  , style :: String
  )

foreign import data ListFormat :: Type

foreign import _new
  :: EffectFn2
       (Array String)
       (Record ListFormatOptions)
       ListFormat

new
  :: forall options options'
   . Union options options' ListFormatOptions
  => Array String
  -> Record options
  -> Effect ListFormat
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

new_
  :: Array String
  -> Effect ListFormat
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
       ListFormat
       (Array String)
       String

format :: ListFormat -> Array String -> String
format = Function.Uncurried.runFn2 _format

foreign import _formatToParts
  :: Fn2
       ListFormat
       (Array String)
       (Array { type :: String, value :: String })

formatToParts :: ListFormat -> Array String -> Array { type :: String, value :: String }
formatToParts = Function.Uncurried.runFn2 _formatToParts

type ResolvedOptions =
  { locale :: String
  , type :: String
  , style :: String
  }

foreign import _resolvedOptions
  :: EffectFn1
       ListFormat
       ResolvedOptions

resolvedOptions :: ListFormat -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions