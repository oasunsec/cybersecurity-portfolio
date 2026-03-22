#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-127.0.0.1}"
PORT="${2:-3000}"

mkdir -p artifacts

echo "[*] HTTP Header Check"
curl -I "http://${TARGET}:${PORT}" | tee "artifacts/http-headers.txt"

echo
echo "[*] Nmap Service Discovery"
nmap -Pn -sV -p "${PORT}" -oN "artifacts/nmap-initial.txt" "${TARGET}"

echo
echo "[*] Nikto Web Check"
nikto -h "http://${TARGET}:${PORT}" -output "artifacts/nikto-initial.txt"

