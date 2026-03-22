#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="${ROOT_DIR}/hardening/runtime"
CONFIG_PATH="${ROOT_DIR}/hardening/nginx.conf"

if [ ! -f "${RUNTIME_DIR}/logs/nginx.pid" ]; then
  echo "[*] Hardened proxy is not running"
  exit 0
fi

echo "[*] Stopping hardened proxy"
nginx -s stop -p "${RUNTIME_DIR}/" -c "${CONFIG_PATH}" >/dev/null
