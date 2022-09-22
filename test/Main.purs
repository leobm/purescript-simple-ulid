module Test.Main where

import Prelude

import Data.String (length, take)
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Simple.ULID (genULID, genULID', toString)
import Test.Unit (test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Data.Number (pow)

main :: Effect Unit
main = runTest do
  test "Length is 26" do
    len <- liftEffect genULID <#> toString <#> length
    Assert.equal 26 len
  test "Same seed time becomes same time component" do
    timeSec <- liftEffect (genULID' $ Milliseconds 1469918176385.0) <#> toString <#> take 10
    Assert.equal "01ARYZ6S41" timeSec
  test "It can't encode time greater than (2 ^ 48) - 1" do
    Assert.expectFailure "Received valid seed time" do
      void $ liftEffect $ genULID' $ Milliseconds $ pow 2.0 48.0
