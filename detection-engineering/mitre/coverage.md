# ATT&CK Coverage Note

## Primary Mapping

- Tactic: Lateral Movement
- Technique: `T1021.001` Remote Desktop Protocol

## Why It Fits

Repeated successful TerminalServices `1149` events show accepted remote interactive access over RDP. In a real environment, that activity can reflect either benign administration or lateral movement, which is why analyst review and correlation matter.

## Supporting Telemetry for Stronger Correlation

- Security `4624` LogonType `10`
- Sysmon process creation after logon
- Sysmon network activity from the same host or source IP
- tunnel or port-forwarding detections that explain how RDP access was established
