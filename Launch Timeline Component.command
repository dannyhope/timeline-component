#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

if ! command -v python3 >/dev/null 2>&1; then
  printf 'Python 3 is required to launch the project.\n' >&2
  exit 1
fi

PORT="$(./scripts/resolve-dev-port.sh)"
URL="http://127.0.0.1:${PORT}/timeline.html"

python3 -m http.server "$PORT" --bind 127.0.0.1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT INT TERM

open "$URL"
printf 'Timeline component is running at %s\n' "$URL"
wait "$SERVER_PID"
