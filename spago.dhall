{ name = "js-intl"
, dependencies =
  [ "arrays"
  , "convertable-options"
  , "datetime"
  , "effect"
  , "functions"
  , "js-date"
  , "maybe"
  , "nullable"
  , "prelude"
  , "record"
  , "tuples"
  , "unfoldable"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ptrfrncsmrph/purescript-js-intl.git"
}
