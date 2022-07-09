# Add an OAuth2 Application
1. Navigate to the Authentik Admin Interface. Open the Navigation pane and expand Applications. Click on [Providers](https://authentik.jafner.net/if/admin/#/core/providers).
2. Create a new provider with the following parameters:

| Parameter | Value |
|:---------:|:-----:|
| Provider type | OAuth2/OpenID Provider |
| Name | *Name of new application (e.g. Grafana)* |
| Authorization flow | Authorize Application (default-provider-authorization-explicit-consent) |
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