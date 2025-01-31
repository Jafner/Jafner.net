{ pkgs, sys, ... }: {
  system.stateVersion = "24.11";
  environment.systemPackages = with pkgs; [
    git
  ];
  users.users."${sys.username}" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    description = "${sys.username}";
    openssh.authorizedKeys.keys = sys.authorizedKeys;
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