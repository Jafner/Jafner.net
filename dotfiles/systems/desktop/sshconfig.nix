{ sys, ... }: {
  home-manager.users."${sys.username}".home.file = {
    ".ssh/config" = {
      enable = true;
      text = ''
        Host *
            ForwardAgent yes
            IdentityFile ~/.ssh/joey.desktop@jafner.net
      '';
      target = ".ssh/config";
    };
    ".ssh/profiles" = {
      enable = true;
      text = ''
        vyos@wizard
        admin@paladin
        admin@fighter
        admin@druid
        admin@artificer
      '';
      target = ".ssh/profiles";
    };
  };
}