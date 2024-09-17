{ pkgs, ... }:
{
  stylix = {
    image = pkgs.fetchurl { url = "https://wallpaperaccess.com/full/7731794.png"; sha256 = "070vysl5ws4470pswnnw3jghwbcs1s5b5sm0cz37vmxwrff7ixdz"; };
    override = { base01 = "332330"; };
  };
}
