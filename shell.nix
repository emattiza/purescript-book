with import <nixpkgs> {};

let
  easy-ps = import (fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "678070816270726e2f428da873fe3f2736201f42";
    sha256 = "JEabdJ+3cZEYDVnzgMH/YFsaGtIBiCFcgvVO9XRgiY4=";
  }) {
    inherit pkgs;
  };
in
  stdenv.mkDerivation {
    name = "purescript-book";

    buildInputs = [
      easy-ps.purs
      easy-ps.spago
      easy-ps.pulp
      easy-ps.purescript-language-server
      yarn
    ];
  }
