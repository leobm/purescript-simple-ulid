module Simple.ULID
  ( ULID
  , genULID
  , genULID'
  , toString
  ) where


import Prelude

import Control.Monad.Rec.Class (Step(..), tailRec, tailRecM)
import Data.Array ((:))
import Data.DateTime.Instant (unInstant)
import Data.Int (floor, toNumber)
import Data.String (length)
import Data.String.CodeUnits (fromCharArray)
import Data.String.Unsafe (charAt)
import Data.Time.Duration (Milliseconds(..))
import Data.Number (pow, (%))
import Effect (Effect)
import Effect.Exception (error, throwException)
import Effect.Now (now)


newtype ULID = ULID String

derive newtype instance showULID :: Show ULID
derive newtype instance eqULID :: Eq ULID
derive newtype instance ordULID :: Ord ULID

genULID :: Effect ULID
genULID = now <#> unInstant >>= genULID'

genULID' :: Milliseconds -> Effect ULID
genULID' ms =
  append <$> timeSec ms <*> randSec <#> ULID

toString :: ULID -> String
toString (ULID str) = str

timeSec :: Milliseconds -> Effect String
timeSec (Milliseconds ms) = do
  when (ms > timeMax) do
    throwException $ error $ "cannot encode time greater than " <> show ms
  pure $ tailRec gen { rest: timeLength, chars: [], t: ms }
  where
    gen { rest: 0, chars } =
      Done $ fromCharArray chars
    gen { rest, chars, t } =
      let mod = t % encodingLength
          chars' = charAt (floor mod) encoding : chars
          t' = (t - mod) / encodingLength
       in Loop { rest: rest - 1, chars: chars', t: t' }

randSec :: Effect String
randSec =
  tailRecM gen { rest: randLength, chars: [] }
  where
    gen { rest: 0, chars } =
      pure $ Done $ fromCharArray chars
    gen { rest, chars } = do
      n <- prng
      let rand = floor $ n * encodingLength
          idx =
            if toNumber rand == encodingLength
              then rand - 1
              else rand
          chars' = charAt idx encoding : chars
      pure $ Loop { rest: rest - 1, chars: chars' }

encoding :: String
encoding = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

encodingLength :: Number
encodingLength = toNumber $ length encoding

timeMax :: Number
timeMax = (pow 2.0 48.0) - 1.0

timeLength :: Int
timeLength = 10

randLength :: Int
randLength = 16

foreign import prng :: Effect Number
