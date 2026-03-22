#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_DIR="$(cd -- "${ROOT_DIR}/../.." && pwd)"
# Default expects the sibling triage-engine repo at ../../triage-engine/cases/Testing.
# Pass an explicit case directory as the first argument if your local export lives elsewhere.
CASE_DIR="${1:-${WORKSPACE_DIR}/triage-engine/cases/Testing}"
ARTIFACT_DIR="${ROOT_DIR}/artifacts"

SUMMARY_PATH="${CASE_DIR}/summary.txt"
FINDINGS_PATH="${CASE_DIR}/findings.json"
TIMELINE_PATH="${CASE_DIR}/timeline.json"
INCIDENT_BRIEF_PATH="${CASE_DIR}/incident_brief.md"

mkdir -p "${ARTIFACT_DIR}"

for required in "${SUMMARY_PATH}" "${FINDINGS_PATH}" "${TIMELINE_PATH}" "${INCIDENT_BRIEF_PATH}"; do
  if [ ! -f "${required}" ]; then
    echo "[!] Required case artifact missing: ${required}" >&2
    exit 1
  fi
done

cp "${SUMMARY_PATH}" "${ARTIFACT_DIR}/case-summary.txt"
cp "${INCIDENT_BRIEF_PATH}" "${ARTIFACT_DIR}/incident-brief.md"

jq -r '
  "# Finding Metrics\n\n" +
  "- Response priority: `" + .case.response_priority + "`\n" +
  "- Signal count: `" + (.case.case_metrics.signal_count | tostring) + "`\n" +
  "- Finding count: `" + (.case.case_metrics.finding_count | tostring) + "`\n" +
  "- Incident count: `" + (.case.case_metrics.incident_count | tostring) + "`\n" +
  "- Finding promotion rate: `" + (.case.case_metrics.finding_promotion_rate | tostring) + "`\n" +
  "- Incident promotion rate: `" + (.case.case_metrics.incident_promotion_rate | tostring) + "`\n" +
  "- Telemetry present: `" + ((.case.telemetry_summary.observed // []) | join(", ")) + "`\n" +
  "- Telemetry missing: `" + ((.case.telemetry_summary.missing // []) | join(", ")) + "`\n\n" +
  "## Rule Metrics\n\n" +
  ((.case.rule_metrics // []) | map(
    "- " + .rule +
    ": raw `" + (.raw_alert_count | tostring) +
    "`, findings `" + (.finding_count | tostring) +
    "`, incidents `" + (.incident_count | tostring) + "`"
  ) | join("\n")) + "\n\n" +
  "## Tuning Recommendations\n\n" +
  ((.case.tuning_recommendations // []) | map(
    "- " + .rule + ": `" + .suggestion + "` (" + .reason + ")"
  ) | join("\n"))
' "${FINDINGS_PATH}" > "${ARTIFACT_DIR}/finding-metrics.md"

jq -r '
  (["display_label","timestamp","title","severity","host","user","source_ip","summary"] | @csv),
  (.timeline[] | [
    .display_label,
    .timestamp,
    .title,
    .severity,
    .host_display,
    .user_display,
    .source_ip_display,
    (.summary | gsub("\n"; " "))
  ] | @csv)
' "${TIMELINE_PATH}" > "${ARTIFACT_DIR}/timeline.csv"

jq '{
  case: {
    case_name: .case.case_name,
    input_source_display: .case.input_source_display,
    primary_host: .case.primary_host,
    primary_user: .case.primary_user,
    primary_source_ip: .case.primary_source_ip,
    response_priority: .case.response_priority,
    telemetry_present: .case.telemetry_summary.observed,
    telemetry_missing: .case.telemetry_summary.missing
  },
  findings: [
    .findings[] | {
      display_label,
      title,
      severity,
      confidence,
      host,
      user: .user_display,
      source_ip,
      summary,
      recommended_next
    }
  ]
}' "${FINDINGS_PATH}" > "${ARTIFACT_DIR}/detection-snapshot.json"

echo "[*] Exported case artifacts into ${ARTIFACT_DIR}"
