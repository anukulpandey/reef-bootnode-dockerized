FROM ubuntu:22.04

# Install dependencies needed to run reef-node
RUN apt-get update && apt-get install -y \
    libssl-dev clang libclang-dev llvm-dev pkg-config build-essential cmake unzip curl git jq \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /reef-node/bin /reef-node/consts /reef-node/data

WORKDIR /reef-node

# Copy binaries and base spec
COPY bin/reef-node ./bin/reef-node
COPY consts/customSpec.json ./consts/customSpec.json

RUN chmod +x ./bin/reef-node

# Expose P2P and RPC ports
EXPOSE 30333 9944

# Default command: bash (so you can exec into it and run reef-node manually)
CMD ["bash", "-c", "while true; do sleep 1000; done"]
