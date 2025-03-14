{ sys, pkgs, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs;
    [ # Productivity
      obsidian
      libreoffice-qt6
    ] ++ [ # Multimedia viewers
      vlc
    ] ++ [ # Messaging tools
      protonmail-desktop
      protonmail-bridge-gui
      vesktop
    ] ++ [ # System utilities
      wl-clipboard
      wl-color-picker
      dotool
    ];
  };
}