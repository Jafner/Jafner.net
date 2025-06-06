{ username, ... }:
let
  stack = "vaultwarden";
in
{
  sops.secrets."${stack}" = {
    sopsFile = builtins.toFile "vaultwarden.secrets.env" ''
      ADMIN_TOKEN=ENC[AES256_GCM,data:IJfjJd66eqmpqLaA/5Vyto03WsIPxots1xuYUNFwXuZH14i2A0UlZuH6ymnw8eMgIcNG5QM8sGCL9SXr3qAed3rgA/GXCSsnUefDiok5DQhsrlIXe/SWMEQ2nwwuQaB/jnhpwjOX9Jr/Jb+wIPxpDR6tEScQty9YyEC60H2U8R7zn2j3QWIGsw==,iv:lI8pFBncEIcT6C1RfiFnhxWEoD+aTr9/dkxXbd5DDvg=,tag:GJLVbuxjxfORYAt6WAK+kQ==,type:str]
      sops_age__list_0__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBlekxwdFd0cE9jQUpSVk0r\nak43STczL3drK0kxNlJiMlpCODV3SWpPWEQ4CkJwcmFHQytMckpyaUwwYllPMERO\nODlsaERJRUxYd2VHVzc2alVmL3g0L2cKLS0tIDBaeDY3bUhmTU56QlhwY0plRHNn\neDRzSWYvVytVSWRnOXhYK1hNVTdPakUKX2Eryy3lZoClA6YPgzQm5ekUlCgPYHvY\nQEas8JCq6H/5GDIF+r8IET0WRW8ZIkJAp8vn/HOBc+/veTvMUSHECA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_0__map_recipient=age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n
      sops_age__list_1__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSB4YkRxZGlNWXM4SjhhUTZo\na2d0OWNMSEoxTTQ4d3UvMGJzZlEwS2RsSHdzCmlwQkRZdXJFVXpwNzArTlNER2pC\nZzM5NWx6UUo2OVlXdzliRHZOVzUxc2MKLS0tIDIwSnYzTytzZ2lBMUVEUDAvNWNp\nWlUrbTFmVlUrbWtYaFFLYmhFLzZBTEEKTJKjtNP3WUQTTRvLXLR5TI7J7O5eOzY5\nvoFGx7rtrGJ7lNNVH/4Q3hrtJ79X0hHxmP1KwboAsu1CbvIoeTNZlA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_1__map_recipient=age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00
      sops_age__list_2__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSA2N1JDTkJQZzlDdkVOaVc0\nanBsRDZ1NmM0YWhVMTFlMDVJQ1A0WEhjaVhjCmo5OXVzNTAxWXVlL0ZEc3ZZWUNW\nYU5mcy9iYVFJb0FSOW5FVlNZeG9tTHMKLS0tIElkeHVyVFVqclQ1SGlHTHFoaHY4\nSVBEZHVBaFBlR0lDVTBGNFNDeE05T2MKIG+ySfUcFpE5b5KnElFWdHe2Tpr8kxIG\n9npfNFgk0WX3yes3PDb69tOLQEODXZArWRWVm4eTvUklRaFUSAmXdA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_2__map_recipient=age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926
      sops_age__list_3__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBrUTFFV0ZhRC9WRDlNcE9Y\neXVydmU4cEhPSTVzMnhtWCtVVGsyUVJwT3hvCmhYR2MrMmFWek0zT0k0RHdNcnZh\nNEVyWHdHVWorMUVzWjZHcXJxZXB1Um8KLS0tIHdUeUZNQzhCMjArRjlFRERwZzR3\nZVpHVHdqckIrcmhwOTBQbDd6UGsvY3cKKdSQCzAEHxgg+rfe5AQuD5vBb2/dHZA8\nUGtVUschnGYldmBE6LQPLIjZfN1HZSOL8WPTBmfAjhu5ASsKLC6uFA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_3__map_recipient=age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj
      sops_age__list_4__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBBUUZJSmZBWUlzWWlnZlFX\nVlVmRnBhYS9lbWRxZWtWdFc2WjVkQ0Nsc3dNClF0Z2NuWkxNaWN0U1JGNkZmZmhH\nUkVKK1VwendEVHk4amVPRTBaL05JN1UKLS0tIFltKzNhbTd1alk2YW9sOUROcCth\ncU80czRkcEZ6WHpydVhpUUs1ME1zdE0K3gpztxV9m855Bl/XLNHdRBOuMq1wI0E4\naJQ31ZlR85W2p6PI6O/Q7WJkbLa5M0E8Z/8iluFWCVP4q9hMBF1PKQ==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_4__map_recipient=age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6
      sops_lastmodified=2025-05-20T07:41:32Z
      sops_mac=ENC[AES256_GCM,data:/wp1COvGd/zSzu0FE0cSURAHTTHGtSrLA1/Nco+lsQtzPi11QNqJjbQV3nsXmvo2C/hQXHw7apMuNjcavbHoy7IuTuSGKzFL0MMqvzaVoGelrwRtywDpTRKMnn6ZU1/NuFfuE/HGxHUPsiLeAK4IJNclolaXKHY7Cnq++RGSBts=,iv:99gy4Pj7Ogs83shwT6rn6IB5jkWk866Me0Ne27J8Lgw=,tag:W1h1POKhUYTdYZ1ttqQVdA==,type:str]
      sops_unencrypted_suffix=_unencrypted
      sops_version=3.10.2
    '';
    key = "";
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  home-manager.users."${username}".home.file = {
    "${stack}/docker-compose.yml" = {
      enable = true;
      text = ''
        services:
          ${stack}:
            image: vaultwarden/server:1.33.2
            container_name: ${stack}_vaultwarden
            restart: "no"
            env_file:
              - path: /run/secrets/vaultwarden
                required: true
            environment:
              DOMAIN: "bitwarden.jafner.net"
              SIGNUPS_ALLOWED: "true"
            volumes:
              - /appdata/${stack}/data:/data
            networks:
              - web
            labels:
              - traefik.http.routers.${stack}.middlewares=securityheaders@file
              - traefik.http.routers.${stack}.rule=Host(`bitwarden.jafner.net`)
              - traefik.http.routers.${stack}.tls.certresolver=lets-encrypt
              - traefik.http.routers.${stack}.tls.options=tls12@file
        networks:
          web:
            external: true
      '';
      target = "stacks/${stack}/docker-compose.yml";
    };
  };
}
