{ username, hostname, ... }:
{
  home-manager.users.${username}.programs.git = {
    enable = true;
    userName = "${username}@${hostname}";
    userEmail = "noreply@jafner.net";
  };
}
