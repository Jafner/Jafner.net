{
  username,
  hostname,
  ...
}: {
  home-manager.users.${username}.programs.git = {
    enable = true;
<<<<<<< HEAD
    settings.user.name = "${username}@${hostname}";
    settings.user.email = "noreply@jafner.net";
=======
    settings = {
      user.name = "admin@champion";
      user.email = "noreply@jafner.net";
    };
>>>>>>> ed55c836 (Update Git user config syntax)
  };
}
