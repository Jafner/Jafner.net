{ pkgs, ... }: {
  # Enable passwordless sudo
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

  # Configure user
  programs.zsh.enable = true;
  users.users.joey = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "joey";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    openssh.authorizedKeys.keys = let
      authorizedKeys = pkgs.fetchurl {
        url = "https://github.com/Jafner.keys";
        sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
      };
    in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };
}
