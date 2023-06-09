module Web.Intl.Internal.ToLocaleArg
  ( LocaleArg
  , class ToLocaleArg
  , to
  ) where

import Unsafe.Coerce as Unsafe.Coerce
import Web.Intl.Locale (Locale)

foreign import data LocaleArg :: Type

class ToLocaleArg a where
  to :: a -> LocaleArg

instance ToLocaleArg Locale where
  to = Unsafe.Coerce.unsafeCoerce

instance ToLocaleArg String where
  to = Unsafe.Coerce.unsafeCoerce
