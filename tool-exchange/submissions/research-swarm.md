# research-swarm

> A DSPy ReAct research agent that thinks out loud, cites its sources, and remembers what you asked last time.

## What it is

Ask a question. A ReAct loop picks from ~12 tools (web / arXiv / GitHub /
fetch / verify citations / etc.) until it has enough material to write a
grounded synthesis. Every page it reads lands in `~/world_knowledge/`
and a local SQLite FTS5 index, so adjacent queries the next day answer
from the archive you already trust. Runs in two modes: single ReAct loop,
or STORM-style parallel decompose-fan-out-merge.

## Who it's for

Researchers who want to skip the "open 20 tabs, lose track of what you
read" part of a literature pull. Anyone running regular grounded-answer
work who wants the agent to get smarter on their own corpus over time
rather than restarting cold every query.

## Install

```bash
# via the shape-rotator-field-kit:
bash setup.sh
rotate research "what is Loopix?"

# standalone:
git clone https://github.com/dmarzzz/research-swarm.git
cd research-swarm
python3.12 -m venv .venv && source .venv/bin/activate
pip install -e .
cp .env.example .env   # pick an LM
research-agent "your question"
```

## Run

```bash
research-agent "what is Loopix and how does it compare to Tor?"
research-agent --parallel "survey modern post-quantum signatures"
research-agent --no-critique "quick lookup, skip the review"
```

Live tool-call trace on stderr (each tool the agent picks, with
latency and one-line result). Synthesis in a bordered box; sources
and self-critique below.

## Platforms

- macOS (Apple Silicon): yes
- macOS (Intel): yes
- Linux: yes
- Windows: yes (untested but stdlib-only code paths; Ollama/OpenAI should both work)

## Dependencies

Python 3.10+ (3.12 recommended). An LM: Ollama (no key), Anthropic,
OpenAI, or anything `litellm` supports.

## Links

- **Repo:** https://github.com/dmarzzz/research-swarm
- **Demo:** `research-agent "what is Loopix?"` in a fresh terminal is the demo.

## Author

- **Name / handle:** @dmarzzz
- **Contact:** GitHub

## License

MIT

## Status

Stable for single-user research loops. Broader features (local
embeddings, mining past runs as a Q→answers corpus) on the roadmap.

## Tags

`research`, `agent`, `cli`, `local-first`

## Notes

Zero API keys required on the free path (Ollama + DDG). Cache gate
short-circuits repeat queries without hitting the network. Temporal-
marker queries ("latest", "today", current year) auto-bypass the
cache so time-sensitive things stay fresh.
