module JS.Intl.RelativeTimeUnit
  ( RelativeTimeUnit(..)
  ) where

import JS.Intl.Internal.Class.StringArg (class StringArg)

data RelativeTimeUnit
  = Seconds
  | Minutes
  | Hours
  | Days
  | Weeks
  | Months
  | Quarters
  | Years

instance StringArg RelativeTimeUnit where
  from = case _ of
    Seconds -> "seconds"
    Minutes -> "minutes"
    Hours -> "hours"
    Days -> "days"
    Weeks -> "weeks"
    Months -> "months"
    Quarters -> "quarters"
    Years -> "years"