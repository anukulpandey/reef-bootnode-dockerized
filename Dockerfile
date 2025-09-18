# Use a lightweight Ubuntu base
FROM ubuntu:22.04

# Install dependencies needed to run reef-node
RUN apt-get update && apt-get install -y \
    libssl-dev clang libclang-dev llvm-dev pkg-config build-essential cmake unzip curl git \
    && rm -rf /var/lib/apt/lists/*

# Create directory for reef node
RUN mkdir -p /reef-node/bin /reef-node/consts /reef-node/data

# Set working directory
WORKDIR /reef-node

# Copy reef-node binary and customSpec.json
COPY bin/reef-node ./bin/reef-node
COPY consts/customSpec.json ./consts/customSpec.json

# Ensure reef-node is executable
RUN chmod +x ./bin/reef-node

# Run: build raw spec, then start node
CMD ./bin/reef-node build-spec --disable-default-bootnode --chain ./consts/customSpec.json --raw > ./consts/customSpecRaw.json && \
    ./bin/reef-node \
      --base-path ./data \
      --chain ./consts/customSpecRaw.json \
      --port 30333 \
      --rpc-port 9944 \
      --no-telemetry \
      --validator \
      --rpc-methods Unsafe \
      --name bootnode \
      --rpc-cors all \
      --rpc-external
