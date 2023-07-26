module JS.Intl.Segmenter
  -- * Types
  ( Segmenter
  , SegmenterOptions

  -- * Constructor
  , new
  , new_

  -- * Methods
  , resolvedOptions
  , supportedLocalesOf
  , supportedLocalesOf_
  , segment
  ) where

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
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
import Prim.Row (class Union)
import Unsafe.Coerce as Unsafe.Coerce

-- | For locale-sensitive text segmentation, enabling you to get meaningful
-- | items (graphemes, words or sentences) from a string.
foreign import data Segmenter :: Type

type SegmenterOptions =
  ( localeMatcher :: String
  , granularity :: String
  )

foreign import _new
  :: EffectFn2
       (Array Locale)
       (Record SegmenterOptions)
       Segmenter

new
  :: forall options options'
   . Union options options' SegmenterOptions
  => NonEmptyArray Locale
  -> Record options
  -> Effect Segmenter
new locales options =
  Effect.Uncurried.runEffectFn2 _new (NonEmpty.toArray locales) (Unsafe.Coerce.unsafeCoerce options)

new_ :: NonEmptyArray Locale -> Effect Segmenter
new_ locales =
  new locales {}

foreign import _supportedLocalesOf
  :: Fn2
       (Array Locale)
       (Record SegmenterOptions)
       (Array String)

supportedLocalesOf
  :: forall options options'
   . Union options options' SegmenterOptions
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