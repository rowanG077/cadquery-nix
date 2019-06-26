with import <nixpkgs> {};

# Make a new "derivation" that represents our shell
let
  cq-python = pkgs.python37;
  cq-pythonPackages = pkgs.python37Packages;
  cq-pyqt = pkgs.libsForQt59.callPackage ./pyqt.nix {
    pythonPackages = cq-pythonPackages;
  };
  cadquery = pkgs.callPackage  ./cadquery.nix {
    python = cq-python;
    pythonPackages = cq-pythonPackages;
  };
  cq-editor = pkgs.callPackage  ./cqEditor.nix {};
in
stdenv.mkDerivation {
  name = "test-environment";

  # Add the derivation to the PATH
  buildInputs = [
    cq-editor
  ];
}
