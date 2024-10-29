{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true; 
  hardware.opengl.driSupport32Bit = true;
  programs.steam.enable = true;

  programs.nix-ld = { 
    enable = true; 
  };
  environment.systemPackages = with pkgs; [ 
    steam 
    steam-run
    lutris-unwrapped
  ];
}
