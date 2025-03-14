{ sys, pkgs, pkgs-unstable, ... }: {
  home-manager.users."${sys.username}" = {
    home.packages = with pkgs; [
      steam-tui
      lazycli
      lazygit
      dblab
      ncdu
      sysz
      fzf
      nethogs
    ] ++ [
      pkgs-unstable.lazyjournal
    ];
    programs.nnn = {
      enable = true;
    };
    programs.lazygit = {
      enable = true;
    };
    programs.gitui = {
      enable = true;
    };
    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        color_theme = "stylix";
        theme_background = true;
        update_ms = 500;
      };
    };
  };
  security.wrappers.nethogs = {
    source = "${pkgs.nethogs}/bin/nethogs";
    capabilities = "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe";
    owner = "${sys.username}";
    group = "users";
    permissions = "u+rx,g+x";
  };
}