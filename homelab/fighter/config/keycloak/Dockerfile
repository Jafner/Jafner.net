FROM quay.io/keycloak/keycloak:23.0 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=${DB:-postgres}

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 8192 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=${DB:-keycloak}
ENV KC_DB_URL=${DB_URL:-postgres}
ENV KC_DB_USERNAME=${DB_USER:-keycloak}
ENV KC_DB_PASSWORD=${DB_PASS:-changeme}
ENV KC_HOSTNAME=${HOST:-keycloak}
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]