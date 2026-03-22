#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="${CONTAINER_NAME:-juice-shop-lab}"
IMAGE="${IMAGE:-bkimminich/juice-shop:latest}"
HOST_PORT="${HOST_PORT:-3000}"

if docker ps --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; then
  echo "[*] Container ${CONTAINER_NAME} is already running"
  exit 0
fi

if docker ps -a --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; then
  docker rm -f "${CONTAINER_NAME}" >/dev/null
fi

echo "[*] Starting Juice Shop on 127.0.0.1:${HOST_PORT}"
docker run -d --rm \
  --name "${CONTAINER_NAME}" \
  -p "127.0.0.1:${HOST_PORT}:3000" \
  "${IMAGE}" >/dev/null

for attempt in $(seq 1 30); do
  if curl -fsS -o /dev/null "http://127.0.0.1:${HOST_PORT}/" 2>/dev/null; then
    echo "[*] Juice Shop is reachable"
    exit 0
  fi
  sleep 1
done

echo "[!] Juice Shop did not become ready in time" >&2
exit 1
