FROM golang:1.20-alpine AS build-dev

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOBIN=/go/bin go install -buildvcs=false -trimpath -ldflags '-w -s' github.com/mattn/algia@latest
RUN CGO_ENABLED=0 GOBIN=/go/bin go install -buildvcs=false -trimpath -ldflags '-w -s' github.com/mattn/jsonargs@latest
RUN CGO_ENABLED=0 GOBIN=/go/bin go install -buildvcs=false -trimpath -ldflags '-w -s' github.com/mattn/ocinosql-dedup@latest
RUN CGO_ENABLED=0 GOBIN=/go/bin go install -buildvcs=false -trimpath -ldflags '-w -s' github.com/carlmjohnson/feed2json/cmd/feed2json@latest
FROM debian:buster-slim AS stage
RUN apt update
RUN apt install -y curl jq
RUN apt clean all
COPY --from=build-dev /go/bin/algia /go/bin/algia
COPY --from=build-dev /go/bin/jsonargs /go/bin/jsonargs
COPY --from=build-dev /go/bin/feed2json /go/bin/feed2json
COPY --from=build-dev /go/bin/ocinosql-dedup /go/bin/ocinosql-dedup
COPY --chmod=755 --from=build-dev /app/job.sh /job.sh
COPY --chmod=755 --from=build-dev /app/algia_post.sh /algia_post.sh
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/job.sh"]
