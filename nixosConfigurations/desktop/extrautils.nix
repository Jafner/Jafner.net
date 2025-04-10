{ pkgs, username, ... }: {
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      delta
      dust
      duf
      choose
      sd
      cheat
      tldr
      glances
      gtop
      hyperfine
      gping
      procs
      httpie
      curlie
      xh
      doggo
      nethogs
      ncdu
      sysz
      lazycli
    ];
    programs.bat = { enable = true; };
    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        color_theme = "stylix";
        theme_background = true;
        update_ms = 500;
      };
    };
    programs.eza = { enable = true; };
    programs.lsd = { enable = true; };
    programs.broot = { enable = true; };
    programs.fd = { enable = true; };
    programs.ripgrep = { enable = true; };
    programs.fzf = { enable = true; };
    programs.mcfly = { enable = true; };
    programs.jq = { enable = true; };
    programs.bottom = { enable = true; };
    programs.zoxide = { enable = true; };
    programs.lazygit = { enable = true; };
  };
  security.wrappers.nethogs = {
    source = "${pkgs.nethogs}/bin/nethogs";
    capabilities = "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe";
    owner = "${username}";
    group = "users";
    permissions = "u+rx,g+x";
  };
}
