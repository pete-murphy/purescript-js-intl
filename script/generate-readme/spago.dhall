{ name = "web-intl-script"
, dependencies =
  [ "aff"
  , "arrays"
  , "console"
  , "control"
  , "debug"
  , "effect"
  , "foldable-traversable"
  , "node-buffer"
  , "node-fs-aff"
  , "node-path"
  , "partial"
  , "prelude"
  , "strings"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "./**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ptrfrncsmrph/purescript-web-intl.git"
}
