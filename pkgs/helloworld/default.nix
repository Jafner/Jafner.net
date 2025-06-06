{ pkgs
, stdenv
, ...
}:
stdenv.mkDerivation {
  name = "helloworld";
  src = pkgs.callPackage ./pkg.nix { };
  nativeBuildInputs = with pkgs; [
    rustc
    cargo
  ];
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
