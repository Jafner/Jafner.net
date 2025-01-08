{ pkgs, lib, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [  ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  home-manager.backupFileExtension = "backup";
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "04:00";
    randomizedDelaySec = "30min";
  };
}
