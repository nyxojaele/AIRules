#!/usr/bin/env bash
#
# Checks that the paths: header of code-style.md lists every pattern
# from the paths: headers of the language rule files in code-style/.
# Each language file is the only place its patterns are written by hand;
# code-style.md carries the combined list so it loads for any code file.
#
# Also fails if a language rule file has no paths: patterns, because such a
# file would load in every session instead of only when matching code is used.
#
# Usage (from Git Bash on Windows, or any bash):
#   bash scripts/check-paths.sh          # check only; exits 1 if out of date
#   bash scripts/check-paths.sh --fix    # rewrite the code-style.md header
#
# Header format this script reads and writes:
#   ---
#   paths:
#     - "**/*.cs"
#   ---

set -euo pipefail
export LC_ALL=C

cd "$(dirname "$0")/.."

combined="code-style.md"
lang_dir="code-style"

fix=0
case "${1:-}" in
    "") ;;
    --fix) fix=1 ;;
    *) echo "Usage: $0 [--fix]" >&2; exit 2 ;;
esac

# Report an error, as a GitHub annotation when running in Actions.
report_error() {
    local file="$1" message="$2"
    if [ -n "${GITHUB_ACTIONS:-}" ]; then
        echo "::error file=${file}::${message}"
    else
        echo "ERROR: ${file}: ${message}" >&2
    fi
}

# Print the paths: patterns from a file's frontmatter, one per line, unquoted.
read_paths() {
    awk '
        { sub(/\r$/, "") }
        NR == 1 { if ($0 != "---") exit; next }
        $0 == "---" { exit }
        /^paths:[[:space:]]*$/ { in_paths = 1; next }
        in_paths && /^[[:space:]]+-[[:space:]]/ {
            p = $0
            sub(/^[[:space:]]+-[[:space:]]+/, "", p)
            sub(/[[:space:]]+$/, "", p)
            if (p ~ /^".*"$/) p = substr(p, 2, length(p) - 2)
            print p
            next
        }
        /^[^[:space:]]/ { in_paths = 0 }
    ' "$1"
}

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
expected="$tmp_dir/expected"
actual="$tmp_dir/actual"
: > "$expected"

failed=0

# Collect patterns from every language file, in sorted file order.
lang_files="$(find "$lang_dir" -type f -name '*.md' | sort)"
if [ -z "$lang_files" ]; then
    report_error "$lang_dir" "No language rule files found."
    exit 1
fi

while IFS= read -r f; do
    patterns="$(read_paths "$f")"
    if [ -z "$patterns" ]; then
        report_error "$f" "No paths: patterns in the frontmatter; this rule would load in every session."
        failed=1
        continue
    fi
    printf '%s\n' "$patterns" >> "$expected"
done <<< "$lang_files"

# Remove duplicates, keeping first-seen order.
awk '!seen[$0]++' "$expected" > "$expected.dedup"
mv "$expected.dedup" "$expected"

if [ "$fix" -eq 1 ]; then
    if [ "$failed" -ne 0 ]; then
        echo "Fix the errors above first; $combined was not changed." >&2
        exit 1
    fi

    # Rewrite the header, keeping the body and the file's line endings.
    awk -v listfile="$expected" '
        NR == 1 {
            eol = ($0 ~ /\r$/) ? "\r" : ""
            print "---" eol
            print "paths:" eol
            while ((getline p < listfile) > 0) print "  - \"" p "\"" eol
            print "---" eol
            line = $0; sub(/\r$/, "", line)
            if (line == "---") { in_header = 1; next }
            print
            next
        }
        in_header {
            line = $0; sub(/\r$/, "", line)
            if (line == "---") in_header = 0
            next
        }
        { print }
    ' "$combined" > "$tmp_dir/combined"
    cat "$tmp_dir/combined" > "$combined"
    echo "Updated the paths: header of $combined."
    exit 0
fi

read_paths "$combined" > "$actual"

if ! cmp -s "$expected" "$actual"; then
    report_error "$combined" "The paths: header doesn't match the combined patterns of $lang_dir/*.md. Run: bash scripts/check-paths.sh --fix"
    echo "Differences (< expected, > current):" >&2
    diff "$expected" "$actual" >&2 || true
    failed=1
fi

if [ "$failed" -ne 0 ]; then
    exit 1
fi

echo "OK: $combined lists all $(wc -l < "$expected" | tr -d ' ') patterns from $lang_dir."
