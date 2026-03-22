# IOC List

## Network Indicators

| Type | Value | Notes |
|---|---|---|
| Source IP | `10.89.0.5` | Internal host observed downloading and beaconing |
| Destination IP | `88.99.137.18` | File retrieval infrastructure |
| Destination IP | `178.63.67.153` | Webhook destination |
| Domain | `filebin.net` | Initial script download |
| Domain | `s3.filebin.net` | Redirect target hosting `install.sh` |
| Domain | `webhook.site` | Outbound request destination |

## HTTP Indicators

| Type | Value | Notes |
|---|---|---|
| User-Agent | `curl/7.88.1` | Used for script retrieval |
| User-Agent | `python-requests/2.28.1` | Used for outbound beacon |
| URI | `/dqatt7c4cvcc1fc1/install.sh` | Initial download path |
| Filename | `install.sh` | Retrieved script payload |

## File Indicators

| Type | Value |
|---|---|
| PCAP SHA256 | `394bbfee67e777d61226c36ecaffeff8de5f97ff95f62b3e3ef7ac06ed8d22d3` |

