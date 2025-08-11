{username, ...}: let
  service = "forwardauth";
in {
  sops.secrets."forwardauth" = {
    sopsFile = builtins.toFile "forwardauth" ''
      CLIENT_ID=ENC[AES256_GCM,data:Hk7BdNNNREwOqxGF1xKi,iv:WMljxxKjtPTzn7tCGSD9ucEWALH5iToYWW0BCMuSO1Y=,tag:T1ggP+Hdx7S1WsI5hfHSmA==,type:str]
      CLIENT_SECRET=ENC[AES256_GCM,data:UGBOTpkVe3VWcO5I7RxKSDo10BIQKQRkweAltEbh1Gw=,iv:WAaHV7POSXTLjWRnmZOMZkAWbPa0z1hDcYzAnUmRRcM=,tag:Vnw1F9aU6n/a4+9WzOb2+g==,type:str]
      ENCRYPTION_KEY=ENC[AES256_GCM,data:2QfW683BCoPdTtXzsdK9rKm5e4J9jdoo2z7OWhbnaEY=,iv:5JrTeL7g9pc61yNisPCXwFKWryLTQ6MVQ89jIf9x8GY=,tag:oYQqazNniPepU8BFWZy1JA==,type:str]
      PROVIDER_URI=ENC[AES256_GCM,data:Ns8xoVgjJu+cTDXTI11zuzTxYKydKJbpUDL3CECpNVMjel9xWJDTgOw+1Rum,iv:pbXYrHXhy5yce7VNsJFPFWt2iVz5JhoP+pUvhuI9dpU=,tag:IBvwlsjuIxxKSQ0mW87P3A==,type:str]
      SECRET=ENC[AES256_GCM,data:3Iye8lYmC6VpwMMNTec52gX64QUUNtA+tZr/yo+83q31AkQjGeqA9cZ37QCCcHB9g3I1uGBaFCcou34Bomk0IA==,iv:kUJemqjp3QDsGGHotEMATLQSvZ2pRApf/4fFv8Ei2wk=,tag:huI91D2Obd8lgVIfsZ34dQ==,type:str]
      sops_age__list_0__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSA0MWVTaTEyTFlsZGxLKzN0\nY1FhcmN5U1d6WmxGaXoyOGxKZlgwVkZwWDJnCkJMV3U4N0Q4d244bndCdmVBTXFS\nSkd2bk9xL0hBUjFFd2QxUGdrVHZhcmcKLS0tIDdpOWw5SG9yN28zT1NZWDlSQitQ\neURjSm8yd3pkWDVBMEs2NkdaRGdlVHcKgpCyZto42+Afh1VfNXxC3aZlU0h/3QU0\nY79yH9ZN4SYsYUAcRYsQSiSuiroRVUP0W3iYwmUc2C3tbP0D9chy8g==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_0__map_recipient=age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n
      sops_age__list_1__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBlTGt5c0dncGhjdnkyVzZY\nK1o2MW10b3pOV2NYT1JqTFpIL29wMzU1VUJVCjZ1ZkpkOXhZK1ZYVEF1cGRMbm5J\nY29RSjhIc3RyTy94U1dydVhpcStwQjgKLS0tIHJuSHRqV1VxV21DVUVPcmZpcVJo\nQjRwMGdBNDFWRkIxN2tBZjhZaW53RHMKJW993obVGlVMprN4uzp+/TUpY/bNJ0vS\nAkbOhrWDeKVWW1Q1ShYONhKA+ftK/EMFP0FMFKq1eLqYk6giamRtNw==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_1__map_recipient=age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00
      sops_age__list_2__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBBR1cxWkM0VDdoMDVzc3h1\neWlFcnl3T3FBelloY3RLYi91TFJQaFV1VVQ4CmRtOEJlOER5SmNLaGVpTFVKV0dK\nRnZNQ2J4NXNjUzExRWpSbEpHTDBibW8KLS0tIGRJL1Jyb09jelV4ZjgrbERTNmdU\nMGFLYkxvVEZpem0vU1k3QUx3ZkJZUFkKEaEExPg6Qg1r6a4rYdLOZ1OsGoqRK9aT\nNeCcNkk4PMnIIqpqZMBQlYa6K/bYSqkEutZMjAUV7JGHvSft1fiL7A==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_2__map_recipient=age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926
      sops_age__list_3__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSB2NGFJTXJGbjVxWHdDTnR3\nS0IwaERWRVgwcGN1R2ZJaFhGdi9zN0UyVmxVCmJubVVDS1VWak8rTDBsa2Rvd3U4\nRi9LTmRveEZkKzVHQnNnQjVKN1pBY1kKLS0tIDhzNGNBQ3V3ZTFLOGxnQjlVNUly\nV3ZVS05TQy91cDlxWGM1a1VBaUFGQ1EKrsnxNqS7LZMgiPaqYBm6Pv/HJMtKsKTl\nnJjyOrlgDdgutLybbQVkwlUjGxdrJNRMlmhRPbpFGPbi+idFoes2wA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_3__map_recipient=age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj
      sops_age__list_4__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBpK0FZbm83RlkzMkF1TmRM\nbjFtYzQ2MkFUK1NjakdDdS9mMmdzR1BmKzFrCml5ai9HSWhMRURsZkVwQXBDMFdk\na0lmVSt3QU5ZYUI5d0ozNHF3N2RORXcKLS0tIDJFb1pSRTNtZDJaejhNL1ZkVDFD\nMUVVbldJbzdaOU44c3ZISkFuaWhrUlkKgPk2/YEGSEhjnaUs6gpxuo6E3SI/cTPC\nI8Rqn0zDutoCG4GzrMAoekj7/ErANrJpbwdVOy3Ks4YnKXtOpe3Vpg==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_4__map_recipient=age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6
      sops_lastmodified=2025-06-05T18:24:14Z
      sops_mac=ENC[AES256_GCM,data:hGGPckqx3Evu8uM4nMJPvY8Cja3ZQ6E8P9HK5urkpJuMVQjYfzeFXGjfqOWpmW3PJEVYoJUEY2rNbhTB5K+1cQ/GzpvG01mF78m8BguOLuzD3InGGd4XYcLjH5jlHy5sJmlRNuI+fxpaRFlTP/SrdoN4mw7QaNZ37rDOBgcVyWw=,iv:r0Wy3txPEdtBgCh8ogjDnuDbAa0B64AWgY4HlzKXWPI=,tag:yvK54mQNVmYsfDFtMaOFEg==,type:str]
      sops_unencrypted_suffix=_unencrypted
      sops_version=3.10.2
    '';
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  home-manager.users.${username} = {
    home.file."${service}" = {
      enable = true;
      target = "stacks-nix/${service}/compose.yml";
      text = ''
        name: forwardauth
        services:
          forwardauth:
            image: mesosphere/traefik-forward-auth:v3.2.1
            container_name: forwardauth
            restart: unless-stopped
            networks:
              - caddy
            env_file:
              - path: /run/secrets/forwardauth
            labels:
              caddy: auth.jafner.net
              caddy.reverse_proxy: "{{upstreams 4181}}"
        networks:
          caddy:
            name: caddy
            external: true
      '';
    };
  };
}
