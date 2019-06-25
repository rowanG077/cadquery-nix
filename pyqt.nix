{ lib, fetchurl, fetchpatch, pythonPackages, pkgconfig
, qmake, lndir, qtbase, qtsvg, qtwebengine, dbus
, withConnectivity ? false, qtconnectivity
, withWebKit ? false, qtwebkit
, withWebSockets ? false, qtwebsockets
}:

let

  inherit (pythonPackages) buildPythonPackage python isPy3k dbus-python enum34;

  sip = pythonPackages.sip.override { sip-module = "PyQt5.sip"; };

in buildPythonPackage rec {
  pname = "PyQt";
  version = "5.9.2";
  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/PyQt5/PyQt-${version}/PyQt5_gpl-${version}.tar.gz";
    sha256 = "15439gxari6azbfql20ksz8h4gv23k3kfyjyr89h2yy9k32xm461";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig qmake lndir sip ];

  buildInputs = [ dbus sip ];

  doCheck = false;

  propagatedBuildInputs = [ qtbase qtsvg qtwebengine ]
    ++ lib.optional (!isPy3k) enum34
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets;

  configurePhase = ''
    runHook preConfigure
    mkdir -p $out
    lndir ${dbus-python} $out
    rm -rf "$out/nix-support"
    export PYTHONPATH=$PYTHONPATH:$out/${python.sitePackages}
    ${python.executable} configure.py  -w \
      --confirm-license \
      --dbus=${dbus.dev}/include/dbus-1.0 \
      --no-qml-plugin \
      --bindir=$out/bin \
      --destdir=$out/${python.sitePackages} \
      --stubsdir=$out/${python.sitePackages}/PyQt5 \
      --sipdir=$out/share/sip/PyQt5 \
      --designer-plugindir=$out/plugins/designer
    runHook postConfigure
  '';

  postInstall = ''
    ln -s ${sip}/${python.sitePackages}/PyQt5/sip.* $out/${python.sitePackages}/PyQt5/
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  enableParallelBuilding = true;
}