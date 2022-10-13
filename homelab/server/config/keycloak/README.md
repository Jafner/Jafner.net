# OIDC Configuration Information Table
| Application asks for... | URL |
|:-----------------------:|:---:|
| Client ID | In Keycloak, under the Jafner.net realm, click Clients -> Create Client. Set your own Client ID |
| Client Secret | After creating the client in Keycloak, go to Clients -> <new client> -> Credentials. Then click the copy icon to the right of "Client secret".
| Client Scopes | `email openid profile`
| Authorization URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/auth |
| Access token URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/token |
| Resource URL, Userinfo URL, API URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/userinfo |
| Redirect URL | Use the home URL of the application (e.g. https://portainer.jafner.net)
| Logout URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/logout