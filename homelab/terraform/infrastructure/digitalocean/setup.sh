#!/bin/bash

adduser --disabled-password --gecos "" admin
usermod -aG sudo admin
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config 
echo -e "ALL\tALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers 
apt-get update && apt-get -y install libpam-google-authenticator
sed -i 's/@include common-auth/#@include common-auth/' /etc/pam.d/sshd
sed -i 's/@include common-password/#@include common-password/' /etc/pam.d/sshd
echo "auth required pam_google_authenticator.so nullok" >> /etc/pam.d/sshd
echo "auth required pam_permit.so" >> /etc/pam.d/sshd
sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
echo "AuthenticationMethods publickey,keyboard-interactive" >> /etc/ssh/sshd_config
mkdir -p /home/admin/.ssh/
cp /root/.ssh/authorized_keys /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh
sudo -i -u admin bash << EOF 
google-authenticator -t -d -f -r 3 -R 30 -w 3 -C
EOF

echo "TOTP_KEY=$(head -n 1 /home/admin/.google_authenticator)"

systemctl restart sshd.service