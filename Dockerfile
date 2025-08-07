#  Use the official Golang image to build the app
FROM golang:1.22.5 AS base

#  Set the working directory inside the container
WORKDIR /app

#  Copy only go.mod (no go.sum needed if there are no dependencies)
COPY go.mod ./

#  Download modules (does nothing if no modules are needed)
RUN go mod download

#  Copy the rest of your source code
COPY . .

#  Build the Go application into a binary named 'main'
RUN go build -o main .

#  Final stage using distroless image
FROM gcr.io/distroless/base

WORKDIR /

#  Copy the built binary and static files
COPY --from=base /app/main .
COPY --from=base /app/static ./static

#  Expose the app port
EXPOSE 8080

#  Run the app
CMD ["./main"]
