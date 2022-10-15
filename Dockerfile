FROM pandoc/core:2.18.0.0 AS basic

RUN apk add --no-cache texlive-full
RUN apk add --no-cache make jq

ENTRYPOINT ["/bin/sh"]

FROM basic AS python

RUN apk add --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    # setup
    python3 -m ensurepip && \
    python3 -m pip install --no-cache --upgrade pip wheel setuptools && \
    # packages for adding pandoc filters in python
    python3 -m pip install --no-cache --upgrade pandocfilters~=1.5 Pygments~=2.13 && \
    # packages for plotting in python
    apk add --no-cache py3-matplotlib=~3.3 py3-pandas=~1.2
