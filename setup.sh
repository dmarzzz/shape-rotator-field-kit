#!/usr/bin/env bash
# shape-rotator-field-kit installer
#
# Bootstraps every tool in the kit on a fresh machine. Idempotent — safe
# to re-run to pick up updates after bumping a submodule pin.
#
# Usage:
#   bash setup.sh
#   bash setup.sh --install-python
#
# What it does:
#   1. Pulls every git submodule to its pinned commit.
#   2. Runs voxterm's own installer (macOS Apple-Silicon only; skipped elsewhere).
#   3. Sets up research-swarm in an isolated Python 3.12 venv, including
#      the Codex backend dependencies.
#   4. Creates ./bin/research-agent as a thin wrapper around that venv.
#   5. Creates research-swarm/.env from .env.example if missing.
#   6. Prints a short "what to do next" cheat sheet.
#
# What it does NOT do:
#   - Touch your shell config. You decide whether to add ./bin to PATH.
#   - Overwrite an existing .env file.
#   - Install anything globally other than what voxterm itself installs.
#   - Install uv or Python unless you pass --install-python.

set -euo pipefail

# ── UI helpers ────────────────────────────────────────────────────────────

if [ -t 1 ]; then
  BOLD='\033[1m'; DIM='\033[2m'; CYAN='\033[36m'; GREEN='\033[32m'
  YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'
else
  BOLD=''; DIM=''; CYAN=''; GREEN=''; YELLOW=''; RED=''; RESET=''
fi

step()  { printf "${CYAN}▸${RESET} %s\n" "$*"; }
ok()    { printf "${GREEN}✓${RESET} %s\n" "$*"; }
warn()  { printf "${YELLOW}!${RESET} %s\n" "$*" >&2; }
fail()  { printf "${RED}✗${RESET} %s\n" "$*" >&2; exit 1; }
heading() { printf "\n${BOLD}%s${RESET}\n" "$*"; }

# ── Args ─────────────────────────────────────────────────────────────────

INSTALL_PYTHON=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --install-python)
      INSTALL_PYTHON=true
      ;;
    -h|--help)
      cat <<EOF
Usage:
  bash setup.sh [--install-python]

Options:
  --install-python   If python3.12 is missing, install uv if needed,
                     then install Python 3.12 with uv.
EOF
      exit 0
      ;;
    *)
      fail "unknown option: $1"
      ;;
  esac
  shift
done

# ── Locate self ───────────────────────────────────────────────────────────

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$KIT_ROOT"

heading "shape-rotator-field-kit setup"
echo "root: $KIT_ROOT"

# ── 1. Prerequisites ─────────────────────────────────────────────────────

step "checking prerequisites"

command -v git >/dev/null 2>&1 || fail "git not found — install git first"

# The whole kit standardizes on Python 3.12 because voxterm declares
# that floor today. macOS/Xcode may only expose /usr/bin/python3.9.
PYTHON=""
if command -v python3.12 >/dev/null 2>&1; then
  PYTHON="$(command -v python3.12)"
elif $INSTALL_PYTHON; then
  UV=""
  if command -v uv >/dev/null 2>&1; then
    UV="$(command -v uv)"
  elif [ -x "$HOME/.local/bin/uv" ]; then
    UV="$HOME/.local/bin/uv"
  else
    command -v curl >/dev/null 2>&1 || fail "python3.12 not found and curl is required to install uv"
    step "installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR="$HOME/.local/bin" UV_NO_MODIFY_PATH=1 sh
    if [ -x "$HOME/.local/bin/uv" ]; then
      UV="$HOME/.local/bin/uv"
    else
      fail "uv install completed, but uv was not found at $HOME/.local/bin/uv"
    fi
  fi

  step "installing Python 3.12 with uv"
  "$UV" python install 3.12
  PYTHON="$("$UV" python find 3.12 --managed-python)"
else
  fail "python3.12 required, none found.
Rerun with this flag to install uv if needed, then Python 3.12:
  bash setup.sh --install-python

Or install uv manually first:
  curl -LsSf https://astral.sh/uv/install.sh | sh"
fi

ok "python: $PYTHON ($("$PYTHON" --version))"
ok "git:    $(git --version)"

# ── 2. Submodules ────────────────────────────────────────────────────────

step "syncing submodules"
git submodule update --init --recursive --quiet
ok "submodules at their pinned commits"
git submodule status | sed 's/^/  /'

# ── 3. voxterm (macOS Apple Silicon only) ────────────────────────────────

heading "voxterm"

if [ "$(uname)" != "Darwin" ]; then
  warn "voxterm requires macOS (Apple Silicon). Skipping on $(uname)."
elif [ "$(uname -m)" != "arm64" ]; then
  warn "voxterm requires Apple Silicon (arm64). Skipping on $(uname -m)."
elif command -v voxterm >/dev/null 2>&1; then
  ok "voxterm already installed at $(command -v voxterm)"
else
  step "running voxterm installer"
  PYTHON_BIN_DIR="$(dirname "$PYTHON")"
  if [ -f voxterm/install.sh ]; then
    PATH="$PYTHON_BIN_DIR:$PATH" bash voxterm/install.sh
  else
    # Fallback to upstream installer if the submodule doesn't ship one
    curl -fsSL https://raw.githubusercontent.com/dmarzzz/VoxTerm/main/install.sh | PATH="$PYTHON_BIN_DIR:$PATH" bash
  fi
  ok "voxterm installed"
fi

# ── 4. research-swarm ────────────────────────────────────────────────────

heading "research-swarm"

SWARM_DIR="$KIT_ROOT/research-swarm"
VENV="$SWARM_DIR/.venv"

if [ ! -d "$VENV" ]; then
  step "creating venv at $VENV"
  "$PYTHON" -m venv "$VENV"
fi

step "installing research-swarm into its venv"
"$VENV/bin/pip" install --quiet --upgrade pip >/dev/null
"$VENV/bin/pip" install --quiet -e "$SWARM_DIR[codex]"
ok "research-swarm installed"

if [ ! -f "$SWARM_DIR/.env" ]; then
  if [ -f "$SWARM_DIR/.env.example" ]; then
    cp "$SWARM_DIR/.env.example" "$SWARM_DIR/.env"
    ok "created research-swarm/.env (RA_BACKEND=auto)"
    echo "  add LM_MODEL/key for DSPy, or leave unset for Codex app-server"
  fi
else
  ok "research-swarm/.env already exists — left alone for DSPy/custom config"
fi

# ── 5. Wrapper scripts ───────────────────────────────────────────────────

heading "wrappers"

mkdir -p "$KIT_ROOT/bin"

cat > "$KIT_ROOT/bin/research-agent" <<EOF
#!/usr/bin/env bash
# Auto-generated by shape-rotator-field-kit/setup.sh
cd "$SWARM_DIR"
exec "$VENV/bin/research-agent" "\$@"
EOF
chmod +x "$KIT_ROOT/bin/research-agent"
ok "bin/research-agent  → $VENV/bin/research-agent"

# ── 6. Cheat sheet ───────────────────────────────────────────────────────

heading "done · try these"

cat <<EOF

  ${BOLD}./kit research "..."${RESET}                 # auto backend
  ${BOLD}./kit research --backend dspy "..."${RESET}  # DSPy backend
  ${BOLD}./kit research --backend codex "..."${RESET} # Codex app-server backend
  ${BOLD}./kit vox${RESET}                            # voxterm voice transcription TUI
  ${BOLD}./kit doctor${RESET}                         # re-check everything is installed
  ${BOLD}./kit install-global${RESET}                 # make 'rotate' callable from anywhere (optional)

To call from any directory as \`rotate\` (and let roaming agents find
this kit via \$SHAPE_ROTATOR_KIT_PATH), run:

  ./kit install-global

${DIM}research-swarm/.env${RESET} contains ${DIM}RA_BACKEND=auto${RESET}. Auto uses DSPy when
${DIM}LM_MODEL${RESET} / keys are configured; otherwise it uses Codex when
${DIM}codex app-server${RESET} is available.
EOF

echo
ok "setup complete"
