# ATT&CK and Defensive Context

I didn't map this project to ATT&CK techniques. The findings are exposure problems, not attacker behavior I observed, and forcing technique labels onto them wouldn't add anything.

What the findings mean for a defender:

- `robots.txt` and the open `/ftp/` route help an attacker map the application
- A wildcard CORS origin and a missing CSP make other bugs easier to exploit
- A reverse proxy can close these gaps while the application fix is pending
