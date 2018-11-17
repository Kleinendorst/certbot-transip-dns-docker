FROM python:3-alpine

ENTRYPOINT /scripts/entrypoint.sh
WORKDIR /scripts

# --- MANDATORY ENVIRONMENT VARIABLES -----------------------------------------------------------------
# The user should set these environment variables,
# This block only exists for documentation purposes.

# |-------------------|---------------------------------------|-------------------------------------|
# |	ENV								| DESCRIPTION														| EXAMPLE															|
# |-------------------|---------------------------------------|-------------------------------------|
# | TRANSIP_USERNAME	|	username of TransIP account						|	kleinendorst21											|
# |-------------------|---------------------------------------|-------------------------------------|
# | CERTBOT_EMAIL			| email passed to certbot. Used for   	|	thomas.kleinendorst@outlook.com			|
# |										| urgent renewal and security notices.	|																			|
# |-------------------|---------------------------------------|-------------------------------------|
# | DOMAIN						| domain to obtain certificates for,		| kleinendorst.info										|
#	|										| should not contain sub-domains					| 																		|
# |-------------------|---------------------------------------|-------------------------------------|

# --- ENVIRONMENT VARIABLES ---------------------------------------------------------------------------
# Mount point where the TransIP API key should reside
ENV TRANSIP_KEY_LOCATION=/transip

# Name of the TransIP API key
ENV TRANSIP_KEY_FILE_NAME=transip.key

# Delay between placing the DNS record, and the
# actual challenge being performed in seconds.
ENV PROPAGATION_SECONDS=240

# --- VOLUMES -----------------------------------------------------------------------------------------
# The volume listed here is the only volume necessary in a static location
# the other volumes, are defined together with the CERT_LOCATION and TRANSIP_KEY_LOCATION
# variables.
VOLUME /etc/letsencrypt

# --- CONTAINER BUILD ---------------------------------------------------------------------------------
# Tools needed to install the Python cryptography package (a dependency of certbot).
# per official installation instructions at:
# https://github.com/pyca/cryptography/blob/master/docs/installation.rst
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev
# openssl is used for converting the TransIP key.
RUN apk add openssl
RUN pip install certbot certbot-dns-transip

COPY ./scripts /scripts
