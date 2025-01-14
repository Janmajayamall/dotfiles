#!/bin/bash

# Define variables
INTEL_SGX_URL="https://download.01.org/intel-sgx"
LINUX_SGX_VERSION="2.19"
INSTALL_ROOT_DIR="/opt/intel"
SGX_SDK="${INSTALL_ROOT_DIR}/sgxsdk"
SGX_SSL="${INSTALL_ROOT_DIR}/sgxssl"
OPENSSL_VERSION="1.1.1t"
SGX_SSL_COMMIT="7d78500f312a6cebeeb1b398ee6639bf01d8746d"
SGX_MODE="SIM"

# Update package repositories and install required packages
apt-get update && apt-get install -y \
    build-essential \
    libcurl4-openssl-dev \
    libprotobuf-dev \
    libssl-dev \
    pkg-config \
    wget \
    git \
    nasm

# Install prebuilt binutils
pkg="as.ld.objdump.r4.tar.gz"
url="${INTEL_SGX_URL}/sgx-linux/${LINUX_SGX_VERSION}/${pkg}"
sha256="85dcba642ee951686cb01479be377dc5da0b4f1597014679d1a29162f0dc8160"
wget "${url}"
echo "${sha256} *${pkg}" | sha256sum --strict --check -
tar -xvf ${pkg} --directory /usr/local/bin/
rm -f ${pkg}

# Install SGX SDK
distro="ubuntu22.04-server"
version="2.19.100.3"
pkg="sgx_linux_x64_sdk_${version}.bin"
url="${INTEL_SGX_URL}/sgx-linux/${LINUX_SGX_VERSION}/distro/${distro}/${pkg}"
sha256="b99b66a2e7d3842d106cf37747a124c53a9b49b07649e1ee26c0da2beb5ab3ce"
wget -O sdk.bin "${url}"
echo "$sha256 *sdk.bin" | sha256sum --strict --check -
chmod +x sdk.bin
echo -e "no\n/${INSTALL_ROOT_DIR}" | ./sdk.bin
echo "source ${SGX_SDK}/environment" >> /root/.bashrc
rm -f sdk.bin

# Install PSW
distro="jammy"
url="${INTEL_SGX_URL}/sgx_repo/ubuntu"
echo "deb [arch=amd64] ${url} ${distro} main" | tee /etc/apt/sources.list.d/intel-sgx.list
wget -qO - "${url}/intel-sgx-deb.key" | apt-key add -
apt-get update
apt-get install -y --no-install-recommends \
    libsgx-headers \
    libsgx-ae-epid \
    libsgx-ae-le \
    libsgx-ae-pce \
    libsgx-aesm-epid-plugin \
    libsgx-aesm-launch-plugin \
    libsgx-aesm-pce-plugin \
    libsgx-aesm-quote-ex-plugin \
    libsgx-enclave-common \
    libsgx-enclave-common-dev \
    libsgx-epid \
    libsgx-epid-dev \
    libsgx-launch \
    libsgx-launch-dev \
    libsgx-quote-ex \
    libsgx-quote-ex-dev \
    libsgx-uae-service \
    libsgx-urts \
    sgx-aesm-service

# Install SGX SSL
git clone https://github.com/intel/intel-sgx-ssl.git ${SGX_SSL}
cd ${SGX_SSL}
git checkout ${SGX_SSL_COMMIT}

pkg="openssl-${OPENSSL_VERSION}.tar.gz"
openssl_url="https://www.openssl.org/source/${pkg}"
sha256="8dee9b24bdb1dcbf0c3d1e9b02fb8f6bf22165e807f45adeb7c9677536859d3b"
wget ${openssl_url} -P openssl_source
echo "${sha256} openssl_source/${pkg}" | sha256sum --strict --check -
make -C Linux sgxssl_no_mitigation SGX_MODE=${SGX_MODE}
DESTDIR=${SGX_SSL} make -C Linux install
