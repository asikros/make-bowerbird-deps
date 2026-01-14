# Developer Guide

Quick reference for contributing to make-bowerbird-deps.

## Code Standards

Follow the project's coding conventions:
- **[Make Style Guide](https://github.com/asikros/make-bowerbird-docs/blob/main/docs/make-styleguide.md)** - Naming conventions, documentation patterns, and formatting rules for Makefiles

## Development Workflows

- **[Testing Workflow](https://github.com/asikros/make-bowerbird-docs/blob/main/docs/testing-workflow.md)** - How to test changes, debug failures, and ensure test coverage

## Key Principles

1. **Test everything**: Run `make clean && make check` after any modifications
2. **Root cause failures**: Fix underlying issues, don't hack tests or code to pass
3. **Simple, direct tests**: Test failures should clearly indicate what's broken
4. **Add missing coverage**: If a bug wasn't caught, add a test for it

## Quick Start

```bash
# Run all tests
make check

# Clean build artifacts and run tests
make clean && make check

# Run a specific test (example)
make test-override-mock-branch

# Run with dev mode to keep .git directories
make check -- --bowerbird-dev-mode
```

## Directory Structure

```
development/
├── DEVELOPMENT.md           # This file
└── proposals/               # Design proposals
    ├── INDEX.md            # Proposals index
    ├── draft/              # Proposals under active development
    ├── accepted/           # Accepted and implemented proposals
    └── rejected/           # Rejected proposals (with rationale)
```

For full details on proposal workflow, see the **[Proposal Lifecycle](https://github.com/asikros/make-bowerbird-docs/blob/main/docs/proposals.md)** guide in make-bowerbird-docs.
