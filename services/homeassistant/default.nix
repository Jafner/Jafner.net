{username, ...}: let
  service = "homeassistant";
in {
  sops.secrets."homeassistant/mosquitto" = {
    sopsFile = builtins.toFile "mosquitto" ''
      {
       	"data": "ENC[AES256_GCM,data:8noj6AWUjPInUKYml071jaiW0PB6l8Rrz6K0SHpZeX0Db2PxDloZRjmu3NSsKuGD2+eyihk4wYCw0pOHA3O83nYdXnpEOs6opBJF0E9kr7Ous2JUytB5vAMzg+MC8uTGEKyYvMdPuIIUgj4H2XlBqTnO5vSCIlY=,iv:Q4uFkpHYdX36Yks8q1a70vj6Zrxen2BT76hojSLbPZY=,tag:YMJIbY2st5OG1lVdwGrDQQ==,type:str]",
       	"sops": {
        		"age": [
       			{
        				"recipient": "age1v5wy7epv5mm8ddf3cfv8m0e9w4s693dw7djpuytz9td8ycha5f0sv2se9n",
        				"enc": "-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBHSUJiaVlMSmxXRDNqR2JC\nMjhKaUo1cFIvVmJQRGQyUFZPb2FTYVdVaGdvClVqODF4QzBsRSt1UkY0VDFyblN3\nNm1laXg0M05HYW5lVVFYZHpCM0hMZFUKLS0tIDMwN3hrampEK05VelBRcUQ1M0VS\nRHIzcGxZUnJSY08xWTNoVlNNdjNhMHcK92xBMR9KZq8O0S3Q8WPjaMevp3q1FtTr\neGswUZB06ued7ZuAAN1js55n0cOFD3Wa1Ygwdr6Ygo1yafsz9wWOqA==\n-----END AGE ENCRYPTED FILE-----\n"
       			},
       			{
        				"recipient": "age1zswcq6t5wl8spr3g2wpxhxukjklngcav0vw8py0jnfkqd2jm2ypq53ga00",
        				"enc": "-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBNbVU2YVVrcUxWMGtTY1Vs\nUHNsczcyY3FSWkt1M1l5Nmk5V3l0RTBlSFE4Ci9mUE1jU2w3TjZqc2N5ZjVrMmNW\nM2l4cEgzU1lVNzQ3Qk52RWhnRytsVG8KLS0tIFdaMFJmMGpRZTdtYVYxOVRxUFJX\nTDV5WDhVUjg0Qnk5Y0Zudm43a3p5WjAKPwjUXfczj0E/YeezBRLhtTGsbypXYN81\nQR6Bxi2S+PCF3k1G5j6fgnlVghvxrCmZ9N7xAZKgvPRiuadoB4bXYQ==\n-----END AGE ENCRYPTED FILE-----\n"
       			},
       			{
        				"recipient": "age1nq652a3y063dy5wllucf5ww29g7sx3lt8ehhspxk6u9d28t8ndgq9q0926",
        				"enc": "-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSA2cW51TFhKOHlsTUtDZ0Vk\neWhOS2pEYWFoTVgxWTFpQlVXTURNZS93UGowCmxtVEtVYnRLMnAwRzFFcUtjWCtW\ncE93Q0thdVRkSGUxcm1ROWNyWXJLNjgKLS0tIHFmNzd3M2ltcmcvOVM2LzBNTGRG\nbUhMV3RabDFzam1VYlprMHRScnNndDgKj+xrBz1sGs9RE1W6tJB38dvhppXCaeHD\nkwR5w6LizTE7ecpaXsZGIq+0eWVrHuZYlNh/fATPLxe2jn8tlCuNcg==\n-----END AGE ENCRYPTED FILE-----\n"
       			},
       			{
        				"recipient": "age1mmy5xx4nxun5fexpxdl2tjx60akc4sgktrquq8c6ggvtehcpa3ss2hh2tj",
        				"enc": "-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBhVU1hL1dDOHpUNjZCQThq\nNS9yMkxmK1IwT2dyR213L3RyQ2dDVGtUb1VJCkhEaWZyRElpWVRzM0cyajFWYlg1\nNVpkMnN5TmF5UVBBbUozQmd2dG9jQ1kKLS0tIG5iNFVRcDQ0Ymd2TGlVZGFMc25l\naFFsWnVBSlZOMXlpU1dubTI5MWJrcXcKUEOHBAfiwA3l/0bUEKQyExIf1lFAdSBA\nrUeAubcVv4bmKwhUmFtIZt0udSOQK5/xxhQ3ZMN0v/TpbSDYKfvEjg==\n-----END AGE ENCRYPTED FILE-----\n"
       			},
       			{
        				"recipient": "age10k706un6exgaym7yt8jnxz8m8n25wd9fezqxr43zkzatjleagg2s64mwt6",
        				"enc": "-----BEGIN AGE ENCRYPTED FILE-----\nYWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSAwNlFCQ2NXUlV1ZGhtNFBw\nWlZ1Tm03cnppdC9DdWZwdzlWMEdmZEtud0JvCkFveEVhNkFQZUx2Z2dRWllGbnZy\nQndqcG53SDBvbmExbk9iWEl1SzliZ00KLS0tIEpHNEUzRFZhMFhGTWt4cmx6S05G\nbERQRnlTRk1lRUUzaEZ2YXdnWXYzWjAKKm433HEYL48CW4wDbwnA5xWnmTKWePpJ\nlwmJ/LuMQLaGTF5R8XsqFYK5dcHo797fz5w1WldJ9J5WZf/qfeF43w==\n-----END AGE ENCRYPTED FILE-----\n"
       			}
        		],
        		"lastmodified": "2025-06-06T20:39:20Z",
        		"mac": "ENC[AES256_GCM,data:iqw53MpxOfBHnN1v+AObt+AIeD6fj5QVosyy+RCTje81TcrgZvdHMzblsqIoKx2Kau9v+KmL9SSO4W5HEqYKFWWagU83kxiZDbfN1VlEuVBClbt5vnk7pt+LQ2F5lQjcArecXRJ/kvb0hWkqR7hJi1Li6JdUltsbCT4C/ykWOmM=,iv:Mx6iLm18NMzuxDDajc4pSM36xEth+xCaExhpn3sQIBk=,tag:6KKeVIdpl4rHGFlrBWyjng==,type:str]",
        		"unencrypted_suffix": "_unencrypted",
        		"version": "3.10.2"
       	}
      }
    '';
    mode = "0440";
    format = "binary";
    owner = username;
  };
  home-manager.users.${username} = {
    home.file."${service}" = {
      enable = true;
      target = "stacks-nix/${service}/compose.yml";
      text = ''
        name: homeassistant
        services:
          homeassistant:
            image: lscr.io/linuxserver/homeassistant:latest
            container_name: homeassistant
            environment:
              PUID: "1000"
              PGID: "100"
              TZ: "America/Los_Angeles"
            networks:
              - caddy
              - homeassistant
            volumes:
              - /appdata/homeassistant/homeassistant:/config
              - /run/dbus:/run/dbus:ro
            labels:
              caddy: homeassistant.jafner.net
              caddy.reverse_proxy: "{{upstreams 8123}}"

          mosquitto:
            image: eclipse-mosquitto:latest
            container_name: mosquitto
            networks:
              - homeassistant
            volumes:
              - ./mosquitto.conf:/mosquitto/config/mosquitto.conf
              - /run/secrets/homeassistant/mosquitto:/mosquitto/config/mosquitto.passwd
              - /appdata/homeassistant/mosquitto:/mosquitto/data
            ports:
              - 12883:1883
              - 19001:9001

        networks:
          caddy:
            name: caddy
            external: true
          homeassistant:
      '';
    };
    home.file."mosquitto.conf" = {
      enable = true;
      target = "stacks-nix/${service}/mosquitto.conf";
      text = ''
        persistence true
        persistence_location /mosquitto/data/
        user mosquitto
        listener 1883 0.0.0.0
        allow_anonymous false
        log_dest file /mosquitto/log/mosquitto.log
        log_dest stdout
        password_file /mosquitto/config/mosquitto.passwd
      '';
    };
  };
}
