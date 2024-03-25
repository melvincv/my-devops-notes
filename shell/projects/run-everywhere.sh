#!/bin/bash -x
# Script to execute a given command on multiple servers
#
SVRFILE="./servers"
# SSH Options
SSH_OPTS="-o ConnectTimeout=2"

# Define Usage function
usage() {
  echo "Usage: ${0} [-f FILE] [-nsv] COMMAND" >&2
  echo 'Execute the given command on multiple servers' >&2
  echo '  -f FILE    Specify the servers file.' >&2
  echo '  -s         Run the command with sudo privileges.' >&2
  echo '  -v         Verbose mode.' >&2
  echo '  -n         Dry Run (just print commands).' >&2
  exit 1
}

# Check if executed as root, exit if YES
if [ "$EUID" -eq 0 ]; then
  echo "Do not run this script as root. Use the -s option instead"
  exit 1
fi

# Let's say that you'd like the -f option to take arguments. 
# You can specify this by putting a colon (":") after that option in optstring.
# Value of the argument is stored in OPTARG

while getopts f:svn OPTION
do
  case ${OPTION} in
    v) VERBOSE='true' ;;
    f) SVRFILE="${OPTARG}" ;;
    n) DRYRUN='true' ;;
    s) SUDO='sudo' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# Display the usage statement if the user does not supply a command to run
if [[ "${#}" -eq 0 ]]
then
  usage
  exit 1
fi

# The first argument should now be the command
COMMAND="$@"

# Make sure the SVRFILE file exists
if [ ! -e "${SVRFILE}" ]; then
    echo "Cannot open the servers file: ${SVRFILE}" >&2
    exit 1
fi

# Loop through the SERVER_LIST
# If it's a dry run, don't execute anything, just echo it
for SERVER in $(cat ${SVRFILE})
do
    if [ "${VERBOSE}" = "true" ]; then
        echo "$SERVER"
    fi
    SSH_COMMAND="ssh ${SSH_OPTS} ${SERVER} ${SUDO} ${COMMAND}"
    if [ "$DRYRUN" = "true" ]; then
        echo "DRY RUN: ${SSH_COMMAND}"
    else
        ${SSH_COMMAND}
        if [ "$?" -ne 0 ]; then
            EXIT_STATUS="$?"
            echo "Command execution on ${SERVER} failed." >&2
        fi
    fi
done

exit $EXIT_STATUS