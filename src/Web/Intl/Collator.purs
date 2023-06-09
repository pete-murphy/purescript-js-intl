module Web.Intl.Collator
  -- * Types
  ( Collator
  , CollatorOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , compare
  , resolvedOptions
  ) where

import Prelude hiding (compare)

import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import Prelude (compare) as Prelude
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.LocaleOptions (LocaleOptions)

type CollatorOptions =
  ( localeMatcher :: String
  , usage :: String
  , sensitivity :: String
  , ignorePunctuation :: Boolean
  , numeric :: Boolean
  , caseFirst :: String
  , collation :: String
  )

foreign import data Collator :: Type

foreign import _new
  :: EffectFn2
       (Array String)
       (Record CollatorOptions)
       Collator

new
  :: forall options options'
   . Union options options' CollatorOptions
  => Array String
  -> Record options
  -> Effect Collator
new locales options =
  Effect.Uncurried.runEffectFn2 _new locales (Unsafe.Coerce.unsafeCoerce options)

new_
  :: Array String
  -> Effect Collator
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

supportedLocalesOf_ :: Array String -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales {}

foreign import _compare
  :: Fn3
       Collator
       String
       String
       Number

compare :: Collator -> String -> String -> Ordering
compare collator x y = do
  Prelude.compare (Function.Uncurried.runFn3 _compare collator x y) 0.0

type ResolvedOptions =
  { locale :: String
  , usage :: String
  , sensitivity :: String
  , ignorePunctuation :: Boolean
  , numeric :: Boolean
  , caseFirst :: String
  , collation :: String
  }

foreign import _resolvedOptions
  :: EffectFn1
       Collator
       ResolvedOptions

resolvedOptions :: Collator -> Effect ResolvedOptions
resolvedOptions collator =
  Effect.Uncurried.runEffectFn1 _resolvedOptions collator
