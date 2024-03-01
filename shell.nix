let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  easy-ps = import sources.easy-purescript-nix {inherit pkgs;};
in
  pkgs.stdenv.mkDerivation {
    name = "purescript-book";

    buildInputs = [
      easy-ps.purs
      easy-ps.spago
      easy-ps.pulp
      easy-ps.purescript-language-server
      pkgs.npins
      pkgs.yarn
      pkgs.mdbook
    ];
  }
