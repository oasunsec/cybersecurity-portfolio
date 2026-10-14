# Cybersecurity Portfolio

Four lab investigations from a VMware and Kali Linux setup. Each one keeps the raw artifacts, screenshots, and the scripts used to produce them, so every claim can be checked.

GIAC GSEC · GIAC GCIH · CompTIA Security+

## Projects

### [SOC Homelab Investigation](./soc-homelab/README.md)

Packet capture of a Linux host downloading `install.sh` from `filebin.net` and calling out to `webhook.site`. I decoded the outbound request by rebuilding the payload's XOR key from unseeded glibc `rand()`. It held the host's environment variables, including an API key, which makes this credential theft.

### [Vulnerability Management Lab](./vuln-mgmt/README.md)

Nmap and Nikto against OWASP Juice Shop. Most of Nikto's "backup file" hits were the single-page app returning the same page for every path. Three findings were real. I fixed them behind an nginx reverse proxy and saved the headers from before and after.

### [Web Application Pentest Lab](./webapp-pentest/README.md)

SQL injection in the Juice Shop login API gives an admin session, and an unauthenticated API call leaks the framework version. Each finding has the saved request and response, plus a retest through a small Python proxy that blocks both.

### [Detection Engineering and Tuning Lab](./detection-engineering/README.md)

A rule for repeated accepted RDP logons (event 1149), run with my [triage-engine](https://github.com/oasunsec/triage-engine). It found three hits and no incidents because Security and Sysmon logs were missing. I explain why I kept the rule instead of suppressing it.

Also see [Honey Token Detection](https://github.com/oasunsec/honey-token-detection): decoy documents that alert into Microsoft Sentinel on Azure.

## Tools used

Wireshark, `tshark`, `tcpdump`, Nmap, Nikto, `curl`, nginx, `jq`, Python, Bash.
