{ pkgs
, config
, ...
}:
let
  cfg = config.desktop.thismodule;
in
{
  options = with pkgs.lib; {
    desktop.thismodule = {
      enable = mkEnableOption "";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      paths = mkOption {
        type = types.submodule {
          options = {
            appdata = {
              type = types.str;
              description = "Path to store persistent data for the stack.";
            };
            anotherPath = {
              type = types.str;
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    # actual configuration goes here.
    # use cfg.<parameter> to refer to values defined in options above
  };
}
