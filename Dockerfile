FROM pandoc/core:2.18.0.0

RUN apk add --no-cache texlive-full
RUN apk add --no-cache make jq

RUN apk add --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache --upgrade pip wheel setuptools

ENTRYPOINT ["/bin/sh"]
