{ stdenv, fetchFromGitHub, libusb1, pkg-config }: 
stdenv.mkDerivation rec {
  pname = "j2534";
  version = "678252b";
  src = fetchFromGitHub {
    owner = "dschultzca";
    repo = "j2534";
    rev = "678252bbd0492f48df5e2d94e89cb5485b76d02f";
    sha256 = "sha256-V76NtilaKjiT203lX8J0xGG1AZzdZK8Y66hynlQtqW0=";
  };
  dontDisableStatic = true;
  buildInputs = [ libusb1 pkg-config ];
  buildPhase = {
    makefile = "j2534/makefile";
  };
  installPhase = ''
    mkdir -p $out/lib
    cp j2534.so $out/lib/${pname}.so
    install -D ${./99-j2534.rules} $out/lib/udev/rules.d/99-j2534.rules
  '';
}