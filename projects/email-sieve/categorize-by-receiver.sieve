require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest", "fileinto", "imap4flags"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") { return; } 


if address :comparator "i;unicode-casemap" :matches ["To", "Cc", "Bcc"] "jafner425*@gmail.com" { fileinto "Gmail.com/jafner425@gmail.com"; return; }

if address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "joey@jafner.net" { fileinto "Jafner.net/joey@jafner.net"; return; }

if address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "noreply@jafner.net" { fileinto "Jafner.net/noreply@jafner.net"; return; }

if address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "consulting@jafner.net" { fileinto "Jafner.net/consulting@jafner.net"; return; }

if address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "joey.hafner@pm.me" { fileinto "ProtonMail/joey.hafner@pm.me"; return; }

if address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "jafner425@proton.me" { fileinto "ProtonMail/jafner425@proton.me"; return; }

if address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "jafner425@pm.me" { fileinto "ProtonMail/jafner425@pm.me"; return; }

if address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc"] "joey@jafner.dev" { fileinto "Jafner.dev/joey@jafner.dev"; return; }
