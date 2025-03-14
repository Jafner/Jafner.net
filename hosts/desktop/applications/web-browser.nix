{ pkgs, sys, inputs, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = [ 
      inputs.zen-browser.packages."x86_64-linux".default
    ];
    programs.chromium.enable = true;
    programs.firefox.enable = true;
  };
}