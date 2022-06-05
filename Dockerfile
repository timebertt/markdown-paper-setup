FROM pandoc/core:2.18.0.0

RUN apk add --no-cache make jq

RUN apk add --no-cache texlive-full
