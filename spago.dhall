{ name = "js-intl"
, dependencies =
  [ "arrays"
  , "convertable-options"
  , "datetime"
  , "effect"
  , "foreign"
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
