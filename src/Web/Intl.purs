module Web.Intl where

import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as Effect.Uncurried

foreign import _getCanonicalLocales
  :: EffectFn1
       (Array String)
       (Array String)

getCanonicalLocales :: Array String -> Effect (Array String)
getCanonicalLocales =
  Effect.Uncurried.runEffectFn1 _getCanonicalLocales

foreign import _supportedValuesOf
  :: EffectFn1
       String
       (Array String)

supportedValuesOf :: String -> Effect (Array String)
supportedValuesOf =
  Effect.Uncurried.runEffectFn1 _supportedValuesOf