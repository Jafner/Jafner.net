{ sys, pkgs, ... }: {
  users.users."${sys.username}" = {
    isNormalUser = true;
    description = "${sys.username}";
    extraGroups = [ "networkmanager" "wheel" ];
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

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = pkgs.lib.mkForce "yes";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
