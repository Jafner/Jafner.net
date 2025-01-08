{ pkgs, ... }: {
  # Configure mouse and touchpad
  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
  };
  services.goxlr-utility.enable = true;
  hardware.wooting.enable = true;
  services.hardware.openrgb.enable = false;
  users.users."joey".extraGroups = [ "input" ];
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
  ];
}
