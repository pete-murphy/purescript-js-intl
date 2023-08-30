{ name = "js-intl-script"
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
, repository = "https://github.com/pete-murphy/purescript-js-intl.git"
}
