{ stdenv, fetchFromGitHub, cmake, ninja, opencascade }:

stdenv.mkDerivation rec {
  pname = "smesh";
  version = "6.7.6";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "smesh";
    rev = "6.7.6";
    sha256 = "1b07j3bw3lnxk8dk3x1kkl2mbsmfwi98si84054038lflaaijzi0";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ opencascade ];
}