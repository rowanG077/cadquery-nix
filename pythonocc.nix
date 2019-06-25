{ stdenv, callPackage, fetchFromGitHub, cmake, ninja, python, opencascade, libGL, libGLU, libX11 }:
let
  cq-freetype = callPackage  ./freetype.nix { };
  cq-swig = callPackage  ./swig.nix { };
  cq-smesh = callPackage ./smesh.nix { };
in
stdenv.mkDerivation rec {
  pname = "pythonocc-core";
  version = "cadquery-version";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "pythonocc-core";
    rev = "454088c45e199da3c45e4ee431d8d8b4d53e08c9";
    sha256 = "0axb3r2cn3v1cmi0805y50k099lcw5adilmncp15fv4lfb94jm3d";
  };

  nativeBuildInputs = [ cmake cq-swig ninja ];
  buildInputs = [
    python opencascade cq-smesh
    cq-freetype libGL libGLU libX11
  ];

  cmakeFlags = [
    "-Wno-dev"
    "-DPYTHONOCC_INSTALL_DIRECTORY=${placeholder "out"}/${python.sitePackages}/OCC"
    "-DSMESH_INCLUDE_PATH=${cq-smesh}/include/smesh"
    "-DSMESH_LIB_PATH=${cq-smesh}/lib"
    "-DPYTHONOCC_WRAP_SMESH=TRUE"
  ];

  meta = with stdenv.lib; {
    description = "Python wrapper for the OpenCASCADE 3D modeling kernel";
    homepage = "https://github.com/tpaviot/pythonocc-core";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}