# Devcontainer WASM-Zig
Simple devcontainer for Zig development for WebAssembly and WASI

# Usage

## Github Codespaces
Just click the button:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=583174212)

## Visual Studio Code
Note this assumes that you have the VS code support for remote containers and `docker` installed 
on your machine.

```sh
git clone https://github.com/dev-wasm/dev-wasm-zig
cd dev-wasm-zig
code ./
```

Visual studio should prompt you to see if you want to relaunch the workspace in a container, you do.

# Building and Running

## Basic example
```sh
zig build-exe src/main.zig -target wasm32-wasi
wasmtime main.wasm --dir .
```

## Web serving with WAGI
Coming soon

## Http client example
Coming soon

# Debugging
Coming later

