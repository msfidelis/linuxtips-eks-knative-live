FROM golang:1.20 as builder

WORKDIR /app

COPY go.mod go.sum ./

COPY . .

RUN go build -o /app

# Use a smaller base image for the final build
FROM gcr.io/distroless/base-debian11

# Copy the binary from the builder stage
COPY --from=builder /app /app

# Expose the port
EXPOSE 3000

# Command to run the application
CMD ["/app"]
