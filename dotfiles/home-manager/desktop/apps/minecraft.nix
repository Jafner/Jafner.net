{ pkgs, ... }: {
  services.flatpak.packages = [
      "org.prismlauncher.PrismLauncher/x86_64/stable"
  ];
  home.packages = [
    pkgs.prismlauncher
  ];
}
