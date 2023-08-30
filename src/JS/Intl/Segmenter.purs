module JS.Intl.Segmenter
  -- * Types
  ( Segmenter
  , SegmenterOptions
  , ToSegmenterOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , resolvedOptions
  , supportedLocalesOf
  , supportedLocalesOf_
  , segment
  ) where

import Prelude

import ConvertableOptions (class ConvertOption, class ConvertOptionsWithDefaults)
import ConvertableOptions as ConvertableOptions
import Data.Function.Uncurried (Fn2, Fn4)
import Data.Function.Uncurried as Function.Uncurried
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Unfoldable (class Unfoldable)
import Data.Unfoldable as Unfoldable
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2)
import Effect.Uncurried as Effect.Uncurried
import JS.Intl.Locale (Locale)
import JS.Intl.Options.Granularity (Granularity)
import JS.Intl.Options.Granularity as Granularity
import JS.Intl.Options.LocaleMatcher (LocaleMatcher)
import JS.Intl.Options.LocaleMatcher as LocaleMatcher
import Unsafe.Coerce as Unsafe.Coerce

-- | For locale-sensitive text segmentation, enabling you to get meaningful
-- | items (graphemes, words or sentences) from a string.
foreign import data Segmenter :: Type

type SegmenterOptions =
  ( localeMatcher :: String
  , granularity :: String
  )

defaultOptions :: { | SegmenterOptions }
defaultOptions =
  Unsafe.Coerce.unsafeCoerce {}

foreign import _new
  :: EffectFn2
       (Array Locale)
       { | SegmenterOptions }
       Segmenter

data ToSegmenterOptions = ToSegmenterOptions

new
  :: forall provided
   . ConvertOptionsWithDefaults
       ToSegmenterOptions
       { | SegmenterOptions }
       { | provided }
       { | SegmenterOptions }
  => Array Locale
  -> { | provided }
  -> Effect Segmenter
new locales provided =
  Effect.Uncurried.runEffectFn2
    _new
    locales
    options
  where
  options :: { | SegmenterOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToSegmenterOptions defaultOptions provided

instance ConvertOption ToSegmenterOptions "localeMatcher" LocaleMatcher String where
  convertOption _ _ = LocaleMatcher.toString

instance ConvertOption ToSegmenterOptions "localeMatcher" String String where
  convertOption _ _ = identity

instance ConvertOption ToSegmenterOptions "granularity" Granularity String where
  convertOption _ _ = Granularity.toString

instance ConvertOption ToSegmenterOptions "granularity" String String where
  convertOption _ _ = identity

new_ :: Array Locale -> Effect Segmenter
new_ locales =
  new locales defaultOptions

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       { | SegmenterOptions }
       (Array String)

supportedLocalesOf
  :: forall provided
   . ConvertOptionsWithDefaults
       ToSegmenterOptions
       { | SegmenterOptions }
       { | provided }
       { | SegmenterOptions }
  => Array Locale
  -> { | provided }
  -> Array String
supportedLocalesOf locales provided =
  Function.Uncurried.runFn2
    _supportedLocalesOf
    locales
    options
  where
  options :: { | SegmenterOptions }
  options = ConvertableOptions.convertOptionsWithDefaults ToSegmenterOptions defaultOptions provided

supportedLocalesOf_
  :: Array Locale
  -> Array String
supportedLocalesOf_ locales =
  supportedLocalesOf locales defaultOptions

type Segment =
  { segment :: String
  , isWordLike :: Boolean
  , input :: String
  , index :: Int
  }

foreign import data Segments :: Type

foreign import _segmentIterator
  :: Fn2
       Segmenter
       String
       Segments

foreign import _nextSegment
  :: Fn4
       (forall a. Maybe a)
       (forall a. a -> Maybe a)
       (forall a b. Fn2 a b (Tuple a b))
       Segments
       (Maybe (Tuple Segment Segments))

-- | Segments a string according to the locale and granularity of the
-- | `Segmenter` instance
segment
  :: forall f
   . Unfoldable f
  => Segmenter
  -> String
  -> f Segment
segment segmenter string =
  Unfoldable.unfoldr
    (Function.Uncurried.runFn4 _nextSegment Nothing Just (Function.Uncurried.mkFn2 Tuple))
    (Function.Uncurried.runFn2 _segmentIterator segmenter string)

type ResolvedOptions =
  { locale :: String
  , granularity :: String
  }

foreign import _resolvedOptions
  :: EffectFn1
       Segmenter
       ResolvedOptions

resolvedOptions
  :: Segmenter
  -> Effect ResolvedOptions
resolvedOptions = Effect.Uncurried.runEffectFn1 _resolvedOptions
