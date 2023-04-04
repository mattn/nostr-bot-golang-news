FROM golang:1.20-alpine AS build-env

WORKDIR /app
RUN CGO_ENABLED=0 GOBIN=/go/bin go install -buildvcs=false -trimpath -ldflags '-w -s' github.com/mattn/algia@latest
RUN [ -e /usr/bin/upx ] && upx /go/bin/algia || echo
FROM scratch
COPY --from=build-env /go/bin/algia /go/bin/algia
ENTRYPOINT ["/go/bin/algia"]
