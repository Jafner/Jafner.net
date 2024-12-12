{ pkgs, ... }: {
  # Configure mouse and touchpad
  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
  };
  services.goxlr-utility.enable = true;
  hardware.wooting.enable = true;
  hardware.xpadneo.enable = true;
  hardware.openrazer = {
    enable = true;
    users = [ "joey" ];
    batteryNotifier = {
      enable = true;
      frequency = 600;
      percentage = 40;
    };
  };
  environment.systemPackages = with pkgs; [
    razergenie
    gamepad-tool
    linuxKernel.packages.linux_6_11.xpadneo
  ];
}