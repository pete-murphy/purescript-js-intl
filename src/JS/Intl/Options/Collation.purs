-- *** DO NOT EDIT! ***
-- This module is generated by ./script/generate-options.sh

module JS.Intl.Options.Collation
  ( Collation(..)
  , toString
  ) where

import Prelude

data Collation
  = Default
  | Compat
  | Dict
  | Emoji
  | Eor
  | Phonebk
  | Phonetic
  | Pinyin
  | Searchji
  | Stroke
  | Trad
  | Zhuyin

derive instance Eq Collation

toString :: Collation -> String
toString = case _ of
  Default -> "default"
  Compat -> "compat"
  Dict -> "dict"
  Emoji -> "emoji"
  Eor -> "eor"
  Phonebk -> "phonebk"
  Phonetic -> "phonetic"
  Pinyin -> "pinyin"
  Searchji -> "searchji"
  Stroke -> "stroke"
  Trad -> "trad"
  Zhuyin -> "zhuyin"
