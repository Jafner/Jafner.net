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
  sops.secrets."truenas/minio/fighter/secret_key" = {
    sopsFile = ../../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/minio/fighter/access_key" = {
    sopsFile = ../../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/versity/secret_key" = {
    sopsFile = ../../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/versity/access_key" = {
    sopsFile = ../../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
  };
  sops.secrets."truenas/samba/fighter/password" = {
    sopsFile = ../../../secrets/truenas.secrets.yml;
    mode = "0440";
    owner = username;
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
            access_key_id = "/run/secrets/cloudflare/r2/access_key_id";
            secret_access_key = "/run/secrets/cloudflare/r2/secret_access_key";
          };
        };
        minio = {
          config = {
            type = "s3";
            provider = "Minio";
            env_auth = "true";
            region = "auto";
            endpoint = "https://192.168.1.12:9000";
          };
          secrets = {
            access_key_id = "/run/secrets/truenas/minio/fighter/access_key";
            secret_access_key = "/run/secrets/truenas/minio/fighter/secret_key";
          };
        };
        versity = {
          config = {
            type = "s3";
            provider = "Other";
            env_auth = "true";
            region = "auto";
            endpoint = "https://192.168.1.10:30157";
          };
          secrets = {
            access_key_id = "/run/secrets/truenas/versity/access_key";
            secret_access_key = "/run/secrets/truenas/versity/secret_key";
          };
        };
        samba = {
          config = {
            type = "samba";
            host = "192.168.1.12";
            user = "${username}";
          };
          secrets = {
            pass = "/run/secrets/truenas/samba/fighter/password";
          };
        };
      };
    };
  };
}
