{ pkgs, ... }: {
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
  ];
}