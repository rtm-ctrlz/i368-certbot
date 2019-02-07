FROM i386/python:2-alpine

ENTRYPOINT [ "certbot" ]
EXPOSE 80 443
VOLUME /etc/letsencrypt /var/lib/letsencrypt

WORKDIR /opt/certbot

RUN set -ex; \
	apk add --no-cache --virtual .certbot-deps \
		libffi \
		libssl1.1 \
		ca-certificates \
		binutils; \
	\
	apk add --no-cache --virtual .build-deps \
		gcc \
		linux-headers \
		openssl-dev \
		musl-dev \
		libffi-dev \
		git ; \
	\
	git clone https://github.com/certbot/certbot /opt/certbot.git ;\
	\
	mkdir -p /opt/certbot/src ; \
	ls -la /opt/certbot.git ; \
	for f in CHANGELOG.md README.rst setup.py acme certbot; do mv "/opt/certbot.git/$f" "/opt/certbot/src/$f"; done ; \
	rm -rf /opt/certbot.git ; \
	\
	(find /opt/certbot/src -type d \( -name tests -o -name docs -o -name examples \) -exec rm -rf "{}" \; 2>/dev/null || true ); \
	\
	pip install -U 'pip<19'; \
	pip install --no-cache-dir \
		--editable /opt/certbot/src/acme \
		--editable /opt/certbot/src ; \
	\
	apk del .build-deps

