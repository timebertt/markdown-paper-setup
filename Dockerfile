FROM pandoc/core:2.19.2.0 AS basic

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
