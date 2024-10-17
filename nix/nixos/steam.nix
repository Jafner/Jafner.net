{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true; 
  hardware.opengl.driSupport32Bit = true;
  programs.steam.enable = true;
  environment.systemPackages = [ pkgs.steam pkgs.bottles-unwrapped ];
}
