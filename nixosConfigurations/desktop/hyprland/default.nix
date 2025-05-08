{ inputs
, pkgs
, lib
, system
, username
, ...
}: {
  environment.systemPackages = with pkgs; [ catppuccin-sddm ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };
  programs.waybar = {
    enable = true;
  };
  home-manager.users.${username} = {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = lib.mkDefault {
        "$mod" = "SUPER";
        "$terminal" = "ghostty";
        "$fileManager" = "nnn";
        "$menu" = "rofi -show drun";
        monitor = [
          "Asus VG27A, 2560x1440@120,-2560x0,1"
          "Asus ROG XG27AQM, 2560x1440@270,0x0,1,vrr,3"
          "Dell S2716DG, 2560x1440@120,-2560x0,1"
        ];
        exec-once = [
          "waybar"
          "hyprpaper"
        ];
        permission = [
          "/usr/(bin|local/bin)/grim, screencopy, allow"
          "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow"
          "/usr/(bin|local/bin)/hyprpm, plugin, allow"
        ];
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          col.inactive_border = "rgba(595959aa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };
        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        animations = {
          enabled = true;
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
        master.new_status = "master";
        misc = {
          force_default_wallpaper = "-1";
          disable_hyprland_logo = false;
        };
        input = {
          kb_layout = "us";
          follow_mouse = "1";
          sensitivity = 0;
        };
        gestures = {
          workspace_swipe = false;
        };
        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, $menu"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.enableInspect = true;
      settings = {
        mainBar = {
          "layer" = "top"; # Waybar at top layer
          "position" = "bottom"; # Waybar position (top| bottom | left | right)
          height = 30; # Waybar height (to be removed for auto height)
          # "width" = 1280; # Waybar width
          spacing = 4; # Gaps between module (4px)
          # Choose the order of the module
          "modules-left" = [
            "sway/workspace"
            "sway/mode"
          ];
          "modules-center" = [
            "sway/window"
          ];
          "modules-right" = [
            "mpd"
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "power-profiles-daemon"
            "cpu"
            "memory"
            "temperature"
            "clock"
            "tray"
            "custom/power"
          ];
          "sway/workspace" = {
            "disable-scroll" = true;
            "all-output" = true;
            "warp-on-scroll" = false;
            format = "{name}: {icon}";
            "format-icon" = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "urgent" = "";
              "focused" = "";
              "default" = "";
            };
          };
          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };
          mpd = {
            format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|
        {queueLength}⸩ {volume}% ";
            "format-disconnected" = "Disconnected ";
            "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            "unknown-tag" = "N/A";
            interval = 5;
            "consume-icon" = {
              on = " ";
            };
            "random-icon" = {
              off = "<span color=\"#f53c3c\"></span> ";
              on = " ";
            };
            "repeat-icon" = {
              on = " ";
            };
            "single-icon" = {
              on = "1 ";
            };
            "state-icon" = {
              paused = "";
              playing = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "MPD (disconnected)";
          };
          idle_inhibitor = {
            format = "{icon}";
            "format-icon" = {
              activated = "";
              deactivated = "";
            };
          };
          tray = {
            # "icon-size" = 21;
            spacing = 10;
            # "icon" = {
            #   blueman = "bluetooth";
            #   TeleGramDesktop = "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png";
            # };
          };
          clock = {
            # "timezone" = "America/New_York";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%Y-%m-%d}";
          };
          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          memory = {
            format = "{}% ";
          };
          temperature = {
            # "thermal-zone" = 2;
            # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
            "critical-threshold" = 80;
            # "format-critical" = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            "format-icon" = ["" "" ""];
          };
          "power-profiles-daemon" = {
            format = "{icon}";
            "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
            tooltip = true;
            "format-icon" = {
              default = "";
              performance = "";
              balanced = "";
              "power-saver" = "";
            };
          };
          network = {
            # "interface" = "wlp2*"; # (Optional) To force the use of this interface
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr}/{cidr} ";
            "tooltip-format" = "{ifname} via {gwaddr} ";
            "format-linked" = "{ifname} (no IP) ";
            "format-disconnected" = "Disconnected ⚠";
            format = "{ifname}: {ipaddr}/{cidr}";
          };
          pulseaudio = {
            # "scroll-step" = 1; # %, can be a float
            format = "{volume}% {icon} {format_source}";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icon" = {
              headphone = "";
              "hands-free" = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            "on-click" = "pavucontrol";
          };
          "custom/media" = {
            format = "{icon} {text}";
            "return-type" = "json";
            "max-length" = 40;
            "format-icon" = {
              spotify = "";
              default = "🎜";
            };
            escape = true;
            exec = "mediaplayer 2> /dev/null";
          };
          "custom/power" = {
            format = "⏻ ";
            tooltip = false;
            menu = "on-click";
            "menu-file" = "$HOME/.config/waybar/power_menu.xml"; # Menu file in resource folder
            "menu-action" = {
              shutdown = "shutdown";
              reboot = "reboot";
              suspend = "systemctl suspend";
              hibernate = "systemctl hibernate";
            };
          };
        };
      };
    };
    home.file = {
      "power_menu.xml" = {
        target = ".config/waybar/power_menu.xml";
        source = ./powermenu.xml;
      };
      "mediaplayer.py" = {
        target = ".config/waybar/mediaplayer.py";
        source = ./mediaplayer.py;
      };
    };
  };
}
