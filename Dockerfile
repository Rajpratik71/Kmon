FROM ubuntu:22.04 as builder
WORKDIR /build
COPY deployment ./deployment
RUN apt-get update -y && apt-get install bcc libbpfcc-dev clang-9 -y
RUN bash ./deployment/script/install_go.sh
COPY . .
ENV PATH="/usr/local/go/bin:${PATH}"
RUN make

FROM ubuntu:22.04
WORKDIR ./ebpf
COPY --from=builder /build/release .
RUN ls
ENTRYPOINT ["./kmon"]
