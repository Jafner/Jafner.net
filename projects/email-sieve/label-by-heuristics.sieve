require ["fileinto", "include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest", "regex", "imap4flags", "date"];

# Generated: Do not run this script on spam messages
if allof (
    environment :matches "vnd.proton.spam-threshold" "*",
    spamtest :value "ge" :comparator "i;ascii-numeric" "${1}"
) { return; }

if anyof(
    address :comparator "i;unicode-casemap" :contains "From" ["bennyr.cloud", "maddiecrawfo13@gmail.com", "ccmychart.org", "o.sofi.org", "noreply@jafner.net"],
    allof( 
        address :domain :comparator "i;unicode-casemap" :is "From" ["notify.cloudflare.com"], 
        header :comparator "i;unicode-casemap" :contains "Subject" ["Certificate Transparency Notification", "Your Cloudflare Invoice is Available"] 
    ),
    allof( 
        address :domain :comparator "i;unicode-casemap" :is "From" ["privacy.com"], 
        header :comparator "i;unicode-casemap" :contains "Subject" ["Transaction decline notification"]
    ),
    allof(
        address :domain :comparator "i;unicode-casemap" :is "From" ["amazon.com"], 
        header :comparator "i;unicode-casemap" :contains "Subject" ["Delivered:"]
    ),
    allof(
        address :domain :comparator "i;unicode-casemap" :is "From" ["digitalocean.com"], 
        header :comparator "i;unicode-casemap" :matches "Subject" ["Your * invoice is available"]
    )
) { fileinto :copy "Important"; return; }
elsif anyof(
    header :comparator "i;unicode-casemap" :contains "Subject" ["Confirmation", "Receipt", "Your subscription", "Your order", "Password reset", "Your appointment", "Verification code", "Your account"]
) { fileinto :copy "Maybe Important"; return; }
else { return; }
