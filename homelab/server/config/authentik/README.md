# Add an OAuth2 Application
1. Navigate to the Authentik Admin Interface. Open the Navigation pane and expand Applications. Click on [Providers](https://authentik.jafner.net/if/admin/#/core/providers).
2. Create a new provider with the following parameters:

| Parameter | Value |
|:---------:|:-----:|
| Provider type | OAuth2/OpenID Provider |
| Name | *Name of new application (e.g. Grafana)* |
| Authorization flow | Authorize Application (default-provider-authorization-implicit-consent) |
| Client type | Confidential |
| Client ID | *Copy this value for later use* |
| Client Secret | *Copy this value for later use* |
| Redirect URIs/Origins | *Leave blank* |
| Signing Key | authentik Self-signed Certificate (RSA) |

3. Leave Advanced protocol settings and Machine-to-Machine authentication settings as defaults. Save by clicking the Finish button.
4. Navigate to Applications and create a new application with the following parameters:

| Parameter | Value |
|:---------:|:-----:|
| Name | *Name of new application (e.g. Grafana)* |
| Slug | *URL-compliant version of name (e.g. grafana)* |
| Group | *Leave empty* |
| Provider | *Select the provider created in step 2* |
| Policy engine mode | ANY, any policy must match to grant access. |

5. Leave UI settings as default, save by clicking the Create button.
6. Open the OAuth2 configuration settings in the new application and apply settings as follows:

| Common Application Configuration Term | Value (or *Authentik key*) |
|:-------------------------------------:|:--------------------------:|
| Client Type | Confidential |
| Client ID | *Client ID* |
| Client Secret | *Client Secret* |
| Scopes | `email openid profile` |
| Auth URL | *Authorize URL* |
| Token URL | *Token URL* |
| API URl | *Userinfo URL* |

7. Apply and restart the application.

# Switching to single-screen (autofill compatible) login
The default out-of-box configuration for Authentik uses two separate screens for inputting username and password (and an optional third for MFA). This breaks compatibility with password managers. To switch to using single-stage username and password login, 

1. Navigate to *Flows & Stages --> Stages --> default-authentication-identification* and edit the "Password stage" to use `default-authentication-password`. 
2. Navigate to *Flows & Stages --> Flows --> default-authentication-flow* and open it. Go to Stage Bindings, select the `default-authentication-password` stage and delete it from the flow (as it is now included in the previous stage). 

All done.

# Make Application Admin-only
Some applications should be available only to members of the Jafner.net Admins group. To protect an application behind this role, 

1. Navigate to *Applications --> Applications* and open the relevant application. 
2. Switch to the "Policy / Group / User Bindings" tab.
3. Click "Create Binding", switch from "Policy" to "Group" (or "User", if preferred). From the drop-down, select the group which should be permitted to access the application, then click "Create". 

All done.

# Set up SSO for an application
1. Add the following Traefik labels to the application:

```yml
labels:
      - traefik.http.routers.<service>.rule=Host(`<service>.jafner.net`)
      - traefik.http.routers.<service>.tls.certresolver=lets-encrypt
      - traefik.http.routers.<service>.middlewares=authentik@file
      - traefik.http.routers.<service>.priority=10
      - traefik.http.routers.<service>-auth.rule=Host(`<service>.jafner.net`) && PathPrefix(`/outpost.goauthentik.io/`)
      - traefik.http.routers.<service>-auth.priority=15
      - traefik.http.routers.<service>-auth.service=http://authentik-server:9000/outpost.goauthentik.io
```

2. In the Authentik admin interface, navigate to *Applications --> Providers* and create a new provider. 
    2a. Select type Proxy Provider. 
    2b. Set the name to the name of the service (e.g. Sonarr). 
    2c. Use the `default-provider-authorization-implicit-consent` Authorization flow. 
    2d. Select the "Forward auth (single application)" configuration.
    2e. For External host, use the value of the host rule label prepended with `https://` (e.g. `https://sonarr.jafner.net`).
    2f. Leave the rest of the configuration as default. Click Finish to create the provider.
3. In the Authentik admin interface, navigate to *Applications --> Applications* and create a new application. 
    2a. Set the Name to the name of the service (e.g. Sonarr).
    2b. Set the Slug to a URL-compliant version of the Name (e.g. `sonarr`)
    2c. Set the Group if the service is part of a *group of services) (e.g. autopirate).
    2d. Use the provider created in step 2 as Provider.
    2e. Leave the rest of the configuration as default. Click Create to create the application. 