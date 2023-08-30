module JS.Intl.ListFormat
  -- * Types
  ( ListFormat
  , ListFormatOptions
  , ToListFormatOptions

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

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Function.Uncurried (Fn2)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.Options.ListFormatType (ListFormatType)
import JS.Intl.Options.ListFormatType as ListFormatType
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Style (Style)
import JS.Intl.Options.Style as Style
import Unsafe.Coerce as Unsafe.Coerce

-- | Language-sensitive list formatting
foreign import data ListFormat :: Type

type ListFormatOptions =
  ( localeMatcher :: String
  , type :: String
  , style :: String
  )

defaultOptions :: { | ListFormatOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | ListFormatOptions }
       ListFormat

data ToListFormatOptions = ToListFormatOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToListFormatOptions
       { | ListFormatOptions }
       { | provided }
       { | ListFormatOptions }
  => Array Locale
  -> { | provided }
  -> Effect ListFormat
new locales provided =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    options
  where
  options :: { | ListFormatOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToListFormatOptions defaultOptions provided

instance ConvertOption ToListFormatOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToListFormatOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToListFormatOptions "type" ListFormatType String where
  convertOption _ _ = ListFormatType.toString

instance ConvertOption ToListFormatOptions "type" String String where
  convertOption _ _ = identity

instance ConvertOption ToListFormatOptions "style" Style String where
  convertOption _ _ = Style.toString

instance ConvertOption ToListFormatOptions "style" String String where
  convertOption _ _ = identity

new_
  :: Array Locale
  -> Effect ListFormat
new_ locales =
  new locales defaultOptions

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | ListFormatOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToListFormatOptions
       { | ListFormatOptions }
       { | provided }
       { | ListFormatOptions }
  => Array Locale
  -> { | provided }
  -> Array String
supportedLocalesOf locales provided =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    locales
    options
  where
  options :: { | ListFormatOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToListFormatOptions defaultOptions provided

supportedLocalesOf_
  :: Array Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales defaultOptions

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
