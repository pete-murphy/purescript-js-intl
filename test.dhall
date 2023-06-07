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
              , "unsafe-coerce"
              ]
        , sources = conf.sources # [ "test/**/*.purs" ]
        }
