#!/bin/bash

# Check if root, else exit

if [ "${EUID}" -ne 0 ]; then
    echo "Please run this script as the root user" >&2
    exit 1
fi

# Check for username

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 username real-name" >&2
    exit 1
fi

# Fetch username and Real name as positional parameters 1 and 2
USERNAME="${1}"
shift
COMMENT="${@}"

# Generate a strong password using a crypto hash

PASSWORD=$(date +%s%N | sha256sum | head -c16)

# Create the user
useradd -c "${COMMENT}" -m ${USERNAME} &> /dev/null

# If user creation is not successful, exit 1
if [ "$?" -ne 0 ]; then
    echo
    echo "ERROR: User exists or was not created" >&2
    exit 1
fi

# Set password
echo ${PASSWORD} | passwd --stdin ${USERNAME} &> /dev/null

if [ "$?" -ne 0 ]; then
    echo
    echo "ERROR: Password was not set"
    exit 1
fi

# Set the password to expire immediately
passwd -e ${USERNAME} &> /dev/null

# Display the username, password and hostname where the account was created.
echo
echo "Username: ${USERNAME}" 
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}" 
echo

exit 0