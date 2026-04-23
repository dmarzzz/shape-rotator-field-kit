# content-pipeline

> Turn any well-structured source into a blog post, a tweet thread, and a self-contained animated explainer video.

## What it is

A small, opinionated pipeline with three pluggable axes: input
adapters (research trace, voxterm transcript, plain markdown),
output formats (blog, tweet-thread, explainer-video), and
aesthetic (voice / visual style overlay). Every run creates a
reproducible snapshot so bumping the main pipeline tomorrow never
invalidates yesterday's outputs. Personal aesthetic overrides and
all runtime outputs are gitignored so nothing leaks to a PR.

## Who it's for

People who do research or talk through ideas and then want to
publish. Anyone tired of rewriting the same blog-plus-thread-plus-
visual workflow by hand for every piece. Cohort members who want
to plug their own voice profile into a reusable chassis rather
than build distribution tooling from scratch.

## Install

Via the field kit:

```bash
bash setup.sh
rotate content --trace path/to/trace.json
rotate content --transcript ~/Documents/voxterm-transcripts/x.md
rotate content --markdown notes.md
```

Standalone:

```bash
git clone https://github.com/dmarzzz/content-pipeline.git
cd content-pipeline
python3 run.py --trace path/to/trace.json
```

## Run

```bash
# any of:
python3 run.py --trace research_run.json
python3 run.py --transcript voxterm_transcript.md
python3 run.py --markdown notes.md

# pick formats:
python3 run.py --trace r.json --formats blog,tweet-thread
python3 run.py --trace r.json --formats all
```

Each run creates `output/<date>-<slug>/` with `source.md`, a frozen
`_pipeline-snapshot/`, and a `NEXT.md` that tells your coding agent
(Claude Code, Cursor, etc.) exactly which prompt to execute with
which paths.

## Platforms

- macOS: yes
- Linux: yes
- Windows: yes (Python 3.10+ is the only real requirement)

## Dependencies

Python 3.10+. No external Python packages at orchestration time.
The format prompts are LLM-executable; whichever agent runs them
needs an LM (see research-swarm for the LM story, or bring your own).

## Links

- **Repo:** https://github.com/dmarzzz/content-pipeline
- **Worked example:** `examples/neural-computers/` in the repo shows
  a full research-trace-to-publication run with committed goldens.

## Author

- **Name / handle:** @dmarzzz
- **Contact:** GitHub

## License

MIT

## Status

v0.1 just landed. The blog format is the most mature; tweet-thread
and explainer-video are first cuts and will evolve in the dogfooding
period during the program.

## Tags

`agent`, `cli`, `prompt-library`, `dev-tools`

## Notes

Aesthetic is explicitly pluggable. `aesthetic/default.yaml` is the
shipped baseline. Your personal voice file goes in
`aesthetic/<handle>.yaml` and is gitignored. This was intentional so
cohort members can iterate on their style in-repo without ever
leaking it.
