{ name = "js-intl"
, dependencies =
  [ "arrays"
  , "datetime"
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
, repository = "https://github.com/ptrfrncsmrph/purescript-js-intl.git"
}
