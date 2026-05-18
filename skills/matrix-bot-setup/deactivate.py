#!/usr/bin/env python3
"""Self-deactivate the bot account whose creds live in bot.env.

Runs the standard Matrix client-side deactivation (UIA password auth).
No admin token needed — the account password is in bot.env.

Usage:
    python3 deactivate.py path/to/bot.env

After this returns 200, the account is dead: it can't log in, can't be
re-registered with the same localpart (continuwuity reserves dead names),
and other users see it as deactivated. Memberships persist as
'leave' tombstones in their rooms.
"""
import json, shlex, sys, urllib.error, urllib.request
from pathlib import Path


def parse_env(path):
    out = {}
    for line in Path(path).read_text().splitlines():
        if line.startswith("#") or "=" not in line:
            continue
        k, _, v = line.partition("=")
        if v.startswith("'") and v.endswith("'"):
            v = v[1:-1].replace("'\"'\"'", "'")
        out[k] = v
    return out


def post(hs, token, body):
    req = urllib.request.Request(
        f"{hs}/_matrix/client/v3/account/deactivate",
        data=json.dumps(body).encode(),
        method="POST",
        headers={"Authorization": f"Bearer {token}",
                 "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=15) as r:
            return r.status, json.loads(r.read())
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read())


def main():
    if len(sys.argv) != 2:
        sys.exit("usage: deactivate.py path/to/bot.env")
    env = parse_env(sys.argv[1])
    for k in ("HS", "MXID", "TOKEN", "BOT_PASSWORD"):
        if k not in env:
            sys.exit(f"bot.env is missing {k}")
    localpart = env["MXID"].split(":")[0].lstrip("@")

    # Step 1: kick off UIA flow → get session token
    st, r = post(env["HS"], env["TOKEN"], {})
    if st != 401 or "session" not in r:
        sys.exit(f"unexpected UIA prompt: {st} {r}")
    session = r["session"]

    # Step 2: submit password
    st, r = post(env["HS"], env["TOKEN"], {"auth": {
        "type":       "m.login.password",
        "identifier": {"type": "m.id.user", "user": localpart},
        "password":   env["BOT_PASSWORD"],
        "session":    session,
    }})
    if st != 200:
        sys.exit(f"deactivate failed: {st} {r}")
    print(f"deactivated {env['MXID']}: {r}")


if __name__ == "__main__":
    main()
