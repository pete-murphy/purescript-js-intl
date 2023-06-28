{ name = "web-intl"
, dependencies =
  [ "arrays"
  , "effect"
  , "functions"
  , "js-date"
  , "maybe"
  , "nullable"
  , "prelude"
  , "tuples"
  , "unfoldable"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ptrfrncsmrph/purescript-web-intl.git"
}
