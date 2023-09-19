with import <nixpkgs> {};

let
  easy-ps = import (fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "5dcea83eecb56241ed72e3631d47e87bb11e45b9";
    hash = "sha256-jUuy2OzmxegEn0KT3u1uf87eGGA33+of9HodIqS3PLY=";
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
