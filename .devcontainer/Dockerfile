FROM ubuntu:24.04

RUN apt-get update && apt-get install -y curl xz-utils lldb git gdb lighttpd && rm -rf /var/lib/apt/lists/*

ENV WASMTIME_VER=41.0.3
RUN curl -fsSL https://github.com/bytecodealliance/wasmtime/releases/download/v${WASMTIME_VER}/wasmtime-v${WASMTIME_VER}-x86_64-linux.tar.xz | tar -xJ && \
    cp wasmtime-v${WASMTIME_VER}-x86_64-linux/wasmtime /usr/local/bin/ && \
    rm -rf wasmtime-v${WASMTIME_VER}-x86_64-linux

ENV WASI_SDK_VER=30
ENV WASI_SDK_FULL=30.0
RUN curl -fsSL https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VER}/wasi-sdk-${WASI_SDK_FULL}-x86_64-linux.tar.gz | tar -xz && \
    mv wasi-sdk-${WASI_SDK_FULL}-x86_64-linux /opt/wasi-sdk

ENV VERSION=0.15.2
ENV FILE=zig-linux-x86_64-${VERSION}.tar.xz
RUN curl https://ziglang.org/download/${VERSION}/${FILE} -L --output ${FILE} && \
    tar -xf ${FILE} && \
    rm ${FILE}