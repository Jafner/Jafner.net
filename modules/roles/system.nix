{ pkgs, config, ... }: let cfg = config.modules.roles.system; in {
  options = with pkgs.lib; {
    modules.roles.system = {
      enable = mkEnableOption "Standard system";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "nixos";
      };
      hostname = mkOption {
        type = types.str;
        default = "nixos";
        description = "Hostname for the system.";
        example = "john-laptop";
      };
      kernelPackage = mkOption {
        type = types.raw;
        default = pkgs.linuxKernel.packages."linux_6_12";
        description = "The Linux kernel package to use.";
        example = "pkgs.linuxKernel.packages.\"linux_zen\"";
      };
      authorizedKeysSource.url = mkOption {
        type = types.str;
        default = null;
        description = "URL from which to source authorized_keys. Must be plain text.";
        example = "https://github.com/MyUser.keys";
      };
      authorizedKeysSource.hash = mkOption {
        type = types.str;
        default = null;
        description = "Hash of authorized_keys content. Must be sha256.";
        example = "1i3Vs6mPPl965g4sRmbXYzx6zQMs5geBCgNx2zfpjF4=";
      };
      sshPrivateKeyPath = mkOption {
        type = types.str;
        default = ".ssh/id_ed_25519";
        description = "Path to private key to use for age. Relative to home of primary user.";
        example = ".ssh/me@example.tld";
      };
      ageKeyFilePath = mkOption {
        type = types.str;
        default = "/home/admin/.config/sops/age/keys.txt";
        description = "Path to the age keyfile to use for scripted sops-nix functions. Relative to home of primary user.";
        example = "/home/john/.sops/age_keys.txt";
      };
      repoRoot = mkOption {
        type = types.str;
        default = "";
        description = "Absolute path to the root of the repository containing this flake.";
        example = "/home/admin/Git/myflake";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    sops = {
      age.sshKeyPaths = [ "/home/${cfg.username}/${cfg.sshPrivateKeyPath}" ];
      age.generateKey = false;
    };
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [
        sops
        age
        ssh-to-age
        ( writeShellApplication {
            name = "sops-nix";
            runtimeInputs = [
              git
              ssh-to-age
              openssh
              yq  ];
            text = ''
              #! bash

              # shellcheck disable=SC2002
              # shellcheck disable=SC2016

              REPO_ROOT="${cfg.repoRoot}"
              # shellcheck disable=SC2034
              SOPS_AGE_KEY_FILE="/home/${cfg.username}/${cfg.ageKeyFilePath}"

              listSecrets () {
                # shellcheck disable=SC2002
                SOPS_REGEX="$(cat "$REPO_ROOT/.sops.yaml" | yq -y '.creation_rules.[].path_regex' | head -n1)"
                find "$REPO_ROOT" -regextype posix-extended -regex "$SOPS_REGEX"
              }

              getPubkey () {
                ADDRESS="$1"
                AGE_PUBKEY="$(ssh-keyscan -t ed25519 "$ADDRESS" | ssh-to-age)"
                echo "$AGE_PUBKEY"
              }

              addPubkey () { # Note: Does not edit any files. Prints .sops.yaml with the given key added.
                AGE_PUBKEY="$1"
                # shellcheck disable=SC2002,SC2016
                cat "$REPO_ROOT"/.sops.yaml |\
                yq -y --arg key "$AGE_PUBKEY" '.keys += [$key]' |\
                yq -y --arg key "$AGE_PUBKEY" '.creation_rules.[].key_groups.[].age += [$key]'
              }

              updateKey () { # Note: Interactive
                sops updatekeys --input-type json "$1"
              }

              encryptFile () { # Note: All encrypted files are in json format
                FILE="$1"
                FILE_EXT="''$''\{FILE##*.}"
                case "$FILE_EXT" in
                  "env") FILE_TYPE=dotenv ;;
                  "json") FILE_TYPE=json ;;
                  "yaml|yml") FILE_TYPE=yaml ;;
                  "ini") FILE_TYPE=ini ;;
                  *) FILE_TYPE=binary ;;
                esac
                sops --encrypt --config "$REPO_ROOT/.sops.yaml" --input-type "$FILE_TYPE" --output-type json "$FILE"
              }

              decryptFile () { # Note: All encrypted files are in json format.
                               # File extension is used as the hint for decrypted file type.
                FILE="$1"
                FILE_EXT="''$''\{FILE##*.}"
                case "$FILE_EXT" in
                  "env") FILE_TYPE=dotenv ;;
                  "json") FILE_TYPE=json ;;
                  "yaml|yml") FILE_TYPE=yaml ;;
                  "ini") FILE_TYPE=ini ;;
                  *) FILE_TYPE=binary ;;
                esac
                sops --decrypt --config "$REPO_ROOT/.sops.yaml" --input-type json --output-type "$FILE_TYPE" "$FILE"
              }

              isJson () {
                FILE="$1"
                jq -e . >/dev/null 2>&1 <<<"$(cat "$FILE")" && return 0 || return 1;
              }

              isEncrypted () {
                FILE="$1"
                FILE_EXT="''$''\{FILE##*.}"
                case "$FILE_EXT" in
                  "env") FILE_TYPE=dotenv ;;
                  "json") FILE_TYPE=json ;;
                  "yaml|yml") FILE_TYPE=yaml ;;
                  "ini") FILE_TYPE=ini ;;
                  *) FILE_TYPE=binary ;;
                esac
                if isJson "$FILE" && [[ "$(sops filestatus "$FILE")" == '{"encrypted":true}' ]]; then echo True; else echo False; fi
              }

              listSecretStatus () {
                for file in $(listSecrets); do
                  FILE="$(realpath -s --relative-to="$REPO_ROOT" "$file")"
                  echo -n "$FILE: " |\
                    xargs echo -n
                  if sops --decrypt --input-type json "$file" >/dev/null 2>&1; then
                    echo Decryptable
                  else
                    echo "Not decryptable"
                  fi
                done
              }

              "$@"
            '';
          } )
      ];
      home.stateVersion = "24.11";
    };

    services.libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };

    boot.kernelPackages = cfg.kernelPackage;
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

    users.users."${cfg.username}" = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      description = "${cfg.username}";
      openssh.authorizedKeys.keys = pkgs.lib.splitString "\n" (builtins.readFile (pkgs.fetchurl {
        url = cfg.authorizedKeysSource.url; # https://github.com/Jafner.keys
        sha256 = cfg.authorizedKeysSource.hash; # 1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=
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

    networking.hostName = cfg.hostname;
    networking.hosts = {
      "192.168.1.1" = [ "wizard" ];
      "192.168.1.12" = [ "paladin" ];
      "192.168.1.23" = [ "fighter" ];
      "192.168.1.135" = [ "desktop" ];
      "143.198.68.202" = [ "artificer" ];
      "172.245.108.219" = [ "champion" ];
    };

    system.stateVersion = "24.11";

  };
}
