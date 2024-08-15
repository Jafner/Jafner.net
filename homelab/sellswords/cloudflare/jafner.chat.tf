resource "cloudflare_record" "any_jafner_chat" {
  content = "174.21.59.108"
  name    = "*"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_chat.id
}

resource "cloudflare_record" "root_jafner_chat" {
  content = "174.21.59.108"
  name    = "jafner.chat"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_chat.id
}

