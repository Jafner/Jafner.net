## Connecting to SFTP
1. Install an SFTP client. See https://www.sftp.net/clients
2. Configure a new connection with the following parameters:

| Parameter | Value |
|:---------:|:-----:|
| Address | $(curl ifconfig.me) |
| Port | `23450` |
| User | `sftp` or provision a new account |
| Pass | See Bitwarden item for the account |

3. Begin transferring files. :)