# Config Snippets for `config.php`
The Nextcloud server is configured via `config.php` at `$DOCKER_DATA/config/www/nextcloud/config/`. We make changes to this file manually, and then restart or recreate the container to apply the changes.

All configuration parameters are contained in the `<?php $CONFIG=array (` block.

## Mail via Gmail
```php
  'mail_smtpmode' => 'smtp',
  'mail_smtpsecure' => 'ssl',
  'mail_sendmailmode' => 'smtp',
  'mail_from_address' => 'noreply',
  'mail_domain' => 'jafner.net',
  'mail_smtpauthtype' => 'LOGIN',
  'mail_smtpauth' => 1,
  'mail_smtphost' => 'smtp.gmail.com',
  'mail_smtpport' => '465',
  'mail_smtpname' => 'noreply@jafner.net',
  'mail_smtppassword' => '${REPLACEME_SMTP_PASSWORD}',
```

## Trusted Proxies
```php
  'trusted_proxies' => 
    array (
      0 => '${REPLACEME_IP_OF_TRAEFIK_CONTAINER}',
    ),
```

## Transactional File Locking with Redis
```php
  'filelocking.enabled' => true,
  'memcache.locking' => '\OC\Memcache\Redis',
  'redis' => array(
    'host' => 'redis',
    'port' => 6379,
    'timeout' => 0.0,
    'password' => '', // Optional, if not defined no password will be used.
  ),
```