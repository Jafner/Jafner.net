{ ... }:
{
  programs.plasma = {
    enable = true;
    shortcuts = {
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Fullscreen" = "Meta+F";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+=,Meta++" "Meta+=,Zoom In"];
      "kwin"."view_zoom_out" = "Meta+-";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
    };
    configFile = {
      "kcminputrc"."Libinput/1739/30382/DLL0704:01 06CB:76AE Mouse"."NaturalScroll" = true;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kwinrulesrc"."1"."Description" = "Start Kitty fullscreen";
      "kwinrulesrc"."1"."desktops" = "8174df23-1d2f-4d61-aef3-9b44ed596ed4";
      "kwinrulesrc"."1"."desktopsrule" = 3;
      "kwinrulesrc"."1"."fullscreenrule" = 3;
      "kwinrulesrc"."1"."wmclass" = "kitty";
      "kwinrulesrc"."1"."wmclassmatch" = 1;
      "kwinrulesrc"."2"."Description" = "Start Zen Browser fullscreen";
      "kwinrulesrc"."2"."desktops" = "ff42d652-e597-4e3c-9eb7-0cb2f5124dfe";
      "kwinrulesrc"."2"."desktopsrule" = 3;
      "kwinrulesrc"."2"."fullscreen" = true;
      "kwinrulesrc"."2"."fullscreenrule" = 3;
      "kwinrulesrc"."2"."title" = "Zen Browser";
      "kwinrulesrc"."2"."wmclass" = "zen-alpha";
      "kwinrulesrc"."2"."wmclassmatch" = 1;
      "kwinrulesrc"."3"."Description" = "Start Vesktop fullscreen";
      "kwinrulesrc"."3"."desktopsrule" = 3;
      "kwinrulesrc"."3"."fullscreenrule" = 3;
      "kwinrulesrc"."3"."wmclass" = "vesktop";
      "kwinrulesrc"."3"."wmclassmatch" = 1;
    };
  };
}
