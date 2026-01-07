# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

```markdown
## [Unreleased] - YYYY-MM-DD

### Added
### Changed
### Deprecated
### Fixed
### Security
```

## [Unreleased] - YYYY-MM-DD

### Added
- Created tests for the makefile work directory variables.
- Added development mode flag `--bowerbird-dev-mode` to preserve .git directories in cloned
  dependencies for local development and modifications.
- Added new tests `test-dev-mode-shallow-clone` and `test-dev-mode-full-clone` to verify
  development mode functionality.
- Added `-u` flag to `.SHELLFLAGS` for undefined variable detection in shell commands.
- Added fallback to "unknown" for VERSION when git command fails.
- Added documentation comment explaining _PATH variable in bowerbird.mk.
- Added include guard to prevent "overriding commands for target" warnings when
  bowerbird-deps.mk is included multiple times.
- Added parameter validation to `bowerbird::git-dependency` macro with clear error messages
  for missing required parameters.
- Added network timeout configuration to git clone (lowSpeedLimit=1000, lowSpeedTime=60)
  to prevent indefinite hangs on network issues.
- Added comprehensive documentation for development mode in README with usage examples.
- Added command-line override support for all dependency parameters via `<name>.<param>=<value>`
  syntax, allowing runtime customization without modifying makefiles.
- Added `test-override.mk` with 12 comprehensive test cases covering override functionality,
  error handling, and edge cases.
- Added Google-style docstring format to all macros, targets, and tests for improved
  documentation consistency.
- Added flexible keyword argument parser supporting both compact and spaced syntax.

### Changed
- Updated the usage of bowerbird::git-dependency to no longer need the pattern
  `$(eval $(call ... ))` and can instead simply use `$(call ...)`.
- Updated comment header in make/deps.mk from "Constants" to "Error Checking" for clarity.
- Updated all test documentation to use appropriate "Raises:" sections for error tests instead
  of "Returns:" or "Verifies:".
- Updated README with comprehensive documentation of new keyword syntax, command-line overrides,
  and usage examples.
- `bowerbird::git-dependency` now requires keyword arguments instead of positional
  arguments. Old syntax: `$(call bowerbird::git-dependency,path,url,version,entry)`.
  New syntax: `$(call bowerbird::git-dependency, name=<name>, path=<path>, url=<url>,
  branch=<branch>, entry=<entry>)`.
- Added required `name` parameter for command-line override support. This parameter
  identifies the dependency for runtime overrides.
- Replaced `version` parameter with mutually exclusive `branch` and `revision`
  parameters for clearer intent. Use `branch=<tag-or-branch>` for branches/tags, or
  `revision=<sha>` for specific commits.
- Dependencies must specify exactly one of `branch` or `revision` (not both,
  not neither). This ensures explicit version specification.

### Deprecated
### Fixed
- Wrapped the git-dependency command in an `ifdef` to avoid undefined variable warning
  during recursive make.
- Restored the print directory flag to assist with debug.
- Restored verbosity to the git-dependency clone command to to assist with debug.
- Fixed minor typos in the macro descriptions.
- Improved the testing to make sure that expected files are generated from the commands
  and not just old files from previous runs.
- Fixed typo in bowerbird::deps::define-dependency-constants comment: "vesion" → "version".
- Standardized all error messages to use stderr (>&2) consistently.
- Fixed error message formatting to remove extra newlines and inconsistent output.
- Fixed keyword argument parser to handle flexible spacing (both compact and spaced syntax).
- Fixed undefined variable warnings in parser by using conditional concatenation.

### Security
- Added comprehensive safety checks to private_clean target to prevent accidental deletion
  of critical directories (root, HOME, or paths outside project directory).
- Added inline validation for all paths before rm -rf operations with clear error messages.
- Enhanced path safety with project directory containment checks.


## [0.3.0] - 2024-06-07

### Added
- Updated make flags to include warnings for undefined variables.
- Added documentation strings for the `bowerbird::git-dependency` macro.
### Changed
- The first argument of the `bowerbird::git-dependency` macro changed from an ID to the
  installation path.
- Updated the internal test comparison calls to the new `compare-strings`.
- The clean target now
### Fixed
- Fixed variables references in macros that cause undefined variable errors in repos
  that use bowerbird-test.
- Fixed missing arguments in `bowerbird::deps::define-dependency-constants` tests that
  were causing undefined variable errors.
- Created an additional test for checking whether git history is deleted after a
  successful shallow clone of the dependency repo.
- Created an additional test for checking whether an error is raised when attempting to
  install a dependency into a previously used path.


## [0.2.0] - 2024-06-03

### Changed
- Corrected the usage code snipped to work after direct copy and paste and to generate
  errors if the download fails.
- Added additional checks to the path variables before deleting the `.git` directory
  from the cloned dependency repos.
- Changed the names of the internally used dependency constants.
- Updated the tests to use the bowerbird test runner.
- Added an error message when dependency cannot be cloned.
- Updated the SHA in the readme usage example.


## [0.1.0] - 2024-05-31

### Added
- Created a README with usage example.
- Migrated the bash build recipes to a separate repo.
