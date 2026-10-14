# Incident Report: Suspicious Script Download And Outbound Beacon

## Incident Summary

On February 3, 2025, host `10.89.0.5` downloaded `install.sh` from `filebin.net` using `curl`, followed the redirect to `s3.filebin.net`, and retrieved a script that contained a Base64-encoded Python payload. The decoded payload used `python-requests` to send encoded environment data to `webhook.site`. Decoding the request recovered the container's environment variables, including an `API_KEY`. This is confirmed credential theft.

## Systems Involved

- Source host: `10.89.0.5`
- External server 1: `88.99.137.18`
- External server 2: `178.63.67.153`
- Domains: `filebin.net`, `s3.filebin.net`, `webhook.site`
- Analyst system: Kali Linux

## Timeline

| Time | Event | Evidence |
|---|---|---|
| 2025-02-03 14:26:57 | Source host opens TCP session to `88.99.137.18:80` | frames 1-3 |
| 2025-02-03 14:26:57 | `GET /dqatt7c4cvcc1fc1/install.sh` sent to `filebin.net` with `curl/7.88.1` | frame 4 |
| 2025-02-03 14:26:57 | Server responds `302 Found` and redirects to `s3.filebin.net` | frame 5 |
| 2025-02-03 14:26:58 | Source host downloads `install.sh` from `s3.filebin.net` | frames 9-11 |
| 2025-02-03 14:26:58 | Retrieved script shows Base64-decoded Python payload | TCP stream 1 |
| 2025-02-03 14:27:00 | Source host sends HTTP GET request to `webhook.site` with `python-requests/2.28.1` | frame 21 |
| 2025-02-03 14:27:00 | `webhook.site` responds `200 OK` | frame 22 |
| Analysis | `?x=` parameter decoded: environment variables including `API_KEY` | `decoded-exfil.txt` |

## Evidence Collected

- PCAP: [../artifacts/2025-02-03_suspicious-http-download.pcap](../artifacts/2025-02-03_suspicious-http-download.pcap)
- Decoded Python: [../artifacts/decoded_python_payload.py](../artifacts/decoded_python_payload.py)
- Decoded exfiltration (key redacted): [../artifacts/decoded-exfil.txt](../artifacts/decoded-exfil.txt), produced by [../scripts/decode_exfil.py](../scripts/decode_exfil.py)
- IOC list: [./iocs.md](./iocs.md)
- ATT&CK mapping: [./attack-mapping.md](./attack-mapping.md)

## Indicators

- Source IP: `10.89.0.5`
- Destination IPs: `88.99.137.18`, `178.63.67.153`
- Domains: `filebin.net`, `s3.filebin.net`, `webhook.site`
- User-Agent 1: `curl/7.88.1`
- User-Agent 2: `python-requests/2.28.1`
- Downloaded file: `install.sh`
- PCAP SHA256: `394bbfee67e777d61226c36ecaffeff8de5f97ff95f62b3e3ef7ac06ed8d22d3`

## Analyst Assessment

Four things make this malicious:

1. A script was retrieved over plain HTTP from a public file-sharing service
2. The script contained obfuscated logic that decoded and executed Python
3. The decoded Python sent encoded environment data to a webhook endpoint
4. The XOR key comes from unseeded glibc `rand()`, so the request could be decoded offline; it contains an `API_KEY`, the container hostname `66e2549a6da7`, and the internal proxy `10.89.0.6:8080`

This is a staged payload followed by confirmed theft of a secret. Escalate it for credential rotation, host review, and containment.

## Recommended Actions

- Credential: rotate the exfiltrated `API_KEY` and review its use since 2025-02-03 14:27
- Proxy review: search `10.89.0.6:8080` logs for other hosts reaching `filebin.net` or `webhook.site`
- Containment: isolate the source system from the network until host review is complete
- Validation: check shell history, process execution records, cron jobs, and downloaded files
- Monitoring: block or alert on `filebin.net`, `s3.filebin.net`, and `webhook.site` where appropriate
- Escalation: submit the script and decoded payload for deeper malware triage
