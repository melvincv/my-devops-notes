#!/bin/bash

# Check if root, else exit

if [ "${EUID}" -ne 0 ]; then
    echo "Please run this script as the root user"
    exit 1
fi

# Check for username

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 username \"real name\""
    exit 1
fi

# Fetch username and Real name as positional parameters 1 and 2

echo Username: $1
echo Real Name: $2

# Generate a strong password using a crypto hash

PASSWORD=$(date +%s%N | sha256sum | head -c16)

# Create the user
useradd -c "${2}" -m ${1}

# If user creation is not successful, exit 1
if [ "$?" -ne 0 ]; then
    echo
    echo "ERROR: User exists or was not created"
    exit 1
fi

# Set password
echo ${PASSWORD} | passwd --stdin ${1}

if [ "$?" -ne 0 ]; then
    echo
    echo "ERROR: Password was not set"
    exit 1
fi

# Set the password to expire immediately
passwd -e ${1}

# Display the username, password and hostname where the account was created.
echo ---------------------------------
echo
echo "Username: ${1}" 
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}" 
echo "IP: " $(hostname -I)
echo

exit 0