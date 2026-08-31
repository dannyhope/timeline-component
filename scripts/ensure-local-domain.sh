#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOMAIN="$(tr -d '[:space:]' < "$ROOT/.local-domain")"
MARKER="# timeline-component.local"
ENTRY="127.0.0.1 $DOMAIN $MARKER"

if ! grep -Fq "$MARKER" /etc/hosts || ! grep -Fq "127.0.0.1 $DOMAIN" /etc/hosts; then
  /usr/bin/sudo /usr/bin/python3 -c 'from pathlib import Path
path = Path("/etc/hosts")
marker = "# timeline-component.local"
lines = [line for line in path.read_text().splitlines() if marker not in line]
lines.append("'"$ENTRY"'")
path.write_text("\n".join(lines) + "\n")' 
fi
