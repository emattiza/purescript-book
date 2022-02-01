{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "scripts"
, dependencies =
  [ "console"
  , "effect"
  , "foldable-traversable"
  , "node-path"
  , "node-fs"
  , "node-child-process"
  , "arrays"
  , "parallel"
  , "maybe"
  , "integers"
  , "prelude"
  ]
, packages = ./packages.dhall
, sources = [ "./**/*.purs" ] 
}
