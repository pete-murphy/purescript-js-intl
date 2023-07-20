{ name = "web-intl-script"
, dependencies =
  [ "aff"
  , "arrays"
  , "console"
  , "control"
  , "effect"
  , "foldable-traversable"
  , "node-buffer"
  , "node-fs-aff"
  , "node-path"
  , "prelude"
  , "strings"
  ]
, packages = ./packages.dhall
, sources = [ "./**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ptrfrncsmrph/purescript-web-intl.git"
}
