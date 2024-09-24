{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"
  };
  outputs = { nixpkgs, ... }: {
    colmena.meta.nixpkgs = import nixpkgs { system = "x86_64-linux"; };
    colmena = { 
      meta = { nixpkgs = import nixpkgs { system = "x86_64-linux"; }; }; 
      defaults = { pkgs, ... }: { 
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
          settings.KbdInteractiveAuthentication = false;
        };
        users.users = {
          root.hashedPassword = "$6$M5J7E21L9VQvMUEs$tmsV2NRtQmEnEkD/gim.8ODzJHL1n59ZTGoTPBSQ.W40vVfA.BwReni5WP4zkbbagnV2Tzkt47IS/iTeznboi.";
          admin = {
            hashedPassword = "$6$BVCN7OEtet3lFORl$KHCg6Z9cUE6FyRKtcGp.ts2Z7KaBO6/RKUQhWxiYHCXvFdVIUlejCzTIQtnp9115pqKO4RRrUaIoQXMAOKGNQ.";
            isNormalUser = true;
            description = "admin";
            extraGroups = [ "networkmanager" "wheel" ];
            openssh.authorizedKeys.keys = let
              authorizedKeys = pkgs.fetchurl {
                url = "https://github.com/Jafner.keys";
                sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
              };
            in pkgs.lib.splitString "\n" (builtins.readFile
            authorizedKeys);
          };
        };

      };
      
    };
  };
}