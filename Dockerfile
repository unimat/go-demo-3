FROM golang:1.16 AS build
ADD . /src
WORKDIR /src
RUN go get -d -v -t
RUN go mod tidy
RUN go mod vendor
RUN go test --cover -v ./... --run UnitTest
RUN go build -v -o go-demo

FROM alpine:3.12
MAINTAINER 	Viktor Farcic <viktor@farcic.com>
RUN apk update && apk add ca-certificates
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

EXPOSE 8080
ENV DB db
CMD ["go-demo"]

COPY --from=build /src/go-demo /usr/local/bin/go-demo
RUN chmod +x /usr/local/bin/go-demo
