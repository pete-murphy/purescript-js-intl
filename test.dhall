let conf = ./spago.dhall

in      conf
    //  { dependencies =
              conf.dependencies
            # [ "assert"
              , "console"
              , "debug"
              , "enums"
              , "effect"
              , "foldable-traversable"
              , "functions"
              , "js-date"
              , "partial"
              , "prelude"
              , "strings"
              , "unsafe-coerce"
              ]
        , sources = conf.sources # [ "test/**/*.purs", "example/**/*.purs" ]
        }
