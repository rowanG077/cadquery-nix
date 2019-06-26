{stdenv, lib, libsForQt59, callPackage, fetchFromGitHub, python37, python37Packages, spyder, makeWrapper}:
let
  cq-python = python37;
  cq-pythonPackages = python37Packages;
  cq-pyqt = libsForQt59.callPackage ./pyqt.nix {
    pythonPackages = cq-pythonPackages;
  };
  cadquery = callPackage  ./cadquery.nix {
    python = cq-python;
    pythonPackages = cq-pythonPackages;
  };
in
cq-pythonPackages.buildPythonPackage rec {
  name = "CQ-editor";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "CQ-editor";
    rev = "fe374972df2ccd6ac2e7e93415dc31f1dd28b265";
    sha256 = "11ljwqlla2i90mirw5i8568brchgsp0jjc37i93n521aafb0h633";
  };

  phases = [ "unpackPhase" "installPhase"];

  # Add the derivation to the PATH
  pythonPath = [
    cadquery
    cq-pythonPackages.pyparsing
    cq-pyqt
    cq-pythonPackages.pyqtgraph
    spyder
    cq-pythonPackages.pathpy
    cq-pythonPackages.Logbook
    cq-pythonPackages.qtconsole
    cq-pythonPackages.requests
  ];

  installPhase = ''
    buildPythonPath "$pythonPath"
    mkdir -p $out/CQ-editor
    mkdir -p $out/bin

    cp -r ./* $out/CQ-editor

    printf '%s\n%s\n%s %s $@\n' \
      "#!/usr/bin/env bash" \
      "export PYTHONPATH='$PYTHONPATH'" \
      "exec ${cq-python}/bin/${cq-python.executable}" \
      "$out/CQ-editor/run.py" \
      > $out/bin/CQ-editor

    chmod +x $out/bin/CQ-editor
  '';
}
