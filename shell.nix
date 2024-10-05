# Install git, sops, Docker, bash, 

{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell { 
  packages = with pkgs; [ 
    git sops docker 
    tree btop
    bat fd eza fzf
  ];
}