{ pkgs, ... }: {
  home.packages = with pkgs; [
    gamepad-tool
    linuxKernel.packages.linux_6_11.xpadneo
  ];
}