module JS.Intl.Collator
  -- * Types
  ( Collator
  , CollatorOptions
  , ToCollatorOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , supportedLocalesOf
  , supportedLocalesOf_
  , compare
  , resolvedOptions

  -- * Options
  , convertOptionsWithDefaults
  ) where

import Prelude hiding (compare)

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Function.Uncurried (Fn2, Fn3)
import Data.Function.Uncurried as Function.Uncurried
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.Options.CaseFirst (CaseFirst)
import JS.Intl.Options.CaseFirst as CaseFirst
import JS.Intl.Options.Collation (Collation)
import JS.Intl.Options.Collation as Collation
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import JS.Intl.Options.Sensitivity (Sensitivity)
import JS.Intl.Options.Sensitivity as Sensitivity
import JS.Intl.Options.Usage (Usage)
import JS.Intl.Options.Usage as Usage
import Prelude (compare) as Prelude

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

defaultOptions :: { | CollatorOptions }
defaultOptions =
  { localeMatcher: LocaleMatcher.toString LocaleMatcher.BestFit
  , usage: Usage.toString Usage.Sort
  , sensitivity: Sensitivity.toString Sensitivity.Variant
  , ignorePunctuation: false
  , numeric: false
  , caseFirst: CaseFirst.toString CaseFirst.False
  , collation: Collation.toString Collation.Default
  }

convertOptionsWithDefaults
  :: forall provided all
   . ConvertOptionsWithDefaults
       ToCollatorOptions
       { | CollatorOptions }
       provided
       all
  => provided
  -> all
convertOptionsWithDefaults =
  ConvertableOptions.convertOptionsWithDefaults
    ToCollatorOptions
    defaultOptions

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | CollatorOptions }
       Collator

new_
  :: Array Locale
  -> Effect Collator
new_ locales =
  new locales defaultOptions

data ToCollatorOptions = ToCollatorOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToCollatorOptions
       { | CollatorOptions }
       { | provided }
       { | CollatorOptions }
  => Array Locale
  -> { | provided }
  -> Effect Collator
new locales providedOptions =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    (convertOptionsWithDefaults providedOptions)

instance ConvertOption ToCollatorOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToCollatorOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToCollatorOptions "usage" Usage String where
  convertOption _ _ = Usage.toString

instance ConvertOption ToCollatorOptions "usage" String String where
  convertOption _ _ = identity

instance ConvertOption ToCollatorOptions "sensitivity" Sensitivity String where
  convertOption _ _ = Sensitivity.toString

instance ConvertOption ToCollatorOptions "sensitivity" String String where
  convertOption _ _ = identity

instance ConvertOption ToCollatorOptions "caseFirst" CaseFirst String where
  convertOption _ _ = CaseFirst.toString

instance ConvertOption ToCollatorOptions "caseFirst" String String where
  convertOption _ _ = identity

instance ConvertOption ToCollatorOptions "collation" Collation String where
  convertOption _ _ = Collation.toString

instance ConvertOption ToCollatorOptions "collation" String String where
  convertOption _ _ = identity

instance ConvertOption ToCollatorOptions "numeric" Boolean Boolean where
  convertOption _ _ = identity

instance ConvertOption ToCollatorOptions "ignorePunctuation" Boolean Boolean where
  convertOption _ _ = identity

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | CollatorOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToCollatorOptions
       { | CollatorOptions }
       { | provided }
       { | CollatorOptions }
  => Array Locale
  -> { | provided }
  -> Array String
supportedLocalesOf locales providedOptions =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    locales
    (convertOptionsWithDefaults providedOptions)

supportedLocalesOf_
  :: Array Locale
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
