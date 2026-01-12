# Bowerbird Dependency Tools

[![Makefile CI](https://github.com/ic-designer/make-bowerbird-deps/actions/workflows/makefile.yml/badge.svg)](https://github.com/ic-designer/make-bowerbird-deps/actions/workflows/makefile.yml)


## Usage

The Bowerbird Dependency Tools provide a simple, declarative way to manage external
Make dependencies. Dependencies are automatically cloned from git repositories and
included in your project.

### Basic Example

```makefile
# Required Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Load Bowerbird Dependency Tools
BOWERBIRD_DEPS.MK := $(WORKDIR_DEPS)/BOWERBIRD_DEPS/bowerbird_deps.mk
$(BOWERBIRD_DEPS.MK):
	@curl --silent --show-error --fail --create-dirs -o $@ -L \
https://raw.githubusercontent.com/ic-designer/make-bowerbird-deps/main/src/bowerbird-deps/bowerbird-deps.mk
include $(BOWERBIRD_DEPS.MK)

# Declare Dependencies
$(call bowerbird::git-dependency, \
    name=bowerbird-help, \
    path=$(WORKDIR_DEPS)/bowerbird-help, \
    url=https://github.com/ic-designer/make-bowerbird-help.git, \
    branch=main, \
    entry=bowerbird.mk)
```

## Development Mode

For local development of dependencies, use the `--bowerbird-dev-mode` flag to preserve
full git history and enable local modifications:

```bash
make -- --bowerbird-dev-mode <target>
```

**Normal Mode (default):**
- Performs shallow clone (`--depth 1`)
- Removes `.git` directories after cloning
- Faster, smaller downloads
- Prevents accidental commits to dependencies

**Development Mode:**
- Performs full clone with complete git history
- Preserves `.git` directories
- Allows local modifications and commits
- Useful for developing and testing dependency changes

### Examples

```bash
# Normal mode - shallow clone, no .git
make check

# Development mode - full clone, keep .git
make -- --bowerbird-dev-mode check
```

## Command-Line Overrides

Override dependency parameters at runtime without modifying makefiles:

```bash
# Override branch/tag
make check bowerbird-help.branch=feature-branch

# Override to specific commit
make check bowerbird-help.revision=abc123def456

# Override repository URL (for forks or mirrors)
make check bowerbird-help.url=https://github.com/user/fork.git

# Override installation path
make check bowerbird-help.path=/tmp/custom-path

# Override entry point
make check bowerbird-help.entry=alternate.mk

# Multiple overrides
make check bowerbird-help.branch=v2.0 bowerbird-help.url=https://github.com/user/fork.git
```

**Available Overrides:**
- `<name>.branch=<value>` - Override branch or tag
- `<name>.revision=<value>` - Override to specific commit SHA
- `<name>.url=<value>` - Override repository URL
- `<name>.path=<value>` - Override installation path
- `<name>.entry=<value>` - Override entry point file

**Note:** `<name>` must match the `name=` parameter in your `bowerbird::git-dependency` call.

## Macros

### `bowerbird::git-dependency`

Installs a git dependency and includes it for immediate use. By default, performs a
shallow clone and removes git history to prevent accidental changes. In development
mode, performs a full clone and preserves `.git` directories.

**Syntax:**

```makefile
$(call bowerbird::git-dependency, \
    name=<name>, \
    path=<path>, \
    url=<url>, \
    branch=<branch>, \
    entry=<entry>)

# OR with revision instead of branch

$(call bowerbird::git-dependency, \
    name=<name>, \
    path=<path>, \
    url=<url>, \
    revision=<sha>, \
    entry=<entry>)
```

**Parameters:**

- `name` - Dependency identifier for command-line overrides (required)
- `path` - Installation path for the dependency (required)
- `url` - Git repository URL (required)
- `branch` - Branch or tag name (required unless `revision` is used)
- `revision` - Specific commit SHA (required unless `branch` is used)
- `entry` - Entry point file, relative to dependency root (required)

**Note:** Specify either `branch` OR `revision`, not both.

**Examples:**

```makefile
# Using branch
$(call bowerbird::git-dependency, \
    name=bowerbird-help, \
    path=$(WORKDIR_DEPS)/bowerbird-help, \
    url=https://github.com/ic-designer/make-bowerbird-help.git, \
    branch=main, \
    entry=bowerbird.mk)

# Using specific revision
$(call bowerbird::git-dependency, \
    name=bowerbird-test, \
    path=$(WORKDIR_DEPS)/bowerbird-test, \
    url=https://github.com/ic-designer/make-bowerbird-test.git, \
    revision=abc123def456, \
    entry=bowerbird.mk)

# Compact syntax (no spaces)
$(call bowerbird::git-dependency,name=dep,path=/tmp/dep,\
    url=https://github.com/user/repo.git,branch=main,entry=main.mk)
```

**Error Handling:**

- If required parameters are missing, exits with error
- If `branch` and `revision` are both specified, exits with error
- If neither `branch` nor `revision` is specified, exits with error
- If git clone fails, exits with error
- If entry point is not found, removes partial installation and exits with error
- If path already exists and is not empty, git clone fails with error
