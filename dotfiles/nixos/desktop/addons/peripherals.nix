{ ... }: {
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
}