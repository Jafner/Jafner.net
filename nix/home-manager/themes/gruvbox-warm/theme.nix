{ pkgs, ... }:
{
  stylix = {
    image = pkgs.fetchurl { url = "https://wallpaperaccess.com/full/7731826.png"; sha256 = "07cq8vvi25h8wp21jgmj1yw3w4674khxcjb6c8vgybi94ikjqcyv"; }; 
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}