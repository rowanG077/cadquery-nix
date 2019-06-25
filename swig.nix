{ stdenv, fetchFromGitHub, autoconf, automake, libtool, bison, pcre, buildPackages }:

stdenv.mkDerivation rec {
  pname = "swig-${version}";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-3.0.9";
    sha256 = "1y63024npwb4x104fmryp7bxgl3z2g2zf952w8f2k9r6s82a7knf";
  };

  PCRE_CONFIG = "${pcre.dev}/bin/pcre-config";
  nativeBuildInputs = [ autoconf automake libtool bison ];
  buildInputs = [ pcre ];

  configureFlags = [ "--without-tcl" ];

  postPatch = ''
    # Disable ccache documentation as it need yodl
    sed -i '/man1/d' CCache/Makefile.in
  '';

  preConfigure = ''
    ./autogen.sh
  '';
}