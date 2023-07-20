{ name = "web-intl"
, dependencies =
  [ "arrays"
  , "datetime"
  , "effect"
  , "enums"
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
, repository = "https://github.com/ptrfrncsmrph/purescript-web-intl.git"
}
