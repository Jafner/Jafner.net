{ username
, hostname
, ...
}: {
  home-manager.users.${username}.programs.git = {
    enable = true;
    settings.user.name = "${username}@${hostname}";
    settings.user.email = "noreply@jafner.net";
  };
}
