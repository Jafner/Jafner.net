{
  pkgs,
  username,
  ...
}: {
  sops.secrets."cloudflare/r2/access_key_id" = {
    sopsFile = ../../secrets/cloudflare.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."cloudflare/r2/secret_access_key" = {
    sopsFile = ../../secrets/cloudflare.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."paladin/versity/access_key" = {
    sopsFile = ../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."paladin/versity/secret_key" = {
    sopsFile = ../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."barbarian/versity/access_key" = {
    sopsFile = ../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."barbarian/versity/secret_key" = {
    sopsFile = ../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };

  home-manager.users.${username} = {
    home.packages = with pkgs; [rclone-browser];
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
            access_key_id = "/run/secrets/cloudflare/r2/access_key_id";
            secret_access_key = "/run/secrets/cloudflare/r2/secret_access_key";
          };
        };
        paladin = {
          config = {
            type = "s3";
            provider = "Other";
            env_auth = "true";
            region = "auto";
            endpoint = "https://192.168.1.12:30157";
          };
          secrets = {
            access_key_id = "/run/secrets/paladin/versity/access_key";
            secret_access_key = "/run/secrets/paladin/versity/secret_key";
          };
        };
        barbarian = {
          config = {
            type = "s3";
            provider = "Other";
            env_auth = "true";
            region = "auto";
            endpoint = "https://192.168.1.10:30157";
          };
          secrets = {
            access_key_id = "/run/secrets/barbarian/versity/access_key";
            secret_access_key = "/run/secrets/barbarian/versity/secret_key";
          };
        };
      };
    };
  };
}
