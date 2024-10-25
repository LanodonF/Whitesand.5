#!/bin/bash

password1="team1Passw0rd!"
password2="team1Adm!n!"

# Get all users with /bin/*sh as their shell
users=$(cat /etc/passwd | grep -vE '(false|nologin|sync)$' | grep -E '/.*sh$' | cut -d':' -f1)

# Change all passwords to password1
for user in $users; do

    # Skip black_team and dead.pool users
    if [ "$user" == "black_team" ] || [ "$user" == "dead.pool" ]; then
        continue
    fi

    echo "Changing password for $user to $password1"
    (echo -e "$password1\n$password1" | passwd $user) || (echo -e "$user:$password1" | chpasswd)
done

# Check if dead.pool user exists
# If it does, change the password to password2
# If it doesn't, create the user with password2 and add it to the sudo group
if id dead.pool &>/dev/null; then
    echo "Changing dead.pool password to $password2"
    (echo -e "$password2\n$password2" | passwd dead.pool) || (echo -e "dead.pool:$password2" | chpasswd)
else
    echo "Creating dead.pool user with password $password2"
    useradd -m dead.pool || pw useradd -n dead.pool -m
    (echo -e "$password2\n$password2" | passwd dead.pool) || (echo -e "dead.pool:$password2" | chpasswd)
    usermod -s /bin/bash dead.pool || echo "Could not set dead.pool shell to /bin/bash"
    usermod -aG sudo dead.pool || pw groupmod wheel -m dead.pool
fi
