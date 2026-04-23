# VoxTerm

> Local real-time voice transcription TUI with speaker diarization and P2P collaborative transcription. Fully offline.

## What it is

Captures mic audio locally, transcribes in real time with speaker
diarization, writes a timestamped markdown transcript to
`~/Documents/voxterm-transcripts/`. No audio is stored on disk. Voice
profiles (biometric embeddings used to recognize speakers across
sessions) are encrypted with AES-256-CBC; the key lives in the macOS
Keychain, zero config. Party mode shares the live transcript stream
across devices on the local network; nothing goes to a relay.

## Who it's for

People who want a real transcript of a meeting, conversation, or solo
talk-out without sending audio to a cloud service. Anyone recording
research discussions and wanting the transcript to feed into a
downstream pipeline (see content-pipeline submission below).

## Install

One-liner recommended:

```bash
curl -fsSL https://raw.githubusercontent.com/dmarzzz/VoxTerm/main/install.sh | bash
```

Or via the field kit:

```bash
bash setup.sh     # includes voxterm install
rotate vox
```

## Run

```bash
voxterm
```

TUI opens. `P` for party / LAN P2P mode. `H` for hive-mind aggregate.
Hotkey reference is in the app and in the repo README.

## Platforms

- macOS (Apple Silicon M1+): yes (primary target)
- macOS (Intel): no (models are Apple-Silicon-optimized)
- Linux: no
- Windows: no

## Dependencies

macOS Apple Silicon + Python 3.9+. Transcription models download on
first use.

## Links

- **Repo:** https://github.com/dmarzzz/VoxTerm

## Author

- **Name / handle:** @dmarzzz
- **Contact:** GitHub

## License

MIT

## Status

v0.1.0 tagged, actively used. Diarization is the roughest edge; a
beefed-up version is on the near-term roadmap.

## Tags

`voice`, `tui`, `p2p`, `privacy`, `local-first`

## Notes

The "nothing stored, nothing uploaded" policy is load-bearing. If you
want recordings you keep, this is not the right tool; this produces
transcripts only. Press `P` → delete any time to wipe all voice-profile
data from disk.
