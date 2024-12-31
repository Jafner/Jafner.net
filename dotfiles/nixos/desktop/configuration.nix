{ ... }: {
  imports = [
    ./hardware/amdgpu.nix
    ./hardware/audio.nix
    ./hardware/boot.nix
    ./hardware/filesystems.nix
    ./hardware/networking.nix
    ./hardware/peripherals.nix
    ./hardware/samba-client.nix

    ./services/flatpak.nix
    ./services/ollama.nix
    ./services/printing.nix
    ./services/ssh.nix
    ./services/syncthing.nix
    ./services/vintagestory.nix

    ./sysconfig/desktop-environment.nix
    ./sysconfig/fonts.nix
    ./sysconfig/gaming.nix
    ./sysconfig/localization.nix
    ./sysconfig/nixos.nix
    ./sysconfig/user.nix
    ./sysconfig/ydotool.nix
  ];

  # DO NOT CHANGE
  system.stateVersion = "24.11";
}
