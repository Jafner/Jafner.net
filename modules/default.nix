{ ... }: {
  imports = [
    ./hardware/default.nix
    ./hyprland/hyprland.nix
    ./networkShares/default.nix
    ./plasma6/plasma6.nix
    ./programs/default.nix
    ./roles/default.nix
    ./services/default.nix
    ./default-applications.nix
  ];
}
