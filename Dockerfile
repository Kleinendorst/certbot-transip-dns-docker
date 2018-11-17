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
#	|										| should not contain subdomains					| 																		|
# |-------------------|---------------------------------------|-------------------------------------|

# --- ENVIRONMENT VARIABLES ---------------------------------------------------------------------------
ENV CERT_LOCATION=/certs
ENV TRANSIP_KEY_LOCATION=/transip

ENV TRANSIP_KEY_FILE_NAME=transip.key

# Environment variables below this point are not meant to be changed by the user.
ENV PROPAGATION_SECONDS=240

# --- VOLUMES -----------------------------------------------------------------------------------------
# The volume listed here is the only volume necessary in a static location
# the other volumes, are defined together with the CERT_LOCATION and TRANSIP_KEY_LOCATION
# variables.
VOLUME /etc/letsencrypt

# --- CONTAINER BUILD ---------------------------------------------------------------------------------
# Tools needed to install the Python cryptography package (a dependancy of certbot).
# per official installation instructions at:
# https://github.com/pyca/cryptography/blob/master/docs/installation.rst
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev
# openssl is used for converting the TransIP key.
RUN apk add openssl
RUN pip install certbot certbot-dns-transip

COPY ./scripts /scripts
