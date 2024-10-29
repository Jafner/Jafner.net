{ inputs, ... }:

{
  home.stateVersion = "24.05";
  imports = [ ./users/${inputs.homeConf.username}.nix ];
}