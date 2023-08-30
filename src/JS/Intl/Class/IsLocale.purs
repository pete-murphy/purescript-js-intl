module JS.Intl.Class.IsLocale where

import Prelude

import Effect.Unsafe as Effect.Unsafe
import JS.Intl.Locale (Locale)
import JS.Intl.Locale as Locale

class IsLocale a where
  toLocale :: a -> Locale

instance IsLocale Locale where
  toLocale = identity

instance IsLocale String where
  toLocale = Effect.Unsafe.unsafePerformEffect <<< Locale.new_

