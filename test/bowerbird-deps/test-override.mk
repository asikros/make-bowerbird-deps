# Test for command-line override functionality
#
#	This file contains tests to verify command-line override behavior for git dependencies.
#	Tests cover branch, revision, url, path, and entry overrides.
#

# test-override-branch
#
#	Tests command-line override of branch parameter.
#	Verifies that <name>.branch=<value> overrides the default branch.
#
#	Raises:
#		ERROR: If override is not applied or clone fails.
#
test-override-branch:
	@echo "Running test-override-branch"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_OVERRIDE_BRANCH=true test-repo.branch=v0.1.0
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git

ifdef TEST_OVERRIDE_BRANCH
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-branch/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-revision
#
#	Tests command-line override to use a specific revision instead of branch.
#	Verifies that <name>.revision=<sha> overrides branch with specific commit.
#
#	Raises:
#		ERROR: If override is not applied or clone fails.
#
test-override-revision:
	@echo "Running test-override-revision"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_OVERRIDE_REVISION=true test-repo.revision=8e3c8a1
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git

ifdef TEST_OVERRIDE_REVISION
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-revision/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-url
#
#	Tests command-line override of repository URL.
#	Verifies that <name>.url=<value> overrides the default repository URL.
#
#	Raises:
#		ERROR: If override is not applied or clone fails.
#
test-override-url:
	@echo "Running test-override-url"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_OVERRIDE_URL=true test-repo.url=https://github.com/ic-designer/make-bowerbird-help.git
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git

ifdef TEST_OVERRIDE_URL
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-url/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-path
#
#	Tests command-line override of installation path.
#	Verifies that <name>.path=<value> overrides the default installation path.
#
#	Raises:
#		ERROR: If override is not applied or clone fails.
#
test-override-path:
	@echo "Running test-override-path"
	test ! -d $(WORKDIR_TEST)/$@/deps/alt-path || rm -rf $(WORKDIR_TEST)/$@/deps/alt-path
	test ! -d $(WORKDIR_TEST)/$@/deps/alt-path
	$(MAKE) FORCE TEST_OVERRIDE_PATH=true test-repo.path=$(WORKDIR_TEST)/test-override-path/deps/alt-path
	test -d $(WORKDIR_TEST)/$@/deps/alt-path
	! test -d $(WORKDIR_TEST)/$@/deps/alt-path/.git

ifdef TEST_OVERRIDE_PATH
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-path/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-entry
#
#	Tests command-line override of entry point file.
#	Verifies that <name>.entry=<value> overrides the default entry point.
#
#	Raises:
#		ERROR: If override is not applied or entry point not found.
#
test-override-entry:
	@echo "Running test-override-entry"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_OVERRIDE_ENTRY=true test-repo.entry=README.md
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	test -f $(WORKDIR_TEST)/$@/deps/test-repo/README.md

ifdef TEST_OVERRIDE_ENTRY
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-entry/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-multiple
#
#	Tests multiple simultaneous overrides.
#	Verifies that multiple parameters can be overridden at once.
#
#	Raises:
#		ERROR: If any override is not applied.
#
test-override-multiple:
	@echo "Running test-override-multiple"
	test ! -d $(WORKDIR_TEST)/$@/deps/alt-path || rm -rf $(WORKDIR_TEST)/$@/deps/alt-path
	test ! -d $(WORKDIR_TEST)/$@/deps/alt-path
	$(MAKE) FORCE TEST_OVERRIDE_MULTIPLE=true \
		test-repo.path=$(WORKDIR_TEST)/test-override-multiple/deps/alt-path \
		test-repo.branch=v0.1.0 \
		test-repo.entry=README.md
	test -d $(WORKDIR_TEST)/$@/deps/alt-path
	test -f $(WORKDIR_TEST)/$@/deps/alt-path/README.md

ifdef TEST_OVERRIDE_MULTIPLE
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-multiple/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-branch-with-dev-mode
#
#	Tests branch override combined with --bowerbird-dev-mode flag.
#	Verifies override works in development mode with full clone.
#
#	Raises:
#		ERROR: If override is not applied or .git not preserved.
#
test-override-branch-with-dev-mode:
	@echo "Running test-override-branch-with-dev-mode"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_OVERRIDE_BRANCH_DEV=true test-repo.branch=v0.1.0 -- --bowerbird-dev-mode
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git

ifdef TEST_OVERRIDE_BRANCH_DEV
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-branch-with-dev-mode/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-no-override
#
#	Tests that defaults are used when no override is provided.
#	Verifies normal behavior without any command-line overrides.
#
#	Raises:
#		ERROR: If clone fails with default parameters.
#
test-override-no-override:
	@echo "Running test-override-no-override"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_OVERRIDE_NONE=true
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git

ifdef TEST_OVERRIDE_NONE
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-no-override/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-invalid-branch
#
#	Tests error handling when invalid branch is provided via override.
#	Verifies that git clone fails gracefully with clear error message.
#
#	Raises:
#		ERROR: Failed to clone dependency (expected).
#
test-override-invalid-branch:
	@echo "Running test-override-invalid-branch"
	! $(MAKE) FORCE TEST_OVERRIDE_BAD_BRANCH=true test-repo.branch=nonexistent-branch-xyz
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo

ifdef TEST_OVERRIDE_BAD_BRANCH
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-invalid-branch/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-invalid-url
#
#	Tests error handling when invalid URL is provided via override.
#	Verifies that git clone fails gracefully with clear error message.
#
#	Raises:
#		ERROR: Failed to clone dependency (expected).
#
test-override-invalid-url:
	@echo "Running test-override-invalid-url"
	! $(MAKE) FORCE TEST_OVERRIDE_BAD_URL=true test-repo.url=https://invalid.url/nonexistent.git
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo

ifdef TEST_OVERRIDE_BAD_URL
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-invalid-url/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-invalid-entry
#
#	Tests error handling when invalid entry point is provided via override.
#	Verifies that missing entry file causes proper error and cleanup.
#
#	Raises:
#		ERROR: Expected entry point not found (expected).
#
test-override-invalid-entry:
	@echo "Running test-override-invalid-entry"
	! $(MAKE) FORCE TEST_OVERRIDE_BAD_ENTRY=true test-repo.entry=nonexistent.mk
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo

ifdef TEST_OVERRIDE_BAD_ENTRY
    $(call bowerbird::git-dependency, \
		name=test-repo, \
		path=$(WORKDIR_TEST)/test-override-invalid-entry/deps/test-repo, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

# test-override-mixed-repos
#
#	Tests that overrides apply to specific dependencies only.
#	Verifies that one dependency's override doesn't affect another.
#
#	Raises:
#		ERROR: If overrides are incorrectly applied.
#
test-override-mixed-repos:
	@echo "Running test-override-mixed-repos"
	test ! -d $(WORKDIR_TEST)/$@/deps/repo1 || rm -rf $(WORKDIR_TEST)/$@/deps/repo1
	test ! -d $(WORKDIR_TEST)/$@/deps/repo2 || rm -rf $(WORKDIR_TEST)/$@/deps/repo2
	$(MAKE) FORCE TEST_OVERRIDE_MIXED=true repo1.branch=v0.1.0
	test -d $(WORKDIR_TEST)/$@/deps/repo1
	test -d $(WORKDIR_TEST)/$@/deps/repo2

ifdef TEST_OVERRIDE_MIXED
    $(call bowerbird::git-dependency, \
		name=repo1, \
		path=$(WORKDIR_TEST)/test-override-mixed-repos/deps/repo1, \
		url=https://github.com/ic-designer/make-bowerbird-deps.git, \
		branch=main, \
		entry=bowerbird.mk)
    $(call bowerbird::git-dependency, \
		name=repo2, \
		path=$(WORKDIR_TEST)/test-override-mixed-repos/deps/repo2, \
		url=https://github.com/ic-designer/make-bowerbird-help.git, \
		branch=main, \
		entry=bowerbird.mk)
endif

.PHONY: FORCE
FORCE:
	@:
