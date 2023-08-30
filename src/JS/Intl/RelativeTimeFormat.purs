module JS.Intl.RelativeTimeFormat
  -- * Types
  ( RelativeTimeFormat
  , RelativeTimeFormatOptions
  , ToRelativeTimeFormatOptions

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
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Numeric (Numeric)
import JS.Intl.Options.Numeric as Numeric
import JS.Intl.Options.RelativeTimeUnit (RelativeTimeUnit)
import JS.Intl.Options.RelativeTimeUnit as RelativeTimeUnit
import JS.Intl.Options.Style (Style)
import JS.Intl.Options.Style as Style
import Unsafe.Coerce as Unsafe.Coerce

-- | Language-sensitive relative time formatting
foreign import data RelativeTimeFormat :: Type

type RelativeTimeFormatOptions =
  ( localeMatcher :: String
  , numeric :: String
  , style :: String
  )

defaultOptions :: { | RelativeTimeFormatOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | RelativeTimeFormatOptions }
       RelativeTimeFormat

data ToRelativeTimeFormatOptions = ToRelativeTimeFormatOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToRelativeTimeFormatOptions
       { | RelativeTimeFormatOptions }
       { | provided }
       { | RelativeTimeFormatOptions }
  => Array Locale
  -> { | provided }
  -> Effect RelativeTimeFormat
new locales provided =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    options
  where
  options :: { | RelativeTimeFormatOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToRelativeTimeFormatOptions defaultOptions provided

instance ConvertOption ToRelativeTimeFormatOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToRelativeTimeFormatOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToRelativeTimeFormatOptions "style" Style String where
  convertOption _ _ = Style.toString

instance ConvertOption ToRelativeTimeFormatOptions "style" String String where
  convertOption _ _ = identity

instance ConvertOption ToRelativeTimeFormatOptions "numeric" Numeric String where
  convertOption _ _ = Numeric.toString

instance ConvertOption ToRelativeTimeFormatOptions "numeric" String String where
  convertOption _ _ = identity

new_
  :: Array Locale
  -> Effect RelativeTimeFormat
new_ locales =
  new locales defaultOptions

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | RelativeTimeFormatOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToRelativeTimeFormatOptions
       { | RelativeTimeFormatOptions }
       { | provided }
       { | RelativeTimeFormatOptions }
  => Array Locale
  -> { | provided }
  -> Array String
supportedLocalesOf locales provided =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    locales
    options
  where
  options :: { | RelativeTimeFormatOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToRelativeTimeFormatOptions defaultOptions provided

supportedLocalesOf_
  :: Array Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales defaultOptions

foreign import _format
  :: Fn3
       RelativeTimeFormat
       Int
       String
       String

-- | Formats an `Int` value and `RelativeTimeUnit` according to the locale and
-- | formatting options of the `RelativeTimeFormat`
format
  :: RelativeTimeFormat
  -> Int
  -> RelativeTimeUnit
  -> String
format relativeTimeFormat n relativeTimeUnit =
  Function.Uncurried.runFn3 _format relativeTimeFormat n (RelativeTimeUnit.toString relativeTimeUnit)

foreign import _formatToParts
  :: Fn3
       RelativeTimeFormat
       Int
       String
       (Array { type :: String, value :: String })

-- | Returns an array of objects representing the relative time format in parts
-- | that can be used for custom locale-aware formatting
formatToParts
  :: RelativeTimeFormat
  -> Int
  -> RelativeTimeUnit
  -> Array { type :: String, value :: String }
formatToParts relativeTimeFormat n relativeTimeUnit =
  Function.Uncurried.runFn3 _formatToParts relativeTimeFormat n (RelativeTimeUnit.toString relativeTimeUnit)

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
