#!/bin/sh

set -e

/usr/bin/curl -s -H "User-Agent: Chrome" "https://www.reddit.com/r/golang.json" | \
    /usr/bin/jq -c '.data.children[].data' | \
    /go/bin/ocinosql-dedup -k id | \
    /go/bin/jsonargs -f /go/bin/algia "{{.title}} #golang_news" "{{.url}}"
