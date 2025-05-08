{ username, ... }:
let
  stack = "immich";
in
{
  sops.secrets."${stack}/immich" = {
    sopsFile = ./immich.secrets;
    key = "";
    mode = "0440";
    format = "dotenv";
    owner = username;
  };
  home-manager.users."${username}".home.file = {
    "${stack}/docker-compose.yml" = {
      enable = true;
      text = ''
        name: immich
        services:
          server:
            container_name: immich_server
            image: ghcr.io/immich-app/immich-server:latest
            volumes:
              - /appdata/${stack}/upload:/usr/src/app/upload
              - /etc/localtime:/etc/localtime:ro
            env_file:
              - /run/secrets/${stack}/immich
            environment:
              TZ: America/Los_Angeles
              DB_USERNAME: postgres
              DB_DATABASE_NAME: immich
            devices:
              - /dev/dri:/dev/dri
            networks:
              - immich
              - web
            depends_on:
              - redis
              - postgres
            labels:
              - traefik.http.routers.immich.rule=Host(`immich.jafner.net`)
              - traefik.http.routers.immich.tls.certresolver=lets-encrypt
          ml:
            container_name: immich_ml
            image: ghcr.io/immich-app/immich-machine-learning:latest
            networks:
              - immich
            volumes:
              - model-cache:/cache

          redis:
            container_name: immich_redis
            image: docker.io/valkey/valkey:8-bookworm@sha256:42cba146593a5ea9a622002c1b7cba5da7be248650cbb64ecb9c6c33d29794b1
            networks:
              - immich
            healthcheck:
              test: redis-cli ping || exit 1
          postgres:
            container_name: immich_postgres
            image: docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:739cdd626151ff1f796dc95a6591b55a714f341c737e27f045019ceabf8e8c52
            networks:
              immich:
                aliases:
                  - database
            environment:
              POSTGRES_PASSWORD: $DB_PASSWORD
              POSTGRES_USER: postgres
              POSTGRES_DB: immich
              POSTGRES_INITDB_ARGS: '--data-checksums'
            volumes:
              - /appdata/${stack}/postgres:/var/lib/postgresql/data
            healthcheck:
              test: >-
                pg_isready --dbname="$${POSTGRES_DB}" --username="$${POSTGRES_USER}" || exit 1; Chksum="$$(psql --dbname="$${POSTGRES_DB}" --username="$${POSTGRES_USER}" --tuples-only --no-align --command='SELECT COALESCE(SUM(checksum_failures), 0) FROM pg_stat_database')"; echo "checksum failure count is $$Chksum"; [ "$$Chksum" = '0' ] || exit 1
              interval: 5m
              start_interval: 30s
              start_period: 5m
            command: >-
              postgres -c shared_preload_libraries=vectors.so -c 'search_path="$$user", public, vectors' -c logging_collector=on -c max_wal_size=2GB -c shared_buffers=512MB -c wal_compression=on

        volumes:
          model-cache:

        networks:
          web:
            external: true
          immich:
      '';
      target = "stacks/${stack}/docker-compose.yml";
    };
  };
}
