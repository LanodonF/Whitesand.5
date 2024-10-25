#!/bin/bash

password1="team1Passw0rd!"
password2="team1Adm!n!"

# Get all users with /bin/*sh as their shell
users=$(cat /etc/passwd | grep -vE '(false|nologin|sync)$' | grep -E '/.*sh$' | cut -d':' -f1)

# Change all passwords to password1
for user in $users; do

    # Skip black_team and team1 users
    if [ "$user" == "black_team" ] || [ "$user" == "team1" ]; then
        continue
    fi

    echo "Changing password for $user to $password1"
    (echo -e "$password1\n$password1" | passwd $user) || (echo -e "$user:$password1" | chpasswd)
done

# Check if team1 user exists
# If it does, change the password to password2
# If it doesn't, create the user with password2 and add it to the sudo group
if id team1 &>/dev/null; then
    echo "Changing team1 password to $password2"
    (echo -e "$password2\n$password2" | passwd team1) || (echo -e "team1:$password2" | chpasswd)
else
    echo "Creating team1 user with password $password2"
    useradd -m team1 || pw useradd -n team1 -m
    (echo -e "$password2\n$password2" | passwd team1) || (echo -e "team1:$password2" | chpasswd)
    usermod -s /bin/bash team1 || echo "Could not set team1 shell to /bin/bash"
    usermod -aG sudo team1 || pw groupmod wheel -m team1
fi
