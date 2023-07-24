module Main where

import Prelude

import Control.Alt ((<|>))
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmpty
import Data.Foldable as Foldable
import Data.Function as Function
import Data.String (Pattern(..))
import Data.String as String
import Data.String.Regex (Regex)
import Data.String.Regex as Regex
import Data.String.Regex.Flags as Regex.Flags
import Data.String.Regex.Unsafe as Regex.Unsafe
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff as Aff
import Effect.Class.Console as Console
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS.Aff
import Node.Path as Path
import Partial.Unsafe as Unsafe

main :: Effect Unit
main = Aff.launchAff_ do
  templateFile <-
    FS.Aff.readTextFile UTF8 (Path.concat [ "example", "README.template.md" ])
      <|> FS.Aff.readTextFile UTF8 (Path.concat [ "..", "..", "example", "README.template.md" ])

  exampleFile <-
    FS.Aff.readTextFile UTF8 (Path.concat [ "example", "Example.purs" ])
      <|> FS.Aff.readTextFile UTF8 (Path.concat [ "..", "..", "example", "Example.purs" ])

  let
    Tuple beforeExample afterExample = case String.split (Pattern "<!-- EXAMPLE -->") templateFile of
      [ before, after ] -> Tuple before after
      _ -> Unsafe.unsafeCrashWith "Invalid template file"

    lines = String.split (Pattern "\n") exampleFile
    groups =
      Array.groupBy ((==) `Function.on` Regex.test commentLinePrefix) lines

  Console.log "<!-- This file was generated using `script/generate-readme.sh` -->\n"

  Console.log beforeExample

  Foldable.for_ groups \group -> do
    let
      isCommentGroup = Regex.test commentLinePrefix (NonEmpty.head group)
      group' =
        if isCommentGroup then
          map removeCommentLinePrefix group
        else surroundCodeblockDelimiters group
    Foldable.for_ group' \line ->
      Console.log line

  Console.log afterExample

  where
  removeCommentLinePrefix :: String -> String
  removeCommentLinePrefix = Regex.replace commentLinePrefix ""

  surroundCodeblockDelimiters :: NonEmptyArray String -> NonEmptyArray String
  surroundCodeblockDelimiters group =
    NonEmpty.cons "```purs" (NonEmpty.snoc group "```")

commentLinePrefix :: Regex
commentLinePrefix = Regex.Unsafe.unsafeRegex "^\\s*--\\s*" Regex.Flags.noFlags