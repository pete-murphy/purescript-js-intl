{ name = "web-intl"
, dependencies =
  [ "effect"
  , "functions"
  , "js-date"
  , "maybe"
  , "nullable"
  , "prelude"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ptrfrncsmrph/purescript-web-intl.git"
}
