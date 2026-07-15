#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMFYUI_DIR="$ROOT/comfyui"
cd "$COMFYUI_DIR/ComfyUI"

if [[ ! -d "$COMFYUI_DIR/.venv" ]]; then
  echo "Virtual environment not found. Run setup from $COMFYUI_DIR first."
  exit 1
fi

# shellcheck disable=SC1091
source "$COMFYUI_DIR/.venv/bin/activate"

if [[ -f "$COMFYUI_DIR/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$COMFYUI_DIR/.env"
  set +a
fi

export PORT="${PORT:-8188}"
export HOST="${HOST:-0.0.0.0}"

echo "ComfyUI: http://localhost:${PORT}"
echo "Models:  $COMFYUI_DIR/ComfyUI/models"
echo "Press Ctrl+C to stop."

exec python main.py --listen "$HOST" --port "$PORT"
