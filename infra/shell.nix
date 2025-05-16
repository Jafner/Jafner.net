{ pkgs ? import <nixpkgs> { } }:
let
  cloudflare_api_token = "`cat /run/secrets/cloudflare/api_token`";
  terraform = pkgs.writers.writeBashBin "terraform" ''
    export TF_VAR_cloudflare_api_token=${cloudflare_api_token}
    ${pkgs.terraform}/bin/terraform "$@"
  '';
in
pkgs.mkShell {
  buildInputs = [ pkgs.terranix terraform ];
}
