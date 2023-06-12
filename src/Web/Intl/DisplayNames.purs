module Web.Intl.DisplayNames
  -- * Types
  ( DisplayNames
  , DisplayNamesOptions
  , DisplayNamesOptions'Optional

  -- * Constructor
  , new

  -- * Methods
  , supportedLocalesOf
  , of_
  ) where

import Data.Function.Uncurried (Fn2)
import Data.Function.Uncurried as Function.Uncurried
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.Locale (Locale)

foreign import data DisplayNames :: Type

type DisplayNamesOptions'Optional =
  ( localeMatcher :: String
  , style :: String
  , languageDisplay :: String
  , fallback :: String
  )

type DisplayNamesOptions =
  { type :: String
  | DisplayNamesOptions'Optional
  }

foreign import _new
  :: EffectFn2
       (Array Locale)
       DisplayNamesOptions
       DisplayNames

new
  :: forall options options'
   . Union options options' DisplayNamesOptions'Optional
  => Array Locale
  -> { type :: String | options }
  -> Effect DisplayNames
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       DisplayNamesOptions
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' DisplayNamesOptions'Optional
  => Array Locale
  -> { type :: String | options }
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2 _supportedLocalesOf locales (Unsafe.Coerce.unsafeCoerce options)

foreign import _of
  :: Fn2
       DisplayNames
       String
       (Nullable String)

of_
  :: DisplayNames
  -> String
  -> Maybe String
of_ displayNames key = Nullable.toMaybe (Function.Uncurried.runFn2 _of displayNames key)