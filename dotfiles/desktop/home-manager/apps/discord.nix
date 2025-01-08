{ pkgs, ... }: {
  home.packages = with pkgs; [ vesktop ];
  #services.flatpak.packages = [ "dev.vencord.Vesktop/x86_64/stable" ];
}
