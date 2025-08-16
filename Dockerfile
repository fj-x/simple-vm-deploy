# build stage
FROM golang:1.22 AS builder
WORKDIR /src
COPY app/go.mod ./app/go.mod
WORKDIR /src/app
RUN go mod download
COPY app/ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o /out/app

# run stage
FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /out/app /app/app
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/app/app"]
