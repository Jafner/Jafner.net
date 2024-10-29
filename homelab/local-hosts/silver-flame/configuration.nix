{ pkgs, hostConf, inputs, ... }: {
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/cluster/k3s/default.nix"
  ];
  disabledModules = [
    "services/cluster/k3s/default.nix"
  ];
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
    # We are going to manage k8s resources separately from the infrastructure config
    manifests = {  }; 
  };
  services.openiscsi = {
    enable = false;
    name = "iqn.2020-03.net.jafner:${hostConf.name}-initiatorhost";
  };
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system-sw/bin/"
  ];
  virtualisation.docker.logDriver = "json-file";
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
    dig
    openiscsi
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
  services.rpcbind.enable = true;
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
    nameservers = [
      "10.0.0.1"
    ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/Los_Angeles";
  nix.settings.trusted-users = [ "root" "admin" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "nfs" ];
  system.stateVersion = "24.05";
}