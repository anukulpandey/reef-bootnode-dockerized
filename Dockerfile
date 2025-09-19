FROM ubuntu:22.04

# Install dependencies for reef-node and Rust
RUN apt-get update && apt-get install -y \
    libssl-dev clang libclang-dev llvm-dev pkg-config build-essential cmake unzip curl git jq \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Create directories
RUN mkdir -p /reef-node/bin /reef-node/consts /reef-node/data

WORKDIR /reef-node

# Clone and build reef-node
RUN git clone https://github.com/reef-defi/reef-node.git src && \
    cd src && \
    cargo build --release && \
    cp target/release/reef-node /reef-node/bin/reef-node && \
    cd .. && rm -rf src

# Copy base spec (you can add your own later)
COPY consts/customSpec.json ./consts/customSpec.json

RUN chmod +x ./bin/reef-node

# Expose P2P and RPC ports
EXPOSE 30333 9944

# Default command: bash (so you can exec into it and run reef-node manually)
CMD ["/bin/bash"]
