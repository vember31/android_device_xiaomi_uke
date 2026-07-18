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

apply_patch() {
    local patchfile="$1"
    local rel="${patchfile#$PATCHES_DIR/}"
    local target="$(dirname "$rel")"
    echo "  Patching $target ($(basename "$patchfile")) ..."
    if (cd "$TOP/$target" && git apply --check --reverse "$patchfile" 2>/dev/null); then
        echo "    -> already applied, skipping"
    else
        (cd "$TOP/$target" && git apply --whitespace=nowarn "$patchfile") || {
            echo "  ERROR: failed to apply patch to $target" >&2
            return 1
        }
        echo "    -> applied"
    fi
}

failed=0
while IFS= read -r patchfile; do
    apply_patch "$patchfile" || failed=1
done < <(find "$PATCHES_DIR" -name "*.patch" | sort)

if [ "$failed" -eq 1 ]; then
    echo "One or more patches failed to apply." >&2
    exit 1
fi

# Extract .tar.gz files (for new files that cant be represented as patches)
while IFS= read -r tarfile; do
    rel="${tarfile#$PATCHES_DIR/}"
    target="$(dirname "$rel")"
    echo "  Extracting new files to $target ..."
    tar xzf "$tarfile" -C "$TOP/$target/"
done < <(find "$PATCHES_DIR" -name "*.tar.gz" | sort)

touch "$APPLIED_MARKER"
echo "All patches applied successfully."
