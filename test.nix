with import <nixpkgs> {};
let
  pythonocc = pkgs.callPackage  ./pythonocc.nix { python = pkgs.python37; };
in
stdenv.mkDerivation rec {
  name = "CQ-editor";

  # Add the derivation to the PATH
  buildInputs = [ pkgs.python37 pythonocc ];
}
