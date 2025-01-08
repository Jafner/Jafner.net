{ pkgs, sys, ... }: {
  hardware.openrazer = {
    enable = true;
    users = [ "${sys.username}" ];
    batteryNotifier = {
      enable = true;
      frequency = 600;
      percentage = 40;
    };
  };
  environment.systemPackages = [ pkgs.razergenie ];
}
