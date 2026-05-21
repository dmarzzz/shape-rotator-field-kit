# shape-rotator-field-kit

Tools for the shape rotator program. Each pinned to a specific commit.

```bash
git clone --recurse-submodules https://github.com/dmarzzz/shape-rotator-field-kit.git
cd shape-rotator-field-kit
bash setup.sh              # install every tool
# or, on a fresh machine without python3.12:
bash setup.sh --install-python
./kit install-global       # make `rotate` callable from anywhere (optional)
```

Then from anywhere on your machine:

```bash
rotate research "what is Loopix?"                 # auto backend
rotate research --backend dspy "what is Loopix?"  # DSPy backend
rotate research --backend codex "what is Loopix?" # Codex app-server backend
rotate vox                                        # voxterm voice transcription TUI
rotate content --trace run.json                   # blog + tweet thread + explainer video
rotate install-skills                             # symlink skills/* → ~/.claude/skills/
rotate install-app                                # install Shape Rotator OS Electron app
rotate doctor                                     # health check
rotate update                                     # bump submodules to upstream main
rotate help                                       # full command list
```

`shape-rotator-kit` is the same binary if you prefer the explicit name.

`install-global` also exports `$SHAPE_ROTATOR_KIT_PATH` and `$SHAPE_ROTATOR_KIT_AGENTS_MD` in your shell, and (if you have Claude Code) appends a pointer to the kit's [`AGENTS.md`](https://github.com/dmarzzz/shape-rotator-field-kit/blob/main/AGENTS.md) in your `~/.claude/CLAUDE.md` so any agent started anywhere knows where these tools live. Reverse with `rotate uninstall-global`.

| tool | what it is |
|---|---|
| [`research-swarm`](https://github.com/dmarzzz/research-swarm) | DSPy / Codex ReAct research harness |
| [`voxterm`](https://github.com/dmarzzz/VoxTerm) | local voice transcription TUI with P2P |
| [`content-pipeline`](https://github.com/dmarzzz/content-pipeline) | turns a research run or transcript into a blog post, tweet thread, and explainer video |
| [`skills/`](https://github.com/dmarzzz/shape-rotator-field-kit/tree/main/skills) | Agent skills — `/shape-rotator-profile` (add/update cohort profile + PR), `/matrix-bot-setup` (stub), `/smithers` (workflow orchestration) |

## Shape Rotator OS desktop app

The cohort viewer / profile editor lives in a separate repo. Install it
with:

```bash
rotate install-app
```

That pulls the latest [release](https://github.com/dmarzzz/shape-rotator-os/releases/latest)
for your platform, copies it into `/Applications` (macOS) or installs
via `dpkg` (Linux), and clears the macOS quarantine flag so Gatekeeper
doesn't refuse to open the unsigned bundle.

**Manual install (any platform):** download the appropriate file from
[releases/latest](https://github.com/dmarzzz/shape-rotator-os/releases/latest):
- macOS arm64: `ShapeRotatorOS-<version>-mac-arm64.dmg`
- macOS x64: `ShapeRotatorOS-<version>-mac-x64.dmg`
- Windows: `ShapeRotatorOS-<version>-win-x64.exe`
- Linux: `ShapeRotatorOS-<version>-linux-amd64.deb` or `.AppImage`

**macOS extra step** (the app is unsigned, so Gatekeeper otherwise
refuses to open it with a misleading "is damaged and can't be opened"
error): after dragging to /Applications, run

```bash
xattr -cr "/Applications/Shape Rotator OS.app"
```

Then launch normally.

## Bringing your own

[`tool-exchange/`](https://github.com/dmarzzz/shape-rotator-field-kit/tree/main/tool-exchange) is the shared directory for tools
cohort members are contributing. PR a markdown file under
[`tool-exchange/submissions/`](https://github.com/dmarzzz/shape-rotator-field-kit/tree/main/tool-exchange/submissions) to list
your tool. There's also a 4-session workshop series the week of May
4-8 — see [`tool-exchange/workshop/`](https://github.com/dmarzzz/shape-rotator-field-kit/tree/main/tool-exchange/workshop) for
the schedule and the signup.

See [`AGENTS.md`](https://github.com/dmarzzz/shape-rotator-field-kit/blob/main/AGENTS.md) for how agents use these tools.
