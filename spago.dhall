{ name = "web-intl"
, dependencies =
  [ "assert"
  , "console"
  , "convertable-options"
  , "datetime"
  , "debug"
  , "effect"
  , "foreign-object"
  , "functions"
  , "js-date"
  , "maybe"
  , "nullable"
  , "prelude"
  , "record"
  , "transformers"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
