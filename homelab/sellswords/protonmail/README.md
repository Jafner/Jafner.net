# Configure SMTP Submission via ProtonMail
| Key | Value |
|:---:|:-----:|
| From Address | noreply@jafner.net |
| From Name | No Reply | 
| Protocol | SMTP |
| Mail Server | smtp.gmail.com | 
| Mail Server Port | 465 |
| Security | SSL (Implicit TLS) |
| SMTP Authentication | Yes |
| Username | noreply@jafner.net |
| Password | *Create a unique Application Password (see below)*  |

> Note: As of now, ProtonMail's SMTP submission feature is restricted to [Proton for Business](https://proton.me/business/plans), [Visionary](https://proton.me/support/proton-plans#proton-visionary), and [Family](https://proton.me/support/proton-plans#proton-family) plans. Additionally, new accounts must submit a support ticket articulating their use-case and domains to add in order to get SMTP submission enabled for their account.

## Create a Token
1. To get a token, navigate to the [ProtonMail Settings -> IMAP/SMTP](https://account.proton.me/u/0/mail/imap-smtp), then click "Generate token".
2. Set the "Token name" to the service that will be sending emails.
3. Set the "Email address" to "noreply@jafner.net".

## References
1. [ProtonMail Support - How to set up SMTP to use business applications or devices with Proton Mail](https://proton.me/support/smtp-submission)