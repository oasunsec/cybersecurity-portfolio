# Tuning Notes

## Current State

The exported case shows that `Repeated RDP Authentication Accepted` produced three findings and zero incidents.

Current interpretation:

- the rule is sensitive enough to surface repeated accepted RDP access
- the rule is not noisy in this sample because there were only three promoted findings
- the missing correlation comes from telemetry gaps, not obvious rule failure

## Tuning Decision

Keep the rule visible as a standalone finding in the lab.

Why:

- accepted RDP access can reflect hands-on-keyboard activity
- there is not enough evidence in this sample to justify suppression
- reducing visibility would be premature before documenting normal admin paths

## When I Would Tune It Further

I would consider more aggressive tuning only after:

1. documenting approved jump hosts or admin workstations
2. collecting Security and Sysmon telemetry
3. validating whether repeated `1149` activity commonly maps to benign maintenance in the target environment

## Published Example

The file `artifacts/local-tuning-example.json` shows a minimal overlay that suppresses one reserved TEST-NET jump-host IP after validation and change control. It is included as a documented example of how suppression could be applied after approved admin paths are confirmed. It was not applied to the exported case artifacts in this project.

## Preferred Next Improvement

The next engineering step should be correlation, not suppression.

Add:

- Security `4624` LogonType `10`
- Sysmon process creation
- Sysmon network events
- any tunnel or port-forwarding signals that share the same user or source IP
