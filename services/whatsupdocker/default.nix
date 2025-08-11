{username, ...}: let
  service = "whatsupdocker";
in {
  sops.secrets."whatsupdocker" = {
    sopsFile = builtins.toFile "whatsupdocker" ''
      WUD_AUTH_OIDC_KEYCLOAK_CLIENTID=ENC[AES256_GCM,data:daJaBeH52Fi3HyIp6F8=,iv:4CXhsCCkvmllM/ueL9sEiNLCLQSlOWjVzaF2l+z9bKI=,tag:FtdwyYzbzdOPTNhcDLt1jg==,type:str]
      WUD_AUTH_OIDC_KEYCLOAK_CLIENTSECRET=ENC[AES256_GCM,data:PT2suUi27oxZcmPTjhGOOXMCZfBEZCAJZshX3BGwN20=,iv:B7nnQKRKY/L9xUZLjOxFvK0nnmDaB66+EKocqFvILW0=,tag:5NhxdekWJyjBdiMkOuaZvA==,type:str]
      WUD_AUTH_OIDC_KEYCLOAK_DISCOVERY=ENC[AES256_GCM,data:CmjimV0cahxmBAWLMeZJyQ5IFCKZsSBXyfNIY1b/PUwmU67qvAKopaFJbokzuD/vVaXUDCm1eRFesKyMpp4W/9xwSz3ff5LHtCCTn8NT,iv:S0bC5tdlFsBhhUV3v2HZ2IFnYahGJ7usxvBoqR1WDOw=,tag:sOrF80cCRsRdfXkS0hOn6g==,type:str]
      WUD_AUTH_OIDC_KEYCLOAK_REDIRECT=ENC[AES256_GCM,data:v6ifpQ==,iv:nZsjzinTrh1dSw4gAvv0MjFDDfhCsXG2RLRRdLd4eZ8=,tag:iLQflbxIm1oqV8rSgZV2uQ==,type:str]
      sops_age__list_0__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBYbnQvbi93dEpuYTV3MGV6\nMWJOeEQ3b0VvUUorc0oyejYydnFWTm5icFVJCkFzcnNvYWU1MU4zd0JsQVh0MDlB\nbzcxU0NNVVVOTjc4eU5NUXYrcWdyWWMKLS0tIFNlUDhmZmpWSEJTSDFYUiswSm45\nYzVuaE5QOTZ4TmgvT2UyTXpDV3k4WTgKLf6txv2VA47V+cviIPe784YF7j/vVJS1\nx7gR2eNN/2LjGwJCWnhxG2GxpQZh0j/SlMM0oOdSPj857l/BL3JGAg==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_0__map_recipient=age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n
      sops_age__list_1__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBzaGg1OXRnU08wQTM5MDdV\nd3V2UUorK0I2ZlNJdW5sUnNhWS9TMHFabDFjCjRaSllDNVZwazMyeTRGYlhJVnI0\nTU1SRnFRVzkzbUhjbWV2ZjJBajhSL1kKLS0tIFI3ajRiK2JIRHRmVVJZazNJNjdW\nT1c1cVFoN1Z4VEZ6aEl6QS8wTWVOam8Kv3DxPfB4mXjU1iyXXYQNhrP3KQBsZtDP\nMyxqe3QWKPfNGpYE2+8RksBWDURrFZB6054CV/uDoCTlMYfpM1FMZA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_1__map_recipient=age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00
      sops_age__list_2__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBYVmJBVm1RcmMxVzZGakxa\nY3dUU201VThPUkl2dW41STgzWkZlRS80OTI0ClVYZmFaSHFTMkF6ajJKN1ZoUTdp\nSkFzZ0xkRGpKeTlpczEzdEJ0aXFrUDAKLS0tIFVvRjVLOGpiWGRseVA2ZXVSMkph\nbGFCSEhPYUVKSmt0TVFIVzZxTlFIYzQKhhlaCKzVer63pEKwyogto/nAy7cDByTR\nSHLX3KKH8WWM3lCPkOCCKSMDw+/IZ+KK991aIhjfUnaO2V/vgw7CXw==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_2__map_recipient=age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926
      sops_age__list_3__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBlOC9uWWVWNExjQVVSbFQ4\nZkQvd3NsaGtWaW1XeW16RFpXZW5BYzNDb1VJCjlua3J5U2pqckJMM0hPd05Jc09W\nanpUa3J3MFRlY3ZDZFZwaHBuU1JDUUkKLS0tIEYwNlk5M1poLzNsS3ZJaUYwekow\nSDdjdnRhS2JUZlc2ZnplYTcwWFNrVlEKt0QeFJMVmFnPiJIuR+TrP0qea/soTLA2\njl+B4u7GET4EXxdNngjvBttruXG30UUvMHuPtsnJAxZV5W0lCgoFJQ==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_3__map_recipient=age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj
      sops_age__list_4__map_enc=-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSAwbnNLd2g1aTlEdkIvT2lB\naHpFOUIxK1FyWmhUY1l0V0gwUHhtUGxwWFVvCnh2Y01nTUVGYWc0VThlKysrODJZ\nWkhBb1ZDTUdSUHlacU1GU21rckpYV0kKLS0tIGljTTlXYXhOTjRQR3JJdHB2V2Zu\nVmJhYVFaczVjeHk1alFlWkZaQjdicWcKcNEq/695dnN2n09Pq6sJcKch5qOzJgfU\nAVCuF6o9qRyG1ZUfEeXbqcuGl9e5n4IiG6fd8B520D3yLc7WDrYPsA==\n-----END AGE ENCRYPTED FILE-----\n
      sops_age__list_4__map_recipient=age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6
      sops_lastmodified=2025-06-06T08:47:19Z
      sops_mac=ENC[AES256_GCM,data:669qXmOQC8V9vz3OR3qnxmMKrUOh4Syuo2Lw62FkM3mfQOgyNPbgQxqeEQQ4OKnRDfitl9xslTia8g0DLdgVQ2YcR7lK4EKaKP3mrO3l3og7XwZ3gatt7mfiJCiQ2V6LI2U8WxHMZpFkpijoJ0ImSj5mBnmWaCld6/cBJqd5DIk=,iv:7v2DatAqYGoUb0pCAM8+2VkiyxULAd0hH0oaI4aK/dg=,tag:Axp5qQX7y66wnBzOH9dipw==,type:str]
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
        name: whatsupdocker
        services:
          whatsupdocker:
            image: getwud/wud
            container_name: whatsupdocker
            networks:
              - caddy
            env_file:
              - /run/secrets/whatsupdocker
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
  };
}
