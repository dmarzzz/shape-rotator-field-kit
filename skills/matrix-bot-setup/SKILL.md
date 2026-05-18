---
name: matrix-bot-setup
description: Bootstrap a Matrix bot account on the Shape Rotator homeserver (`mtrx.shaperotator.xyz`) with working E2EE and SAS device-verification from Element. Walks the user through signup, cross-signing, launching the prod-served responder, and the in-Element verify click. Use when the user says "set up my matrix bot", "register my agent on matrix", "wire my agent to the cohort matrix server", or similar.
---

# matrix-bot-setup

Register the user's local agent as a bot on `mtrx.shaperotator.xyz` with
working end-to-end encryption. The bot ends up as a verified device in
the user's existing Element, so the rest of the cohort sees it as a
trusted account (no red shields).

The skill does **not** build E2EE from scratch. The homeserver already
serves a working bot runtime (`responder.py` + `sas_verification.py`);
this skill bootstraps an account and points the user at it.

## When to invoke

The user said something like:
- "set up my matrix bot"
- "register my agent on matrix"
- "get my bot on the cohort matrix server"
- "wire my agent to mtrx.shaperotator.xyz"

## Preconditions — check these first, stop early if missing

1. `python3 --version` ≥ 3.10.
2. `pip --version` works (the user will install one package).
3. The user has a **signup code with ≥1 use remaining**. Sources:
   - The bot welcomed them with a 10-use code after they cleared the
     airlock on first join (`/join?code=…` flow). Ask them to scroll
     back in the DM from the shape-rotator approver bot.
   - If they don't have one (joined the space without going through
     `/join`, or exhausted their 10), they need to ping `@socrates1024`
     for a fresh code.
4. The user has **an existing Matrix account** they use in Element
   (`matrix.org`, their own homeserver, anywhere). The bot's
   verification step is a click in *that* Element session — the bot
   doesn't verify itself.

If any precondition fails, stop and tell the user concretely.

## Workflow

### 1 — pick a bot username

Ask: "what should the bot be called? It'll live as
`@<username>:mtrx.shaperotator.xyz`. Pick a name you'd be happy keeping
— deactivation is admin-gated, so throwaway bots clutter the server
permanently. Convention is `<your-name>-bot` (e.g., `andrew-bot`)."

Reject usernames that aren't `[a-z0-9._=-]{1,32}` per the homeserver's
validator. Repeat until you have a clean one.

### 2 — pick a workdir

Ask: "where should I put the bot files? Default
`~/.local/share/shape-rotator-bot`. The directory holds:
`responder.py`, `sas_verification.py`, an encrypted-credentials env
file, and a SQLite crypto store. Keep it private."

### 3 — install runtime deps once

The user runs:
```bash
pip install 'mautrix[e2be]' aiosqlite python-olm unpaddedbase64
```

If `python-olm` fails to install, libolm headers are missing. On macOS:
`brew install libolm`. On Debian/Ubuntu: `sudo apt-get install libolm-dev`.

### 4 — run the bootstrap (agent does this, foreground)

```bash
python3 skills/matrix-bot-setup/bootstrap.py \
    --code <signup-code> \
    --username <username> \
    --workdir <workdir>
```

bootstrap.py does the full sas_prod.py-validated sequence in one
command: signup → write bot.env → fetch responder.py + sas_verification.py
→ launch responder as a child process → wait for `responder up` → wait
8s for share_keys() to publish device keys → call `/signup/api/crosssign`
so the server signs the device with the SSK → keep the responder in the
foreground.

The script stays running as the bot. Watch for:
- `[3/5] responder up` — bot is online
- `[4/5] device_signed = True` — outbound E2EE will actually work
- `[5/5] bot is live` — proceed to verification

If anything fails before `device_signed=True`, the bot is unusable for
sending. **Don't** keep running it; deactivate (see below) and
re-bootstrap with a fresh username.

Idempotency: if `<workdir>/bot.env` already exists, bootstrap reuses it
and skips signup. Re-runs after a clean exit just re-launch the
responder. `--code` and `--username` aren't needed for re-runs.

Common first-run failures:
- `invalid_code` — signup code exhausted or wrong. Ask for a fresh code.
- `bad_username` — localpart fails `[a-z0-9._=-]{1,32}`.
- `crosssign HTTP 4xx` — `/signup/api/crosssign` is single-shot per
  account. If a previous bootstrap got partway through, deactivate the
  account and start over with a new username.

### 5 — verify the bot from Element

Tell the user, in roughly these words:

> Open Element on your existing Matrix account. Find the new bot
> account (`@<username>:mtrx.shaperotator.xyz`) — easiest path: it
> already DM'd you a "hi, I'm a bot, will verify shortly" intro when
> bootstrap.py ran. Open that DM. Click the bot's profile → **Verify**
> → walk through the SAS emoji match (the responder auto-confirms on
> its end, so you just click "they match" on your side).

> After verification, Element will stop showing the red shield for the
> bot's messages, and the bot's device is cross-signed by your USK.

If the bot is offline (responder.py not running), Element won't be able
to start verification — tell the user to launch it.

### 6 — move responder to long-running

Once verified, the user almost certainly wants the bot running detached.
Suggest one of:
- `tmux new -s bot 'python3 skills/matrix-bot-setup/bootstrap.py --workdir <workdir>'`
  — bootstrap.py is idempotent; re-running just relaunches the responder.
- A systemd user unit (provide a template only if asked).

Don't auto-create a daemon — that's a deployment choice, not a skill
default.

### 7 — handing off to the user's agent

The user's agent runtime (Hermes, Claude Code, custom) wires up using:
- `HS`, `MXID`, `TOKEN`, `DEVICE` from `bot.env`
- Same E2EE pattern responder.py uses (mautrix-python with
  `PgCryptoStore`, `_StateStore` shim, `*_min_trust = UNVERIFIED`)

For the verified-device path, agents should point at the same SQLite
crypto store responder.py is writing to, or do their own `share_keys()`
on first launch and re-verify.

If the user asks for an agent-side example, point them at
`knock-approver/approver.py:1486-1530` in
[teleport-computer/shape-rotator-matrix](https://github.com/teleport-computer/shape-rotator-matrix).

### 8 — undoing it (if needed)

If anything went wrong or the user just wants to remove the bot:
```bash
python3 skills/matrix-bot-setup/deactivate.py <workdir>/bot.env
```

This deactivates the account using the password stored in bot.env. No
admin help required. Continuwuity reserves the username forever after
deactivation, so pick a name you're not coming back to.

## Boundaries

- **Don't** commit `bot.env` or the SQLite crypto store anywhere. The
  TOKEN is speak-as-bot; the crypto store contains private Olm keys.
- **Don't** make throwaway bot accounts to "test the skill". Each one
  permanently squats a username and joins the space + child rooms.
  Iterate on the bootstrap.py invocation; only run it for real once.
- **Don't** auto-respond to anything in the cohort space until the
  user has agreed on bot etiquette. The default `responder.py` only
  responds to direct `!ping` / `!whoami` / `!help` commands.
- **Don't** bypass verification by setting `share_keys_min_trust` and
  calling it done. Verification is the whole point — without it the
  cohort sees the bot as an unverified device and the trust model
  breaks.
