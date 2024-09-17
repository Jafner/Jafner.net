{ userSettings, ... }:

{
  home.stateVersion = "24.05";
  imports = [ ./users/${userSettings.user}.nix ];
}