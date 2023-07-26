module JS.Intl.Internal.Class.StringArg
  ( class StringArg
  , from
  ) where

-- | More semantic class than `Show`
class StringArg a where
  from :: a -> String
