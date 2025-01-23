# Devcontainer WASM-Zig
Simple devcontainer for Zig development for WebAssembly and WASI

# Usage

## Github Codespaces
Just click the button:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=583174212)
[![Open in Codeanywhere](https://codeanywhere.com/img/open-in-codeanywhere-btn.svg)](https://app.codeanywhere.com/#https://github.com/dev-wasm/dev-wasm-zig)

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
*NB*: this example uses an experimental `wasmtime-http` that incorporates a highly
experimental HTTP client library that is not yet part of the WASI specification.
Use at your own risk, things are likely to change drastically in the future.

```sh
# Build it
$ zig build-exe src/http.zig -target wasm32-wasi
# Without any approved URLs it fails
$ wasmtime-http --wasi-modules=experimental-wasi-http http.wasm
Response Error: 7
# With approved URLs it works
$  WASI_HTTP_ALLOWED_HOSTS=https://postman-echo.com wasmtime-http --wasi-modules=experimental-wasi-http http.wasmRequest succeeded: 200
Content length: 236
{"args":{},"headers":{"x-forwarded-proto":"https","x-forwarded-port":"443","host":"postman-echo.com","x-amzn-trace-id":"Root=1-63af6c37-35d6bd1e4fe55f022cd62b81","content-length":"0","accept":"*/*"},"url":"https://postman-echo.com/get"}
```

# Debugging
Both `lldb` and `gdb` work. There is vscode debugger integration in `.vscode/launch.json` so you should
be able to use F5 to launch the debugger.

If you want to debug from the command line:

```sh
$ lldb wasmtime
# Disable dslr so debugging works in a container
$ settings set target.disable-aslr false
# Set a break point
$ b src/main.zig:8
# Start running
$ run -g main.wasm
...
```

