{ pkgs, config, ... }:
let
  cfg = config.services.hello;
in
{
  options = with pkgs.lib; {
    services.hello = {
      enable = mkEnableOption "hello service";
      greeting = mkOption {
        type = types.str;
        default = "Hello, world!";
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    systemd.services.hello = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.hello}/bin/hello -g'${pkgs.lib.escapeShellArg config.services.hello.greeting}'";
    };
  };
}
