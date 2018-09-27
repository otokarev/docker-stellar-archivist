FROM golang:alpine as builder

ENV VERSION=stellar-archivist-v0.2.0


RUN apk add --no-cache curl git gcc linux-headers musl-dev mercurial \
    && mkdir -p /go/src/github.com/stellar/ \
    && git clone https://github.com/stellar/go.git /go/src/github.com/stellar/go \
    && cd /go/src/github.com/stellar/go \
    && git checkout $VERSION \
    && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh  \
    && dep ensure \
    && go install github.com/stellar/go/tools/stellar-archivist


FROM alpine:latest

COPY --from=builder /go/bin/stellar-archivist /usr/local/bin/stellar-archivist

ENTRYPOINT ["/usr/local/bin/stellar-archivist"]
CMD ["--help"]
