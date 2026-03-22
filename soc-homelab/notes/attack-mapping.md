# ATT&CK Mapping

## Analyst Mapping

This mapping is based on observed network behavior and decoded script content.

| Technique | ID | Why It Fits |
|---|---|---|
| Command and Scripting Interpreter: Unix Shell | `T1059.004` | The retrieved payload is a Bash script |
| Ingress Tool Transfer | `T1105` | The host downloads `install.sh` from external infrastructure |
| Exfiltration Over Web Service | `T1567` | Encoded environment data is sent to `webhook.site` |
| Obfuscated/Compressed Files and Information | `T1027` | Script hides Python logic in Base64 content |

## Notes

- `T1105` is the clearest fit because the script is fetched from an external service
- `T1567` is an informed inference based on the outbound request carrying encoded data
- The data sent appears to be derived from environment variables, which makes host triage important

