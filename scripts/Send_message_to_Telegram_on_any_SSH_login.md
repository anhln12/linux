# Lets create file telegram-send.sh
```
touch telegram-send.sh
```

# Then add script to this file. Set your group id and token in script.
```
#!/bin/bash
    
GROUP_ID=<group_id>
BOT_TOKEN=<bot_token>

# this 3 checks (if) are not necessary but should be convenient
if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` \"text message\""
  exit 0
fi

if [ -z "$1" ]
  then
    echo "Add message text as second arguments"
    exit 0
fi

if [ "$#" -ne 1 ]; then
    echo "You can pass only one argument. For string with spaces put it on quotes"
    exit 0
fi

curl -s --data "text=$1" --data "chat_id=$GROUP_ID" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
```
# To run this script we should add permission
```
chmod +x telegram-send.sh
```

# Now you can test it
```
./telegram-send.sh "Test message"
```

# In order to use this script from everywhere and type telegram-send instead ./telegram-send.sh add it to /usr/bin/ folder
```
sudo mv telegram-send.sh /usr/bin/telegram-send
```

# Owner of all files in /usr/bin is root user. So let’s do the same with our script:

```
sudo chown root:root /usr/bin/telegram-send
```

# Send notification on SSH login

# Let’s add a new script to send the notification.

```
touch login-notify.sh
```

# Add this code to script
```
#!/bin/bash
    
# prepare any message you want
login_ip="$(echo $SSH_CONNECTION | cut -d " " -f 1)"
login_date="$(date +"%e %b %Y, %a %r")"
login_name="$(whoami)"

# For new line I use $'\n' here
message="New login to server"$'\n'"$login_name"$'\n'"$login_ip"$'\n'"$login_date"

#send it to telegram
telegram-send "$message"
```

# Then move this script to /etc/profile.d/ folder
```
sudo mv login-notify.sh /etc/profile.d/login-notify.sh
```
