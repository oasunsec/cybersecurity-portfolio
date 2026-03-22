#!/usr/bin/env bash
set -euo pipefail

PCAP="${1:-artifacts/2025-02-03_suspicious-http-download.pcap}"

echo "[*] Metadata"
capinfos "$PCAP"

echo
echo "[*] HTTP Requests"
tshark -r "$PCAP" -Y http.request -T fields \
  -e frame.number -e frame.time -e ip.src -e ip.dst \
  -e http.host -e http.request.method -e http.request.uri

echo
echo "[*] HTTP Responses"
tshark -r "$PCAP" -Y http.response -T fields \
  -e frame.number -e frame.time -e ip.src -e ip.dst \
  -e http.response.code -e http.content_type -e http.location

echo
echo "[*] TCP Stream 1"
tshark -r "$PCAP" -q -z follow,tcp,ascii,1

echo
echo "[*] TCP Stream 2"
tshark -r "$PCAP" -q -z follow,tcp,ascii,2

