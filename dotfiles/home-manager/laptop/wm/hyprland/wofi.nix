{ pkgs, ... }: {
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      width = "40%";
      height = "20%";
      allow_markup = true;
    };
  };
}
