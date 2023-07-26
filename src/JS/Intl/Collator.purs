module JS.Intl.Collator
  -- * Types
  ( Collator
  , CollatorOptions

  -- * Constructor
  , new
  , new_

  , New

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , compare
  , resolvedOptions
  ) where

import Prelude hiding (compare)

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.Options.CaseFirst (CaseFirst)
import JS.Intl.Options.CaseFirst as CaseFirst
import JS.Intl.Options.LocaleMatcher (LocaleMatcher(..))
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Sensitivity (Sensitivity(..))
import JS.Intl.Options.Sensitivity as Sensitivity
import JS.Intl.Options.Usage (Usage(..))
import JS.Intl.Options.Usage as Usage
import Prelude (compare) as Prelude
import Prim.Row (class Nub, class Union)
import Record as Record

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

defaultOptions :: Record CollatorOptions
defaultOptions =
  { localeMatcher: LocaleMatcher.toString BestFit
  , usage: Usage.toString Sort
  , sensitivity: Sensitivity.toString Variant
  , ignorePunctuation: false
  , numeric: false
  , caseFirst: CaseFirst.toString CaseFirst.False
  , collation: "false"
  }

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record CollatorOptions)
       Collator

new
  :: forall provided
   . ConvertOptionsWithDefaults New { | CollatorOptions } { | provided } { | CollatorOptions }
  => NonEmptyArray Locale
  -> { | provided }
  -> Effect Collator
new locales providedOptions =
  Effect.Uncurried.runEffectFn2
    _new
    (NonEmpty.toArray locales)
    options

  where
  options :: { | CollatorOptions }
  options = ConvertableOptions.convertOptionsWithDefaults New defaultOptions providedOptions

data New = New

instance ConvertOption New "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption New "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption New "usage" Usage String where
  convertOption _ _ = Usage.toString

instance ConvertOption New "usage" String String where
  convertOption _ _ = identity

instance ConvertOption New "sensitivity" Sensitivity String where
  convertOption _ _ = Sensitivity.toString

instance ConvertOption New "sensitivity" String String where
  convertOption _ _ = identity

instance ConvertOption New "caseFirst" CaseFirst String where
  convertOption _ _ = CaseFirst.toString

instance ConvertOption New "caseFirst" String String where
  convertOption _ _ = identity

instance ConvertOption New "collation" Boolean String where
  convertOption _ _ = show

instance ConvertOption New "collation" String String where
  convertOption _ _ = identity

instance ConvertOption New "numeric" Boolean Boolean where
  convertOption _ _ = identity

instance ConvertOption New "ignorePunctuation" Boolean Boolean where
  convertOption _ _ = identity

new_
  :: NonEmptyArray Locale
  -> Effect Collator
new_ locales =
  new locales defaultOptions

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record CollatorOptions)
       (Array String)

supportedLocalesOf
  :: forall provided options
   . Union provided CollatorOptions options
  => Nub options CollatorOptions
  => NonEmptyArray Locale
  -> Record provided
  -> Array String
supportedLocalesOf locales providedOptions =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    (NonEmpty.toArray locales)
    (Record.merge providedOptions defaultOptions)

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
