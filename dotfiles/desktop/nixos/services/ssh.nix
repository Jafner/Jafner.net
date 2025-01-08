{ ... }: {
  # Enable SSH server with exclusively key-based auth
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}