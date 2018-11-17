#!/bin/ash
/scripts/validate-variables.sh 
if [[ "$?" -ne "0" ]]; then
	echo "ERROR: input was invalid exiting"
	exit 1
else
	echo "input OK"
fi

WORK_DIR="/work-dir"
TRANSIP_INI_FILE=$WORK_DIR/transip.ini
TRANSIP_KEY_FILE=$WORK_DIR/transip-rsa.key

echo "copying the TransIP API key to the working directory"
mkdir -p $WORK_DIR
openssl rsa -in $TRANSIP_KEY_LOCATION/$TRANSIP_KEY_FILE_NAME -out $TRANSIP_KEY_FILE

# cp $TRANSIP_KEY_LOCATION/$TRANSIP_KEY_FILE_NAME $WORK_DIR

echo "create the transip.ini file used by the certbot-dns-transip plugin"
echo "certbot_dns_transip:dns_transip_username = $TRANSIP_USERNAME" > $TRANSIP_INI_FILE
echo "certbot_dns_transip:dns_transip_key_file = $TRANSIP_KEY_FILE" >> $TRANSIP_INI_FILE

# Disable the permission error on key and ini file
chmod 600 $TRANSIP_INI_FILE $TRANSIP_KEY_FILE

echo "running the certbot challenge for $DOMAIN"
certbot certonly -d *.$DOMAIN -d $DOMAIN -a certbot-dns-transip:dns-transip \
				--certbot-dns-transip:dns-transip-credentials $TRANSIP_INI_FILE \
				--email $CERTBOT_EMAIL \
				-n \
				--agree-tos \
				--certbot-dns-transip:dns-transip-propagation-seconds $PROPAGATION_SECONDS
