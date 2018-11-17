FROM python:3-alpine

ENTRYPOINT /scripts/entrypoint.sh
WORKDIR /scripts

# --- ENVIRONMENT VARIABLES ---------------------------------------------------------------------------
# Mount point where the TransIP API key should reside
ENV TRANSIP_KEY_LOCATION=/transip

# Name of the TransIP API key
ENV TRANSIP_KEY_FILE_NAME=transip.key

# Delay between placing the DNS record, and the
# actual challenge being performed in seconds.
ENV PROPAGATION_SECONDS=240

# --- CONTAINER BUILD ---------------------------------------------------------------------------------
# Tools needed to install the Python cryptography package (a dependency of certbot).
# per official installation instructions at:
# https://github.com/pyca/cryptography/blob/master/docs/installation.rst
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev
# openssl is used for converting the TransIP key.
RUN apk add openssl
RUN pip install certbot certbot-dns-transip

COPY ./scripts /scripts
