#!/bin/sh

set -e

/usr/bin/curl -s https://github.com/nostr-protocol/nips/commits/master.atom | \
    /go/bin/feed2json | \
    /usr/bin/jq -c '.items[]' | \
    /go/bin/ocinosql-dedup -k id -hashkey | \
    /go/bin/jsonargs /algia_post.sh "{{.title}} #nips_changes" "{{.url}}"
