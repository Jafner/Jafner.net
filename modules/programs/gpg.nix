{ pkgs
, config
, ...
}:
let
  cfg = config.modules.programs.gpg;
in
{
  options = with pkgs.lib; {
    modules.programs.gpg = {
      enable = mkEnableOption "gpg";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    home-manager.users."${cfg.username}" = {
      home.packages = with pkgs; [
        pinentry-all
      ];
      programs.gpg = {
        enable = true;
        homedir = "/home/${cfg.username}/.gpg";
        mutableKeys = true;
        mutableTrust = true;
        publicKeys = [ ];
      };
      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        enableScDaemon = false;
        pinentryPackage = pkgs.pinentry-qt;
        maxCacheTtl = 86400;
        defaultCacheTtl = 86400;
      };
    };
  };
}
