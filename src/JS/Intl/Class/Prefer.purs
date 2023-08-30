module JS.Intl.Class.Prefer where

import Prim.TypeError (class Warn, Above, Beside, Doc, Quote, Text)
import Unsafe.Coerce as Coerce

infixr 6 type Above as :>

type Indented :: Doc -> Doc -> Doc
type Indented before this =
  before
    :> Beside (Text "    ") this

infixr 8 type Indented as :>>

type Prefer :: forall k1 k2. k1 -> k2 -> Doc
type Prefer this that =
  Text "Prefer"
    :>> Quote this
    :> Text "instead of"
      :>> Quote that

unwrap :: forall a. (forall (doc :: Doc). Warn doc => a) -> a
unwrap x = Coerce.unsafeCoerce x