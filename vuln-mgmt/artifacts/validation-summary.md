# Validation Summary

## Baseline

- `http://127.0.0.1:3000/` returned `Access-Control-Allow-Origin: *`
- `http://127.0.0.1:3000/` did not return a `Content-Security-Policy` header
- `http://127.0.0.1:3000/ftp/` returned `200 OK`
- `http://127.0.0.1:3000/robots.txt` disclosed the `/ftp/` route

## Hardened Proxy

- `http://127.0.0.1:8081/` limits `Access-Control-Allow-Origin` to the proxy origin
- `http://127.0.0.1:8081/` returns a `Content-Security-Policy` header
- `http://127.0.0.1:8081/ftp/` returns `403 Forbidden`
- `http://127.0.0.1:8081/robots.txt` no longer discloses the `/ftp/` route
