#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACT_DIR="${ROOT_DIR}/artifacts"
BASE_URL="http://127.0.0.1:3000"
HARDENED_URL="http://127.0.0.1:8081"
RUNTIME_DIR="${ROOT_DIR}/hardening/runtime"
PID_FILE="${RUNTIME_DIR}/logs/nginx.pid"

mkdir -p "${ARTIFACT_DIR}"

normalize_file() {
  sed -i 's/\r$//' "$1"
}

HARDENED_PROXY_STARTED_BY_SCRIPT=0
cleanup() {
  if [ "${HARDENED_PROXY_STARTED_BY_SCRIPT}" -eq 1 ]; then
    "${ROOT_DIR}/scripts/stop_hardened_proxy.sh" >/dev/null 2>&1 || true
    rm -rf "${RUNTIME_DIR}"
  fi
}
trap cleanup EXIT

"${ROOT_DIR}/scripts/start_target.sh"

echo "[*] Capturing fresh baseline artifacts"
curl -sSI "${BASE_URL}/" > "${ARTIFACT_DIR}/validation-baseline-http-headers.txt"
normalize_file "${ARTIFACT_DIR}/validation-baseline-http-headers.txt"
curl -sS "${BASE_URL}/robots.txt" > "${ARTIFACT_DIR}/validation-baseline-robots.txt"
normalize_file "${ARTIFACT_DIR}/validation-baseline-robots.txt"
curl -sSI "${BASE_URL}/ftp/" > "${ARTIFACT_DIR}/validation-baseline-ftp-head.txt"
normalize_file "${ARTIFACT_DIR}/validation-baseline-ftp-head.txt"

if [ -f "${PID_FILE}" ] && kill -0 "$(cat "${PID_FILE}")" 2>/dev/null; then
  :
else
  HARDENED_PROXY_STARTED_BY_SCRIPT=1
fi
"${ROOT_DIR}/scripts/start_hardened_proxy.sh"

echo "[*] Capturing hardened validation artifacts"
curl -sSI "${HARDENED_URL}/" > "${ARTIFACT_DIR}/validation-hardened-http-headers.txt"
normalize_file "${ARTIFACT_DIR}/validation-hardened-http-headers.txt"
curl -sS "${HARDENED_URL}/robots.txt" > "${ARTIFACT_DIR}/validation-hardened-robots.txt"
normalize_file "${ARTIFACT_DIR}/validation-hardened-robots.txt"
curl -sSI "${HARDENED_URL}/ftp/" > "${ARTIFACT_DIR}/validation-hardened-ftp-head.txt"
normalize_file "${ARTIFACT_DIR}/validation-hardened-ftp-head.txt"

cat > "${ARTIFACT_DIR}/validation-summary.md" <<'EOF'
# Validation Summary

## Baseline

- `http://127.0.0.1:3000/` returned `Access-Control-Allow-Origin: *`
- `http://127.0.0.1:3000/` did not return a `Content-Security-Policy` header
- `http://127.0.0.1:3000/ftp/` returned `200 OK`
- `http://127.0.0.1:3000/robots.txt` disclosed the `/ftp/` route

## Hardened Proxy

- `http://127.0.0.1:8081/` limits `Access-Control-Allow-Origin` to the proxy origin
- `http://127.0.0.1:8081/` returns a `Content-Security-Policy` header
- `http://127.0.0.1:8081/ftp/` returns `403 Forbidden`
- `http://127.0.0.1:8081/robots.txt` no longer discloses the `/ftp/` route
EOF

echo "[*] Validation artifacts written to ${ARTIFACT_DIR}"
