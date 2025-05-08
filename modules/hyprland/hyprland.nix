{ pkgs
, config
, ...
}:
let
  cfg = config.modules.hyprland;
in
{
  options = with pkgs.lib; {
    modules.hyprland = {
      enable = mkEnableOption "hyprland";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    environment.systemPackages = with pkgs; [
      waybar
      mako
      libnotify
      swww
      rofi-wayland
    ];
    services = {
      xserver = {
        enable = true;
        videoDrivers = [ "amdgpu" ];
        excludePackages = [ pkgs.xterm ];
        xkb.layout = "us";
      };
      displayManager.sddm.wayland.enable = true;
    };
    programs.hyprland.enable = true;
    home-manager.users.${cfg.username} = {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        plugins = [ ];
        settings = {
          source = [
            "~/.config/hypr/custom.conf"
          ];
          monitor = [
            "DP-1, 2560x1440@270, 0x0, 1" # Primary display, Asus XG27AQM
            "DP-3, 2560x1440@120, -2560x0, 1" # Secondary (left) display, Asus VG27A
            "DP-2, 2560x1440@120, 2560x0, 1" # Tertiary (right) display, Dell S2716DG
          ];
          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };
          animations = {
            enabled = "yes, please :)";
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];
            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };
          master = {
            new_status = "master";
          };
          input = {
            kb_layout = "us";
            follow_mouse = 0;
            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          };
          bindd = [
            # Third argument is bind description
            "MOD4 SHIFT, R, Reload hyprland, exec, hyprctl reload"
            "MOD4 SHIFT CONTROL, R, Rebuild NixOS and switch, exec, kitty -T \"system rebuild\" nh os switch -s hyprland ~/Git/Jafner.net"
            "MOD4, Q, Launch terminal, exec, kitty"

            "MOD4, R, Open app launcher, exec, rofi -show drun"
            "MOD4, TAB, Open window selector, exec, rofi -show window"

            "MOD4, left, Move focus to window left, movefocus, l"
            "MOD4, right, Move focus to window right, movefocus, r"
            "MOD4, up, Move focus to window up, movefocus, u"
            "MOD4, down, Move focus to window down, movefocus, d"

            "Alt_L, numpad0, Forward the Alt_L+Num0 hotkey to OBS Studio, pass, class:^(com\.obsproject\.Studio)$"
          ];
          bindm = [
            # Binds with mouse (m) flag
            # middle mouse press = mouse:274
            # forward mouse side button press = mouse:276
            # rearward mouse side button press = mouse:275
            "ALT, mouse:274, movewindow"
          ];
          windowrulev2 = [
            "float, class:kitty, title:(system rebuild)"
            "suppressevent maximize, class:.*"
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          ];
        };
      };
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
    programs.kdeconnect.enable = true;
  };
}
