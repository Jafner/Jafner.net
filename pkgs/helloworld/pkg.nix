{ pkgs, ... }:
let
  manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
in
pkgs.rustPlatform.buildRustPackage {
  pname = manifest.name;
  version = manifest.version;
  cargoLock =
    let
      fixupLockFile = path: (builtins.readFile path);
    in
    {
      lockFileContents = fixupLockFile ./Cargo.lock;
    };
  #configureFlags = [ "--with-sdl2" ];
  src = pkgs.lib.cleanSource ./.;
}
