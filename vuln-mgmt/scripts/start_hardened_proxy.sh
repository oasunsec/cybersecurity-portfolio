#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="${ROOT_DIR}/hardening/runtime"
CONFIG_PATH="${ROOT_DIR}/hardening/nginx.conf"
PROXY_PORT="${PROXY_PORT:-8081}"

mkdir -p \
  "${RUNTIME_DIR}/logs" \
  "${RUNTIME_DIR}/temp/client_body" \
  "${RUNTIME_DIR}/temp/proxy" \
  "${RUNTIME_DIR}/temp/fastcgi" \
  "${RUNTIME_DIR}/temp/uwsgi" \
  "${RUNTIME_DIR}/temp/scgi"

if [ -f "${RUNTIME_DIR}/logs/nginx.pid" ]; then
  PID="$(cat "${RUNTIME_DIR}/logs/nginx.pid")"
  if kill -0 "${PID}" 2>/dev/null; then
    echo "[*] Hardened proxy is already running on 127.0.0.1:${PROXY_PORT}"
    exit 0
  fi
  rm -f "${RUNTIME_DIR}/logs/nginx.pid"
fi

echo "[*] Starting hardened proxy on 127.0.0.1:${PROXY_PORT}"
nginx -p "${RUNTIME_DIR}/" -c "${CONFIG_PATH}"

for attempt in $(seq 1 15); do
  if curl -fsS -o /dev/null "http://127.0.0.1:${PROXY_PORT}/" 2>/dev/null; then
    echo "[*] Hardened proxy is reachable"
    exit 0
  fi
  sleep 1
done

echo "[!] Hardened proxy did not become ready in time" >&2
exit 1
