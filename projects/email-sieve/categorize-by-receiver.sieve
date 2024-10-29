require ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest", "fileinto", "imap4flags"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*", spamtest :value "ge" :comparator "i;ascii-numeric" "${1}") { return; } 

if address :comparator "i;unicode-casemap" :matches ["To", "Cc", "Bcc", "X-Original-To"] "jafner425*@gmail.com" { fileinto "Gmail.com/jafner425@gmail.com"; return; } 

elsif address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc", "X-Original-To"] "joey@jafner.net" { fileinto "Jafner.net/joey@jafner.net"; return; }

elsif address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc", "X-Original-To"] "noreply@jafner.net" { fileinto "Jafner.net/noreply@jafner.net"; return; }

elsif address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc", "X-Original-To"] "consulting@jafner.net" { fileinto "Jafner.net/consulting@jafner.net"; return; }

elsif address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc", "X-Original-To"] "joey.hafner@pm.me" { fileinto "ProtonMail/joey.hafner@pm.me"; return; }

elsif address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc", "X-Original-To"] "jafner425@proton.me" { fileinto "ProtonMail/jafner425@proton.me"; return; }

elsif address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc", "X-Original-To"] "jafner425@pm.me" { fileinto "ProtonMail/jafner425@pm.me"; return; }

elsif address :comparator "i;unicode-casemap" :is ["To", "Cc", "Bcc", "X-Original-To"] "joey@jafner.dev" { fileinto "Jafner.dev/joey@jafner.dev"; return; }

else { fileinto "Mailing Lists"; }