module Main where

import Prelude

import Control.Alt ((<|>))
import Control.Monad.Writer as Writer
import Data.Array as Array
import Data.Foldable as Foldable
import Data.Maybe (Maybe(..))
import Data.String as String
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Exception as Exception
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS.Aff
import Node.FS.Perms as Perms
import Node.Path as Path
import Node.Process as Process
import Partial.Unsafe as Partial.Unsafe
import PureScript.CST.Types (Module)
import Tidy.Codegen as Codegen
import Tidy.Codegen.Monad as Codegen.Monad

type Option = { name :: String, constructors :: Array { name :: String, toString :: String } }

options :: Array Option
options =
  [ { name: "Weekday", constructors: narrowShortLong }
  , { name: "Era", constructors: narrowShortLong }
  , { name: "Year", constructors: twoDigitNumeric }
  , { name: "Month", constructors: twoDigitNumeric <> narrowShortLong }
  , { name: "Day", constructors: twoDigitNumeric }
  , { name: "DayPeriod", constructors: narrowShortLong }
  , { name: "Hour", constructors: twoDigitNumeric }
  , { name: "Minute", constructors: twoDigitNumeric }
  , { name: "Second", constructors: twoDigitNumeric }
  , { name: "DateStyle", constructors: fullLongMediumShort }
  , { name: "TimeStyle", constructors: fullLongMediumShort }
  , { name: "HourCycle"
    , constructors:
        [ { name: "H11", toString: "h11" }
        , { name: "H12", toString: "h12" }
        , { name: "H23", toString: "h23" }
        , { name: "H24", toString: "h24" }
        ]
    }
  , { name: "FormatMatcher"
    , constructors:
        [ { name: "Basic", toString: "basic" }
        , { name: "BestFit", toString: "best fit" }
        ]
    }
  , { name: "CaseFirst"
    , constructors:
        [ { name: "Upper", toString: "upper" }
        , { name: "Lower", toString: "lower" }
        , { name: "False", toString: "false" }
        ]
    }
  , { name: "Usage"
    , constructors:
        [ { name: "Sort", toString: "sort" }
        , { name: "Search", toString: "search" }
        ]
    }
  , { name: "TimeZoneName"
    , constructors:
        [ { name: "Short", toString: "short" }
        , { name: "Long", toString: "long" }
        , { name: "ShortOffset", toString: "shortOffset" }
        , { name: "LongOffset", toString: "longOffset" }
        , { name: "ShortGeneric", toString: "shortGeneric" }
        , { name: "LongGeneric", toString: "longGeneric" }
        ]
    }
  , { name: "Sensitivity"
    , constructors:
        [ { name: "Base", toString: "base" }
        , { name: "Accent", toString: "accent" }
        , { name: "Case", toString: "case" }
        , { name: "Variant", toString: "variant" }
        ]
    }
  , { name: "LocaleMatcher"
    , constructors:
        [ { name: "BestFit", toString: "best fit" }
        , { name: "Lookup", toString: "lookup" }
        ]
    }
  , { name: "Collation"
    , constructors:
        -- TODO: Not sure what all is valid here, going off of this list
        -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Collator/Collator
        [ { name: "Default", toString: "default" }
        , { name: "Compat", toString: "compat" }
        , { name: "Dict", toString: "dict" }
        , { name: "Emoji", toString: "emoji" }
        , { name: "Eor", toString: "eor" }
        , { name: "Phonebk", toString: "phonebk" }
        , { name: "Phonetic", toString: "phonetic" }
        , { name: "Pinyin", toString: "pinyin" }
        , { name: "Searchji", toString: "searchji" }
        , { name: "Stroke", toString: "stroke" }
        , { name: "Trad", toString: "trad" }
        , { name: "Zhuyin", toString: "zhuyin" }
        ]
    }
  , { name: "AvailableCanonical"
    , constructors:
        [ { name: "Calendar", toString: "calendar" }
        , { name: "Collation", toString: "collation" }
        , { name: "Currency", toString: "currency" }
        , { name: "NumberingSystem", toString: "numberingSystem" }
        , { name: "TimeZone", toString: "timeZone" }
        , { name: "Unit", toString: "unit" }
        ]
    }
  , { name: "Style", constructors: narrowShortLong }
  , { name: "DisplayNamesType"
    , constructors:
        [ { name: "Language", toString: "language" }
        , { name: "Region", toString: "region" }
        , { name: "Script", toString: "script" }
        , { name: "Currency", toString: "currency" }
        , { name: "Calendar", toString: "calendar" }
        , { name: "DateTimeField", toString: "dateTimeField" }
        ]
    }
  , { name: "Fallback"
    , constructors:
        [ { name: "Code", toString: "code" }
        , { name: "None", toString: "none" }
        ]
    }
  , { name: "LanguageDisplay"
    , constructors:
        [ { name: "Dialect", toString: "dialect" }
        , { name: "Standard", toString: "standard" }
        ]
    }
  , { name: "ListFormatType"
    , constructors:
        [ { name: "Conjunction", toString: "conjunction" }
        , { name: "Disjunction", toString: "disjunction" }
        , { name: "Unit", toString: "unit" }
        ]
    }
  , { name: "CompactDisplay"
    , constructors:
        [ { name: "Short", toString: "short" }
        , { name: "Long", toString: "long" }
        ]
    }
  , { name: "NumberFormatStyle"
    , constructors:
        [ { name: "Decimal", toString: "decimal" }
        , { name: "Currency", toString: "currency" }
        , { name: "Percent", toString: "percent" }
        , { name: "Unit", toString: "unit" }
        ]
    }
  , { name: "CurrencyDisplay"
    , constructors:
        [ { name: "Code", toString: "code" }
        , { name: "Symbol", toString: "symbol" }
        , { name: "NarrowSymbol", toString: "narrowSymbol" }
        , { name: "Name", toString: "name" }
        ]
    }
  , { name: "CurrencySign"
    , constructors:
        [ { name: "Standard", toString: "standard" }
        , { name: "Accounting", toString: "accounting" }
        ]
    }
  , { name: "Notation"
    , constructors:
        [ { name: "Standard", toString: "standard" }
        , { name: "Scientific", toString: "scientific" }
        , { name: "Engineering", toString: "engineering" }
        , { name: "Compact", toString: "compact" }
        ]
    }
  , { name: "SignDisplay"
    , constructors:
        [ { name: "Auto", toString: "auto" }
        , { name: "Always", toString: "always" }
        , { name: "Never", toString: "never" }
        , { name: "ExceptZero", toString: "exceptZero" }
        ]
    }
  , { name: "UnitDisplay"
    , constructors: narrowShortLong
    }
  , { name: "UseGrouping"
    , constructors:
        [ { name: "Min2", toString: "min2" }
        , { name: "Auto", toString: "auto" }
        , { name: "Always", toString: "always" }
        ]
    }
  , { name: "RoundingPriority"
    , constructors:
        [ { name: "Auto", toString: "auto" }
        , { name: "MorePrecision", toString: "morePrecision" }
        , { name: "LessPrecision", toString: "lessPrecision" }
        ]
    }
  , { name: "RoundingMode"
    , constructors:
        [ { name: "Ceil", toString: "ceil" }
        , { name: "Floor", toString: "floor" }
        , { name: "Expand", toString: "expand" }
        , { name: "Trunc", toString: "trunc" }
        , { name: "HalfCeil", toString: "halfCeil" }
        , { name: "HalfFloor", toString: "halfFloor" }
        , { name: "HalfExpand", toString: "halfExpand" }
        , { name: "HalfTrunc", toString: "halfTrunc" }
        , { name: "HalfEven", toString: "halfEven" }
        ]
    }
  , { name: "TrailingZeroDisplay"
    , constructors:
        [ { name: "Auto", toString: "auto" }
        , { name: "StripIfInteger", toString: "stripIfInteger" }
        ]
    }
  , { name: "PluralRulesType"
    , constructors:
        [ { name: "Cardinal", toString: "cardinal" }
        , { name: "Ordinal", toString: "ordinal" }
        ]
    }
  , { name: "RelativeTimeUnit"
    , constructors:
        [ { name: "Seconds", toString: "seconds" }
        , { name: "Minutes", toString: "minutes" }
        , { name: "Hours", toString: "hours" }
        , { name: "Days", toString: "days" }
        , { name: "Weeks", toString: "weeks" }
        , { name: "Months", toString: "months" }
        , { name: "Quarters", toString: "quarters" }
        , { name: "Years", toString: "years" }
        ]
    }
  , { name: "Numeric"
    , constructors:
        [ { name: "Always", toString: "always" }
        , { name: "Auto", toString: "auto" }
        ]
    }
  , { name: "Granularity"
    , constructors:
        [ { name: "Grapheme", toString: "grapheme" }
        , { name: "Word", toString: "word" }
        , { name: "Sentence", toString: "sentence" }
        ]
    }
  ]
  where
  twoDigitNumeric =
    [ { name: "Numeric", toString: "numeric" }
    , { name: "TwoDigit", toString: "2-digit" }
    ]
  narrowShortLong =
    [ { name: "Narrow", toString: "narrow" }
    , { name: "Short", toString: "short" }
    , { name: "Long", toString: "long" }
    ]
  fullLongMediumShort =
    [ { name: "Full", toString: "full" }
    , { name: "Long", toString: "long" }
    , { name: "Medium", toString: "medium" }
    , { name: "Short", toString: "short" }
    ]

makeModule :: String -> Option -> Module Void
makeModule moduleName option = Partial.Unsafe.unsafePartial do
  Codegen.Monad.codegenModule moduleName do
    Codegen.Monad.exportTypeAll option.name
    Codegen.Monad.exportValue "toString"

    Codegen.Monad.importOpen "Prelude"

    Writer.tell
      [ Codegen.declData option.name []
          (option.constructors <#> \{ name } -> Codegen.dataCtor name [])

      , Codegen.declDerive Nothing [] "Eq" [ Codegen.typeCtor option.name ]

      , Codegen.declSignature "toString" do
          Codegen.typeForall [] do
            Codegen.typeArrow [ Codegen.typeCtor option.name ] (Codegen.typeCtor "String")

      , Codegen.declValue "toString" [] do
          Codegen.exprCase [ Codegen.exprSection ]
            ( option.constructors <#> \{ name, toString } ->
                Codegen.caseBranch [ Codegen.binderCtor name [] ] do
                  Codegen.exprString toString
            )
      ]

main :: Effect Unit
main = do
  projectRoot <- Process.lookupEnv "INTL_PROJECT_ROOT"
  rootDirectory <- Process.argv >>= \args -> case Array.index args 2 <|> projectRoot of
    Just path -> pure path
    Nothing -> Exception.throw "Expected path to output directory as first argument"
  let
    modulePath = [ "JS", "Intl", "Options" ]
    directoryPath = Path.concat ([ rootDirectory, "src" ] <> modulePath)
  Aff.launchAff_ do
    FS.Aff.mkdir' directoryPath { recursive: true, mode: Perms.mkPerms Perms.none Perms.none Perms.none }

  Foldable.for_ options \option -> do
    let
      moduleName = String.joinWith "." (modulePath <> [ option.name ])
      module_ = makeModule moduleName option
      filePath = Path.concat [ directoryPath, option.name <> ".purs" ]
      contents =
        String.joinWith "\n"
          [ "-- *** DO NOT EDIT! ***"
          , "-- This module is generated by ./script/generate-options.sh"
          , ""
          , Codegen.printModuleWithOptions (Codegen.defaultPrintOptions { pageWidth = 80 }) module_
          ]
    Aff.launchAff_ do
      FS.Aff.writeTextFile UTF8 filePath contents
