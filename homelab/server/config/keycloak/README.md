# Configuring an OIDC client with Keycloak
1. For the Jafner.net realm, navigate to Clients -> Create Client.
2. Create a client of type 'OpenID Connect', and choose a Client ID. The client ID should be short and unique (e.g. 'gitlab.jafner.net'). Click Next, enable Client Authentication, and click Save.
3. Under the Credentials tab, copy the Client secret for future use.
4. 

## URL Table
| Application asks for... | URL |
|:-----------------------:|:---:|
| Authorization URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/auth |
| Access token URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/token |
| Resource URL or Userinfo URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/userinfo |
| Redirect URL | Use the home URL of the application (e.g. https://portainer.jafner.net)
| Logout URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/logout