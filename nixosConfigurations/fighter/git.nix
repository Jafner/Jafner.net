{ username, ... }: {
  home-manager.users.${username}.programs.git = {
    enable = true;
    userName = "admin@fighter";
    userEmail = "noreply@jafner.net";
  };
}
