module Web.Intl.DateTimeFormat
  -- * Types
  ( DateTimeFormat
  , DateTimeFormatOptions

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
import Data.JSDate (JSDate)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Foreign.Object (Object)
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.LocaleOptions (LocaleOptions)

type DateTimeFormatOptions =
  ( localeMatcher :: String
  , weekday :: String
  , era :: String
  , year :: String
  , month :: String
  , day :: String
  , hour :: String
  , minute :: String
  , second :: String
  , timeZoneName :: String
  , formatMatcher :: String
  , hour12 :: Boolean
  , timeZone :: String
  )

foreign import data DateTimeFormat :: Type

foreign import _new
  :: EffectFn2
       (Array String)
       (Record DateTimeFormatOptions)
       DateTimeFormat

new
  :: forall options options'
   . Union options options' DateTimeFormatOptions
  => Array String
  -> Record options
  -> Effect DateTimeFormat
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

new_
  :: Array String
  -> Effect DateTimeFormat
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
       DateTimeFormat
       JSDate
       String

format :: DateTimeFormat -> JSDate -> String
format = Function.Uncurried.runFn2 _format

foreign import _formatRange
  :: Fn3
       DateTimeFormat
       JSDate
       JSDate
       String

formatRange :: DateTimeFormat -> JSDate -> JSDate -> String
formatRange = Function.Uncurried.runFn3 _formatRange

foreign import _formatRangeToParts
  :: Fn3
       DateTimeFormat
       JSDate
       JSDate
       (Array { type :: String, value :: String })

formatRangeToParts :: DateTimeFormat -> JSDate -> JSDate -> Array { type :: String, value :: String }
formatRangeToParts = Function.Uncurried.runFn3 _formatRangeToParts

foreign import _formatToParts
  :: Fn2
       DateTimeFormat
       JSDate
       (Array { type :: String, value :: String })

formatToParts :: DateTimeFormat -> JSDate -> Array { type :: String, value :: String }
formatToParts = Function.Uncurried.runFn2 _formatToParts

foreign import _resolvedOptions
  :: EffectFn1
       DateTimeFormat
       -- TODO: Better type here
       (Object String)

resolvedOptions :: DateTimeFormat -> Effect (Object String)
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions