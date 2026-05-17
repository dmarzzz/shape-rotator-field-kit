---
name: matrix-bot-setup
description: Set up the user's local agent as a bot on the Shape Rotator OS Matrix server. Walks through bot account creation, credentials, and registering the bot. Use when the user says "set up my matrix bot", "register my agent on matrix", or similar. Currently a stub — full instructions are pending.
---

# matrix-bot-setup

Register the user's local agent as a bot on the Shape Rotator OS Matrix
server.

> **STATUS — STUB.** The operator hasn't supplied the Matrix homeserver,
> bot-registration token, or room IDs yet. Until those are filled in,
> stop after step 1 and tell the user the skill isn't fully wired up.

## When to invoke

- "set up my matrix bot"
- "register my agent on matrix"
- "get my bot on the cohort matrix server"

## Preconditions

1. The user has finished the `shape-rotator-profile` skill (so their
   cohort record is in place — the bot is attached to a person record).
2. `gh` CLI available + authenticated (only needed if we end up writing
   bot config back into the cohort repo).

## Workflow

### 1 — confirm the homeserver and room

TODO(operator): fill in once the operator provides:
- Matrix homeserver URL (e.g. `https://matrix.shape-rotator.xyz`)
- Cohort room ID (e.g. `#shape-rotator-cohort:matrix.shape-rotator.xyz`)
- Whether bot registration is open or token-gated

### 2 — create the bot account

TODO(operator): document either:
- Self-service: register at `<homeserver>/_matrix/static/...`, or
- Token-gated: how to request a registration token from the steward.

The bot's localpart should be `<user-slug>-bot` (e.g. `dmarz-bot`) to
keep it predictable.

### 3 — store credentials locally

TODO(operator): pick a location — likely `~/.config/shape-rotator/matrix.toml`
or a per-bot `.env` in the user's local agent dir. Don't commit any of
this to a repo.

### 4 — point the bot at the cohort room

TODO(operator): wire the bot to:
- Auto-join the cohort room on startup
- Honor any per-user kill switch (env var) so people can mute their
  bot during deep work

### 5 — verify

TODO(operator): a small script or `rotate matrix-doctor` that pings the
bot, confirms it's joined the room, and prints its display name.

## Boundaries

- **Don't** commit credentials. Anywhere. Bot access tokens are
  sensitive — they let anyone who has them speak as the user's agent.
- **Don't** join rooms other than the cohort room without asking.
- **Don't** auto-respond to anything until the cohort steward has
  agreed on bot etiquette (rate limits, opt-in for DMs, etc.).
