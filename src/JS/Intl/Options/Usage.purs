module JS.Intl.Options.Usage where

import Prelude

data Usage
  = Sort
  | Search

derive instance Eq Usage

toString :: Usage -> String
toString = case _ of
  Sort -> "sort"
  Search -> "search"
