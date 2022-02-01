FROM alpine:latest AS builder

RUN apk add --update go git

ENV GOPATH /go
ENV CGO_ENABLED=0

ADD . /go/src/github.com/solipsist01/xapi_exporter
RUN go get github.com/solipsist01/xapi_exporter
RUN go mod init github.com/solipsist01/xapi_exporter
RUN go mod tidy github.com/solipsist01/xapi_exporter
RUN go build -o /bin/xapi_exporter github.com/solipsist01/xapi_exporter

FROM prom/busybox:glibc

COPY --from=builder /bin/xapi_exporter /bin/xapi_exporter

EXPOSE 9290

VOLUME ["/xapi_exporter"]

CMD ["/bin/xapi_exporter", "-config", "/xapi_exporter/config.yml"]
