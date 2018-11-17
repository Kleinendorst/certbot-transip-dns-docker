**[Docker Hub page](https://hub.docker.com/r/thomaskleinendorst/certbot-transip-dns-docker/)**

# Cerbot TransIP challenge
This project provides the excellent [cerbot-dns-transip](https://github.com/hsmade/certbot-dns-transip)
plugin wrapped in a Docker container. This plugin is used for performing the 
[dns challenge](https://certbot.eff.org/docs/using.html#dns-plugins) in the [certbot](https://certbot.eff.org/)
tool, in order to obtain a [let's encrypt](https://letsencrypt.org/) certificate. The DNS challenge is currently
the only challenge that will result in a [wildcard certificate](https://searchsecurity.techtarget.com/definition/wildcard-certificate).

The challenge will add a TXT dns record, using the API exposed by TransIP. After creating this
record, the let's encrypt servers will verify if this record is present. On success the ownership
of the domain name is proven (including its subdomains) and a certificate is obtained.

This project wraps the tools and commands into a single docker container to make obtaining
wilcard certificates from TransIP as easy as possible.

## Running the container
Before we can start the container, we should first get an API key from
TransIP which allows the dns plugin to add the TXT dns record. Follow these steps:

> **Tip:** If you intend to run this container from a server with 
> a static IP address, enable "Whitelisted IP" and add that server's
> public IP address to the "IP-adres whitelist" list after step 5. 

1. Navigate to the [TransIP home page](https://www.transip.nl/).
2. Click on "Controlepaneel"
3. Log in to TransIP.
4. Click the account button in the upper right corner, and select "Mijn account" in the dropdown.
5. Click the "API" tab.
6. Enter a descriptive name in the "Label" text field.
7. Copy the API key to a new file saved in a new empty directory. Call this variable `transip.key`.

### Prepare volumes
This container requires 2 volumes to be mounted to the host. The first volume will
contain the `transip.key` file. This directory should be mounted on the `/transip` path.

The second volume will mount to the directory that the certificates are
dumped to. This volume is not only required for acquiring the certificate after the 
challenge, but also to hold onto certificates for additional runs. If a certificate is
present which doesn't expire soon, no new certificate will be generated. This volume
should be mounted on the `/etc/letsencrypt` path.

### Obtaining the certificate
Run the following command to obtain a certificate:
```bash
docker run --rm \
		-e TRANSIP_USERNAME={{USERNAME}} \
		-e DOMAIN={{DOMAIN}} \
		-e CERTBOT_EMAIL={{EMAIL}} \
		-v "{{HOST_TRANSIP_KEY}}:/transip" \
		-v "{{HOST_CERT_LOCATION}}:/etc/letsencrypt" \
		thomaskleinendorst/certbot-transip-dns-docker
```

## Environment variable overview
1. **TRANSIP_USERNAME**: Username of TransIP account.
2. **CERTBOT_EMAIL**: Email passed to certbot. Used for urgent renewal and security notices.
3. **DOMAIN**: Domain to obtain certificates for should not contain sub-domains.

## Known issues
* There is an issue, on Windows only, where the certificate cannot be dumped in a mounted directory.
	The error reads: `OSError: [Errno 71] Protocol error`. This error seams to be caused by mounting
	issues in Docker. Linux hosts should not be affected.
