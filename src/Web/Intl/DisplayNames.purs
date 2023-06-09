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
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce

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
       (Array String)
       DisplayNamesOptions
       DisplayNames

new
  :: forall options options'
   . Union options options' DisplayNamesOptions'Optional
  => Array String
  -> { type :: String | options }
  -> Effect DisplayNames
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

foreign import _supportedLocalesOf
  :: Fn2
       (Array String)
       DisplayNamesOptions
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' DisplayNamesOptions'Optional
  => Array String
  -> { type :: String | options }
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2 _supportedLocalesOf locales (Unsafe.Coerce.unsafeCoerce options)

foreign import _of
  :: Fn2 DisplayNames String String

of_ :: DisplayNames -> String -> String
of_ = Function.Uncurried.runFn2 _of