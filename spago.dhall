{ name = "web-intl"
, dependencies =
  [ "effect", "functions", "js-date", "prelude", "unsafe-coerce" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/ptrfrncsmrph/purescript-web-intl.git"
}
