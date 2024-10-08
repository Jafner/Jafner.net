{ pkgs, hostConf, inputs, ... }: {
  #imports = [ inputs.sops-nix.nixosModules.sops ];
  # sops = {
  #   defaultSopsFile = ./secrets/secrets.yaml;
  #   defaultSopsFormat = "yaml";
  #   age.keyFile = "../../../.sops/nix.key";
  #   secrets."k3s.token" = { };
  # };
  networking.firewall = {
    allowedTCPPorts = [
      6443 # k3s API
      2379 # k3s etcd clients
      2380 # k3s etcd peers
    ];
    allowedUDPPorts = [
      8472 # k3s flannel
    ];
  };
  networking.hosts = {
    "192.168.1.31" = [ "bard" ];
    "192.168.1.32" = [ "ranger" ];
    "192.168.1.33" = [ "cleric" ];
  };
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "/var/lib/rancher/k3s/server/token";
    extraFlags = toString [
      "--write-kubeconfig-mode \"0644\""
      "--disable servicelb"
      "--disable traefik"
      "--disable local-storage"
    ];
    clusterInit = (hostConf.name == "bard");
    serverAddr = (if hostConf.name == "bard" then "" else "https://192.168.1.31:6443");
  };
  environment.systemPackages = with pkgs; [
    vim 
    fastfetch
    tree 
    btop
    bat 
    fd 
    eza
    fzf
    k3s
    cifs-utils
    nfs-utils
    git
  ];
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
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  users.users = {
    admin = {
      isNormalUser = true;
      description = "admin";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/Jafner.keys";
          sha256 = "1i3Vs6mPPl965g3sRmbXGzx6zQBs5geBCgNx2zfpjF4=";
        };
      in pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
    };
  };
  networking = {
    hostName = "${hostConf.name}";
    defaultGateway = { address = "192.168.1.1"; interface = "enp1s0"; };
    interfaces."${hostConf.nic.name}" = {
      useDHCP = false;
      macAddress = "${hostConf.nic.mac}";
      ipv4.addresses = [ { address = "${hostConf.nic.ip}"; prefixLength = 24; } ];
    };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/Los_Angeles";
  nix.settings.trusted-users = [ "root" "admin" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.05";
}