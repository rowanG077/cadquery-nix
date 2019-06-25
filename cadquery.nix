{ stdenv, callPackage, fetchFromGitHub, python, pythonPackages }:
let
  pythonocc-core = callPackage  ./pythonocc.nix { python = python; };
in
pythonPackages.buildPythonPackage rec {
  pname = "cadquery";
  version = "unstable-2019-05-20";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = "cadquery";
    rev = "10118e563add4e60f21c882ff2a842757ceaacad";
    sha256 = "1b1g6qy05flrhxfzfp9x67d2m9y5zx4k2yf914qxzy48w7ggiscf";
  };

  propagatedBuildInputs = [ pythonocc-core pythonPackages.pyparsing ];
  checkInputs = [ pythonPackages.six ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Parametric CAD scripting framework based on PythonOCC";
    homepage = "https://github.com/CadQuery/cadquery";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
