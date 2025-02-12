FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o app main.go

RUN go test ./...

FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/app .

COPY tracker.db .

RUN apk --no-cache add sqlite

CMD ["./app"]

