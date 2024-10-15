{ pkgs, ... }:
{
 
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [];
    settings = {
      monitor = ",1920x1080@60,0x0,1";
      # Declare default applications
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$browser" = "flatpak run io.github.zen_browser.zen";
      "$bar" = "killall .waybar-wrapped; waybar"; #"$bar" = "killall .waybar-wrapped; waybar --style ~/.config/waybar/waybar.css";
      "$menu" = "wofi --show drun";
      "$notifd" = "mako";
      "$wallpaperd" = "swww-daemon";
      "$screenshot" = "grimblast copy area";

      # Scripted actions
      "$commandRebuildNix" = "$terminal sudo nixos-rebuild switch --flake ~/Jafner.net/nix";
      "$commandRebuildHomeManager" = "$terminal home-manager switch -b bak --flake ~/Jafner.net/nix";

      exec-once = [
        "$terminal"
        "$bar"
        "$notifd"
        "$wallpaperd"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = "5";
        gaps_out = "20";
        border_size = "2";
        allow_tearing = false;
        resize_on_border = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = "10";
        active_opacity = "1.0";
        inactive_opacity = "0.99";
        drop_shadow = true;
        shadow_range = "4";
        shadow_render_power = "3";
        blur = {
          enabled = true;
          size = "3";
          passes = "1";
          vibrancy = "0.1696";
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = "0";
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = "1";
        sensitivity = "0";
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };

      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod CTRL, S, exec, $screenshot"
        "$mainMod CTRL, Z, exec, $browser"
        "$mainMod CTRL ALT, N, exec, $commandRebuildNix"
        "$mainMod CTRL ALT, H, exec, $commandRebuildHomeManager"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod CTRL, right, workspace, +1"
        "$mainMod CTRL, left, workspace, -1"
        "$mainMod CTRL SHIFT, right, movetoworkspace, +1"
        "$mainMod CTRL SHIFT, left, movetoworkspace, -1"
        "$mainMod CTRL, B, exec, $bar" 
      ];

      windowrulev2 = "suppressevent maximize, class:.*";
    };
  };
}
