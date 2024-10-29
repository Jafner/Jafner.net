{ pkgs, ... }: {
  home.packages = with pkgs; [ waybar ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 30;
        margin-left = 0;
        margin-right = 0;
        modules-left = [ "custom/appmenu" "wlr/taskbar" "hyprland/window" "tray" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "clock"
          "custom/power"
        ];
        "hyprland/workspaces" = {
          active-only = false;
          on-click = "activate";
          format = "{}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 3;
          };
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = [
            "kitty"
          ];
          app_ids-mapping = {};
          rewrite = {};
        };
        "hyprland/window" = {
          rewrite = {};
          separate-outputs = true;
        };
        "custom/appmenu" = {
          format = "     "; # Manual padding to move it further from left edge
          on-click = "wofi --show drun";
        };
        "custom/exit" = {
          format = "     "; # Manual padding to move it further from right edge
          on-click = "wlogout";
          tooltip-format = "Power Menu";
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = " ";
            unlocked = " ";
          };
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = ''{:%Y-%m-%d}'';
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = ''{capacity}% {icon}'';
          format-full = ''{capacity}% {icon}'';
          format-charging = ''{capacity}%  '';
          format-plugged = ''{capacity}%  '';
          format-alt = ''{time} {icon}'';
          format-icons = [ " " " " " " " " " " ];
        };
        power-profiles-daemon = {
          format = ''{icon}'';
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = '' '';
            performance = '' '';
            balanced = '' '';
            power-saver = '' '';
          };
        };
        network = {
          format-wifi = ''{essid} ({signalStrength}%)  '';
          format-ethernet = ''{ipaddr}/{cidr}  '';
          tooltip-format = ''{ifname} via {gwaddr}  '';
          format-linked = ''{ifname} (No IP)  '';
          format-disconnected = ''Disconnected ⚠ '';
          format-alt = ''{ifname}: {ipaddr}/{cidr}'';
          on-click = "kitty --class floating --override initial_window_width=400 --override initial_window_height=400 --override remember_window_size=false nmtui";
          on-click-right = "nm-connection-editor";
        };
        pulseaudio = {
          format = ''{volume}% {icon} {format_source}'';
          format-bluetooth = ''{volume}% {icon} {format_source}'';
          format-bluetooth-muted = ''{icon} {format_source}'';
          format-muted = ''{format_source}'';
          format-source = ''{volume}% '';
          format-source-muted = '' '';
          format-icons = {
            headphone = '' '';
            hands-free = '' '';
            headset = '' '';
            phone = '' '';
            portable = '' '';
            car = '' '';
            default = [ "" " " " " ];
          };
          on-click = ''pavucontrol'';
        };
        "custom/power" = {
          format = ''⏻ '';
          tooltip = false;
          menu = "on-click";
          menu-file = ''$HOME/.config/waybar/power_menu.xml'';
          menu-actions = {
            shutdown = "shutdown";
            reboot = "reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
          };
        };
      };
    };
  };
  # We want Stylix to do most of the heavy lifting for our styling,
  #   but we want to add a few snippets. So we're going to run waybar
  #   with '-c ~/.config/waybar/waybar.css', which will add our snippets
  #   and then source the original, default '~/.config/waybar/style.css' 
  #   created by Stylix.
  # home.file."waybar.css" = {
  #   target = ".config/waybar/waybar.css";
  #   source = ./waybar.css;
  # };
}
