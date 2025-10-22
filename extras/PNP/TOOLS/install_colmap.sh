#!/usr/bin/env bash
set -eu

RED="\033[1;31m"
ORANGE='\033[1;33m'
GREEN="\033[1;32m"
CYAN="\033[1;36m"
RESET="\033[0m"

error_exit() {
    echo -e "${RED}   ✗ Error: $1${RESET}"
    exit 1
}

warning() {
    echo -e "${ORANGE}   ⚠ Warning: $1${RESET}"
}

echo -e "🚧 Checking Colab runtime environment..."
os_version=$(lsb_release -rs)
if [[ "$os_version" != "22.04" ]]; then
    error_exit "This script requires Ubuntu 22.04. Detected version: $os_version"
fi
echo -e "${GREEN}   ✔ Ubuntu 22.04 detected${RESET}"

if ! command -v nvidia-smi &> /dev/null; then
    warning "'nvidia-smi' not found. This runtime does not have a GPU."
else
    gpu_model=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n1)
    if [[ "$gpu_model" != *"T4"* && "$gpu_model" != *"A100"* && "$gpu_model" != *"L4"* ]]; then
        error_exit "An NVIDIA T4, A100, or L4 GPU is required. Detected: $gpu_model"
    fi
    echo -e "${GREEN}   ✔ Supported GPU detected: $gpu_model${RESET}"

    cuda_version=$(nvcc --version | grep "release" | sed -E 's/.*release ([0-9]+\.[0-9]+).*/\1/')
    if [[ "$cuda_version" != "12.5" ]]; then
        error_exit "CUDA Toolkit 12.5 is required. Detected: $cuda_version"
    fi
    echo -e "${GREEN}   ✔ CUDA Toolkit 12.5 detected${RESET}"
fi

echo
echo -e "⬇️ Downloading precompiled binaries..."
wget -q https://github.com/epassaro/opensplat-colab/releases/latest/download/colmap-3.9.1-ubuntu-22.04.tar.gz
tar xf colmap-3.9.1-ubuntu-22.04.tar.gz -C /usr/local
rm -f colmap-3.9.1-ubuntu-22.04.tar.gz
echo -e "${GREEN}   ✔ colmap installed${RESET}"

echo
echo -e "📦 Installing runtime dependencies..."
apt-get install -qq libmetis5 libspqr2 libcxsparse3 libfreeimage3 libqt5widgets5 > /dev/null 2>&1
echo -e "${GREEN}   ✔ libmetis5 installed${RESET}"
echo -e "${GREEN}   ✔ libspqr2 installed${RESET}"
echo -e "${GREEN}   ✔ libcxsparse3 installed${RESET}"
echo -e "${GREEN}   ✔ libfreeimage3 installed${RESET}"
echo -e "${GREEN}   ✔ libqt5widgets5 installed${RESET}"

wget -q https://download.pytorch.org/libtorch/cu124/libtorch-cxx11-abi-shared-with-deps-2.6.0%2Bcu124.zip -O libtorch.zip
unzip -q libtorch.zip
rm -f libtorch.zip
cp -r libtorch/. /usr/local
rm -rf libtorch/
ldconfig > /dev/null 2>&1
echo -e "${GREEN}   ✔ torchlib installed${RESET}"

echo
echo "🚀 Everything is set up! You can now run COLMAP in this Colab environment"