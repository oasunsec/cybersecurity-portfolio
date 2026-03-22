# Finding Metrics

- Response priority: `P4`
- Signal count: `3`
- Finding count: `3`
- Incident count: `0`
- Finding promotion rate: `1.0`
- Incident promotion rate: `0.0`
- Telemetry present: `TerminalServices`
- Telemetry missing: `Security, Sysmon, PowerShell`

## Rule Metrics

- Repeated RDP Authentication Accepted: raw `3`, findings `3`, incidents `0`

## Tuning Recommendations

- Repeated RDP Authentication Accepted: `review_incident_correlation_coverage` (This rule promotes strongly into findings but rarely contributes to an incident narrative.)
