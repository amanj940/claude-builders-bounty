# Claude Builders Bounty

This repository contains utilities for Claude Builders bounty challenges.

## Generate a Structured CHANGELOG

A simple Bash script (`changelog.sh`) is provided to automatically generate a structured `CHANGELOG.md` from your project's Git history.

### How to use

1. **Ensure your repository has at least one Git tag** (e.g., `v1.0.0`). The script will generate the changelog for commits since the latest tag.
2. **Run the script**:
   ```bash
   bash changelog.sh
   ```
3. **Commit the generated `CHANGELOG.md`** to your repository.

The script categorises commits into the following sections based on their commit message prefixes:
- `Added` – messages starting with `feat:`, `add:`, `Feature:`, etc.
- `Fixed` – messages starting with `fix:`, `bug:`, etc.
- `Changed` – messages starting with `refactor:`, `change:`, `chore:`, etc.
- `Removed` – messages starting with `remove:`, `del:`, `Delete:`, etc.

Any commit that does not match a specific prefix falls under `Changed` by default.

### Example output

```markdown
## [Unreleased]

### Added
- feat: support for new API endpoint

### Fixed
- fix: resolve crash on startup

### Changed
- refactor: improve logging mechanism

### Removed
- remove: deprecated configuration flag
```

Feel free to customise the script to match your project's commit conventions.
