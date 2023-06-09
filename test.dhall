let conf = ./spago.dhall

in      conf
    //  { dependencies =
              conf.dependencies
            # [ "assert"
              , "console"
              , "debug"
              , "effect"
              , "either"
              , "exceptions"
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
