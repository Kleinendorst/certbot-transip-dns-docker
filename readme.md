# Cerbot TransIP challenge
This project provides the excellent [cerbot-dns-transip](https://github.com/hsmade/certbot-dns-transip)
plugin wrapped in a Docker container.

## Quickstart
Use the following command to generate a new certificate, or (attempt) renewal for existing certificates.

```bash
docker run --rm \
				-e TRANSIP_USERNAME={{ USERNAME }} \
				-e DOMAIN={{ DOMAIN }} \
				-e CERTBOT_EMAIL={{ EMAIL }} \
				-v "{{ PATH_TO_API_KEY }}:/transip" \
				-v "{{ CERTIFICATE_PATH }}:/etc/letsencrypt" transip-certbot
```
