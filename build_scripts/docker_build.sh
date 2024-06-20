#!/bin/bash

set -e

. /venv/bin/activate
maturin build --release --out dist --find-interpreter --manifest-path crates/pymic2/Cargo.toml

cargo build --release