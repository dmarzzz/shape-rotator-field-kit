# Tool Exchange

A shared directory of tools the [shape rotator program](https://shaperotator.xyz)
cohort is bringing, using, and dogfooding together during the month.

The field kit at the root of this repo ships a core set of tools
(research-swarm, voxterm, content-pipeline). That set is small on
purpose. **Tool Exchange** is where everything else the cohort wants
to share lives: half-built experiments, scripts, TUIs, MCP servers,
harnesses, agents, anything that helps someone else get work done.

## How to submit a tool

1. Fork this repo.
2. Copy [`TEMPLATE.md`](./TEMPLATE.md) to `submissions/<your-tool-slug>.md`.
3. Fill it in. Be concrete: what the tool does, how to run it, who it's
   for, what platforms it works on, where the code lives.
4. Open a PR with title `tool-exchange: add <your-tool>`.

Submissions are lightly reviewed by dmarz (checking for completeness
and safety, not taste) and merged. If a tool ends up being broadly
useful to the cohort, it may be promoted to a full submodule in the
main field kit.

## Submissions

Everything under [`submissions/`](./submissions/) is a listed tool.
See the individual files. Three of ours are there as examples of the
shape:

- [`submissions/research-swarm.md`](./submissions/research-swarm.md)
- [`submissions/voxterm.md`](./submissions/voxterm.md)
- [`submissions/content-pipeline.md`](./submissions/content-pipeline.md)

## Scope

Appropriate: dev tools, research tools, editor extensions, CLI
utilities, TUIs, MCP servers, agent harnesses, prompt libraries,
voice/vision/TEE experiments, local-first infra, anything that
moves work along during the program.

Out of scope here: SaaS products that require someone else's paid
account to try, closed-source binaries without source, anything
that a cohort member couldn't clone and run on their laptop.
Host those somewhere else; link from the submission if you'd like
to reference them.
