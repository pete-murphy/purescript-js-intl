module JS.Intl.DisplayNames
  -- * Types
  ( DisplayNames
  , DisplayNamesOptions
  , DisplayNamesOptions'Optional
  , ToDisplayNamesOptions

  -- * Constructor
  , new

  -- * Methods
  , supportedLocalesOf
  , of_
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults, class Defaults)
import ConvertableOptions as ConvertableOptions
import Data.Function.Uncurried (Fn2)
import Data.Function.Uncurried as Function.Uncurried
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.Options.DisplayNamesType (DisplayNamesType)
import JS.Intl.Options.DisplayNamesType as DisplayNamesType
import JS.Intl.Options.Fallback (Fallback)
import JS.Intl.Options.Fallback as Fallback
import JS.Intl.Options.LanguageDisplay (LanguageDisplay)
import JS.Intl.Options.LanguageDisplay as LanguageDisplay
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Style (Style)
import JS.Intl.Options.Style as Style
import Unsafe.Coerce as Unsafe.Coerce

-- | Consistent translation of language, region and script display names
foreign import data DisplayNames :: Type

type DisplayNamesOptions'Optional =
  ( localeMatcher :: String
  , style :: String
  , languageDisplay :: String
  , fallback :: String
  )

type DisplayNamesOptions =
  ( type :: String
  | DisplayNamesOptions'Optional
  )

defaultOptions :: { | DisplayNamesOptions'Optional }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | DisplayNamesOptions }
       DisplayNames

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToDisplayNamesOptions
       { | DisplayNamesOptions'Optional }
       { | provided }
       { | DisplayNamesOptions }
  => Array Locale
  -> { | provided }
  -> Effect DisplayNames
new locales provided =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    options
  where
  options :: { | DisplayNamesOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToDisplayNamesOptions defaultOptions provided

data ToDisplayNamesOptions = ToDisplayNamesOptions

instance ConvertOption ToDisplayNamesOptions "type" DisplayNamesType String where
  convertOption _ _ = DisplayNamesType.toString

instance ConvertOption ToDisplayNamesOptions "type" String String where
  convertOption _ _ = identity

instance ConvertOption ToDisplayNamesOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToDisplayNamesOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToDisplayNamesOptions "style" Style String where
  convertOption _ _ = Style.toString

instance ConvertOption ToDisplayNamesOptions "style" String String where
  convertOption _ _ = identity

instance ConvertOption ToDisplayNamesOptions "languageDisplay" LanguageDisplay String where
  convertOption _ _ = LanguageDisplay.toString

instance ConvertOption ToDisplayNamesOptions "languageDisplay" String String where
  convertOption _ _ = identity

instance ConvertOption ToDisplayNamesOptions "fallback" Fallback String where
  convertOption _ _ = Fallback.toString

instance ConvertOption ToDisplayNamesOptions "fallback" String String where
  convertOption _ _ = identity

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | DisplayNamesOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . Defaults
       { | DisplayNamesOptions'Optional }
       { | provided }
       { | DisplayNamesOptions }
  => Array Locale
  -> { | provided }
  -> Array String
supportedLocalesOf locales provided =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    locales
    options
  where
  options :: { | DisplayNamesOptions }
  options = ConvertableOptions.defaults defaultOptions provided

foreign import _of
  :: Fn2
       DisplayNames
       String
       (Nullable String)

-- | Receives a code and returns a string based on the locale and options of the
-- | `DisplayNames`
of_
  :: DisplayNames
  -> String
  -> Maybe String
of_ displayNames key =
  Nullable.toMaybe (Function.Uncurried.runFn2 _of displayNames key)
