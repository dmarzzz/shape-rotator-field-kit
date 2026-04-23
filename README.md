# shape-rotator-field-kit

Tools for the shape rotator program. Each pinned to a specific commit.

```bash
git clone --recurse-submodules https://github.com/dmarzzz/shape-rotator-field-kit.git
cd shape-rotator-field-kit
bash setup.sh              # install every tool
./kit install-global       # make `srk` callable from anywhere (optional)
```

Then from anywhere on your machine:

```bash
srk research "what is Loopix?"   # DSPy ReAct research agent
srk vox                          # voxterm voice transcription TUI
srk doctor                       # health check
srk update                       # bump submodules to upstream main
srk help                         # full command list
```

`install-global` also exports `$SHAPE_ROTATOR_KIT_PATH` and `$SHAPE_ROTATOR_KIT_AGENTS_MD` in your shell, and (if you have Claude Code) appends a pointer to the kit's [`AGENTS.md`](./AGENTS.md) in your `~/.claude/CLAUDE.md` so any agent started anywhere knows where these tools live. Reverse with `srk uninstall-global`.

| tool | what it is |
|---|---|
| [`research-swarm`](./research-swarm) | DSPy ReAct research agent |
| [`voxterm`](./voxterm) | local voice transcription TUI with P2P |
| `content-pipeline` | _coming soon_ |

See [`AGENTS.md`](./AGENTS.md) for how agents use these tools.
