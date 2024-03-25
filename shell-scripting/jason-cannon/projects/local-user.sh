#!/bin/bash

# Check if root, else exit

if [ "${EUID}" -ne 0 ]; then
    echo "Please run this script as the root user"
    exit 1
fi

# Prompt user to enter username, real name and password

read -p 'Enter username: ' USER_NAME
read -p 'Enter Real Name: ' COMMENT
read -p 'Enter Password: ' PASSWORD

# Create the user
useradd -c "${COMMENT}" -m ${USER_NAME}

# If user creation is not successful, exit 1
if [ "$?" -ne 0 ]; then
    echo
    echo "ERROR: User was not created"
    exit 1
fi

# Set password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

if [ "$?" -ne 0 ]; then
    echo
    echo "ERROR: Password was not set"
    exit 1
fi

# Set the password to expire immediately
passwd -e ${USER_NAME}

# Display the username, password and hostname where the account was created.
echo ---------------------------------
echo
echo "Username: ${USER_NAME}" 
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}" 
echo "IP: " $(hostname -I)
echo

exit 0