# Takes a share name and returns a fileSystems submodule
{ name }: {
  "${name}" = {
    enable = true;
    mountPoint = "/mnt/name";
    device = "//192.168.1.12/${name}"; # Hard coding the address of my Samba server relative to my LAN.
    fsType = "cifs";
    options = [ # Automount options
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ] ++ [ # Permissions options
      "credentials=/run/secrets/smb"
      "uid=1000"
      "gid=1000"
    ];
  };
}
