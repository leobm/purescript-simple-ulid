{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "simple-ulid"
, license = "MIT"
, repository = "https://github.com/oreshinya/purescript-simple-ulid"
, dependencies = [ 
    "test-unit",
    "exceptions", 
    "now", 
    "strings",
    "arrays",
    "datetime",
    "effect",
    "integers",
    "numbers",
    "prelude",
    "tailrec"
]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
