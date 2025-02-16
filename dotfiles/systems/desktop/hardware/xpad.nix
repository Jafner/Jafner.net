{ pkgs, ... }: {
  hardware.xpadneo.enable = true;
  environment.systemPackages = [ pkgs.gamepad-tool ];
}
