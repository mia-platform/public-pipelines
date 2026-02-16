# Rust Image for Pipelines

This is a Docker image that will be used on `rust` pipelines jobs that pertain to building, testing and linting
a Rust project with its main package manager.

## Description

This Docker image is designed for use it inside the `rust` steps of the pipelines, and it install `rust` with its
main components.

## Contents

This image is based on the base-pipeline image and add this components:

- rust
- cargo
- cargo-clippy
- cargo-fmt
- cargo-make
- cargo-miri
- clippy-driver
- makers
- rls
- rust-analyzer
- rust-gdb
- rust-gdbgui
- rust-lldb
- rustc
- rustdoc
- rustfmt
- rustup
