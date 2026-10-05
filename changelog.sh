#!/usr/bin/env bash
set -e

# Determine the most recent tag. If none exists, use the beginning of history.
if git rev-parse --verify --quiet HEAD >/dev/null; then
  latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
else
  latest_tag=""
fi

if [ -z "$latest_tag" ]; then
  range="HEAD"
else
  range="${latest_tag}..HEAD"
fi

# Initialize category arrays
added=()
fixed=()
changed=()
removed=()

# Read commit messages in the range
while IFS= read -r line; do
  msg=$(echo "$line" | sed 's/^\s*//')
  case "$msg" in
    feat:*|add:*|Add:*|Feature:*|added:*|Add*)
      added+=("$msg")
      ;;
    fix:*|Fix:*|bug:*|Bug:*)
      fixed+=("$msg")
      ;;
    refactor:*|Refactor:*|change:*|Change:*|chore:*)
      changed+=("$msg")
      ;;
    remove:*|Remove:*|del:*|Delete:*)
      removed+=("$msg")
      ;;
    *)
      changed+=("$msg")
      ;;
  esac
done < <(git log $range --pretty=format:%s)

# Build the new changelog section
{
  echo "## [Unreleased]"
  echo ""
  if [ ${#added[@]} -gt 0 ]; then
    echo "### Added"
    for c in "${added[@]}"; do echo "- $c"; done
    echo ""
  fi
  if [ ${#fixed[@]} -gt 0 ]; then
    echo "### Fixed"
    for c in "${fixed[@]}"; do echo "- $c"; done
    echo ""
  fi
  if [ ${#changed[@]} -gt 0 ]; then
    echo "### Changed"
    for c in "${changed[@]}"; do echo "- $c"; done
    echo ""
  fi
  if [ ${#removed[@]} -gt 0 ]; then
    echo "### Removed"
    for c in "${removed[@]}"; do echo "- $c"; done
    echo ""
  fi
} > CHANGELOG.tmp

# Prepend the new section to existing CHANGELOG.md (if any)
if [ -f CHANGELOG.md ]; then
  cat CHANGELOG.tmp CHANGELOG.md > CHANGELOG.new
  mv CHANGELOG.new CHANGELOG.md
else
  mv CHANGELOG.tmp CHANGELOG.md
fi

echo "CHANGELOG.md generated successfully."
