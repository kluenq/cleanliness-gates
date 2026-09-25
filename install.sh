#!/usr/bin/env bash
# Install the cleanliness gates into a project.
# Usage: ./install.sh /path/to/project
set -euo pipefail

proj="${1:-}"
if [ -z "$proj" ]; then
  echo "Usage: $0 /path/to/project" >&2
  exit 2
fi
if [ ! -d "$proj" ]; then
  echo "Not a directory: $proj" >&2
  exit 2
fi

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="$proj/.claude/skills"

if ! command -v python3 >/dev/null 2>&1 && ! command -v py >/dev/null 2>&1; then
  echo "Warning: no python3 or py found on PATH. The clean-user-facing-text scripts need Python 3." >&2
fi

mkdir -p "$dest"
rm -rf "$dest/humanizer" "$dest/clean-user-facing-text"
cp -R "$here/skills/humanizer" "$dest/humanizer"
cp -R "$here/skills/clean-user-facing-text" "$dest/clean-user-facing-text"
find "$dest/clean-user-facing-text" -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true

echo "Installed skills to $dest"
echo
echo "Next: paste templates/CLAUDE-gates-snippet.md into $proj/CLAUDE.md"
echo "and change the folder names in the 'destined for' line to match your project."
if [ -f "$proj/CLAUDE.md" ]; then
  echo "(A CLAUDE.md already exists there; append the snippet to it.)"
else
  echo "(No CLAUDE.md found there yet; create one at the project root.)"
fi
