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

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Function.Uncurried (Fn2)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.Locale (Locale)

-- | Language-sensitive list formatting
foreign import data ListFormat :: Type

type ListFormatOptions =
  ( localeMatcher :: String
  , type :: String
  , style :: String
  )

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record ListFormatOptions)
       ListFormat

new
  :: forall options options'
   . Union options options' ListFormatOptions
  => NonEmptyArray Locale
  -> Record options
  -> Effect ListFormat
new locales options =
  Effect.Uncurried.runEffectFn2 _new (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

new_
  :: NonEmptyArray Locale
  -> Effect ListFormat
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record ListFormatOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' ListFormatOptions
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
       ListFormat
       (Array String)
       String

-- | Returns a string with a language-specific representation of the list
format
  :: ListFormat
  -> Array String
  -> String
format = Function.Uncurried.runFn2 _format

foreign import _formatToParts
  :: Fn2
       ListFormat
       (Array String)
       (Array { type :: String, value :: String })

-- | Returns an array of objects representing the different components that can
-- | be used to format a list of values in a locale-aware fashion
formatToParts
  :: ListFormat
  -> Array String
  -> Array { type :: String, value :: String }
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

resolvedOptions
  :: ListFormat
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions