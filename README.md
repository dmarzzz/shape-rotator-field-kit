# shape-rotator-field-kit

Tools for the shape rotator program. Each pinned to a specific commit.

```bash
git clone --recurse-submodules https://github.com/dmarzzz/shape-rotator-field-kit.git
cd shape-rotator-field-kit
bash setup.sh
```

Then:

```bash
./kit research "what is Loopix?"      # DSPy ReAct research agent
./kit vox                             # voxterm voice transcription TUI
./kit doctor                          # check everything is installed
./kit update                          # bump submodules to upstream main
./kit help                            # full command list
```

| tool | what it is |
|---|---|
| [`research-swarm`](./research-swarm) | DSPy ReAct research agent |
| [`voxterm`](./voxterm) | local voice transcription TUI with P2P |
| `content-pipeline` | _coming soon_ |

See [`AGENTS.md`](./AGENTS.md) for how to use these from your own agent.
