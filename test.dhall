let conf = ./spago.dhall

in      conf
    //  { dependencies =
              conf.dependencies
            # [ "assert"
              , "console"
              , "debug"
              , "effect"
              , "foldable-traversable"
              , "functions"
              , "js-date"
              , "prelude"
              , "record"
              , "strings"
              , "unsafe-coerce"
              ]
        , sources = conf.sources # [ "test/**/*.purs" ]
        }
