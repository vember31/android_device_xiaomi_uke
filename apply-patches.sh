#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOP="${1:-$(git rev-parse --show-toplevel 2>/dev/null)}"
PATCHES_DIR="$SCRIPT_DIR/patches"
APPLIED_MARKER="$SCRIPT_DIR/.patches-applied"

if [ -z "$TOP" ]; then
    echo "Error: could not determine TOP (Android root directory)" >&2
    exit 1
fi

if [ -f "$APPLIED_MARKER" ]; then
    echo "Patches already applied. Remove $APPLIED_MARKER to reapply."
    exit 0
fi

echo "Applying patches from $PATCHES_DIR..."

# Apply .patch files
find "$PATCHES_DIR" -name "*.patch" | sort | while read -r patchfile; do
    rel=${patchfile#"$PATCHES_DIR/"}
    target=$(dirname "$rel")
    echo "  Patching $target ..."
    (cd "$TOP/$target" && git apply --whitespace=nowarn "$patchfile") || {
        echo "  ERROR: failed to apply patch to $target" >&2
        exit 1
    }
done

# Extract .tar.gz files (for new files that can't be represented as patches)
find "$PATCHES_DIR" -name "*.tar.gz" | sort | while read -r tarfile; do
    rel=${tarfile#"$PATCHES_DIR/"}
    target=$(dirname "$rel")
    echo "  Extracting new files to $target ..."
    tar xzf "$tarfile" -C "$TOP/$target/"
done

touch "$APPLIED_MARKER"
echo "All patches applied successfully."
