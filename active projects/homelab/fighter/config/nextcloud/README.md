# Config Snippets for `default.conf` Nginx config
The Nginx server inside the container manages many aspects of connectivity for the Nextcloud server. 
The `default.conf` here is for reference only.
The effective `default.conf` file is located at: `/config/nginx/site-confs/default.conf`.


## Increase Upload Limits
In the `server {` block:
```conf
client_max_body_size 50G;
client_body_timeout 600s;
```

# Config Snippets for `php-local.ini` PHP config override
It seems the preferred mode for modifying Nextcloud's PHP config is via `php.ini`, located at `/config/php/php-local.ini`.

## Increase Upload Limits
```ini
upload_max_filesize = 8192M
post_max_size = 8192M
max_execution_time = 600
```

## Increase PHP Memory Limit
```ini
memory_limit = 4G
```

# Config Snippets for `config.php` PHP config
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

## HEIC Image Previews
```php
  'enable_previews' => true,
  'enabledPreviewProviders' =>
  array (
    'OC\Preview\PNG',
    'OC\Preview\JPEG',
    'OC\Preview\GIF',
    'OC\Preview\BMP',
    'OC\Preview\XBitmap',
    'OC\Preview\MP3',
    'OC\Preview\TXT',
    'OC\Preview\MarkDown',
    'OC\Preview\OpenDocument',
    'OC\Preview\Krita',
    'OC\Preview\HEIC',
  ),
```

## Increase Upload Limits
```php
  upload_max_filesize = 2048M
  post_max_size = 2048M
  max_execution_time = 200
```