{username, ...}: let
  service = "keycloak";
in {
  sops.secrets."keycloak" = {
    sopsFile = builtins.toFile "keycloak" ''
      POSTGRES_USER=ENC[AES256_GCM,data:+gfpKe1fxkA=,iv:Ac4esUyU5yaOMhS9nukBxOUqPUdq6ipCfLD74lZ9AQs=,tag:ch4tvJeIhkxD9EtG+wtMLQ==,type:str]
      POSTGRES_PASSWORD=ENC[AES256_GCM,data:UqKGhyGGV3vo7CgihjX4+3/NT8IzWj+tAKkIIdEwlLA=,iv:Nv5dqCFT7myuMyZ56Jxu8gf5jlNrY5/PeglTaEQWMrE=,tag:lKTAA375y0zYl/pFkFe+FA==,type:str]
      KC_DB_PASSWORD=ENC[AES256_GCM,data:iPjY51OP91DITNcNe7qLAQDLuhinK64RLPA55kGb+AA=,iv:780sPe2RFazw2/uzcuVYJqSFgvheySTsTCmG+g2U7oo=,tag:DCB2Sbv9cwG+HaurHJ+Pbw==,type:str]
      DB_PASS=ENC[AES256_GCM,data:IblX5HaJzl2NXUX87KEHj7zDXbda3J9tmedABdAthpU=,iv:9sX5A86pAjjw2bOZDf3h+KPytUT2qLzRwCn+Zz/DHtg=,tag:TdxghUKfYhvdSHw+A2sw4Q==,type:str]
      KEYCLOAK_ADMIN_PASSWORD=ENC[AES256_GCM,data:WrVJFUOOadha7lzGfsKgxGfL/3JA5LbguwEsZAOt8e5JENxX6BgYey7avVVovciFwez8j2H1,iv:irABDSZ1F7/5Yq6yXFdy9FBFj+DVYa6u98pxE8OZmUs=,tag:erBStRba7f4fo85704fJUQ==,type:str]
      sops_age__list_0__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSAvL0VCMVR4dnVnd1p2aXNi\nNlRQTmVpN1ZRYkVsWE5RSkUvRFg0UGtyMmtFClExdklBVFcxZ0xwZEhFU3VhVG8z\nZWRIVW9yc29CdThZektFdy9XVHR3czQKLS0tIFZhcElqaFdmZm9ISTE5Q2t6Y2Ux\nWUtLY2ozR2RaMHNPdUZkU1orRW5uaFEKCufHeC8/yQV/308LDEU7nUU3YCgc8CQU\nfynZBuLlHjTf1qBGGkYCl6KVaaiJJFwnw7Z35tM/w81sefCpeRUvmg==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_0__map_recipient=age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n
      sops_age__list_1__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSB2MU9nR0dYcXhadmowY012\nVGN3RzZUSHU2eVVHV1ZXZHBOYzNPNmNmaXlnCnRnNlNPTFYwa2pLVk1DZFdRRWVB\nV3c4WGVTbDA1VnhqaVViS3R2WCtLV2cKLS0tIEM1OVpvdjU1Z2xQNTZzSXI5dmNj\nVHhWVXRqeDlya3h4R252RFFmeEhEM28K6vTAciE1sWut4nv6kBHbgLzeOhxGgBwg\nUs+3jl5fq0UUTjVPxplusaow5KESwxaxs07nI6SsWhQwD8Bi9z1Ezg==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_1__map_recipient=age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00
      sops_age__list_2__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBlb2xrL0I0dnNsL3FzejRC\nREdGYlJKSjNXemlwQzFad2dxbGNZaWhleWdVCkFHbVA5MVJjVmhqc0F4VkoxSzQr\ncDVaZ3kzby8zeWlLbVR1OUpOTXV3cTgKLS0tIE40bUFiQkV6TTMvQ0hsVGtHN2Zt\nWEhoSStPMjBna1ZIRUhkVGZsVWo3c2sKNPAfL7udoe9ICVuDAMvicYUVQCEbawnt\n2aKXa5TbZgpVhcm82xKwrUdGWf5q3ZzjSsf0iUBsNBkhvvl9SzTblw==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_2__map_recipient=age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926
      sops_age__list_3__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBHTU96eGx6ZlRNMi9uKzM5\nU0hoamdpbDl0VTNmc0VWWGVLbFQrVXN0M0JnCnZ1dkFWdk1GVU4xdzI0MlROM0lB\nZHBtUXZlb3NFRmV1ZkNOUldpUWpZT3MKLS0tIGd6RElMZm5kcGwrTjduZEQ2SjAx\nMGtOU3lDZkN5RU45K1dJbkRKMThveDAK0vGnwe1NFNE/1v/1eBl40fqGRpiJg4QO\n4Tmy9n+UizZa04wQY3ZO7srDEumPFB/ZxKYoS59X25Fx9ZjEHv4s5Q==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_3__map_recipient=age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj
      sops_age__list_4__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBWc0IvK053dzFzdTBRaUor\nM0ZMdHBXZ3NCak03NnltWFBkQnR0WG1XdURRCnE2Mmd0M0pVYlJjV2VGSWg4R3BV\nRFFXZmlKOHpUL0RTeHlSSWhMZkVrbUUKLS0tIGUxaDRFUlJ5NW9ySzhYcnhyY1Ur\nK2lHejduT2tNdlF0cXEzdzhNdnhUY0UKp3V6ASxPWdvO2Ag7rTcxeJGwHhI1JwF0\npnrVXDMQTrLNN+iuSzOutSF+/Is7/+RkWZZVVfIxSuExcSXSd7pk0g==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_4__map_recipient=age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6
      sops_lastmodified=2025-06-05T18:26:59Z
      sops_mac=ENC[AES256_GCM,data:4h5vuC4SoHVpUVglkwnXMUhZNDXa9adIaH8S/ofeX20mfFToRBvvgzLYEDHB8O/DqEQ3V1mxANUUUsXDXMD8R1V9RfiNeQqZxPCfx7GDxIqGFWFIzGIEnXh/R7sC8hkdzgHsoC93mPxNMUG5AgANz8Vwh/uUXICZKi860UyYSoI=,iv://NXia46pB6sarF9uz8hPJhkgioQwESKSavlUNkFFHQ=,tag:k+o2G+sJvhQByKChwAPS7w==,type:str]
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
        name: keycloak
        services:
          keycloak:
            image: quay.io/keycloak/keycloak:latest
            container_name: keycloak
            networks:
              keycloak:
                aliases:
                  - keycloak
              caddy:
                aliases:
                  - keycloak
            restart: no
            depends_on:
              - postgres
            command: start --hostname=keycloak.jafner.net
            env_file:
              - path: /run/secrets/keycloak
            environment:
              KC_DB: postgres
              KC_DB_URL: jdbc:postgresql://postgres/keycloak
              KC_DB_USERNAME: keycloak
              KC_PROXY_HEADERS: xforwarded
              KC_HTTP_ENABLED: true
              KC_HEALTH_ENABLED: true
              KC_METRICS_ENABLED: true
              KEYCLOAK_ADMIN: jafner425@gmail.com
            labels:
              caddy: keycloak.jafner.net
              caddy.reverse_proxy: "{{upstreams 8080}}"
          postgres:
            image: "postgres:17"
            container_name: keycloak-db
            networks:
              - keycloak
            env_file:
              - path: /run/secrets/keycloak
            environment:
              POSTGRES_DB: keycloak
              POSTGRES_USER: keycloak
              PG_VERSION: 17
            volumes:
              - /appdata/keycloak/postgres:/var/lib/postgresql/data
        networks:
          keycloak:
            name: keycloak
          caddy:
            name: caddy
            external: true
      '';
    };
  };
}
