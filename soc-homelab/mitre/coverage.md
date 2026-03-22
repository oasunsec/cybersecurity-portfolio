# ATT&CK Coverage Note

## Confirmed or Strongly Supported Mappings


| Technique | ID | Why It Fits |
|---|---|---|
| Command and Scripting Interpreter: Unix Shell | `T1059.004` | The retrieved payload is a Bash script |
| Ingress Tool Transfer | `T1105` | The host downloaded `install.sh` from external infrastructure |
| Exfiltration Over Web Service | `T1567` | Encoded environment data was sent to `webhook.site` |
| Obfuscated/Compressed Files and Information | `T1027` | The script hid Python logic in Base64 content |

## Analyst Note

`T1105` and `T1567` are the strongest mappings because the evidence clearly supports payload retrieval and outbound data transfer.
