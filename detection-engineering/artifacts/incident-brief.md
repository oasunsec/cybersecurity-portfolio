# Incident Brief: Testing

## Case Overview
- Input source: DE_RDP_Tunneling_TerminalServices-RemoteConnectionManagerOperational_1149.evtx
- Primary host: PC01.example.corp
- Primary user: admin01
- Primary source IP: 10.0.2.15
- Response priority: P4
- First seen: 2018-11-06T21:31:54.070986+00:00
- Last seen: 2019-02-13T18:04:57.452387+00:00
- Telemetry present: TerminalServices
- Telemetry missing: Security, Sysmon, PowerShell

## Collection Quality
- Offline collection parsed 1 EVTX file(s) and produced 228 normalized event(s). Missing telemetry: Security, Sysmon, PowerShell.
- Source kind: files
- Source count: 1
- Parsed events: 228
- Warning count: 0
- Warning sources: None
- Permission denied sources: None
- Fallback used: No
- Recommendation: Collect Security telemetry for stronger authentication, privilege, and account-management coverage.
- Recommendation: Enable or collect Sysmon telemetry for stronger process, network, and image-load context.
- Recommendation: Include PowerShell Operational logging for better script-based detection coverage.

## Campaign Summary
- No multi-host campaign overlaps identified.

## Detection Quality Notes
- Repeated RDP Authentication Accepted: raw 3, suppressed 0, findings 3, incidents 0
- Tune: Repeated RDP Authentication Accepted: review_incident_correlation_coverage (This rule promotes strongly into findings but rarely contributes to an incident narrative.)

- Raw alerts: 3
- Suppressed alerts: 0
- Post-filter alerts: 3
- Deduplicated alerts: 0
- Post-dedup alerts: 3
- Suppression reasons: {}

## Key Incidents
- No incidents identified.

## Affected Hosts
- IEWIN7
- PC01.example.corp

## Affected Users
- administrator
- admin01

## Observed IPs
- 10.0.2.15
- 10.0.2.16

## Attack Timeline
- 2018-11-06T21:45:50.411263+00:00 FND-0001 Repeated RDP Authentication Accepted (finding)
- 2019-01-29T23:00:10.212008+00:00 FND-0002 Repeated RDP Authentication Accepted (finding)
- 2019-02-02T22:40:13.572290+00:00 FND-0003 Repeated RDP Authentication Accepted (finding)

## Recommended Next Actions
- Collect Security telemetry for stronger authentication, privilege, and account-management coverage.
- Enable or collect Sysmon telemetry for stronger process, network, and image-load context.
- Include PowerShell Operational logging for better script-based detection coverage.
