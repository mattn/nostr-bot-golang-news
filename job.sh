#!/bin/sh

set -e

/usr/bin/curl -s -H "User-Agent: Chrome" "https://www.reddit.com/r/golang.json" | \
    /usr/bin/jq -c '.data.children[].data' | \
    /go/bin/ocinosql-dedup -V -k url -hashkey | \
    /go/bin/jsonargs -f /go/bin/algia -V n "{{.title}} #golang_news" "{{.url}}"
