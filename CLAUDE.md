# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make test       # Run integration tests (via tools/test.sh)
make install    # Install to /usr/local (customize with PREFIX=/path)
make uninstall  # Remove installed files
```

To run tests with a custom prefix:
```bash
make install PREFIX=/custom/path
```

## Architecture

**git-follow** is a Perl 5 Git subcommand that wraps `git log` to track the full lifetime history of a file across renames.

### Entry point

`git-follow` (root-level executable) — parses CLI options via `Getopt::Long`, validates the repository and pathspec, then delegates to `GitFollow::Log` to build and execute the `git log` command.

### Modules (`src/GitFollow/`)

| Module | Role |
|---|---|
| `Log.pm` | Core logic — assembles `git log` arguments from normalized options and executes the command |
| `Cli/OptionsNormalizer.pm` | Maps git-follow flags to their `git log` equivalents; resolves conflicts (e.g. `--no-renames` suppresses `--follow`) |
| `Config.pm` | Reads `follow.*` keys from `git config` (`follow.diff.mode`, `follow.log.format`, `follow.pager.disable`) |
| `Repository/ObjectUtils.pm` | Validates that the working directory is a git repo and that the pathspec exists in the given ref |
| `Environment.pm` | Resolves the git binary path (defaults to `/usr/bin/git`, overridable via `$GIT_PATH`) |
| `Metadata.pm` | Version string and usage text |
| `Stdlib/NumberUtils.pm` | `is_numeric` helper |
| `Blame.pm` | Stub/partial blame utilities (not yet wired into main flow) |

### Data flow

1. `git-follow` validates repo + pathspec via `ObjectUtils`
2. Raw CLI options are normalized by `OptionsNormalizer` into `git log` flags
3. `Log.pm` appends `--follow` (unless `--no-renames`), injects diff/format config from `Config.pm`, and execs `git log`

### Testing

`tools/test.sh` is a shell-based integration test runner. It temporarily patches the `use lib` path in the main script to point at the local `src/` directory, runs ~16 test cases covering option combinations, then restores the original path. Tests invoke the `git-follow` script directly and check exit codes / output.
