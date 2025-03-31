{ pkgs, stdenv, ... }: stdenv.mkDerivation {
  name = "helloworld";
  src = pkgs.callPackage ./pkg.nix {  };
  nativeBuildInputs = with pkgs; [
    SDL2
    rustc
    cargo
  ];
  configureFlags = ["--with-sdl2"];
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
