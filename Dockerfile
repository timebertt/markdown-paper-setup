# pandoc/core is currently adm64-only, build handcrafted pandoc base image for multi-arch support
# similar to https://github.com/pandoc/dockerfiles/blob/f23bdd37b28d023a7f2596c1f72fece48f3420fc/ubuntu/Dockerfile
# pandoc itself offers arm64 builds on github releases, but we have to build pandoc-crossref ourselves
# ref https://github.com/pandoc/dockerfiles/issues/134
FROM haskell:9.4.5-slim-buster AS pandoc-crossref-builder

ARG PANDOC_VERSION=3.1.6
ARG PANDOC_CROSSREF_VERSION=0.3.16.0d

RUN git clone --branch=v$PANDOC_CROSSREF_VERSION --depth=1 --quiet https://github.com/lierdakil/pandoc-crossref /usr/src/pandoc-crossref

WORKDIR /usr/src/pandoc-crossref

COPY cabal.root.config /root/.cabal/config
COPY cabal.project ./

RUN cabal --version && \
    ghc --version && \
    cabal v2-update && \
    cabal v2-configure --constraint pandoc==$PANDOC_VERSION --constraint zip-archive'>='0.4.2.1

RUN cabal v2-build --enable-executable-static --only-dependencies

RUN cabal v2-build --enable-executable-static . && \
    # Cabal's exec stripping doesn't seem to work reliably, let's do it here.
    find dist-newstyle \
      -name 'pandoc*' -type f -perm -u+x \
      -exec strip '{}' ';' \
      -exec cp '{}' /usr/local/bin/ ';'

# compiling a statically linked pandoc-crossref binary yields the following warning:
#   warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
# print the builder's libc version so that it is easier to identify when something breaks in the runtime image
RUN ldd --version

FROM alpine:3.18 AS pandoc

ARG PANDOC_VERSION=3.1.6
ARG LUA_VERSION=5.4
ARG TARGETARCH

WORKDIR /data

# needed for running binary built in debian-based haskell image
RUN apk add --no-cache gcompat

COPY --from=pandoc-crossref-builder /usr/local/bin/pandoc-crossref /usr/local/bin/

RUN wget https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux-$TARGETARCH.tar.gz -O - \
    | tar -xzvf - --strip-components 2 -C /usr/local/bin pandoc-$PANDOC_VERSION/bin/pandoc

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
    python3 -m pip install --no-cache --upgrade pandocfilters~=1.5 Pygments~=2.15 && \
    # packages for plotting in python
    apk add --no-cache py3-matplotlib=~3.7 py3-pandas=~1.5 py3-scipy=~1.10
