# pandoc/core is currently adm64-only, build handcrafted pandoc base image for multi-arch support
# ref https://github.com/pandoc/dockerfiles/issues/134
FROM haskell:9.4-slim AS pandoc-builder

ARG PANDOC_VERSION=2.19.2
ARG PANDOC_CROSSREF_VERSION=0.3.13.0

WORKDIR /work

RUN cabal v2-update && \
    cabal v2-install --jobs --install-method=copy pandoc-$PANDOC_VERSION pandoc-crossref-$PANDOC_CROSSREF_VERSION

FROM alpine:3.16 AS pandoc

ARG LUA_VERSION=5.4

WORKDIR /data

# needed for running binary built in debian-based haskell image
RUN apk add --no-cache gcompat

COPY --from=pandoc-builder /root/.cabal/bin/pandoc /root/.cabal/bin/pandoc-crossref /usr/local/bin/

# similar to https://github.com/pandoc/dockerfiles/blob/29f1e47a107e153786c8766a9d5d7afc34d29551/alpine/Dockerfile
RUN apk --no-cache add gmp libffi lua$LUA_VERSION lua$LUA_VERSION-lpeg librsvg

ENTRYPOINT ["/usr/local/bin/pandoc"]

FROM pandoc AS basic

# build dependencies
RUN apk add --no-cache make jq

# slimmed down installation of texlive (drop big packages texmf-dist-lang and texmf-dist-fontsextra)
RUN apk add --no-cache \
      # texlive-full without texmf-dist-full
      texlive texlive-doc texlive-luatex texlive-xetex xdvik texlive-dvi \
      # texmf-dist-most without texmf-dist-fontsextra
      texmf-dist texmf-dist-bibtexextra texmf-dist-formatsextra texmf-dist-games texmf-dist-humanities texmf-dist-latexextra texmf-dist-music texmf-dist-pictures texmf-dist-pstricks texmf-dist-publishers texmf-dist-science

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
    apk add --no-cache py3-matplotlib=~3.5 py3-pandas=~1.3
