require ["fileinto", "relational", "comparator-i;ascii-numeric", "spamtest", "date"];

# Generated: Do not run this script on spam messages
if allof (environment :matches "vnd.proton.spam-threshold" "*",
spamtest :value "ge" :comparator "i;ascii-numeric" "${1}")
{
    return;
}

if date :originalzone :value "eq" "date" "year" "2024" {  fileinto "2024"; return; }
if date :originalzone :value "eq" "date" "year" "2023" {  fileinto "2023"; return; }
if date :originalzone :value "eq" "date" "year" "2022" {  fileinto "2022"; return; }
if date :originalzone :value "eq" "date" "year" "2021" {  fileinto "2021"; return; }
if date :originalzone :value "eq" "date" "year" "2020" {  fileinto "2020"; return; }
if date :originalzone :value "lt" "date" "year" "2020" {  fileinto "Archive"; return; }