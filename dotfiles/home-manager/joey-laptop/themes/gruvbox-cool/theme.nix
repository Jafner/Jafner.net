{ pkgs, ... }:
{
  stylix = {
    image = pkgs.fetchurl { url = "https://wallpaperaccess.com/full/7731794.png"; sha256 = "1n0l1v0hfna5378zdfazvhq1np8x1wgjcmfnphxj4vjb48gkzmjk"; }; 
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}