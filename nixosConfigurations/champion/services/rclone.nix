{ pkgs, username, ... }: {
  sops.secrets."cloudflare/r2/access_key_id" = {
    sopsFile = ../../../secrets/cloudflare.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."cloudflare/r2/secret_access_key" = {
    sopsFile = ../../../secrets/cloudflare.secrets.yml;
    mode = "0440";
    owner = username;
  };
  systemd.services."rclone-sync-appdata" = {
    script = ''
      ${pkgs.rclone}/bin/rclone sync /appdata/ r2:champion/
    '';
    serviceConfig = {
      User = "${username}";
    };
    startAt = [ "*-*-* 05:00:00" ];
  };
  home-manager.users.${username} = {
    home.packages = with pkgs; [ rclone-browser ];
    programs.rclone = {
      enable = true;
      remotes = {
        r2 = {
          config = {
            type = "s3";
            provider = "Cloudflare";
            env_auth = "true";
            region = "auto";
            endpoint = "https://9c3bc49e4d283320f5df4fc2e8ed9acc.r2.cloudflarestorage.com";
          };
          secrets = {
            access_key_id = "/run/secrets/cloudflare/r2_admin/access_key_id";
            secret_access_key = "/run/secrets/cloudflare/r2_admin/secret_access_key";
          };
        };
      };
    };
  };
}
