set system config-management commit-revisions '200'
set system conntrack expect-table-size '8192'
set system conntrack hash-size '32768'
set system conntrack modules ftp
set system conntrack modules h323
set system conntrack modules nfs
set system conntrack modules pptp
set system conntrack modules sip
set system conntrack modules sqlnet
set system conntrack modules tftp
set system conntrack table-size '262144'
set system conntrack timeout tcp time-wait '15'
set system console device ttyS0 speed '115200'
set system host-name 'vyos'
set system login banner
set system login user vyos authentication encrypted-password $SYSTEM_LOGIN_USER_VYOS_AUTHENTICATION_ENCRYPTEDPASSWORD
set system login user vyos authentication otp key $SYSTEM_LOGIN_USER_VYOS_AUTHENTICATION_OTP_KEY
set system login user vyos authentication otp rate-limit '3'
set system login user vyos authentication otp rate-time '30'
set system login user vyos authentication otp window-size '3'
set system login user vyos authentication public-keys deploy@gitea.jafner.tools key 'AAAAC3NzaC1lZDI1NTE5AAAAIBzQU/ZbpLXgAXUImNKNfkyEkggRfgVDCozOVby/CLMR'
set system login user vyos authentication public-keys deploy@gitea.jafner.tools type 'ssh-ed25519'
set system login user vyos authentication public-keys jafner425@gmail.com key 'AAAAC3NzaC1lZDI1NTE5AAAAIMbzncsWNWxoDSqeva/ZoGHv32A0ggUMWfzx2Gz6Kmkk'
set system login user vyos authentication public-keys jafner425@gmail.com type 'ssh-ed25519'
set system name-server '192.168.1.32'
set system name-server 'eth5'
set system option performance 'latency'
set system syslog global facility all level 'info'
set system syslog global facility local7 level 'debug'
set system task-scheduler task update-nat-reflection executable path '/home/vyos/ipupdate.sh'
set system task-scheduler task update-nat-reflection interval '30'
set system time-zone 'America/Los_Angeles'
