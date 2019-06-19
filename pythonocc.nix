{ stdenv, callPackage, fetchFromGitHub, cmake, python, opencascade }:
let
  cq-freetype = callPackage  ./freetype.nix { };
  cq-swig = callPackage  ./swig.nix { };
  cq-smesh = callPackage ./smesh.nix { };
in
stdenv.mkDerivation rec {
  name = "pythonocc-core";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "pythonocc-core";
    rev = version;
    sha256 = "1b07j3bw3lnxk8dk3x1kkl2mbsmfwi98si84054038lflaaijzi0";
  };


  buildInputs = [
    python cmake opencascade
    cq-freetype cq-swig cq-smesh
  ];

  cmakeFlags = [
    "-Wno-dev"
    "-DPYTHONOCC_INSTALL_DIRECTORY=${placeholder "out"}/${python.sitePackages}/OCC"
    "-DASD=3"
    "-DSMESH_INCLUDE_PATH=${cq-smesh}/include/smesh"
    "-DSMESH_LIB_PATH=${cq-smesh}/lib"
    "-DPYTHONOCC_WRAP_SMESH=TRUE"
  ];
}