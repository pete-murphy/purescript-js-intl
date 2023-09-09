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
  , "partial"
  , "prelude"
  , "tuples"
  , "unfoldable"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/pete-murphy/purescript-js-intl.git"
}
