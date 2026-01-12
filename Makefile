# Project
NAME := bowerbird-deps
VERSION := $(shell git describe --always --dirty --broken 2> /dev/null || echo "unknown")

# Targets
.PHONY: check
## Runs the repository tests
check: private_test

.PHONY: clean
## Deletes all files created by Make
clean: private_clean

.PHONY: test
## Runs the repository tests
test: private_test

# Includes
include make/private.mk
