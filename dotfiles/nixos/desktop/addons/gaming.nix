{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    lutris-unwrapped
    protonup-ng
  ];
}