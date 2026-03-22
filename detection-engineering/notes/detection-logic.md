# Detection Logic Notes

## Use Case

Detect repeated accepted RDP authentication events that may indicate interactive lateral movement.

## Logic Summary

- Review Windows TerminalServices RemoteConnectionManager events
- Keep only event ID `1149`
- Extract the authenticating user, remote source host, and remote source IP
- Group activity by destination host, user, and source IP
- Split groups into clusters when events are more than two hours apart
- Promote clusters with at least two accepted authentications into findings

## Why This Logic Works

- Single successful RDP events can be ambiguous
- Repetition from the same remote source is more suspicious and easier to defend analytically
- The rule stays narrow enough to support consistent review and tuning

## Confidence Limits

This use case is still constrained by missing supporting telemetry:

- no Security `4624` validation in the exported case
- no Sysmon process creation to confirm follow-on execution
- no PowerShell logging to show script-driven activity

The detection is still worth keeping because the weakness is context depth, not the core signal.
