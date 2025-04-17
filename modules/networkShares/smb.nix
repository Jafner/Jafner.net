{ pkgs, config, ... }: let cfg = config.networkShares.smb; in {
  options = with pkgs.lib; {
    networkShares.smb = {
      enable = mkEnableOption "Samba client";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      automountOpts = mkOption {
        type = types.listOf types.str;
        default = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
        ];
        description = "fstab options for mounting each SMB share.";
      };
      permissionsOpts = mkOption {
        type = types.listOf types.str;
        default = [
          "credentials=/run/secrets/smb"
          "uid=1000"
          "gid=1000"
        ];
        description = "fstab options for mounting each SMB share.";
      };
      smbSecretsFile = mkOption {
        type = types.pathInStore;
        default = null;
        description = "In-store path to sops-encrypted file containing SMB credentials to use.";
        example = "hosts/desktop/secrets/smb.secrets";
      };
      shares = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              description = "Name of the share. Used to set the mount point unless otherwise specified.";
              type = types.str;
            };
            sambaHost = mkOption {
              description = "IP address or hostname of the SMB server.";
              type = types.str;
            };
            shareName = mkOption {
              description = "Name of the share on the SMB server.";
              type = types.str;
            };
          };
        });
      };
      # shares = mkOption {
      #   type = types.submodule {
      #     options = {
      #       movies.enable     = mkOption { type = types.bool; default = false; };
      #       music.enable      = mkOption { type = types.bool; default = false; };
      #       shows.enable      = mkOption { type = types.bool; default = false; };
      #       av.enable         = mkOption { type = types.bool; default = false; };
      #       printing.enable   = mkOption { type = types.bool; default = false; };
      #       books.enable      = mkOption { type = types.bool; default = false; };
      #       torrenting.enable = mkOption { type = types.bool; default = false; };
      #       archive.enable    = mkOption { type = types.bool; default = false; };
      #       recordings.enable = mkOption { type = types.bool; default = false; };
      #     };
      #   };
      # };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    sops.secrets."smb" = {
      sopsFile = cfg.smbSecretsFile;
      format = "binary";
      key = "";
      mode = "0440";
      owner = cfg.username;
    };

    environment.systemPackages = with pkgs; [ cifs-utils ];

    fileSystems."${cfg.shares.name}" = {
      mountPoint = "/mnt/${cfg.shares.name}";
      device = "//${cfg.shares.sambaHost}/${cfg.shares.shareName}";
      fsType = "cifs";
      options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    };

    # fileSystems."movies" = pkgs.lib.mkIf cfg.shares.movies.enable {
    #   mountPoint = "/mnt/movies";
    #   device = "//192.168.1.12/Movies";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."music" = pkgs.lib.mkIf cfg.shares.music.enable {
    #   mountPoint = "/mnt/music";
    #   device = "//192.168.1.12/Music";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."shows" = pkgs.lib.mkIf cfg.shares.shows.enable {
    #   mountPoint = "/mnt/shows";
    #   device = "//192.168.1.12/Shows";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."av" = pkgs.lib.mkIf cfg.shares.av.enable {
    #   mountPoint = "/mnt/av";
    #   device = "//192.168.1.12/AV";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."printing" = pkgs.lib.mkIf cfg.shares.printing.enable {
    #   mountPoint = "/mnt/3dprinting";
    #   device = "//192.168.1.12/3DPrinting";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."books" = pkgs.lib.mkIf cfg.shares.books.enable {
    #   mountPoint = "/mnt/books";
    #   device = "//192.168.1.12/Text";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."torrenting" = pkgs.lib.mkIf cfg.shares.torrenting.enable {
    #   mountPoint = "/mnt/torrenting";
    #   device = "//192.168.1.12/Torrenting";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."archive" = pkgs.lib.mkIf cfg.shares.archive.enable {
    #   mountPoint = "/mnt/archive";
    #   device = "//192.168.1.12/Archive";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };

    # fileSystems."recordings" = pkgs.lib.mkIf cfg.shares.recordings.enable {
    #   mountPoint = "/mnt/recordings";
    #   device = "//192.168.1.12/Recordings";
    #   fsType = "cifs";
    #   options = builtins.concatLists [ cfg.automountOpts cfg.permissionsOpts ];
    # };
  };
}
