{ pkgs, inputs, username, system, ... }: {
  imports = [
    ./default-applications.nix
    ./docker.nix
    ./extrautils.nix
    ./filesystems.nix
    ./git.nix
    ./goxlr.nix
    ./hardware.nix
    ./home-manager.nix
    ./iscsi-shares.nix
    ./keybase.nix
    ./networking.nix
    ./obs-studio.nix
    ./ollama.nix
    ./plasma.nix
    ./scripts.nix
    ./spotify.nix
    ./stylix.nix
    ./zed.nix
    ./zsh.nix
  ];

  roles.system = {
    enable = true;
    kernelPackage = pkgs.linuxPackages_cachyos;
    systemKey = ".ssh/joey.desktop@jafner.net";
  };

  chaotic.mesa-git.enable = true;

  # User Programs
  programs.nh = { enable = true; flake = "/home/joey/Git/Jafner.net";};
  programs.chromium.enable = false;
  programs.steam.enable = true;
  programs.gamescope = { enable = true; capSysNice = false; };
  programs.gamemode = { enable = true; enableRenice = true; };
  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      vesktop
      libreoffice-qt6
      obsidian
      protonmail-desktop
      protonmail-bridge-gui
      losslesscut-bin
      prismlauncher
      protonup-qt
      aichat
      yek
    ];
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.home-manager.enable = true;
    programs.kitty.enable = true;
    programs.mpv.enable = true;
    programs.tmux = {
      enable = true;
      newSession = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      mouse = true;
      prefix = "C-b";
      resizeAmount = 2;
      plugins = with pkgs; [
        { plugin = tmuxPlugins.resurrect; }
        { plugin = tmuxPlugins.tmux-fzf; }
      ];
      shell = "${pkgs.zsh.shellPath}";
    };
    programs.nnn.enable = true;
    programs.mangohud = {
      enable = true;
      package = pkgs.mangohud;
      settingsPerApplication = {
        wine-Overwatch = {
          fps = false;
          fps_color_change = false;
          fps_text = "";
          fps_value = "59,239";
          fps_metrics = false;
          frame_timing = true;
          frame_timing_detailed = false;
          dynamic_frame_timing = true;
          frametime = false;
          histogram = true;
          show_fps_limit = false;
          gamemode = false;
          present_mode = false;
          vulkan_driver = false;
          engine_version = false;
          engine_short_names = false;
          exec_name = false;
          vkbasalt = false;
          wine = false;
          winesync = false;
          cpu_text = "";
          cpu_stats = false;
          core_load = false;
          core_bars = false;
          cpu_power = false;
          cpu_temp = false;
          gpu_text = "";
          gpu_stats = false;
          gpu_power = false;
          gpu_temp = false;
          gpu_core_clock = false;
          gpu_mem_clock = false;
          gpu_fan = false;
          gpu_voltage = false;
          throttling_status = false;
          throttling_status_graph = false;
          procmem = false;
          procmem_shared = false;
          procmem_virt = false;
          ram = false;
          vram = false;
          swap = false;
          network = false;
          time = false;
          time_format = "%r";
          time_no_label = true;
          graphs = "";

          toggle_hud = "Shift_R+F12";
          toggle_logging = "Shift_L+F2";
          toggle_hud_position = "Shift_R+F11";
          toggle_preset = "Shift_R+F10";
          toggle_fps_limit = "Shift_L+F1";
          reload_cfg = "Shift_L+F4";
          reload_log = "Shift_L+F3";
          reset_fps_metrics = "Shift_R+F9";
          output_folder = "/home/${username}/.config/MangoHud";

          width = 240;
          table_columns = 2;
          offset_x = 3;
          offset_y = 24;
          position = "top-left";
          legacy_layout = true;
          height = 0;
          horizontal = false;
          horizontal_stretch = false;
          hud_compact = false;
          hud_no_margin = true;
          cellpadding_y = 0;
          round_corners = 10;
          alpha = 1.000000;
          background_alpha = 1.000000;
          font_scale = 1.0;
          font_size = 24;
          font_size_text = 24;
          no_small_font = false;
          text_color = "cdd6f4";
          text_outline = true;
          text_outline_thickness = 1;
          text_outline_color = "1e1e2e";
          frametime_color = "b2bedc";
          frametime_text_color = "";
          background_color = "1d253a";
          battery_color = "ff0000";
          engine_color = "cdd6f4";
          cpu_color = "89b4fa";
          cpu_load_color = "a6e3a1, f9e2af, f38ba8";
          io_color = "f9e2af";
          media_player_color = "cdd6f4";
          gpu_color = "a6e3a1";
          gpu_load_color = "a6e3a1, f9e2af, f38ba8";
          fps_color = "a6e3a1, f9e2af, f38ba8";
          wine_color = "cba6f7";
          vram_color = "94e2d5";
        };
      };
      # OW HUD background: #1d253a
      # OW HUD text: #b2bedc
      # cat ~/.config/MangoHud/MangoHud.conf
    };
    nixGL = {
      vulkan.enable = true;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
    home = {
      enableNixpkgsReleaseCheck = false;
      preferXdgDirectories = true;
      username = "${username}";
      homeDirectory = "/home/${username}";
    };
    xdg.systemDirs.data = [ "/usr/share" ];
    home.stateVersion = "24.11";
  };

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };
  nix.settings.download-buffer-size = 1073741824;
  nixpkgs = {
    hostPlatform = system;
    overlays = [
      inputs.nixgl.overlay
      inputs.chaotic.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };
  services.pulseaudio.enable = false;

  # Hardware, input devices
  services.printing.enable = false;
  hardware.wooting.enable = true;
  hardware.xpadneo.enable = true;
  users.users."${username}".extraGroups = [ "input" ];

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    powerline-symbols
    nerd-fonts.symbols-only
  ];
}
