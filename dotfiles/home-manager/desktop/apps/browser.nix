{ inputs, ... }: {
  # services.flatpak.packages = [
  #   "io.github.zen_browser.zen/x86_64/stable"
  # ];
  programs.firefox = {
    enable = true;
  };
  programs.chromium = {
    enable = true;
  };
  home.packages = [
    inputs.zen-browser.packages."x86_64-linux".default
    #pkgs-unstable.zen-browser
  ];
}
