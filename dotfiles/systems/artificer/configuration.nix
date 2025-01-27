{ pkgs, sys, ... }: {
  imports = [
    ./docker.nix
  ];
  system.stateVersion = "24.11";
  environment.systemPackages = with pkgs; [
    git
  ];
  users.users."${sys.username}" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    description = "${sys.username}";
    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
      }; in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}