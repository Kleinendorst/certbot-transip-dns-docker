#!/bin/ash
echo "validating input"

# Check if these variables exist.
MANDATORY_VARIABLES='TRANSIP_USERNAME DOMAIN CERTBOT_EMAIL TRANSIP_KEY_LOCATION TRANSIP_KEY_FILE_NAME PROPAGATION_SECONDS'

for MANDATORY_ENV in $MANDATORY_VARIABLES; do
	# Because the variables are provided in MANDATORY_VARIABLES
	# this is the way we extract the actually set variable
	VARIABLE_NAME=$(printenv | grep $MANDATORY_ENV | sed 's/.*=//')

	# if the output is 0 characters long, it is not set
	if [[ -z "$VARIABLE_NAME" ]]; then
	  echo "ERROR: the $MANDATORY_ENV environment variable should be set"
	  exit 1
	fi
done

# Check whether the key file exists
if [[ ! -f $TRANSIP_KEY_LOCATION/$TRANSIP_KEY_FILE_NAME ]]; then
    echo "ERROR: the key file does not exist"
    exit 1
fi
