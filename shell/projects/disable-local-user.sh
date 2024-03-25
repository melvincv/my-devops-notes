#!/bin/bash

# Define Variables
ARCHIVE_DIR='/archives'

# Check if root, else exit
if [ "${EUID}" -ne 0 ]; then
    echo "Please run this script as the root user" >&2
    exit 1
fi

# Define a function to display usage / help text to the user
usage() {
    echo "Usage: ${0} [-dra] USER [USER1]..."
    echo "Disable local user accounts."
    echo "Options:"
    echo "  -d : Deletes acccounts instead of disabling them"
    echo "  -r : Removes the home dir of the user"
    echo "  -a : Creates a archive of the user's home and stores the archive in the /archives directory"
    echo "  -h : Displays this message."
    echo "Any other option will cause the script to display a usage statement and exit with an exit status of 1."
    exit 1
}

# Process the given options
while getopts drah OPTION
do
    case ${OPTION} in
        d) DELETE_USER='true' ;;
        r) DHOME='-r' ;;
        a) ARCHIVE_HOME='true' ;;
        h) 
            usage
            ;;
        ?) usage ;;
    esac
done

# Remove the options to process the positional parameters
shift "$(( OPTIND - 1 ))"

if [ "$#" -eq 0 ]; then
    echo "Username not found" >&2
    echo
    usage >&2
    exit 1
fi

# Loop through all the usernames
for USER in "$@"
do
    echo "Processing user: $USER"

    # Make sure the UID of the account is at least 1000
    if [ "$(id -u ${USER})" -lt 1000 ]; then
        echo "User ${USER} is a system user. Not removing it." >&2
        exit 1
    fi

    # Create an archive of the home dir if requested
    HOME_DIR="/home/${USER}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USER}.tgz"
    if [ "${ARCHIVE_HOME}" = 'true' ]; then
        if [ ! -d "${ARCHIVE_DIR}" ]; then
            mkdir -p ${ARCHIVE_DIR}
        fi
        if [ -d "${HOME_DIR}" ]; then
            tar -czf ${ARCHIVE_FILE} ${HOME_DIR}
            if [ "$?" -ne 0 ]; then
                echo "Archive file not created" >&2
            else
                echo "Archived home dir: ${ARCHIVE_FILE}"
            fi
            exit 1
        else
            echo "Home directory not found" >&2
            exit 1
        fi
    fi

    # Delete the user. If r option is set, delete home dir
    if [ "${DELETE_USER}" = 'true' ]; then
        userdel ${DHOME} ${USER}
        if [ "$?" -ne 0 ]; then
            echo "$USER not deleted" >&2
        else
            echo "${USER} has been deleted"
        fi
    fi

    # Disable the user
    chage -E now ${USER}
        if [ "$?" -ne 0 ]; then
            echo "${USER} not disabled" >&2
        else
            echo "${USER} has been disabled"
        fi
done

exit 0
