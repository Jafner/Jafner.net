{ pkgs
, username
, ...
}:
let
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
  ];
in
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/88a3f223-ed42-4be1-a748-bb9e0f9007dc";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/518e8d5f-cba4-4d87-a80a-e06a811f73e4";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  swapDevices = [
    {
      device = "/.swapfile";
      size = 32 * 1024;
    }
  ];

  sops.secrets."truenas/smb/fighter" = {
    sopsFile = ../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };

  environment.systemPackages = with pkgs; [ cifs-utils ];
  fileSystems."movies" = {
    enable = true;
    mountPoint = "/mnt/movies";
    device = "//192.168.1.12/Movies";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."music" = {
    enable = true;
    mountPoint = "/mnt/music";
    device = "//192.168.1.12/Music";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."shows" = {
    enable = true;
    mountPoint = "/mnt/shows";
    device = "//192.168.1.12/Shows";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."av" = {
    enable = true;
    mountPoint = "/mnt/av";
    device = "//192.168.1.12/AV";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."printing" = {
    enable = true;
    mountPoint = "/mnt/3dprinting";
    device = "//192.168.1.12/3DPrinting";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."books" = {
    enable = true;
    mountPoint = "/mnt/books";
    device = "//192.168.1.12/Text";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."torrenting" = {
    enable = true;
    mountPoint = "/mnt/torrenting";
    device = "//192.168.1.12/Torrenting";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."archive" = {
    enable = true;
    mountPoint = "/mnt/archive";
    device = "//192.168.1.12/Archive";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  fileSystems."recordings" = {
    enable = true;
    mountPoint = "/mnt/recordings";
    device = "//192.168.1.12/Recordings";
    fsType = "cifs";
    options = builtins.concatLists [
      automountOpts
      permissionsOpts
    ];
  };
  # inputs.disko.nixosModules.disko
  # inputs.impermanence.nixosModules.impermanence
  # environment.persistence."/steam" = {
  #   enable = true;
  #   hideMounts = true;
  #   directories = [];
  #   files = [];
  #   users.${username} = {
  #     directories = [];
  #     files = [];
  #   };
  # };
  # services.beesd.filesystems.root = {
  #   spec = "LABEL=root";
  #   hashTableSizeMB = 4096;
  #   extraOptions = [ "--thread-count" "4" ];
  # };
  # services.beesd.filesystems.store = {
  #   spec = "LABEL=store";
  #   hashTableSizeMB = 8192;
  #   extraOptions = [ "--thread-count" "4" ];
  # };
  # disko.devices.disk.root = {
  #   type = "disk";
  #   device = "/dev/disk/by-id/nvme-Predator_SSD_GM3500_1TB_PSF41380100026";
  #   content = {
  #     type = "gpt";
  #     partitions = {
  #       ESP = {
  #         type = "EF00";
  #         size = "500M";
  #         content = {
  #           type = "filesystem";
  #           format = "vfat";
  #           mountpoint = "/boot";
  #           mountOptions = [ "umask=0077" ];
  #         };
  #       };
  #       root = {
  #         size = "-8G";
  #         content = {
  #           type = "btrfs";
  #           extraArgs = [ "-f" ];
  #           mountpoint = "/";
  #           mountOptions = [
  #             "compress=zstd"
  #             "noatime"
  #           ];
  #         };
  #       };
  #       swap = {
  #         size = "100%";
  #         content = {
  #           type = "swap";
  #           discardPolicy = "both";
  #         };
  #       };
  #     };
  #   };
  # };
  # disko.devices.disk.store = {
  #   type = "disk";
  #   device = "/dev/disk/by-id/nvme-ADATA_SX8200PNP_2L2329AG5BXU";
  #   content = {
  #     type = "gpt";
  #     partitions = {
  #       store = {
  #         size = "100%";
  #         content = {
  #           type = "btrfs";
  #           extraArgs = [ "-f" ];
  #           subvolumes = {
  #             "/store/steam" = { mountpoint = "/steam"; };
  #             "/store/docker" = { mountpoint = "/docker"; };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
