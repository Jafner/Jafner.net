{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    terranix.url = "github:terranix/terranix";
  };
  outputs = { self, nixpkgs, terranix }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfreePredicate = _: true; };
  in {
    defaultPackage."x86_64-linux" = self.terraformConfigurations.main;
    terraformConfigurations."main" = terranix.lib.terranixConfiguration {
      system = "x86_64-linux";
      modules = [ ./main.nix ];
    };
    defaultApp.${system} = self.apps.${system}.apply;
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [ pkgs.terranix pkgs.opentofu self.packages."x86_64-linux".tf ];
      shellHook = ''
        export CLOUDFLARE_API_TOKEN=$(rbw get "Cloudflare API" --field "API Token")
      '';
    };
    packages."x86_64-linux".tf = pkgs.writers.writeBashBin "tf" ''
      export CLOUDFLARE_API_TOKEN=$(rbw get "Cloudflare API" --field "API Token")
      ${pkgs.terraform}/bin/terraform "$@"
    '';
  };
}
