{ stdenv, fetchFromGitHub }: 
stdenv.mkDerivation rec {
  pname = "romraider";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "RomRaider";
    repo = "RomRaider";
    rev = "bd77db3f1b32b359a6aaebb789001e71c43e9e02";
    sha256 = "sha256-ZN1L1pZJ2tvmxf5Imd5tAZWI2044bY8X6WoK2fBa2Yw=";
  };
  buildInputs = [  ];
  buildPhase = '''';
  installPhase = '''';
}