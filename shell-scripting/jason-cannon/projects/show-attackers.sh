#!/bin/bash
# Define the limit of no. of attacks
LIMIT=10

# Require that a file is provided as an argument
LOG_FILE="$1"

if [ ! -e "${LOG_FILE}" ]; then
    echo "Log File cannot be opened: ${LOG_FILE}" >&2
    exit 1
fi

# Check and install geoip
if [ ! -e "$(which geoiplookup)" ]; then
    yum makecache
    yum -y install GeoIP
fi

# Count the no. of failed login attempts by IP address
# Display the data in CSV format with the headers
# Count,IP,Location
echo "Count,IP,Location"
grep -e 'Failed password' ${LOG_FILE} | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
    if [ "${COUNT}" -gt ${LIMIT} ]; then
        LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
        echo "${COUNT},${IP},${LOCATION}"
    fi
done 