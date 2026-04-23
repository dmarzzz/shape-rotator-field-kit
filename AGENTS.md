# AGENTS.md

Instructions for LLM agents (Claude Code, Cursor, Codex, Claude Desktop,
raw DSPy / LangGraph / anything) that want to *use* the shape-rotator
tools from any working directory on this machine.

## How to find this file from anywhere

If the operator has run `srk install-global` (or `./kit install-global`),
two environment variables are available in every shell:

```
$SHAPE_ROTATOR_KIT_PATH         absolute path to the kit root
$SHAPE_ROTATOR_KIT_AGENTS_MD    absolute path to THIS file
```

An agent not already working inside this repo should check those env
vars first. If they're set, read
`$SHAPE_ROTATOR_KIT_AGENTS_MD` for tool usage, then invoke tools via
the `srk` binary (also on PATH after install-global).

If those env vars are not set, fall back to asking the user where the
kit lives, or skip these tools for now.

## What this repo is

A pinned bundle of small, local-first tools for the **shape rotator
program**. Each tool lives in its own git repo and is included here as
a submodule pinned to a specific commit. The kit is stable; individual
tools are updated by bumping their submodule pointer.

When you clone and work on something in this repo, you're usually
working *inside* one of the submodules. Respect each submodule's own
`CLAUDE.md` / `AGENTS.md` / `README.md` for its conventions. This file
is the monorepo-level overview.

## Calling tools globally

After `srk install-global`, every tool is invokable from anywhere:

```bash
srk research "question"          # DSPy research agent
srk vox                          # voice transcription TUI
srk doctor                       # health check
srk update                       # bump submodule pins
srk help                         # full command list
```

`shape-rotator-kit` is an alias for `srk` if your muscle memory prefers
the explicit name. Extra args pass through, e.g.
`srk research --parallel "..."`.

## Setup (run once)

```bash
git clone --recurse-submodules https://github.com/dmarzzz/shape-rotator-field-kit.git
cd shape-rotator-field-kit

# If you forgot --recurse-submodules:
git submodule update --init --recursive
```

## The tools

### `research-swarm/` — DSPy ReAct research agent

- **Use when:** the user needs a grounded, cited answer to an open
  research question, or a literature survey, or a "explain X and
  compare it to Y" kind of ask.
- **What it does:** picks tools (web / arXiv / GitHub / fetch / ...)
  across a ReAct loop until it has enough to write a synthesis with
  inline citations. Every page it reads goes into `~/world_knowledge/`
  and an SQLite FTS5 index, so adjacent queries later go faster and
  answer from material it already trusts.
- **Quickest run:**
  ```bash
  cd research-swarm
  python3.12 -m venv .venv && source .venv/bin/activate
  pip install -e .
  cp .env.example .env                  # set LM_MODEL or ANTHROPIC_API_KEY
  research-agent "your question"
  ```
- **Modes:** `research-agent "q"` (single ReAct loop) or
  `research-agent --parallel "q"` (STORM decompose-fan-out-merge).
- **Library use (for your own agent):**
  ```python
  from research_agent.tools import web_search, local_search, fetch_url, arxiv_search
  # use these as tools in your own DSPy / LangGraph / whatever loop
  ```
- **What NOT to do:** don't invoke the whole `research-agent` CLI for
  one-shot web fetches; import `fetch_url` directly. Don't hit external
  search APIs that need paid keys (Tavily, Brave API, Exa) — the design
  principle is no paid intermediaries.

### `voxterm/` — local voice transcription TUI

- **Use when:** the user wants a real-time transcript of a meeting,
  conversation, or solo talk-out. Works fully offline.
- **What it does:** captures mic audio locally, transcribes in real
  time with speaker diarization, writes a markdown transcript to
  `~/Documents/voxterm-transcripts/`. No audio is stored. Voice
  profiles live encrypted in macOS Keychain. P2P mode shares a
  transcript stream across devices on the same LAN.
- **Requires:** macOS with Apple Silicon (M1+) and Python 3.9+.
- **Quickest install (recommended):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/dmarzzz/VoxTerm/main/install.sh | bash
  voxterm
  ```
- **In-app hotkeys of note:** `P` for party / LAN P2P mode; `H` for
  hive-mind-style aggregate sharing; see voxterm's own README for the
  full set.
- **What NOT to do:** don't spin up a cloud transcription service for
  the same task. This tool is the cloud replacement.

### `content-pipeline/` — _coming soon_

Not yet included. Will appear as a third submodule once the operator
pushes it. When it shows up, it'll turn research outputs and
transcripts into shareable visuals.

## Using tools together

These tools are designed to compose. Some common patterns:

- **Voice-in, research-out:** record a voxterm transcript of someone
  describing a research question → pipe the transcript into
  `research-agent "..."` as the question → share the grounded synthesis.
- **Cumulative archive:** every research-swarm run adds to
  `~/world_knowledge/`. Transcripts land in
  `~/Documents/voxterm-transcripts/`. Both are searchable locally; a
  sibling tool could index both into one view.
- **Offline friendly:** voxterm is fully offline. research-swarm with
  an Ollama LM + an empty query cache still wants network the first
  time, but answers locally thereafter.

## Environment assumptions

- Python 3.12 recommended (3.10+ will also work for research-swarm;
  voxterm needs 3.9+).
- macOS is the first-class target. Linux works for research-swarm.
  voxterm's speaker diarization is Apple-Silicon-optimized.
- No tool in this kit requires a cloud account to run. API keys are
  grudging exceptions where a provider is the only reasonable path
  (GitHub for higher rate limits, Anthropic/OpenAI if you prefer a
  hosted LM). Ollama is always a valid free fallback.

## When to update a submodule

```bash
cd research-swarm
git checkout main
git pull
cd ..
git add research-swarm
git commit -m "bump research-swarm to <new SHA>"
git push
```

Same shape for any other submodule. The kit pins a specific SHA so
workshop attendees get a reproducible stack; bumps are explicit.
