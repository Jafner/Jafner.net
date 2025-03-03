{ ... }: {
  imports = let stacksPath = ../../../homelab/stacks; in [
    "${stacksPath}/ai/stack.nix"
    "${stacksPath}/autopirate/stack.nix"
    "${stacksPath}/homeassistant/stack.nix"
    "${stacksPath}/keycloak/stack.nix"
    "${stacksPath}/manyfold/stack.nix"
    "${stacksPath}/minecraft/stack.nix"
    "${stacksPath}/monitoring/stack.nix"
    "${stacksPath}/navidrome/stack.nix"
    "${stacksPath}/plex/stack.nix"
    "${stacksPath}/qbittorrent/stack.nix"
    "${stacksPath}/send/stack.nix"
    "${stacksPath}/stash/stack.nix"
    "${stacksPath}/traefik/stack.nix"
    "${stacksPath}/unifi/stack.nix"
    "${stacksPath}/wireguard/stack.nix"
    "${stacksPath}/zipline/stack.nix"
  ];
}