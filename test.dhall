let conf = ./spago.dhall

in      conf
    //  { dependencies =
              conf.dependencies
            # [ "assert"
              , "console"
              , "effect"
              , "functions"
              , "js-date"
              , "prelude"
              , "record"
              , "strings"
              , "unsafe-coerce"
              ]
        , sources = conf.sources # [ "test/**/*.purs" ]
        }
