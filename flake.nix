{
  description = "Jafner.net Flake";
  inputs = {
    # Package repositories:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    "nixpkgs-24.11".url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Applications:
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    ghostty.url = "github:ghostty-org/ghostty";
    nixos-dns = {
      url = "github:Janik-Haag/nixos-dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, chaotic, self, ... }: {
    nixosConfigurations = {
      artificer = let
        sys = {
          username = "admin";
          hostname = "artificer";
          sshPrivateKey = ".ssh/admin@artificer";
          repoPath = "Jafner.net";
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        in inputs.nixpkgs.lib.nixosSystem {
          modules = [
            "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.nixos-dns.nixosModules.dns
            ./modules/system.nix
            ./modules/git.nix
            ./modules/sops.nix
            ./modules/docker.nix
            ./services/gitea/stack.nix
            ./services/gitea-runner/stack.nix
            ./services/vaultwarden/stack.nix
            ./services/monitoring/stack.nix
            ./services/traefik/stack.nix
          ];
          inherit system;
          specialArgs = {
            inherit inputs pkgs pkgs-unstable;
            sys = sys;
            git = {
              username = sys.username;
              realname = sys.hostname;
              email = "noreply@jafner.net";
              sshPrivateKey = sys.sshPrivateKey;
              signingKey = "";
            };
            sops = {
              username = sys.username;
              sshPrivateKey = sys.sshPrivateKey;
              repoRoot = "/home/admin/Jafner.net";
            };
            docker = {
              username = sys.username;
            };
            stacks = {
              appdata = "/appdata";
              monitoring = {

              };
            };
            repo = {
              path = "Jafner.net"; # Path to copy repo, relative to home.
            };
            traefik = {
              configFile = ./hosts/artificer/traefik_config.yaml;
            };
            gitea-runner = {
              tokenFile = ./hosts/artificer/registration.token;
            };
          };
        };
      champion = let
        sys = {
          username = "admin";
          hostname = "champion";
          sshPrivateKey = ".ssh/admin@champion";
          repoPath = "Jafner.net";
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = { allowUnfreePredicate = (_: true); };
        };
        in inputs.nixpkgs.lib.nixosSystem {
          modules = [
            "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.disko.nixosModules.disko
            {
              disko.devices = {
                disk.primary = {
                  device = "/dev/vda";
                  type = "disk";
                  content = {
                    type = "gpt";
                    partitions = {
                      boot = {
                        size = "1M";
                        type = "EF02";
                      };
                      root = {
                        name = "root";
                        size = "100%";
                        content = {
                          type = "filesystem";
                          format = "ext4";
                          mountpoint = "/";
                        };
                      };
                    };
                  };
                };
              };
            }
            ./modules/system.nix
            ./modules/git.nix
            ./modules/sops.nix
            ./modules/docker.nix
          ];
          inherit system;
          specialArgs = {
            inherit inputs pkgs pkgs-unstable;
            sys = sys;
            git = {
              username = sys.username;
              realname = sys.hostname;
              email = "noreply@jafner.net";
              sshPrivateKey = sys.sshPrivateKey;
              signingKey = "";
            };
            sops = {
              username = sys.username;
              sshPrivateKey = sys.sshPrivateKey;
              repoRoot = "/home/admin/Jafner.net";
            };
            docker = {
              username = sys.username;
            };
          };
        };
      fighter = let
        # TODO:
        # Gitea/runner
        # Homeassistant
        # plex
        # qbittorrent
        # send
        # stash
        # unifi
        # vaultwarden
        # zipline
        username = "admin";
        hostname = "fighter";
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfreePredicate = (_: true);
            allowUnfree = true;
          };
        };
        in inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            username = username;
            hostname = hostname;
          };
          modules = [ # Import modules from other flakes.
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            self.nixosModules.roles
            self.nixosModules.stacks
          ] ++ [ # Configure this system.
            {
              nixpkgs.config.allowUnfree = true;
            }
            { # Network shares
              sops.secrets."smb" = {
                sopsFile = ./hosts/desktop/secrets/smb.secrets;
                format = "binary";
                key = "";
                mode = "0440";
                owner = username;
              };
              environment.systemPackages = with pkgs; [ cifs-utils ];
              fileSystems = let
                automountOpts = [
                  "x-systemd.automount"
                  "noauto"
                  "x-systemd.idle-timeout=60"
                  "x-systemd.device-timeout=5s"
                  "x-systemd.mount-timeout=5s"
                ];
                permissionsOpts = [
                  "credentials=/run/secrets/smb"
                  "uid=1000"
                  "gid=1000"
                ]; in {
                "movies" = {
                  enable = false;
                  mountPoint = "/mnt/movies";
                  device = "//192.168.1.12/Movies";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "music" = {
                  enable = false;
                  mountPoint = "/mnt/music";
                  device = "//192.168.1.12/Music";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "shows" = {
                  enable = false;
                  mountPoint = "/mnt/shows";
                  device = "//192.168.1.12/Shows";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "av" = {
                  enable = true;
                  mountPoint = "/mnt/av";
                  device = "//192.168.1.12/AV";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "printing" = {
                  enable = false;
                  mountPoint = "/mnt/3dprinting";
                  device = "//192.168.1.12/3DPrinting";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "books" = {
                  enable = false;
                  mountPoint = "/mnt/books";
                  device = "//192.168.1.12/Text";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "torrenting" = {
                  enable = true;
                  mountPoint = "/mnt/torrenting";
                  device = "//192.168.1.12/Torrenting";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "archive" = {
                  enable = false;
                  mountPoint = "/mnt/archive";
                  device = "//192.168.1.12/Archive";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "recordings" = {
                  enable = true;
                  mountPoint = "/mnt/recordings";
                  device = "//192.168.1.12/Recordings";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
              };
            }
            { # Roles
              roles.system = {
                enable = true;
                authorizedKeysSource.url = "https://github.com/Jafner.keys";
                authorizedKeysSource.hash = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
                sshPrivateKeyPath = ".ssh/${username}@${hostname}";
              };
            }
            { # Stacks
              stacks.ai = {
                enable = true;
                paths.appdata = "/appdata/ai";
                domains.base = "jafner.net";
              };
              stacks.autopirate = {
                enable = true;
                paths = {
                  appdata = "/appdata/autopirate";
                  movies = "/mnt/movies";
                  shows = "/mnt/shows";
                  music = "/mnt/music";
                };
                domains = {
                  base = "jafner.net";
                };
              };
              stacks.books = {
                enable = true;
                paths.appdata = "/appdata/books";
                paths.books = "/mnt/books";
                domains.base = "jafner.net";
              };
              stacks.coder = {
                enable = true;
                secretsFiles.coder = ./hosts/fighter/secrets/coder.secrets;
                paths.appdata = "/appdata/coder";
                domains.base = "jafner.net";
              };
              stacks.gitea = {
                enable = true;
                secretsFiles.gitea = ./hosts/fighter/secrets/gitea.secrets;
                secretsFiles.postgres = ./hosts/fighter/secrets/gitea_postgres.secrets;
                paths.appdata = "/appdata/gitea";
                domains.base = "jafner.net";
              };
              stacks.gitea-runner = {
                enable = true;
                secretsFile = ./hosts/fighter/secrets/gitea-runner.token;
                domains.gitea-host = "git.jafner.net";
              };
              stacks.keycloak = {
                enable = true;
                keycloakAdminUsername = "jafner425@gmail.com";
                secretsFiles = {
                  keycloak = ./hosts/fighter/secrets/keycloak.secrets;
                  postgres = ./hosts/fighter/secrets/keycloak_postgres.secrets;
                  forwardauth = ./hosts/fighter/secrets/forwardauth.secrets;
                  forwardauth-privileged = ./hosts/fighter/secrets/forwardauth-privileged.secrets;
                };
                paths.appdata = "/appdata/keycloak";
                domains.base = "jafner.net";
              };
              stacks.minecraft = {
                enable = true;
                paths.appdata = "/appdata/minecraft";
              };
              stacks.traefik = {
                enable = true;
                secretsFile = ./hosts/fighter/secrets/traefik.secrets;
                extraConf = ./hosts/fighter/traefik_config.yaml;
                domainOwnerEmail = "jafner425@gmail.com";
                paths.appdata = "/appdata/traefik";
                domains.base = "jafner.net";
                domains.traefik = "traefik.jafner.net";
              };
            }
            {
              fileSystems = {
                "/" = {
                  device = "/dev/disk/by-uuid/88a3f223-ed42-4be1-a748-bb9e0f9007dc";
                  fsType = "ext4";
                };
                "/boot" = {
                  device = "/dev/disk/by-uuid/744D-0867";
                  fsType = "vfat";
                  options = [ "fmask=0077" "dmask=0077" ];
                };
              };
              swapDevices = [ { device = "/.swapfile"; size = 32*1024;} ];
              boot = {
                loader.systemd-boot.enable = true;
                initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
                initrd.kernelModules = [ ];
                kernelModules = [ "amdgpu" "kvm-amd" ];
                extraModulePackages = [ ];
              };
              hardware = {
                amdgpu.amdvlk.enable = false;
                graphics = {
                  enable = true;
                  enable32Bit = true;
                };
              };
              environment.systemPackages = with pkgs; [
                rocmPackages.rocm-smi
                rocmPackages.rocminfo
                amdgpu_top
              ];
              users.users."${username}".extraGroups = [ "video" "render" ];
              nixpkgs.hostPlatform = "x86_64-linux";
              hardware.cpu.amd.updateMicrocode = true;
              hardware.enableRedistributableFirmware = true;
            }
          ];
          inherit system;
        };
      desktop = let
        username = "joey";
        hostname = "desktop";
        system = "x86_64-linux";
        sshPrivateKeyPath = ".ssh/joey.desktop@jafner.net";
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nixgl.overlay
            inputs.chaotic.overlays.default
          ];
          config.allowUnfreePredicate = (_: true);
        };
        in nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ # Import modules from other flakes.
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.chaotic.nixosModules.default
          ] ++ [ # Configure this system.
            {
              chaotic.mesa-git.enable = false;
            }
            { # Configure nixpkgs
              nixpkgs.config.allowUnfree = true;
            }
            { # Role: System
              sops = {
                age.sshKeyPaths = [ "/home/${username}/${sshPrivateKeyPath}" ];
                age.generateKey = false;
              };
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  sops
                  age
                  ssh-to-age
                ];
                home.stateVersion = "24.11";
              };

              services.libinput = {
                enable = true;
                mouse.naturalScrolling = true;
                touchpad.naturalScrolling = true;
              };

              boot.kernelPackages = pkgs.linuxPackages_cachyos;
                # Read more: https://nixos.wiki/wiki/Linux_kernel
                # Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages

              environment.etc."current-nixos".source = ../.;
              environment.systemPackages = with pkgs; [
                coreutils
                git
                tree
                htop
                file
                fastfetch
                dig
                btop
                vim
                tree
              ];

              programs.nix-ld.enable = true;
              systemd.enableEmergencyMode = false;

              # Enable SSH server with exclusively key-based auth
              services.openssh = {
                enable = true;
                settings.PasswordAuthentication = false;
                settings.KbdInteractiveAuthentication = false;
              };

              users.users."${username}" = {
                isNormalUser = true;
                extraGroups = [ "networkmanager" "wheel" ];
                description = "${username}";
                openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
                  url = "https://github.com/Jafner.keys";
                  sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
                })); # Equivalent to `curl https://github.com/Jafner.keys > /home/$USER/.ssh/authorized_keys`
              };

              security.sudo = {
                enable = true;
                extraRules = [{
                  commands = [
                    {
                      command = "ALL";
                      options = [ "NOPASSWD" ];
                    }
                  ];
                  groups = [ "wheel" ];
                }];
              };

              time.timeZone = "America/Los_Angeles";
              i18n.defaultLocale = "en_US.UTF-8";
              i18n.extraLocaleSettings = {
                LC_ADDRESS = "en_US.UTF-8";
                LC_IDENTIFICATION = "en_US.UTF-8";
                LC_MEASUREMENT = "en_US.UTF-8";
                LC_MONETARY = "en_US.UTF-8";
                LC_NAME = "en_US.UTF-8";
                LC_NUMERIC = "en_US.UTF-8";
                LC_PAPER = "en_US.UTF-8";
                LC_TELEPHONE = "en_US.UTF-8";
                LC_TIME = "en_US.UTF-8";
              };

              nix.settings.experimental-features = [ "nix-command" "flakes" ];
              nix.settings.trusted-users = [ "root" "@wheel" ];
              nix.settings.auto-optimise-store = true;
              nix.extraOptions = ''
                accept-flake-config = true
                warn-dirty = false
              '';

              networking.hostName = hostname;
              networking.hosts = {
                "192.168.1.1" = [ "wizard" ];
                "192.168.1.12" = [ "paladin" ];
                "192.168.1.23" = [ "fighter" ];
                "192.168.1.135" = [ "desktop" ];
                "143.198.68.202" = [ "artificer" ];
                "172.245.108.219" = [ "champion" ];
              };

              system.stateVersion = "24.11";
            }
            { # Role: Desktop
              security.rtkit.enable = true;
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
              };
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
              programs.nh = { enable = true; flake = "/home/joey/Git/Jafner.net";};
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  vesktop
                  kdePackages.konsole
                  libreoffice-qt6
                  obsidian
                  protonmail-desktop
                  protonmail-bridge-gui
                  vlc
                  losslesscut-bin
                ];
                home.file.".ssh/config" = {
                  enable = true;
                  text = ''
                    Host *
                        ForwardAgent yes
                        IdentityFile ~/.ssh/joey.desktop@jafner.net
                  '';
                  target = ".ssh/config";
                };
                home.file.".ssh/profiles" = {
                  enable = true;
                  text = ''
                    vyos@wizard
                    admin@paladin
                    admin@fighter
                    admin@artificer
                    admin@champion
                  '';
                  target = ".ssh/profiles";
                };
                home = {
                  enableNixpkgsReleaseCheck = false;
                  preferXdgDirectories = true;
                  username = "${username}";
                  homeDirectory = "/home/${username}";
                };
                xdg.systemDirs.data = [ "/usr/share" ];
                programs.home-manager.enable = true;
                home.stateVersion = "24.11";
                programs.chromium = {
                  enable = false;
                  package = pkgs.chromium;
                };
                programs.firefox = {
                  enable = false;
                  package = pkgs.firefox;
                };
                programs.tmux = {
                  enable = false;
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
                programs.vim = {
                  enable = true;
                  defaultEditor = false;
                  settings = {
                    copyindent = true;
                    relativenumber = true;
                    expandtab = true;
                    tabstop = 2;
                  };
                  extraConfig = ''
                    set nocompatible
                    filetype on
                    filetype plugin on
                    filetype indent on
                    syntax on
                    set cursorline
                    set wildmenu
                    set wildmode=list:longest
                  '';
                };
                nixGL = {
                  vulkan.enable = true;
                  defaultWrapper = "mesa";
                  installScripts = [ "mesa" ];
                };
              };
            }
            { # Role: Gaming
              networking.firewall = {
                allowedTCPPorts = [ 25565 ];
                allowedUDPPorts = [ 25565 ];
              };
              programs.steam = {
                enable = true;
                extraPackages = [
                  pkgs.proton-ge-custom
                ];
                extraCompatPackages = [
                  pkgs.proton-ge-custom
                ];
              };
              programs.gamescope = {
                enable = false;
                capSysNice = false;
              };
              programs.gamemode = {
                enable = true;
                enableRenice = true;
              };
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  dolphin-emu
                  mgba
                  desmume
                  lutris
                  prismlauncher
                  minecraft-server
                  protonup-qt
                ];
                programs.nnn = {
                  enable = true;
                };
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
              };
            }
            { # Clipit
              sops.secrets.zipline = {
                sopsFile = ./hosts/desktop/secrets/zipline.token;
                key = "";
                mode = "0440";
                format = "binary";
                owner = username;
              };
              sops.secrets."cloudflare/id" = {
                sopsFile = ./hosts/desktop/secrets/cloudflare_id.token;
                key = "";
                mode = "0440";
                format = "binary";
                owner = username;
              };
              sops.secrets."cloudflare/token" = {
                sopsFile = ./hosts/desktop/secrets/cloudflare_stream.token;
                key = "";
                mode = "0440";
                format = "binary";
                owner = username;
              };
              home-manager.users.${username}.home.packages = with pkgs; [
                ffmpeg
                ( writeShellApplication {
                  name = "convert-for-discord"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                  runtimeInputs = [
                    libnotify
                    ffmpeg-full
                  ];
                  text = ''
                    #!/bin/bash

                    INPUT_FILE=$(realpath "$1")
                    FILE_PATH=$(dirname "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    #FILE_EXT="''$''\{FILE_NAME##*.}"
                    FILE_NAME="''$''\{FILE_NAME%.*}"
                    OUTFILE="$FILE_PATH/$FILE_NAME.mp4"

                    # Actual transcoding happens here:
                    notify-send -t 2000 "Transcode starting" "$FILE_NAME"
                    ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -map 0 -vf 'format=nv12,scale=-1:720,hwupload' -c:v h264_vaapi -b:v 8M -c:a copy -r 30 "$OUTFILE"
                    notify-send -t 4000 "Transcode complete" "$FILE_NAME"
                  '';
                } )
                ( writeShellApplication {
                  name = "convert-lossless"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                  runtimeInputs = [
                    libnotify
                    ffmpeg-full
                  ];
                  text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_PATH=$(dirname "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    #FILE_EXT="''$''\{FILE_NAME##*.}"
                    FILE_NAME="''$''\{FILE_NAME%.*}"
                    OUTFILE="$FILE_PATH/$FILE_NAME.mp4"

                    # Actual transcoding happens here:
                    notify-send -t 2000 "Transcode starting" "$FILE_NAME"
                    ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -movflags faststart -map 0 -c:v copy -c:a copy "$OUTFILE"
                    notify-send -t 4000 "Transcode complete" "$FILE_NAME"
                  '';
                } )
                ( writeShellApplication {
                  name = "send-to-zipline"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                  runtimeInputs = [
                    libnotify
                    curl
                    jq
                    wl-clipboard
                    wl-clip-persist
                  ];
                  text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    FILE_NAME="''$''\{FILE_NAME%.*}"

                    ZIPLINE_HOST_ROOT=https://zipline.jafner.net

                    ZIPLINE_TOKEN="$(cat /run/secrets/zipline)"

                    RESPONSE=$(curl \
                        --header "authorization: $ZIPLINE_TOKEN" \
                        $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
                        --header "Content-Type: multipart/form-data" \
                        --header "Format: name" \
                        --header "Embed: true" \
                        --header "Original-Name: true")
                    LINK=$(echo "$RESPONSE" | jq -r .'files[0]')
                    notify-send -t 4000 "Zipline - Upload complete." "Link copied to clipboard: $LINK"
                    echo "[$FILE_NAME]($LINK)"
                  '';
                } )
                ( writeShellApplication {
                  name = "send-to-cloudflare"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                  runtimeInputs = [
                    libnotify
                    curl
                    jq
                    wl-clipboard
                    wl-clip-persist
                  ];
                  text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    FILE_NAME="''$''\{FILE_NAME%.*}"

                    CF_TOKEN="$(cat /run/secrets/cloudflare/token)"
                    CF_ID="$(cat /run/secrets/cloudflare/id)"

                    notify-send -t 2000 "Cloudflare - Beginning upload."

                    # shellcheck disable=SC2086
                    RESPONSE=$(curl -X POST \
                    --header "Authorization: Bearer $CF_TOKEN" \
                    --form "file=@$INPUT_FILE" \
                    https://api.cloudflare.com/client/v4/accounts/$CF_ID/stream
                    )
                    LINK=$(echo "$RESPONSE" | jq -r '.result.preview')
                    notify-send -t 4000 "Cloudflare - Upload complete." "Link copied to clipboard: $LINK"
                    echo "[$FILE_NAME]($LINK)"
                  '';
                } )
                ( writeShellApplication {
                  name = "send-to-zipline-and-cloudflare"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                  runtimeInputs = [
                    libnotify
                    curl
                    jq
                    wl-clipboard
                    wl-clip-persist
                  ];
                  text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    FILE_NAME="''$''\{FILE_NAME%.*}"

                    ZIPLINE_HOST_ROOT=https://zipline.jafner.net

                    CF_TOKEN="$(cat /run/secrets/cloudflare/token)"
                    CF_ID="$(cat /run/secrets/cloudflare/id)"
                    ZIPLINE_TOKEN="$(cat /run/secrets/zipline)"


                    notify-send -t 2000 "Zipline and Cloudflare - Beginning upload."
                    RESPONSE=$(curl \
                        --header "authorization: $ZIPLINE_TOKEN" \
                        $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
                        --header "Content-Type: multipart/form-data" \
                        --header "Format: name" \
                        --header "Embed: true" \
                        --header "Original-Name: true")
                    LINK=$(echo "$RESPONSE" | jq -r .'files[0]' | sed 's/\/u\//\/r\//')

                    # shellcheck disable=SC2086
                    RESPONSE=$(curl -X POST \
                    --header "Authorization: Bearer $CF_TOKEN" \
                    --data "{\"url\":\"$LINK\",\"meta\":{\"name\":\"$FILE_NAME\"}}" \
                    https://api.cloudflare.com/client/v4/accounts/$CF_ID/stream/copy
                    )
                    LINK=$(echo "$RESPONSE" | jq -r '.result.preview')
                    notify-send -t 4000 "Zipline and Cloudflare - Upload complete." "Link copied to clipboard: $LINK"
                    echo "[$FILE_NAME]($LINK)"
                  '';
                } )
              ];
            }
            { # Default DE: Plasma6
              programs.kdeconnect.enable = true;
              programs.xwayland.enable = true;
              programs.partition-manager.enable = true;
              home-manager.users."${username}" = { # TODO: Identify which packages we would only use with Plasma6 (vs. Hyrpland)
                home.packages = with pkgs; [
                  kdePackages.kcalc
                  kdePackages.filelight
                  wl-clipboard
                  wl-color-picker
                  dotool
                ];
                home.file = { # Note: Will need to be integrated with any file manager that isn't dolphin
                  "run-video-script" = {
                    target = ".local/share/kio/servicemenus/run-video-script.desktop";
                    text = ''
                      [Desktop Entry]
                      Type=Service
                      MimeType=video/*;
                      Actions=convertForDiscord;convertLossless;sendToZipline;sendToCloudflare;sendToZiplineAndCloudflare;
                      X-KDE-Submenu=Run video script...

                      [Desktop Action convertForDiscord]
                      Name=Convert for Discord
                      Icon=video-mp4
                      Exec=kitty convert-for-discord "%f"

                      [Desktop Action convertLossless]
                      Name=Convert losslessly to MP4
                      Icon=video-mp4
                      Exec=kitty convert-lossless "%f"

                      [Desktop Action sendToZipline]
                      Name=Send to Zipline
                      Icon=video-mp4
                      Exec=send-to-zipline "%f" | wl-copy

                      [Desktop Action sendToCloudflare]
                      Name=Send to Cloudflare
                      Icon=video-mp4
                      Exec=send-to-cloudflare "%f" | wl-copy

                      [Desktop Action sendToZiplineAndCloudflare]
                      Name=Send to Zipline and Cloudflare
                      Icon=video-mp4
                      Exec=send-to-zipline-and-cloudflare "%f" | wl-copy
                    '';
                  };
                };
              };
              xdg.portal = {
                enable = true;
                wlr.enable = true;
                extraPortals = with pkgs; [
                  kdePackages.xdg-desktop-portal-kde
                ];
              };
              services = {
                desktopManager.plasma6.enable = true;
                displayManager = {
                  enable = true;
                  defaultSession = "plasma";
                  autoLogin.enable = true;
                  autoLogin.user = "${username}";
                  sddm = {
                    enable = true;
                    autoNumlock = true;
                    wayland.enable = true;
                    wayland.compositor = "kwin";
                  };
                };
                xserver = {
                  enable = false;
                  videoDrivers = [ "amdgpu" ];
                  excludePackages = [ pkgs.xterm ];
                  xkb = {
                    layout = "us";
                    variant = "";
                  };
                };
              };
              environment.plasma6.excludePackages = with pkgs.kdePackages; [
                elisa
                kate
                okular
                discover
              ];
              systemd.services = {
                "getty@tty1".enable = false;
                "autovt@tty1".enable = false;
              };
            }
            { # Specialisation: hyprland
              specialisation."hyprland".configuration = {
                environment.sessionVariables = {
                  NIXOS_OZONE_WL = "1";
                };
                programs.waybar = {
                  enable = true;
                };
                services = {
                  xserver = {
                    videoDrivers = [ "amdgpu" ];
                    excludePackages = [ pkgs.xterm ];
                    xkb.layout = "us";
                  };
                  displayManager.sddm.wayland.enable = true;
                };
                programs.kdeconnect.enable = true;
                programs.hyprland.enable = true;
                home-manager.users.${username} = {
                  services.dunst = {
                    enable = true;
                  };
                  programs.rofi = {
                    enable = true;
                    package = pkgs.rofi-wayland;
                  };
                  services.swww.enable = true;
                  wayland.windowManager.hyprland = {
                    enable = true;
                    xwayland.enable = true;
                    systemd.enable = true;
                    plugins = [];
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
                      bindd = [ # Third argument is bind description
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
                      bindm = [ # Binds with mouse (m) flag
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
              };
            }
            { # Bitwarden
              home-manager.users."${username}" = {
                programs.rbw = {
                  enable = true;
                  settings = {
                    base_url = "bitwarden.jafner.net";
                    email = "jafner425@gmail.com";
                    lock_timeout = 2592000;
                    pinentry = pkgs.pinentry-qt;
                  };
                };
                programs.wofi.enable = true;
                home.packages = with pkgs; [
                  rofi-rbw-wayland
                ];
                xdg.desktopEntries = {
                  rofi-rbw = {
                    exec = "${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";
                    icon = "/home/${username}/.icons/custom/bitwarden.png";
                    name = "Bitwarden";
                    categories = [ "Utility" "Security" ];
                    type = "Application";
                  };
                };
                home.file = {
                  "rofi-rbw.rc" = {
                    target = ".config/rofi-rbw.rc";
                    text = ''
                      action="type"
                      typing-key-delay=0
                      selector-args="-W 40% -H 30%"
                      selector="wofi"
                      clipboarder="wl-copy"
                      typer="dotool"
                      keybindings="Enter:type:username:enter:tab:type:password:enter:copy:totp"
                    '';
                  };
                  "bitwarden.png" = {
                    target = ".icons/custom/bitwarden.png";
                    source = pkgs.fetchurl {
                      url = "https://raw.githubusercontent.com/bitwarden/clients/refs/heads/main/apps/desktop/resources/icons/64x64.png";
                      sha256 = "sha256-ZEYwxeoL8doV4y3M6kAyfz+5IoDsZ+ci8m+Qghfdp9M=";
                    };
                  };
                };
              };
            }
            { # Git
              home-manager.users.${username}.programs.git = {
                enable = true;
                userName = "Joey Hafner";
                userEmail = "joey@jafner.net";
                extraConfig = {
                  init.defaultBranch = "main";
                  core.sshCommand = "ssh -i /home/${username}/${sshPrivateKeyPath}";
                  gpg.format = "ssh";
                  commit.gpgsign = true;
                  tag.gpgsign = true;
                  user.signingKey = "/home/${username}/${sshPrivateKeyPath}.pub";
                };
                delta.enable = true;
                delta.options.side-by-side = true;
              };
            }
            { # Stylix
              home-manager.users.${username} = {
                home.packages = with pkgs; [ base16-schemes ];
                # Use the following before running a switch to prevent clobbering:
                # rm ~/.gtkrc-2.0 ~/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/settings.ini ~/.config/gtk-4.0/gtk.css
                # if one run with backups has already been done, clean it up with:
                # rm ~/.gtkrc-2.0.backup ~/.config/gtk-3.0/settings.ini.backup ~/.config/gtk-3.0/gtk.css.backup ~/.config/gtk-4.0/settings.ini.backup ~/.config/gtk-4.0/gtk.css.backup
                stylix = {
                  enable = true;
                  autoEnable = true;
                  polarity = "dark";
                  image = ./assets/romb-3840x2160.png; # ../../assets/romb-3840x2160.png;
                  base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
                  fonts = {
                    sizes = {
                      applications = 10;
                      desktop = 10;
                      popups = 10;
                      terminal = 12;
                    };
                    monospace = {
                      name = "DejaVu Sans Mono";
                      package = pkgs.dejavu_fonts;
                    };
                    serif = {
                      name = "DejaVu Serif";
                      package = pkgs.dejavu_fonts;
                    };
                    sansSerif = {
                      name = "DejaVu Sans";
                      package = pkgs.dejavu_fonts;
                    };
                    emoji = {
                      name = "Noto Color Emoji";
                      package = pkgs.noto-fonts-color-emoji;
                    };
                  };
                  targets = {
                    bat.enable = true;
                    btop.enable = true;
                    firefox.enable = true;
                    firefox.profileNames = [ "Default" ];
                    fzf.enable = true;
                    gnome.enable = true;
                    gtk.enable = true;
                    kde.enable = true;
                    rofi.enable = true;
                    vesktop.enable = true;
                    vscode.enable = true;
                    wofi.enable = true;
                  };
                };
                # Use the following to get an ordered list of color codes from ~/.config/stylix/palette.json:
                #
                #   cat ~/.config/stylix/palette.json | jq 'to_entries | .[] | select(.key | contains("base")) | .value'
                # To convert that to the format expected by [genix7000](https://github.com/cab404/genix7000):
                # sed 's/^"/"\\#/' | tr '\n' ' '
              };
            }
            { # Zsh
              users.users."${username}".shell = pkgs.zsh;
              programs.zsh.enable = true;
              home-manager.users."${username}" = {
                programs.zsh = {
                  enable = true;
                  dotDir = ".config/zsh";
                  enableCompletion = true;
                  autosuggestion.enable = true;
                  syntaxHighlighting.enable = true;
                  history = {
                    share = true;
                    save = 10000;
                    size = 10000;
                    expireDuplicatesFirst = false;
                    extended = false;
                    ignoreAllDups = false;
                    ignoreDups = true;
                  };
                  initExtra = ''
                    bindkey '^[[1;5A' history-search-backward # Ctrl+Up-arrow
                    bindkey '^[[1;5B' history-search-forward # Ctrl+Down-arrow
                    bindkey '^[[1;5D' backward-word # Ctrl+Left-arrow
                    bindkey '^[[1;5C' forward-word # Ctrl+Right-arrow
                    bindkey '^[[H' beginning-of-line # Home
                    bindkey '^[[F' end-of-line # End
                    bindkey '^[w' kill-region # Delete
                    bindkey '^I^I' autosuggest-accept # Tab, Tab
                    bindkey '^[' autosuggest-clear # Esc
                    bindkey -s '^E' 'ssh $(cat ~/.ssh/profiles | fzf --multi)\n'
                    _fzf_compgen_path() {
                        fd --hidden --exclude .git . "$1"
                    }
                    _fzf_compgen_dir() {
                        fd --hidden --exclude .git . "$1"
                    }
                    eval "$(~/.nix-profile/bin/fzf --zsh)"
                    fastfetch
                  '';
                };
              };
            }
            { # Spotify
              networking.firewall.allowedTCPPorts = [ 57621 ];
              networking.firewall.allowedUDPPorts = [ 5353 ];
              home-manager.users.${username} = {
                home.packages = with pkgs; [
                  spotify-qt
                  ncspot
                  librespot
                ];
                systemd.user.services.librespot = {
                  Unit = {
                    Description = "Librespot (an open source Spotify client)";
                    Documentation = [ "https://github.com/librespot-org/librespot" "https://github.com/librespot-org/librespot/wiki/Options" ];
                  };
                  Service = {
                    Restart = "always";
                    RestartSec = 10;
                    ExecStart = "${pkgs.librespot}/bin/librespot --backend pulseaudio --system-cache /home/${username}/.spotify -j";
                  };
                };
              };
            }
            { # OBS-studio
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  ( writers.writePython3Bin "obs-toggle-recording" {
                    libraries = [
                      ( python312Packages.buildPythonPackage {
                        pname = "obsws_python";
                        version = "1.7.0";
                        src = fetchurl {
                          url = "https://files.pythonhosted.org/packages/22/29/dcb5286c9301eee8b72aee1e997761fb2cca9bf963fcd373acdfca353af3/obsws_python-1.7.0-py3-none-any.whl";
                          sha256 = "0jvqfvqgvqjsv0jsddj51m4wrinbrc2gbymmnmv9kfarfj7ly7g7";
                        };
                        format = "wheel";
                        doCheck = false;
                        buildInputs = [];
                        checkInputs = [];
                        nativeBuildInputs = [];
                        propagatedBuildInputs = [
                          ( python312Packages.buildPythonPackage {
                            pname = "tomli";
                            version = "2.0.2";
                            src = fetchurl {
                              url = "https://files.pythonhosted.org/packages/cf/db/ce8eda256fa131af12e0a76d481711abe4681b6923c27efb9a255c9e4594/tomli-2.0.2-py3-none-any.whl";
                              sha256 = "0f5ar8vfq7lkydj19am5ymxg11d00ql0kv5hj3v07lskbi429gif";
                            };
                            format = "wheel";
                            doCheck = false;
                            buildInputs = [];
                            checkInputs = [];
                            nativeBuildInputs = [];
                            propagatedBuildInputs = [];
                          } )
                          ( python312Packages.buildPythonPackage {
                            pname = "websocket-client";
                            version = "1.8.0";
                            src = fetchurl {
                              url = "https://files.pythonhosted.org/packages/5a/84/44687a29792a70e111c5c477230a72c4b957d88d16141199bf9acb7537a3/websocket_client-1.8.0-py3-none-any.whl";
                              sha256 = "09m5pwwi4bbwdv2vdhlc5k0737kskhnxyb5j17l9ii7mjz4lrd0p";
                            };
                            format = "wheel";
                            doCheck = false;
                            buildInputs = [];
                            checkInputs = [];
                            nativeBuildInputs = [];
                            propagatedBuildInputs = [];
                          } )
                        ];
                      } )
                    ];
                    } ''
                      import obsws_python as obs
                      client = obs.ReqClient(host='localhost', port=4455)
                      recording_status = client.get_record_status()
                      active = recording_status.output_active
                      paused = recording_status.output_paused

                      if not active:
                          client.start_record()
                      else:
                          client.toggle_record_pause()
                    '' )
                ];
                programs.obs-studio = {
                  enable = true;
                  plugins = with pkgs.obs-studio-plugins; [
                    obs-vaapi
                    obs-vkcapture
                    input-overlay
                    wlrobs
                  ];
                };
              };
            }
            { # Neo-coreutils
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
            { # Kitty
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  ( writeShellApplication {
                    name = "kitty-popup";
                    runtimeInputs = [];
                    text = ''
                      #!/bin/bash

                      ${pkgs.kitty}/bin/kitty \
                        --override initial_window_width=1280 \
                        --override initial_window_height=720 \
                        --override remember_window_size=no \
                        --class kitty-popup \
                        "$@"
                    '';
                  } )
                ];
                programs.kitty.enable = true;
              };
            }
            { # Keybase
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  keybase
                  keybase-gui
                ];
                services.keybase.enable = true;
              };
            }
            { # GoXLR-Utility
              services.goxlr-utility.enable = true;
              home-manager.users."${username}" = {
                home.packages = with pkgs; [ goxlr-utility ];
                systemd.user.services = {
                  goxlr-utility = {
                    Unit = {
                      Description = "Unofficial GoXLR App replacement for Linux, Windows and MacOS";
                      Documentation = [ "https://github.com/GoXLR-on-Linux/goxlr-utility" ];
                    };
                    Service = {
                      Restart = "always";
                      RestartSec = 30;
                      ExecStart = "${pkgs.goxlr-utility}/bin/goxlr-daemon";
                    };
                  };
                };
              };
            }
            { # Zed editor
              home-manager.users."${username}" = {
                home.packages = with pkgs; [ nixd sops ];
                programs.zed-editor = {
                  # https://mynixos.com/home-manager/options/programs.zed-editor
                  enable = true;
                  package = pkgs.zed-editor_git; # Temp: https://github.com/NixOS/nixpkgs/pull/392319
                  extensions = [ "Nix" "Catppuccin" ];
                  userSettings = {
                    tab_size = 2;
                    languages."Nix" = { "language_servers" = [ "!nil" "nixd" ]; };
                    theme = {
                      mode = "system";
                      dark = "Catppuccin Mocha";
                      light = "Catppuccin Mocha";
                    };
                    show_edit_predictions = false;
                    edit_predictions = {
                      mode = "subtle";
                    };
                    terminal = {
                      shell = { program = "zsh"; };
                    };
                    lsp = {
                      "nixd" = {
                        nixpkgs.expr = "import (builtins.getFlake \"/home/joey/Git/Jafner.net\").inputs.nixpkgs { } ";
                        formatting.command = "nixfmt";
                        options = {
                          nixos.expr = "(builtins.getFlake \"/home/joey/Git/Jafner.net\").nixosConfigurations.desktop.options";
                        };
                      };
                      "rust-analyzer" = {
                        "initialization_options" = {
                          "inlayHints" = {
                            "maxLength" = null;
                            "closureReturnTypeHints" = {
                              "enable" = "always";
                            };
                          };
                        };
                      };
                    };
                  };
                };
              };
            }
            { # Hardware, networking, filesystems
              systemd.network = {
                enable = true;
                networks."50-enp4s0f0" = {
                  matchConfig.Name = "enp4s0f0";
                  address = [
                    "192.168.1.135/24"
                  ];
                  routes = [
                    { Gateway = "192.168.1.1"; }
                  ];
                  linkConfig.RequiredForOnline = "routable";
                };
              };
              networking.useNetworkd = true;
              networking.useDHCP = false;
              boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
              boot.loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
              };
              boot.kernelModules = [ "amdgpu" "kvm-amd" ];
              hardware.enableRedistributableFirmware = true;
              hardware.cpu.amd.updateMicrocode = true;
              hardware.graphics = {
                enable = true;
                enable32Bit = true;
              };
              environment.systemPackages = with pkgs; [
                rocmPackages.rocm-smi
                rocmPackages.rocminfo
                amdgpu_top
              ];
              environment.variables = {
                AMD_VULKAN_ICD = "RADV";
              };
              nix.settings.download-buffer-size = 1073741824;
              fileSystems = {
                "/" = {
                  device = "/dev/disk/by-uuid/e29ec340-6231-4afe-91a8-aaa2da613282";
                  fsType = "ext4";
                };

                "/boot" = {
                  device = "/dev/disk/by-partuuid/ff24dcbc-39e9-4bbe-b013-50d755c9d13d";
                  fsType = "vfat";
                  options = [ "fmask=0077" "dmask=0077" ];
                };

                "/data" = {
                  device = "/dev/disk/by-uuid/f023ae02-7742-4e13-a8ea-c1ea634436fa";
                  fsType = "btrfs";
                };
              };
              swapDevices = [ { device = "/dev/disk/by-uuid/73e8e737-1c5c-4ead-80c6-e616be538145"; } ];
            }
            { # Home-manager
              home-manager.users."${username}" = {
                home.packages = [
                  inputs.deploy-rs.packages."${system}".deploy-rs
                  inputs.zen-browser.packages."${system}".default
                ];
              };
              home-manager.sharedModules = [
                inputs.stylix.homeManagerModules.stylix
                inputs.chaotic.homeManagerModules.default
              ];
              home-manager.backupFileExtension = "bk";
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            { # Network shares
              services.openiscsi = {
                enable = true;
                name = hostname;
                discoverPortal = "192.168.1.12";
              };
              systemd.services = {
                iscsi-autoconnect = {
                  description = "Log into iSCSI target iqn.2020-03.net.jafner:joey-desktop";
                  after = [ "network.target" "iscsid.service" ];
                  wants = [ "iscsid.service" ];
                  serviceConfig = {
                    ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 192.168.1.12:3260";
                    ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2020-03.net.jafner:joey-desktop -p 192.168.1.12:3260 --login";
                    ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2020-03.net.jafner:joey-desktop -p 192.168.1.12:3260 --logout";
                    Restart = "on-failure";
                    RemainAfterExit = true;
                  };
                };
              };
              sops.secrets."smb" = {
                sopsFile = ./hosts/desktop/secrets/smb.secrets;
                format = "binary";
                key = "";
                mode = "0440";
                owner = username;
              };
              environment.systemPackages = with pkgs; [ cifs-utils ];
              fileSystems = let
                automountOpts = [
                  "x-systemd.automount"
                  "noauto"
                  "x-systemd.idle-timeout=60"
                  "x-systemd.device-timeout=5s"
                  "x-systemd.mount-timeout=5s"
                ];
                permissionsOpts = [
                  "credentials=/run/secrets/smb"
                  "uid=1000"
                  "gid=1000"
                ]; in {
                "movies" = {
                  enable = false;
                  mountPoint = "/mnt/movies";
                  device = "//192.168.1.12/Movies";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "music" = {
                  enable = false;
                  mountPoint = "/mnt/music";
                  device = "//192.168.1.12/Music";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "shows" = {
                  enable = false;
                  mountPoint = "/mnt/shows";
                  device = "//192.168.1.12/Shows";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "av" = {
                  enable = true;
                  mountPoint = "/mnt/av";
                  device = "//192.168.1.12/AV";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "printing" = {
                  enable = false;
                  mountPoint = "/mnt/3dprinting";
                  device = "//192.168.1.12/3DPrinting";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "books" = {
                  enable = false;
                  mountPoint = "/mnt/books";
                  device = "//192.168.1.12/Text";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "torrenting" = {
                  enable = true;
                  mountPoint = "/mnt/torrenting";
                  device = "//192.168.1.12/Torrenting";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "archive" = {
                  enable = false;
                  mountPoint = "/mnt/archive";
                  device = "//192.168.1.12/Archive";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "recordings" = {
                  enable = true;
                  mountPoint = "/mnt/recordings";
                  device = "//192.168.1.12/Recordings";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
              };
            }
          ];
        };
      desktop-hyprland = let
        username = "joey";
        hostname = "desktop";
        system = "x86_64-linux";
        sshPrivateKeyPath = ".ssh/joey.desktop@jafner.net";
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nixgl.overlay
            inputs.chaotic.overlays.default
          ];
          config.allowUnfreePredicate = (_: true);
        };
        in nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ # Import modules from other flakes.
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.chaotic.nixosModules.default
          ] ++ [ # Configure this system.
            { # Chaotic-nyx
              chaotic.mesa-git.enable = true;
            }
            { # Configure nixpkgs
              nixpkgs.config.allowUnfree = true;
            }
            { # Role: System
              sops = {
                age.sshKeyPaths = [ "/home/${username}/${sshPrivateKeyPath}" ];
                age.generateKey = false;
              };
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  sops
                  age
                  ssh-to-age
                ];
                home.stateVersion = "24.11";
              };

              services.libinput = {
                enable = true;
                mouse.naturalScrolling = true;
                touchpad.naturalScrolling = true;
              };

              boot.kernelPackages = pkgs.linuxPackages_cachyos;
                # Read more: https://nixos.wiki/wiki/Linux_kernel
                # Other options: https://mynixos.com/nixpkgs/packages/linuxKernel.packages

              environment.etc."current-nixos".source = ../.;
              environment.systemPackages = with pkgs; [
                coreutils
                git
                tree
                htop
                file
                fastfetch
                dig
                btop
                vim
                tree
              ];

              programs.nix-ld.enable = true;
              systemd.enableEmergencyMode = false;

              # Enable SSH server with exclusively key-based auth
              services.openssh = {
                enable = true;
                settings.PasswordAuthentication = false;
                settings.KbdInteractiveAuthentication = false;
              };

              users.users."${username}" = {
                isNormalUser = true;
                extraGroups = [ "networkmanager" "wheel" ];
                description = "${username}";
                openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
                  url = "https://github.com/Jafner.keys";
                  sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
                })); # Equivalent to `curl https://github.com/Jafner.keys > /home/$USER/.ssh/authorized_keys`
              };

              security.sudo = {
                enable = true;
                extraRules = [{
                  commands = [
                    {
                      command = "ALL";
                      options = [ "NOPASSWD" ];
                    }
                  ];
                  groups = [ "wheel" ];
                }];
              };

              time.timeZone = "America/Los_Angeles";
              i18n.defaultLocale = "en_US.UTF-8";
              i18n.extraLocaleSettings = {
                LC_ADDRESS = "en_US.UTF-8";
                LC_IDENTIFICATION = "en_US.UTF-8";
                LC_MEASUREMENT = "en_US.UTF-8";
                LC_MONETARY = "en_US.UTF-8";
                LC_NAME = "en_US.UTF-8";
                LC_NUMERIC = "en_US.UTF-8";
                LC_PAPER = "en_US.UTF-8";
                LC_TELEPHONE = "en_US.UTF-8";
                LC_TIME = "en_US.UTF-8";
              };

              nix.settings.experimental-features = [ "nix-command" "flakes" ];
              nix.settings.trusted-users = [ "root" "@wheel" ];
              nix.settings.auto-optimise-store = true;
              nix.extraOptions = ''
                accept-flake-config = true
                warn-dirty = false
              '';

              networking.hostName = hostname;
              networking.hosts = {
                "192.168.1.1" = [ "wizard" ];
                "192.168.1.12" = [ "paladin" ];
                "192.168.1.23" = [ "fighter" ];
                "192.168.1.135" = [ "desktop" ];
                "143.198.68.202" = [ "artificer" ];
                "172.245.108.219" = [ "champion" ];
              };

              system.stateVersion = "24.11";
            }
            { # Role: Desktop
              security.rtkit.enable = true;
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;
              };
              services.pulseaudio.enable = false;
              services.printing.enable = true;
              hardware.wooting.enable = true;
              hardware.xpadneo.enable = true;
              users.users."${username}".extraGroups = [ "input" ];
              programs.ydotool = {
                enable = true;
                group = "wheel";
              };
              fonts.packages = with pkgs; [
                font-awesome
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-emoji
                powerline-symbols
                nerd-fonts.symbols-only
              ];
              programs.nh = { enable = true; flake = "/home/joey/Git/Jafner.net";};
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  vesktop
                  kdePackages.konsole
                  libreoffice-qt6
                  obsidian
                  protonmail-desktop
                  protonmail-bridge-gui
                  vlc
                  losslesscut-bin
                ];
                home.file.".ssh/config" = {
                  enable = true;
                  text = ''
                    Host *
                        ForwardAgent yes
                        IdentityFile ~/.ssh/joey.desktop@jafner.net
                  '';
                  target = ".ssh/config";
                };
                home.file.".ssh/profiles" = {
                  enable = true;
                  text = ''
                    vyos@wizard
                    admin@paladin
                    admin@fighter
                    admin@artificer
                    admin@champion
                  '';
                  target = ".ssh/profiles";
                };
                home = {
                  enableNixpkgsReleaseCheck = false;
                  preferXdgDirectories = true;
                  username = "${username}";
                  homeDirectory = "/home/${username}";
                };
                xdg.systemDirs.data = [ "/usr/share" ];
                programs.home-manager.enable = true;
                home.stateVersion = "24.11";
                programs.chromium = {
                  enable = true;
                  package = pkgs.chromium;
                };
                programs.firefox = {
                  enable = true;
                  package = pkgs.firefox;
                };
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
                programs.vim = {
                  enable = true;
                  defaultEditor = true;
                  settings = {
                    copyindent = true;
                    relativenumber = true;
                    expandtab = true;
                    tabstop = 2;
                  };
                  extraConfig = ''
                    set nocompatible
                    filetype on
                    filetype plugin on
                    filetype indent on
                    syntax on
                    set cursorline
                    set wildmenu
                    set wildmode=list:longest
                  '';
                };
                nixGL = {
                  vulkan.enable = true;
                  defaultWrapper = "mesa";
                  installScripts = [ "mesa" ];
                };
              };
            }
            { # Role: Gaming
              networking.firewall = {
                allowedTCPPorts = [ 25565 ];
                allowedUDPPorts = [ 25565 ];
              };
              programs.steam = {
                enable = true;
                extraPackages = [
                  pkgs.proton-ge-custom
                ];
                extraCompatPackages = [
                  pkgs.proton-ge-custom
                ];
              };
              programs.gamescope = {
                enable = true;
                capSysNice = false;
              };
              programs.gamemode = {
                enable = true;
                enableRenice = true;
              };
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  dolphin-emu
                  mgba
                  desmume
                  lutris
                  prismlauncher
                  minecraft-server
                  protonup-qt
                ];
                programs.nnn = {
                  enable = true;
                };
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
              };
            }
            { # DE: hyprland
              environment.sessionVariables = {
                NIXOS_OZONE_WL = "1";
              };
              programs.waybar = {
                enable = true;
              };
              services = {
                xserver = {
                  videoDrivers = [ "amdgpu" ];
                  excludePackages = [ pkgs.xterm ];
                  xkb.layout = "us";
                };
                displayManager.sddm.wayland.enable = true;
              };
              programs.kdeconnect.enable = true;
              programs.hyprland.enable = true;
              home-manager.users.${username} = {
                services.dunst = {
                  enable = true;
                };
                programs.rofi = {
                  enable = true;
                  package = pkgs.rofi-wayland;
                };
                services.swww.enable = true;
                wayland.windowManager.hyprland = {
                  enable = true;
                  xwayland.enable = true;
                  systemd.enable = true;
                  plugins = [];
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
                    bindd = [ # Third argument is bind description
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
                    bindm = [ # Binds with mouse (m) flag
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
            }
            { # Bitwarden
              home-manager.users."${username}" = {
                programs.rbw = {
                  enable = true;
                  settings = {
                    base_url = "bitwarden.jafner.net";
                    email = "jafner425@gmail.com";
                    lock_timeout = 2592000;
                    pinentry = pkgs.pinentry-qt;
                  };
                };
                programs.wofi.enable = true;
                home.packages = with pkgs; [
                  rofi-rbw-wayland
                ];
                xdg.desktopEntries = {
                  rofi-rbw = {
                    exec = "${pkgs.rofi-rbw-wayland}/bin/rofi-rbw";
                    icon = "/home/${username}/.icons/custom/bitwarden.png";
                    name = "Bitwarden";
                    categories = [ "Utility" "Security" ];
                    type = "Application";
                  };
                };
                home.file = {
                  "rofi-rbw.rc" = {
                    target = ".config/rofi-rbw.rc";
                    text = ''
                      action="type"
                      typing-key-delay=0
                      selector-args="-W 40% -H 30%"
                      selector="wofi"
                      clipboarder="wl-copy"
                      typer="dotool"
                      keybindings="Enter:type:username:enter:tab:type:password:enter:copy:totp"
                    '';
                  };
                  "bitwarden.png" = {
                    target = ".icons/custom/bitwarden.png";
                    source = pkgs.fetchurl {
                      url = "https://raw.githubusercontent.com/bitwarden/clients/refs/heads/main/apps/desktop/resources/icons/64x64.png";
                      sha256 = "sha256-ZEYwxeoL8doV4y3M6kAyfz+5IoDsZ+ci8m+Qghfdp9M=";
                    };
                  };
                };
              };
            }
            { # Git
              home-manager.users.${username}.programs.git = {
                enable = true;
                userName = "Joey Hafner";
                userEmail = "joey@jafner.net";
                extraConfig = {
                  init.defaultBranch = "main";
                  core.sshCommand = "ssh -i $HOME/${sshPrivateKeyPath}";
                  gpg.format = "ssh";
                  commit.gpgsign = true;
                  tag.gpgsign = true;
                  user.signingKey = "${sshPrivateKeyPath}.pub";
                };
                delta.enable = true;
                delta.options.side-by-side = true;
              };
            }
            { # Stylix
              home-manager.users.${username} = {
                home.packages = with pkgs; [ base16-schemes ];
                # Use the following before running a switch to prevent clobbering:
                # rm ~/.gtkrc-2.0 ~/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/settings.ini ~/.config/gtk-4.0/gtk.css
                # if one run with backups has already been done, clean it up with:
                # rm ~/.gtkrc-2.0.backup ~/.config/gtk-3.0/settings.ini.backup ~/.config/gtk-3.0/gtk.css.backup ~/.config/gtk-4.0/settings.ini.backup ~/.config/gtk-4.0/gtk.css.backup
                stylix = {
                  enable = true;
                  autoEnable = true;
                  polarity = "dark";
                  image = ./assets/romb-3840x2160.png; # ../../assets/romb-3840x2160.png;
                  base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
                  fonts = {
                    sizes = {
                      applications = 10;
                      desktop = 10;
                      popups = 10;
                      terminal = 12;
                    };
                    monospace = {
                      name = "DejaVu Sans Mono";
                      package = pkgs.dejavu_fonts;
                    };
                    serif = {
                      name = "DejaVu Serif";
                      package = pkgs.dejavu_fonts;
                    };
                    sansSerif = {
                      name = "DejaVu Sans";
                      package = pkgs.dejavu_fonts;
                    };
                    emoji = {
                      name = "Noto Color Emoji";
                      package = pkgs.noto-fonts-color-emoji;
                    };
                  };
                  targets = {
                    bat.enable = true;
                    btop.enable = true;
                    firefox.enable = true;
                    firefox.profileNames = [ "Default" ];
                    fzf.enable = true;
                    gnome.enable = true;
                    gtk.enable = true;
                    kde.enable = true;
                    rofi.enable = true;
                    vesktop.enable = true;
                    vscode.enable = true;
                    wofi.enable = true;
                  };
                };
                # Use the following to get an ordered list of color codes from ~/.config/stylix/palette.json:
                #
                #   cat ~/.config/stylix/palette.json | jq 'to_entries | .[] | select(.key | contains("base")) | .value'
                # To convert that to the format expected by [genix7000](https://github.com/cab404/genix7000):
                # sed 's/^"/"\\#/' | tr '\n' ' '
              };
            }
            { # Clipit
              sops.secrets.zipline = {
                sopsFile = ./hosts/desktop/secrets/zipline.token;
                key = "";
                mode = "0440";
                format = "binary";
                owner = username;
              };
              sops.secrets."cloudflare/id" = {
                sopsFile = ./hosts/desktop/secrets/cloudflare_id.token;
                key = "";
                mode = "0440";
                format = "binary";
                owner = username;
              };
              sops.secrets."cloudflare/token" = {
                sopsFile = ./hosts/desktop/secrets/cloudflare_stream.token;
                key = "";
                mode = "0440";
                format = "binary";
                owner = username;
              };
              home-manager.users."${username}".home.packages = with pkgs; [
                ( writeShellApplication {
                name = "convert-for-discord"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                runtimeInputs = [
                    libnotify
                    ffmpeg-full
                ];
                text = ''
                    #!/bin/bash

                    INPUT_FILE=$(realpath "$1")
                    FILE_PATH=$(dirname "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    #FILE_EXT="''$''\{FILE_NAME##*.}"
                    FILE_NAME="''$''\{FILE_NAME%.*}"
                    OUTFILE="$FILE_PATH/$FILE_NAME.mp4"

                    # Actual transcoding happens here:
                    notify-send -t 2000 "Transcode starting" "$FILE_NAME"
                    ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -map 0 -vf 'format=nv12,scale=-1:720,hwupload' -c:v h264_vaapi -b:v 8M -c:a copy -r 30 "$OUTFILE"
                    notify-send -t 4000 "Transcode complete" "$FILE_NAME"
                '';
                } )
                ( writeShellApplication {
                name = "convert-lossless"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                runtimeInputs = [
                    libnotify
                    ffmpeg-full
                ];
                text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_PATH=$(dirname "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    #FILE_EXT="''$''\{FILE_NAME##*.}"
                    FILE_NAME="''$''\{FILE_NAME%.*}"
                    OUTFILE="$FILE_PATH/$FILE_NAME.mp4"

                    # Actual transcoding happens here:
                    notify-send -t 2000 "Transcode starting" "$FILE_NAME"
                    ffmpeg -hide_banner -vaapi_device /dev/dri/renderD128 -i "$INPUT_FILE" -movflags faststart -map 0 -c:v copy -c:a copy "$OUTFILE"
                    notify-send -t 4000 "Transcode complete" "$FILE_NAME"
                '';
                } )
                ( writeShellApplication {
                name = "send-to-zipline"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                runtimeInputs = [
                    libnotify
                    curl
                    jq
                    wl-clipboard
                    wl-clip-persist
                ];
                text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    FILE_NAME="''$''\{FILE_NAME%.*}"

                    ZIPLINE_HOST_ROOT=https://zipline.jafner.net

                    ZIPLINE_TOKEN="$(cat /run/secrets/zipline)"

                    RESPONSE=$(curl \
                        --header "authorization: $ZIPLINE_TOKEN" \
                        $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
                        --header "Content-Type: multipart/form-data" \
                        --header "Format: name" \
                        --header "Embed: true" \
                        --header "Original-Name: true")
                    LINK=$(echo "$RESPONSE" | jq -r .'files[0]')
                    notify-send -t 4000 "Zipline - Upload complete." "Link copied to clipboard: $LINK"
                    echo "[$FILE_NAME]($LINK)"
                '';
                } )
                ( writeShellApplication {
                name = "send-to-cloudflare"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                runtimeInputs = [
                    libnotify
                    curl
                    jq
                    wl-clipboard
                    wl-clip-persist
                ];
                text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    FILE_NAME="''$''\{FILE_NAME%.*}"

                    CF_TOKEN="$(cat /run/secrets/cloudflare/token)"
                    CF_ID="$(cat /run/secrets/cloudflare/id)"

                    notify-send -t 2000 "Cloudflare - Beginning upload."

                    # shellcheck disable=SC2086
                    RESPONSE=$(curl -X POST \
                    --header "Authorization: Bearer $CF_TOKEN" \
                    --form "file=@$INPUT_FILE" \
                    https://api.cloudflare.com/client/v4/accounts/$CF_ID/stream
                    )
                    LINK=$(echo "$RESPONSE" | jq -r '.result.preview')
                    notify-send -t 4000 "Cloudflare - Upload complete." "Link copied to clipboard: $LINK"
                    echo "[$FILE_NAME]($LINK)"
                '';
                } )
                ( writeShellApplication {
                name = "send-to-zipline-and-cloudflare"; # { filePath }: { none } (side-effect: transcodes & remuxes file to x264/mp4)
                runtimeInputs = [
                    libnotify
                    curl
                    jq
                    wl-clipboard
                    wl-clip-persist
                ];
                text = ''
                    #!/bin/bash

                    INPUT_FILE="''$''\{1:-INPUT_FILE}"
                    INPUT_FILE=$(realpath "$INPUT_FILE")
                    FILE_NAME=$(basename "$INPUT_FILE")
                    FILE_NAME="''$''\{FILE_NAME%.*}"

                    ZIPLINE_HOST_ROOT=https://zipline.jafner.net

                    CF_TOKEN="$(cat /run/secrets/cloudflare/token)"
                    CF_ID="$(cat /run/secrets/cloudflare/id)"
                    ZIPLINE_TOKEN="$(cat /run/secrets/zipline)"


                    notify-send -t 2000 "Zipline and Cloudflare - Beginning upload."
                    RESPONSE=$(curl \
                        --header "authorization: $ZIPLINE_TOKEN" \
                        $ZIPLINE_HOST_ROOT/api/upload -F "file=@$INPUT_FILE" \
                        --header "Content-Type: multipart/form-data" \
                        --header "Format: name" \
                        --header "Embed: true" \
                        --header "Original-Name: true")
                    LINK=$(echo "$RESPONSE" | jq -r .'files[0]' | sed 's/\/u\//\/r\//')

                    # shellcheck disable=SC2086
                    RESPONSE=$(curl -X POST \
                    --header "Authorization: Bearer $CF_TOKEN" \
                    --data "{\"url\":\"$LINK\",\"meta\":{\"name\":\"$FILE_NAME\"}}" \
                    https://api.cloudflare.com/client/v4/accounts/$CF_ID/stream/copy
                    )
                    LINK=$(echo "$RESPONSE" | jq -r '.result.preview')
                    notify-send -t 4000 "Zipline and Cloudflare - Upload complete." "Link copied to clipboard: $LINK"
                    echo "[$FILE_NAME]($LINK)"
                '';
                } )
              ];
            }
            { # Zsh
              users.users."${username}".shell = pkgs.zsh;
              programs.zsh.enable = true;
              home-manager.users."${username}" = {
                programs.zsh = {
                  enable = true;
                  dotDir = ".config/zsh";
                  enableCompletion = true;
                  autosuggestion.enable = true;
                  syntaxHighlighting.enable = true;
                  history = {
                    share = true;
                    save = 10000;
                    size = 10000;
                    expireDuplicatesFirst = false;
                    extended = false;
                    ignoreAllDups = false;
                    ignoreDups = true;
                  };
                  initExtra = ''
                    bindkey '^[[1;5A' history-search-backward # Ctrl+Up-arrow
                    bindkey '^[[1;5B' history-search-forward # Ctrl+Down-arrow
                    bindkey '^[[1;5D' backward-word # Ctrl+Left-arrow
                    bindkey '^[[1;5C' forward-word # Ctrl+Right-arrow
                    bindkey '^[[H' beginning-of-line # Home
                    bindkey '^[[F' end-of-line # End
                    bindkey '^[w' kill-region # Delete
                    bindkey '^I^I' autosuggest-accept # Tab, Tab
                    bindkey '^[' autosuggest-clear # Esc
                    bindkey -s '^E' 'ssh $(cat ~/.ssh/profiles | fzf --multi)\n'
                    _fzf_compgen_path() {
                        fd --hidden --exclude .git . "$1"
                    }
                    _fzf_compgen_dir() {
                        fd --hidden --exclude .git . "$1"
                    }
                    eval "$(~/.nix-profile/bin/fzf --zsh)"
                    fastfetch
                  '';
                };
              };
            }
            { # Spotify
              networking.firewall.allowedTCPPorts = [ 57621 ];
              networking.firewall.allowedUDPPorts = [ 5353 ];
              home-manager.users.${username} = {
                home.packages = with pkgs; [
                  spotify-qt
                  ncspot
                  librespot
                ];
                systemd.user.services.librespot = {
                  Unit = {
                    Description = "Librespot (an open source Spotify client)";
                    Documentation = [ "https://github.com/librespot-org/librespot" "https://github.com/librespot-org/librespot/wiki/Options" ];
                  };
                  Service = {
                    Restart = "always";
                    RestartSec = 10;
                    ExecStart = "${pkgs.librespot}/bin/librespot --backend pulseaudio --system-cache /home/${username}/.spotify -j";
                  };
                };
              };
            }
            { # OBS-studio
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  ( writers.writePython3Bin "obs-toggle-recording" {
                    libraries = [
                      ( python312Packages.buildPythonPackage {
                        pname = "obsws_python";
                        version = "1.7.0";
                        src = fetchurl {
                          url = "https://files.pythonhosted.org/packages/22/29/dcb5286c9301eee8b72aee1e997761fb2cca9bf963fcd373acdfca353af3/obsws_python-1.7.0-py3-none-any.whl";
                          sha256 = "0jvqfvqgvqjsv0jsddj51m4wrinbrc2gbymmnmv9kfarfj7ly7g7";
                        };
                        format = "wheel";
                        doCheck = false;
                        buildInputs = [];
                        checkInputs = [];
                        nativeBuildInputs = [];
                        propagatedBuildInputs = [
                          ( python312Packages.buildPythonPackage {
                            pname = "tomli";
                            version = "2.0.2";
                            src = fetchurl {
                              url = "https://files.pythonhosted.org/packages/cf/db/ce8eda256fa131af12e0a76d481711abe4681b6923c27efb9a255c9e4594/tomli-2.0.2-py3-none-any.whl";
                              sha256 = "0f5ar8vfq7lkydj19am5ymxg11d00ql0kv5hj3v07lskbi429gif";
                            };
                            format = "wheel";
                            doCheck = false;
                            buildInputs = [];
                            checkInputs = [];
                            nativeBuildInputs = [];
                            propagatedBuildInputs = [];
                          } )
                          ( python312Packages.buildPythonPackage {
                            pname = "websocket-client";
                            version = "1.8.0";
                            src = fetchurl {
                              url = "https://files.pythonhosted.org/packages/5a/84/44687a29792a70e111c5c477230a72c4b957d88d16141199bf9acb7537a3/websocket_client-1.8.0-py3-none-any.whl";
                              sha256 = "09m5pwwi4bbwdv2vdhlc5k0737kskhnxyb5j17l9ii7mjz4lrd0p";
                            };
                            format = "wheel";
                            doCheck = false;
                            buildInputs = [];
                            checkInputs = [];
                            nativeBuildInputs = [];
                            propagatedBuildInputs = [];
                          } )
                        ];
                      } )
                    ];
                    } ''
                      import obsws_python as obs
                      client = obs.ReqClient(host='localhost', port=4455)
                      recording_status = client.get_record_status()
                      active = recording_status.output_active
                      paused = recording_status.output_paused

                      if not active:
                          client.start_record()
                      else:
                          client.toggle_record_pause()
                    '' )
                ];
                programs.obs-studio = {
                  enable = true;
                  plugins = with pkgs.obs-studio-plugins; [
                    obs-vaapi
                    obs-vkcapture
                    input-overlay
                    wlrobs
                  ];
                };
              };
            }
            { # Neo-coreutils
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
            { # Kitty
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  ( writeShellApplication {
                    name = "kitty-popup";
                    runtimeInputs = [];
                    text = ''
                      #!/bin/bash

                      ${pkgs.kitty}/bin/kitty \
                        --override initial_window_width=1280 \
                        --override initial_window_height=720 \
                        --override remember_window_size=no \
                        --class kitty-popup \
                        "$@"
                    '';
                  } )
                ];
                programs.kitty.enable = true;
              };
            }
            { # Keybase
              home-manager.users."${username}" = {
                home.packages = with pkgs; [
                  keybase
                  keybase-gui
                ];
                services.keybase.enable = true;
              };
            }
            { # GoXLR-Utility
              services.goxlr-utility.enable = true;
              home-manager.users."${username}" = {
                home.packages = with pkgs; [ goxlr-utility ];
                systemd.user.services = {
                  goxlr-utility = {
                    Unit = {
                      Description = "Unofficial GoXLR App replacement for Linux, Windows and MacOS";
                      Documentation = [ "https://github.com/GoXLR-on-Linux/goxlr-utility" ];
                    };
                    Service = {
                      Restart = "always";
                      RestartSec = 30;
                      ExecStart = "${pkgs.goxlr-utility}/bin/goxlr-daemon";
                    };
                  };
                };
              };
            }
            { # Zed editor
              home-manager.users."${username}" = {
                home.packages = with pkgs; [ nixd sops ];
                programs.zed-editor = {
                  # https://mynixos.com/home-manager/options/programs.zed-editor
                  enable = true;
                  package = pkgs.zed-editor_git; # Temp: https://github.com/NixOS/nixpkgs/pull/392319
                  extensions = [ "Nix" "Catppuccin" ];
                  userSettings = {
                    tab_size = 2;
                    languages."Nix" = { "language_servers" = [ "!nil" "nixd" ]; };
                    theme = {
                      mode = "system";
                      dark = "Catppuccin Mocha";
                      light = "Catppuccin Mocha";
                    };
                    terminal = {
                      shell = { program = "zsh"; };
                    };
                    lsp = {
                      "nixd" = {
                        nixpkgs.expr = "import (builtins.getFlake \"/home/joey/Git/Jafner.net\").inputs.nixpkgs { } ";
                        formatting.command = "nixfmt";
                        options = {
                          nixos.expr = "(builtins.getFlake \"/home/joey/Git/Jafner.net\").nixosConfigurations.desktop.options";
                        };
                      };
                    };
                  };
                };
              };
            }
            { # Hardware, networking, filesystems
              systemd.network = {
                enable = true;
                networks."50-enp4s0f0" = {
                  matchConfig.Name = "enp4s0f0";
                  address = [
                    "192.168.1.135/24"
                  ];
                  routes = [
                    { Gateway = "192.168.1.1"; }
                  ];
                  linkConfig.RequiredForOnline = "routable";
                };
              };
              networking.useNetworkd = true;
              networking.useDHCP = false;
              boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
              boot.loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
              };
              boot.kernelModules = [ "amdgpu" "kvm-amd" ];
              hardware.enableRedistributableFirmware = true;
              hardware.cpu.amd.updateMicrocode = true;
              hardware.graphics = {
                enable = true;
                enable32Bit = true;
              };
              environment.systemPackages = with pkgs; [
                rocmPackages.rocm-smi
                rocmPackages.rocminfo
                amdgpu_top
              ];
              environment.variables = {
                AMD_VULKAN_ICD = "RADV";
              };
              nix.settings.download-buffer-size = 1073741824;
              fileSystems = {
                "/" = {
                  device = "/dev/disk/by-uuid/e29ec340-6231-4afe-91a8-aaa2da613282";
                  fsType = "ext4";
                };

                "/boot" = {
                  device = "/dev/disk/by-partuuid/ff24dcbc-39e9-4bbe-b013-50d755c9d13d";
                  fsType = "vfat";
                  options = [ "fmask=0077" "dmask=0077" ];
                };

                "/data" = {
                  device = "/dev/disk/by-uuid/f023ae02-7742-4e13-a8ea-c1ea634436fa";
                  fsType = "btrfs";
                };
              };
              swapDevices = [ { device = "/dev/disk/by-uuid/73e8e737-1c5c-4ead-80c6-e616be538145"; } ];
            }
            { # Home-manager
              home-manager.users."${username}" = {
                home.packages = [
                  inputs.deploy-rs.packages."${system}".deploy-rs
                  inputs.zen-browser.packages."${system}".default
                ];
              };
              home-manager.sharedModules = [
                inputs.stylix.homeManagerModules.stylix
                inputs.chaotic.homeManagerModules.default
              ];
              home-manager.backupFileExtension = "bk";
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            { # Network shares
              services.openiscsi = {
                enable = true;
                name = hostname;
                discoverPortal = "192.168.1.12";
              };
              systemd.services = {
                iscsi-autoconnect = {
                  description = "Log into iSCSI target iqn.2020-03.net.jafner:joey-desktop";
                  after = [ "network.target" "iscsid.service" ];
                  wants = [ "iscsid.service" ];
                  serviceConfig = {
                    ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 192.168.1.12:3260";
                    ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2020-03.net.jafner:joey-desktop -p 192.168.1.12:3260 --login";
                    ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2020-03.net.jafner:joey-desktop -p 192.168.1.12:3260 --logout";
                    Restart = "on-failure";
                    RemainAfterExit = true;
                  };
                };
              };
              sops.secrets."smb" = {
                sopsFile = ./hosts/desktop/secrets/smb.secrets;
                format = "binary";
                key = "";
                mode = "0440";
                owner = username;
              };
              environment.systemPackages = with pkgs; [ cifs-utils ];
              fileSystems = let
                automountOpts = [
                  "x-systemd.automount"
                  "noauto"
                  "x-systemd.idle-timeout=60"
                  "x-systemd.device-timeout=5s"
                  "x-systemd.mount-timeout=5s"
                ];
                permissionsOpts = [
                  "credentials=/run/secrets/smb"
                  "uid=1000"
                  "gid=1000"
                ]; in {
                "movies" = {
                  enable = false;
                  mountPoint = "/mnt/movies";
                  device = "//192.168.1.12/Movies";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "music" = {
                  enable = false;
                  mountPoint = "/mnt/music";
                  device = "//192.168.1.12/Music";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "shows" = {
                  enable = false;
                  mountPoint = "/mnt/shows";
                  device = "//192.168.1.12/Shows";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "av" = {
                  enable = true;
                  mountPoint = "/mnt/av";
                  device = "//192.168.1.12/AV";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "printing" = {
                  enable = false;
                  mountPoint = "/mnt/3dprinting";
                  device = "//192.168.1.12/3DPrinting";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "books" = {
                  enable = false;
                  mountPoint = "/mnt/books";
                  device = "//192.168.1.12/Text";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "torrenting" = {
                  enable = true;
                  mountPoint = "/mnt/torrenting";
                  device = "//192.168.1.12/Torrenting";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "archive" = {
                  enable = false;
                  mountPoint = "/mnt/archive";
                  device = "//192.168.1.12/Archive";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
                "recordings" = {
                  enable = true;
                  mountPoint = "/mnt/recordings";
                  device = "//192.168.1.12/Recordings";
                  fsType = "cifs";
                  options = builtins.concatLists [ automountOpts permissionsOpts ];
                };
              };
            }
          ];
        };
    };
    deploy = {
      nodes = {
        artificer = { # deploy with nix run github:serokell/deploy-rs -- --targets .#artificer
          hostname = "artificer";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.artificer;
          };
        };
        champion = { # deploy with nix run github:serokell/deploy-rs -- --targets .#champion
          hostname = "champion";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.champion;
          };
        };
        desktop = { # deploy with nix run github:serokell/deploy-rs -- --targets .#desktop
          hostname = "desktop";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "joey";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.desktop;
          };
        };
        fighter = { # deploy with nix run github:serokell/deploy-rs -- --targets .#fighter
          hostname = "fighter";
          profilesOrder = [ "system" ];
          profiles.system = {
            user = "root";
            sshUser = "admin";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.fighter;
          };
        };
      };
      fastConnection = true;
      interactiveSudo = false;
      autoRollback = true;
      magicRollback = true;
      remoteBuild = false;
      confirmTimeout = 60;
    };
    nixosModules.networkShares = import ./modules/networkShares/default.nix;
    nixosModules.roles = import ./modules/roles/default.nix;
    nixosModules.stacks = import ./modules/stacks/default.nix;
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/helloworld { };
    });
    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/helloworld { };
    });
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
