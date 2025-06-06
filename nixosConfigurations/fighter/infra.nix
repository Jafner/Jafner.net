{ username, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/docker";
    logDriver = "local";
    rootless.enable = false;
    rootless.setSocketVariable = true;
  };
  programs.fuse.userAllowOther = true;
  users.users.${username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.docker-compose ];
  sops.secrets."autokuma" = {
    sopsFile = builtins.toFile "autokuma" ''
      AUTOKUMA__KUMA__URL=ENC[AES256_GCM,data:twWkVIoF6Am0GNhHxZpRBxYBOakwhpE=,iv:5lVvpixI7OcZIfjaCtMD70XhXNkOz5hN57nXyOTlqio=,tag:Aho/k/eN4f60Vk/yflcXbQ==,type:str]
      AUTOKUMA__KUMA__USERNAME=ENC[AES256_GCM,data:6hCW3Tww,iv:DMgt/us3nMVgW4l87tzCLGfcuVRTNliJRXIMRfSNoL4=,tag:JZ4ggQlh3HgM+WFHoxMESA==,type:str]
      AUTOKUMA__KUMA__PASSWORD=ENC[AES256_GCM,data:uf+C3REEij7jV26HmQ3qoOdf+CZdMpRsxq1Ral899Rs=,iv:jm/gkerQhUb1r7XRgNzYfOdi0/WD+e1LjG8zi2FDLxU=,tag:AK8p00Zc0J4j2V+ZiYasyw==,type:str]
      sops_age__list_0__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBYZG1jSUxMcElTQlZ1dDVO\nMDJzRGF2ZlF2TVNBb0NmWnM5SzRJUzNiZFdrCjNXeFQ4enNlOCtrWGNublZKcW45\nWkNjdU83Unp6a3hjRjJhNEhDeXJPdWsKLS0tIDY0dmpmUXhJZURVSlpMRkVLcThx\nN3o3dEFTVGMxTmpWVEZualVucUdPbUEKNPmzudYqqKArvKlJFSBXCkXvIofAqEX2\nJrv35bEABZbw4U89tbt4fQ5sxX7PuELqrvvxvEiK1VdxPSMERQbHlA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_0__map_recipient=age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n
      sops_age__list_1__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSB2cGVVanpJeTA2WVIzUjNC\nbDlxR0dYdi9yUWpyYzRCeHhTWlB1QUlLcUUwCm9WbEdlRFdnUzA2c25vL1g1d1Ev\nYjBWTGYybDMyR0M1MU85aXdpNGFKUTQKLS0tIHlvQkpIcTZWSXFTQktZL3NlRVVl\nam44UnEwb3UvUDhqYjR3Smg2L3RPVW8KvRR78pkKYhAJciw2iDfiIK3FdwHik+pW\nboSAJLJpoyrMISPp6ATgWFju2Z+fEsQxA8azA2pZyrvr7V4XoT9I5Q==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_1__map_recipient=age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00
      sops_age__list_2__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBRVng4emRMTE9KUFF1MlVr\nZE1Qa2lPRU50dTBnVG54YURRZzFWdEpONjJVClNUSjNlWG1ZS0VTMkxZSXZ2SzY2\nNlhQanpTbEpadGVQRk13VDFyTGduNjgKLS0tIHV5bk0vc25lRXZmY0p1SVJ5VEVB\nZnlvSXAvOHRuWVAwU3RXVnEvbk40M0EKckvaHttFEfKQWj2upGVIFFA/5TlOGlGG\nIuhnrAdJqoP/yy7890jggp/SQ2Rwh61tMi2JEHU2eD6UOyd4N4DcjA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_2__map_recipient=age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926
      sops_age__list_3__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBPVXQ4ZXJHYUFHQVNoRE5h\nZUJLMkJ2bmRpbjA5aWM4K3Y2VWZSUXZIZlJnCkpoeFFMb2g4amVGYlBSZXN6Ykdy\ndWdiYlpla0JLa1o0elVoNWpTeHROZ1UKLS0tIDFjd0NWdThaY1k2THptVTVNQmFM\nMTZDNGZIa3o0eDJUQzg0NW5GZGJseFkKnNxBglv9JEDrYXIxJqJWbaJ5Y3sMLPLN\nOAZHdJ0rc6ycfusXtitswYq6jktHCBtD4DjGqe5lyzX1ycojzGKiYA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_3__map_recipient=age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj
      sops_age__list_4__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBlSVhwY3AzNllKeVErVTlt\ncnV3QklvclBneUxmZWlXOUpRakFIOHRhVnk0ClF3cTV2YVNPbk5tTm1QL1dvUVRF\nd1hRTUc1YTdWbFR6Z3VMYXJLbmVMTEEKLS0tIFBLUHFmZ2puK3ZXQ3V0LzNaSjQz\nVjBkUG43dDZjQTdOZnhpN3h0ZU5XWW8K8PRm75ZUWgsAaHqoAU7uuPbq4WeX5RDZ\n219JrUmIkBI8rQHXEwQD0mLBrqUJQYz2U0GkchzFGiF1j5eLTHaT0Q==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_4__map_recipient=age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6
      sops_lastmodified=2025-06-05T19:22:01Z
      sops_mac=ENC[AES256_GCM,data:eIasymMCHl1KdmP/P65TSOAn9Ro+yUFEyU2U0OTJLarINV/rFTNP75LVmaI7wILMCt3Cgw2uNMthgPv3jnaSvwH85ZRWrMHZH+G42QppfDc0qPMw1mf7SsK3W103S6QMpvV7TygB6gsfzWf5p9z4u/A7xV/C+v9q5qhHfKD3i6I=,iv:byMRR3ybPADVWBW2XBOn7HG+EC8So904+6fYcpr2pNg=,tag:h/F2cfHo6TLkBpTQ3U4BZQ==,type:str]
      sops_unencrypted_suffix=_unencrypted
      sops_version=3.10.2
    '';
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
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
    home.file = {
      "compose.yml" = {
        enable = true;
        target = "compose.yml";
        text = ''
          include:
            - caddy.yml
            - dockge.yml
            - whatsupdocker.yml
            - kuma.yml
            - forwardauth.yml
            - keycloak.yml
        '';
      };
      "caddy.yml" = {
        enable = true;
        target = "caddy.yml";
        text = ''
          name: caddy
          services:
            caddy:
              container_name: caddy
              environment:
                CADDY_INGRESS_NETWORKS: caddy
              image: lucaslorentz/caddy-docker-proxy:ci-alpine
              labels:
                caddy_0.email: joey@jafner.net
              networks:
                caddy: null
              ports:
                - mode: ingress
                  target: 80
                  published: "80"
                  protocol: tcp
                - mode: ingress
                  target: 443
                  published: "443"
                  protocol: tcp
              restart: unless-stopped
              volumes:
                - type: bind
                  source: /var/run/docker.sock
                  target: /var/run/docker.sock
                  bind:
                    create_host_path: true
                - type: bind
                  source: /appdata/caddy/data
                  target: /data
                  bind:
                    create_host_path: true
          networks:
            caddy:
              name: caddy
              external: true
        '';
      };
      "dockge.yml" = {
        enable = true;
        target = "dockge.yml";
        text = ''
          name: dockge
          services:
            dockge:
              container_name: dockge
              environment:
                DOCKGE_STACKS_DIR: /appdata/dockge/stacks
              image: louislam/dockge:latest
              labels:
                caddy: dockge.jafner.net
                caddy.reverse_proxy: '{{upstreams 5001}}'
              networks:
                caddy: null
              restart: unless-stopped
              volumes:
                - type: bind
                  source: /var/run/docker.sock
                  target: /var/run/docker.sock
                  bind:
                    create_host_path: true
                - type: bind
                  source: /appdata/dockge/data
                  target: /app/data
                  bind:
                    create_host_path: true
                - type: bind
                  source: /appdata/dockge/stacks
                  target: /appdata/dockge/stacks
                  bind:
                    create_host_path: true
          networks:
            caddy:
              name: caddy
              external: true
        '';
      };
      "whatsupdocker.yml" = {
        enable = true;
        target = "whatsupdocker.yml";
        text = ''
          name: whatsupdocker
          services:
            whatsupdocker:
              image: getwud/wud
              container_name: wud
              networks:
                - caddy
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
              labels:
                caddy: wud.jafner.net
                caddy.reverse_proxy: "{{upstreams 3000}}"
          networks:
            caddy:
              name: caddy
              external: true
          x-dockge:
            urls:
              - https://wud.jafner.net
        '';
      };
      "kuma.yml" = {
        enable = true;
        target = "kuma.yml";
        text = ''
          name: kuma
          services:
            autokuma:
              image: ghcr.io/bigboot/autokuma:latest
              container_name: autokuma
              restart: unless-stopped
              networks:
                - kuma
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
                - /appdata/autokuma/data:/data
              env_file:
                - path: /run/secrets/autokuma
            uptime-kuma:
              image: louislam/uptime-kuma:1
              container_name: uptimekuma
              restart: unless-stopped
              volumes:
                - /appdata/uptimekuma/data:/app/data
                - /var/run/docker.sock:/var/run/docker.sock
              networks:
                - caddy
                - kuma
              labels:
                caddy: uptime.jafner.net
                caddy.reverse_proxy: "{{upstreams 3001}}"
                homepage.name: Uptime Kuma
                homepage.group: Admin
                homepage.icon: sh-uptime-kuma
                homepage.href: https://uptime.jafner.net
                homepage.description: Simple service monitor.
          networks:
            kuma:
              name: kuma
            caddy:
              name: caddy
              external: true
          x-dockge:
            urls:
              - https://uptime.jafner.net
        '';
      };
      "forwardauth.yml" = {
        enable = true;
        target = "forwardauth.yml";
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
            nginx:
              image: nginx:latest
              container_name: nginx
              restart: unless-stopped
              networks:
                - caddy
              labels:
                caddy: nginx.jafner.net
                caddy.forward_auth: forwardauth:4181
                caddy.forward_auth.uri: /_oauth
                caddy.forward_auth.copy_headers: X-Forwarded-User
                caddy.reverse_proxy: "{{upstreams 80}}"
          networks:
            caddy:
              name: caddy
              external: true
          x-dockge:
            urls:
              - https://nginx.jafner.net
        '';
      };
      "keycloak.yml" = {
        enable = true;
        target = "keycloak.yml";
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
    home.packages = [
      # (pkgs.writeShellApplication {
      #   name = "rmount";
      #   runtimeInputs = [
      #     pkgs.rclone
      #   ];
      #   text = ''
      #     #! /usr/bin/env bash
      #     rmount() {
      #       SOURCE="$1"
      #       DEST="''$''\{2:-$(echo $SOURCE | sed 's/:/\//' | sed 's/^/\/mnt\//')}"
      #       if ! [ -d $DEST ]; then sudo mkdir -p "$DEST"; sudo chown -R ${username}:users "$DEST"; fi
      #       rclone \
      #         --no-check-certificate \
      #         --config /home/$USER/.config/rclone/rclone.conf \
      #         mount \
      #         --daemon \
      #         "$SOURCE" \
      #         "$DEST"
      #     }
      #     rmount "$@"
      #   '';
      # })
    ];
  };
  systemd.services."rclone-mount" = {
    script = ''
      #! /usr/bin/env bash
      rmount() {
        SOURCE="$1"
        DEST="''$''\{2:-$(echo $SOURCE | sed 's/:/\//' | sed 's/^/\/mnt\//')}"
        if ! [ -d $DEST ]; then sudo mkdir -p "$DEST"; sudo chown -R ${username}:users "$DEST"; fi
        rclone \
          --no-check-certificate \
          --config /home/${username}/.config/rclone/rclone.conf \
          mount \
          --daemon \
          "$SOURCE" \
          "$DEST"
      }
    '';
    serviceConfig = {
      User = "${username}";
    };
  };
}
