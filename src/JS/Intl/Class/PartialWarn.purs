module JS.Intl.Class.PartialWarn where

import Prim.TypeError (class Warn, Doc)
import Unsafe.Coerce as Unsafe.Coerce

class PartialWarn :: Doc -> Constraint
class PartialWarn doc

instance (Partial, Warn doc) => PartialWarn doc

unwrap :: forall a. (forall (doc :: Doc). PartialWarn doc => a) -> a
unwrap = Unsafe.Coerce.unsafeCoerce
