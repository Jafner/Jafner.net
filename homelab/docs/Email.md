# Connect a service to the noreply@jafner.net service account
| Key | Value | Note |
|:---:|:-----:|:----:|
| From Address | noreply@jafner.net |
| From Name | No Reply | 
| Protocol | SMTP |
| Mail Server | smtp.gmail.com | 
| Mail Server Port | 465 |
| Security | SSL (Implicit TLS) |
| SMTP Authentication | Yes |
| Username | noreply@jafner.net |
| Password | *Create a unique Application Password (see below)*  |

## Create an Application Password
1. To get an Application Password, navigate to the [Google Account Console -> Security
](https://myaccount.google.com/u/2/security), then click "App passwords".
2. Under the "Select device" drop-down menu, select "Other (custom name)" and type the name of the service that will use the password. 
3. Copy the yellow-highlighted App password. Use it for the desired service.

## References
1. [Google Support - Check Gmail through other email platforms](https://support.google.com/mail/answer/7126229?hl=en#zippy=%2Cstep-check-that-imap-is-turned-on%2Cstep-change-smtp-other-settings-in-your-email-client)