module Web.Intl.DisplayNames
  -- * Types
  ( DisplayNames
  , DisplayNamesOptions
  , DisplayNamesOptions'Required
  , DisplayNamesOptions'Optional

  -- * Constructor
  , new

  -- * Methods
  , supportedLocalesOf
  , of_
  ) where

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
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

type DisplayNamesOptions'Required options =
  ( type :: String
  | options
  )

type DisplayNamesOptions =
  DisplayNamesOptions'Required DisplayNamesOptions'Optional

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record DisplayNamesOptions)
       DisplayNames

new
  :: forall options options'
   . Union options options' DisplayNamesOptions'Optional
  => NonEmptyArray Locale
  -> Record (DisplayNamesOptions'Required options)
  -> Effect DisplayNames
new locales options =
  Effect.Uncurried.runEffectFn2 _new (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record DisplayNamesOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' DisplayNamesOptions'Optional
  => NonEmptyArray Locale
  -> { type :: String | options }
  -> Array String
supportedLocalesOf locales options =
  Function.Uncurried.runFn2 _supportedLocalesOf (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

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