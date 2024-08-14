# remove root account from logging to ssh
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Changing SSH port and account lockout policy
nano /etc/ssh/sshd_config
Port 222
MaxAuthTries 5 # MaxAuthTries will lock out IP address if it enters wrong password in more than 5 attempts (you can set this lower or higher).

# Allow port 222
sudo ufw allow 222

# Timeout Idle Value
nano /etc/ssh/sshd_config
ClientAliveInterval 180



