# OIDC Configuration Information Table
| Application asks for... | URL |
|:-----------------------:|:---:|
| Client ID | In Keycloak, under the Jafner.net realm, click Clients -> Create Client. Set your own Client ID |
| Client Secret | After creating the client in Keycloak, go to Clients -> <new client> -> Credentials. Then click the copy icon to the right of "Client secret".
| Client Scopes | `email openid profile`
| Authorization URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/auth |
| Access token URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/token |
| Resource URL, Userinfo URL, API URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/userinfo |
| Redirect URL | Use the home URL of the application (e.g. https://portainer.jafner.net) |
| Logout URL | https://keycloak.jafner.net/realms/Jafner.net/protocol/openid-connect/logout |

# How to Add ForwardAuth to a New Service
We'll assume the new service is hosted at `https://web.jafner.net`.
1. Open the [traefik-forward-auth client configuration page](https://keycloak.jafner.net/admin/master/console/#/Jafner.net/clients/90760ab3-f77f-48da-9dc1-df5ea6eed3a3/settings) and add the new site (appended with `/_oauth`) to the list of valid redirect URIs. E.g. `https://web.jafner.net/_oauth`.
2. Add the `traefik-forward-auth@file` Traefik middleware to the service. 
3. Start up the new service. Open a new private window and navigate to the new service (`https://web.jafner.net`). It should redirect to Keycloak with a login prompt.
4. If applicable, disable any local auth. 