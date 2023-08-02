FROM brendanburns/wasm-dev-base:0.0.7

ENV VERSION=0.10.1
ENV FILE=zig-linux-x86_64-${VERSION}.tar.xz
RUN curl https://ziglang.org/download/${VERSION}/${FILE} -L --output ${FILE} && \
    tar -xf ${FILE} && \
    rm ${FILE}