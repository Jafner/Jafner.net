{ pkgs, sys, ... }: {
  # Enable SSH server with exclusively key-based auth
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  users.users."${sys.username}".openssh.authorizedKeys.keys = sys.authorizedKeys;
}