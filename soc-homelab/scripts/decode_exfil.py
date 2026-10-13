#!/usr/bin/env python3
"""Recover the data the decoded payload sent to webhook.site.

The payload XORs str(os.environ) with a key built from glibc rand() and
Base64-encodes the result into the ?x= query parameter. rand() is never
seeded, so it uses glibc's default seed of 1 and the key is reproducible
on any system.

Usage: python3 decode_exfil.py ../artifacts/tcp-stream-webhook.txt
"""

import base64
import re
import sys


def glibc_rand(count, seed=1):
    """Return the first `count` values of glibc rand() (TYPE_3 generator)."""
    r = [0] * (344 + count)
    r[0] = seed
    for i in range(1, 31):
        r[i] = (16807 * r[i - 1]) % 2147483647
    for i in range(31, 34):
        r[i] = r[i - 31]
    for i in range(34, 344 + count):
        r[i] = (r[i - 31] + r[i - 3]) & 0xFFFFFFFF
    return [value >> 1 for value in r[344:]]


def payload_key():
    # Mirrors x() in decoded_python_payload.py: the 1337th rand() value,
    # split into two-digit character codes, Base64-encoded, padding removed.
    y = str(glibc_rand(1337)[-1])
    chars = "".join(chr(int(y[i:i + 2])) for i in range(0, len(y), 2))
    return base64.b64encode(chars.encode()).decode().replace("=", "")


def decode(blob):
    data = base64.b64decode(blob).decode()
    key = payload_key()
    key = key * (len(data) // len(key) + 1)
    return "".join(chr(ord(c) ^ ord(k)) for c, k in zip(data, key))


def main():
    text = open(sys.argv[1], encoding="utf-8").read()
    match = re.search(r"[?&]x=([A-Za-z0-9+/=]+)", text)
    if not match:
        sys.exit("no ?x= parameter found")
    print(decode(match.group(1)))


if __name__ == "__main__":
    main()
