#!/usr/bin/env bash
# Download MDN Intl docs (markdown) and ECMA-402 spec (HTML) to docs/reference/.
# Requires: curl, jq (for discovering MDN paths).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS_ROOT="$PROJECT_ROOT/docs/reference"
MDN_BASE="https://raw.githubusercontent.com/mdn/content/main/files/en-us/web/javascript/reference/global_objects"
INTL_BASE="$MDN_BASE/intl"
SPEC_URL="https://tc39.es/ecma402/"

mkdir -p "$DOCS_ROOT/ecma402"
mkdir -p "$DOCS_ROOT/mdn"

# Download ECMA-402 spec (single HTML page)
echo "Downloading ECMA-402 spec..."
curl -sfL -o "$DOCS_ROOT/ecma402/spec.html" "$SPEC_URL" || echo "Warning: could not download spec from $SPEC_URL"

# Recursively discover and download all index.md under a given API path.
# Usage: download_mdn_recursive <api_path> <local_dir>
# e.g. download_mdn_recursive "intl" "mdn"
download_mdn_recursive() {
  local api_path="$1"
  local local_dir="$2"
  local full_url="https://api.github.com/repos/mdn/content/contents/files/en-us/web/javascript/reference/global_objects/${api_path}?ref=main"
  local entries
  entries=$(curl -sfL "$full_url" 2>/dev/null) || return 0

  # Download index.md if present
  local index_path
  index_path=$(echo "$entries" | jq -r '.[] | select(.name == "index.md") | .path' 2>/dev/null)
  if [[ -n "$index_path" && "$index_path" != "null" ]]; then
    local rel_path="${index_path#files/en-us/web/javascript/reference/global_objects/}"
    local out_file="$DOCS_ROOT/$local_dir/$rel_path"
    mkdir -p "$(dirname "$out_file")"
    echo "  $rel_path"
    curl -sfL -o "$out_file" "https://raw.githubusercontent.com/mdn/content/main/$index_path" || true
  fi

  # Recurse into subdirs
  local subdirs
  subdirs=$(echo "$entries" | jq -r '.[] | select(.type == "dir") | .name' 2>/dev/null)
  while IFS= read -r subdir; do
    [[ -z "$subdir" || "$subdir" == "null" ]] && continue
    download_mdn_recursive "${api_path}/${subdir}" "$local_dir"
  done <<< "$subdirs"
}

echo "Downloading MDN Intl docs..."
download_mdn_recursive "intl" "mdn"

# Locale-sensitive builtins: String, Number, Date, Array
echo "Downloading MDN locale-sensitive builtin docs..."
for builtin in string number date array; do
  case "$builtin" in
    string)
      for method in localecompare tolocalelowercase tolocaleuppercase; do
        out="$DOCS_ROOT/mdn/$builtin/$method/index.md"
        mkdir -p "$(dirname "$out")"
        url="$MDN_BASE/../$builtin/$method/index.md"
        url="https://raw.githubusercontent.com/mdn/content/main/files/en-us/web/javascript/reference/global_objects/$builtin/$method/index.md"
        echo "  $builtin/$method"
        curl -sfL -o "$out" "$url" || true
      done
      ;;
    number)
      mkdir -p "$DOCS_ROOT/mdn/number/tolocalestring"
      echo "  number/tolocalestring"
      curl -sfL -o "$DOCS_ROOT/mdn/number/tolocalestring/index.md" \
        "https://raw.githubusercontent.com/mdn/content/main/files/en-us/web/javascript/reference/global_objects/number/tolocalestring/index.md" || true
      ;;
    date)
      for method in tolocalestring tolocaledatestring tolocaletimestring; do
        mkdir -p "$DOCS_ROOT/mdn/date/$method"
        echo "  date/$method"
        curl -sfL -o "$DOCS_ROOT/mdn/date/$method/index.md" \
          "https://raw.githubusercontent.com/mdn/content/main/files/en-us/web/javascript/reference/global_objects/date/$method/index.md" || true
      done
      ;;
    array)
      mkdir -p "$DOCS_ROOT/mdn/array/tolocalestring"
      echo "  array/tolocalestring"
      curl -sfL -o "$DOCS_ROOT/mdn/array/tolocalestring/index.md" \
        "https://raw.githubusercontent.com/mdn/content/main/files/en-us/web/javascript/reference/global_objects/array/tolocalestring/index.md" || true
      ;;
  esac
done

echo "Done. Docs are in $DOCS_ROOT"
