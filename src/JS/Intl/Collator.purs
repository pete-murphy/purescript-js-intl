module JS.Intl.Collator
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

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import Prelude (compare) as Prelude
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce

-- | Language-sensitive string comparison
foreign import data Collator :: Type

type CollatorOptions =
  ( localeMatcher :: String
  , usage :: String
  , sensitivity :: String
  , ignorePunctuation :: Boolean
  , numeric :: Boolean
  , caseFirst :: String
  , collation :: String
  )

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record CollatorOptions)
       Collator

new
  :: forall options options'
   . Union options options' CollatorOptions
  => NonEmptyArray Locale
  -> Record options
  -> Effect Collator
new locales options =
  Effect.Uncurried.runEffectFn2 _new (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

new_
  :: NonEmptyArray Locale
  -> Effect Collator
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record CollatorOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' CollatorOptions
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

foreign import _compare
  :: Fn3
       Collator
       String
       String
       Number

-- | Compare two strings according to the sort order of the `Collator`
compare
  :: Collator
  -> String
  -> String
  -> Ordering
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

resolvedOptions
  :: Collator
  -> Effect ResolvedOptions
resolvedOptions collator =
  Effect.Uncurried.runEffectFn1 _resolvedOptions collator
