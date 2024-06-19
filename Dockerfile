FROM ubuntu:20.04

WORKDIR /build
COPY . /build/

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install software-properties-common -y \
    && add-apt-repository -y 'ppa:deadsnakes/ppa' \
    && apt-get install -y --no-install-recommends python3.8 python3.8-venv curl libsfml-dev libudev-dev libftdi1-dev build-essential pkg-config cmake

# Get Rust; NOTE: using sh for better compatibility with other base images
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# https://github.com/rust-lang/rust/pull/95026/
# 1.64 and above target glibc 2.17, lets freeze it here so we don't run into glibc upgrades in the future
RUN rustup install 1.79.0 \
    && rustup default 1.79.0 \
    && rustc --version

#RUN cargo build --release
RUN python3.8 -m venv .venv \
    && . .venv/bin/activate \
    && pip install --upgrade pip \
    && pip install maturin patchelf \
    && python3.8 --version \
    && pip freeze \
    && maturin build --release --out dist --find-interpreter --manifest-path crates/pymic2/Cargo.toml

#CMD ["maturin", "build", "--release", "--out", "dist", "--find-interpreter", "--manifest-path", "crates/pymic2/Cargo.toml"]

ENTRYPOINT [ "/usr/bin/bash" ]