# lets start from debian bullseye
FROM debian:bullseye-slim

ENV KEYRINGS /usr/local/share/keyrings

RUN set -eux; \
    mkdir -p $KEYRINGS; \
    apt-get update && apt-get install -y gpg curl; \
    # clang/lld/llvm
    curl --fail https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > $KEYRINGS/llvm.gpg;


RUN set -eux; \
    dpkg --add-architecture i386; \
    # Skipping all of the "recommended" cruft reduces total images size by ~300MiB
    apt-get update && apt-get install --no-install-recommends -y \
    lsb-release wget software-properties-common gnupg tar make python3 python3-pip; \
    pip3 install pefile; \
    wget https://apt.llvm.org/llvm.sh; \
    chmod +x llvm.sh; \
    ./llvm.sh 17; \
    # ensure that clang/clang++ are callable directly
    ln -s clang-17 /usr/bin/clang && ln -s clang /usr/bin/clang++ && ln -s lld-17 /usr/bin/ld.lld; \
    # We also need to setup symlinks ourselves for the MSVC shims because they aren't in the debian packages
    ln -s clang-17 /usr/bin/clang-cl && ln -s llvm-ar-17 /usr/bin/llvm-lib && ln -s lld-link-17 /usr/bin/lld-link; \
    # Verify the symlinks are correct
    clang++ -v; \
    ld.lld -v; \
    # Doesn't have an actual -v/--version flag, but it still exits with 0
    llvm-lib -v; \
    clang-cl -v; \
    lld-link --version; \
    # Use clang instead of gcc when compiling binaries targeting the host (eg proc macros, build files)
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100; \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100; \
    apt-get remove -y --auto-remove; \
    rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
    wget https://github.com/Jake-Shadle/xwin/releases/download/0.5.0/xwin-0.5.0-x86_64-unknown-linux-musl.tar.gz; \
    tar -xzf ./xwin-0.5.0-x86_64-unknown-linux-musl.tar.gz -C /usr/bin --strip-components=1 xwin-0.5.0-x86_64-unknown-linux-musl/xwin; \
    echo "[+] "; \
    echo "[+] Installing Windows SDK (this may take a couple minutes...)"; \
    echo "[+] "; \
    xwin --accept-license splat --output /xwin; \
    rm -rf .xwin-cache /usr/bin/xwin;
