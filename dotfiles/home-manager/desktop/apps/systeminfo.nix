{ pkgs, ... }: {
  # services.flatpak.packages = [ 
  #   "io.missioncenter.MissionCenter/x86_64/stable"
  # ];
  home.packages = with pkgs; [ 
    amdgpu_top
    mission-center
  ];

  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      color_theme = "stylix";
      theme_background = true;
      update_ms = 500;
    };
  };

  xdg.desktopEntries = {
    btop = {
      exec = "${pkgs.kitty}/bin/kitty --override initial_window_width=800 --override initial_window_height=480 --override remember_window_size=no btop";
      icon = "utilities-system-monitor"; 
      name = "btop";
      categories = [ "Utility" "System" ]; 
      type = "Application";
    };
  };
}
