FROM pandoc/latex:2.18.0.0

# install perl LWP for speeding up tlmgr downloads
RUN apk add --no-cache perl-libwww

RUN apk add --no-cache make jq

RUN wget -O /tmp/KOMA.repo.asc https://komascript.de/repository/KOMA.repo.asc && \
    tlmgr key add /tmp/KOMA.repo.asc && \
    rm /tmp/KOMA.repo.asc && \
    tlmgr repository add https://www.komascript.de/repository/texlive/2021 KOMA && \
    tlmgr pinning add KOMA koma-script && \
    tlmgr install --reinstall koma-script

RUN tlmgr install latexmk

# base image has only scheme-basic installed, which is stripped down to the bare minimum
# install collections with required packages
# if package is missing, determine suitable package with
#  $ tlmgr list $package | grep collection:
# check the size of the collection (if very large, installing individual package might be more suitable)
#  $ tlmgr info $collection
RUN tlmgr install collection-latexrecommended collection-latexextra nth

ENTRYPOINT ["/bin/sh"]
CMD ["-c", "make pdf"]
