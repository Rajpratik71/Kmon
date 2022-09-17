FROM ghcr.io/iovisor/bcc:ubuntu-20.04 as builder
WORKDIR /build
COPY deployment ./deployment
RUN apt-get update -y && apt-get install apt-get install libbpfcc-dev -y
RUN bash ./deployment/script/install_go.sh
COPY . .
ENV PATH="/usr/local/go/bin:${PATH}"
RUN make


FROM ghcr.io/iovisor/bcc:ubuntu-20.04
WORKDIR ./ebpf
COPY --from=builder /build/release .
RUN ls
ENTRYPOINT ["./kmon"]
