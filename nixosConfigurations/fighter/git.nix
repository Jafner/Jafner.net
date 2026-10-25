{username, ...}: {
  home-manager.users.${username}.programs.git = {
    enable = true;
    settings = {
      user.name = "admin@fighter";
      user.email = "noreply@jafner.net";
    };
  };
}
