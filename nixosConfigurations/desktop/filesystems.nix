{ pkgs, username, ... }: {
  sops.secrets."smb" = {
    sopsFile = ../../hosts/desktop/secrets/smb.secrets;
    format = "binary";
    key = "";
    mode = "0440";
    owner = username;
  };
  environment.systemPackages = with pkgs; [ cifs-utils ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e29ec340-6231-4afe-91a8-aaa2da613282";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/ff24dcbc-39e9-4bbe-b013-50d755c9d13d";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/f023ae02-7742-4e13-a8ea-c1ea634436fa";
    fsType = "btrfs";
  };
  fileSystems."av" = import ../../utils/mkMountSmbShare.nix "av";
  fileSystems."torrenting" = import ../../utils/mkMountSmbShare.nix "torrenting";
  fileSystems."recordings" = import ../../utils/mkMountSmbShare.nix "recordings";
  swapDevices = [ { device = "/dev/disk/by-uuid/73e8e737-1c5c-4ead-80c6-e616be538145"; } ];
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
