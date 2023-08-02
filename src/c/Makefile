.phony: gen clean run

default: main.wasm

wasi-http: ; git clone https://github.com/WebAssembly/wasi-http; cd wasi-http; git checkout 53e2d25

gen: wasi-http ; wit-bindgen c ${PWD}/wasi-http/wit -w proxy

clean: ; rm -rf wasi-http