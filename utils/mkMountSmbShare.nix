# Takes a share name and returns a fileSystems submodule
name: {
  enable = true;
  mountPoint = "/mnt/${name}";
  device = "//192.168.1.12/${name}"; # Hard coding the address of my Samba server relative to my LAN.
  fsType = "cifs";
  options = [ # Automount options
    "x-systemd.automount"
    "x-systemd.requires=network.target"
    "vers=3"
  ] ++ [ # Permissions options
    "credentials=/run/secrets/smb"
    "uid=1000,forceuid"
    "gid=1000,forcegid"
  ];
}
