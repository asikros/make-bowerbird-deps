# test-git-dependency-bowerbird-deps-success
#
#	Tests successful git dependency cloning with branch parameter.
#	Verifies that dependency directory is created and .git directory is removed (shallow clone).
#
test-git-dependency-bowerbird-deps-success:
	test ! -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps || rm -rf $(WORKDIR_TEST)/$@/deps/bowerbird-deps
	test ! -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps
	$(MAKE) FORCE TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_SUCCESS=true
	test -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps
	! test -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps/.git

ifdef TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_SUCCESS
    $(call bowerbird::git-dependency, \
        name=test-bowerbird-deps-success, \
        path=$(WORKDIR_TEST)/test-git-dependency-bowerbird-deps-success/deps/bowerbird-deps, \
        url=https://github.com/ic-designer/make-bowerbird-deps.git, \
        branch=main, \
        entry=bowerbird.mk)
endif


# test-git-dependency-bowerbird-deps-bad-entry
#
#	Tests error handling when entry point is missing or empty.
#
#	Raises:
#		ERROR: 'entry' parameter is required (if empty).
#		ERROR: Expected entry point not found (if wrong path).
#		Partial installation is cleaned up.
#
test-git-dependency-bowerbird-deps-bad-entry:
	! $(MAKE) FORCE TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_ENTRY=true
	! test -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps

ifdef TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_ENTRY
    $(call bowerbird::git-dependency, \
        name=test-bowerbird-deps-bad-entry, \
        path=$(WORKDIR_TEST)/test-git-dependency-bowerbird-deps-bad-entry/deps/bowerbird-deps, \
        url=https://github.com/ic-designer/make-bowerbird-deps.git, \
        branch=main, \
        entry=)
endif


# test-git-dependency-bowerbird-deps-bad-path
#
#	Tests error handling when target path already exists.
#
#	Raises:
#		ERROR: Failed to clone dependency (git error for non-empty directory).
#
test-git-dependency-bowerbird-deps-bad-path:
	test ! -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps || rm -rf $(WORKDIR_TEST)/$@/deps/bowerbird-deps
	mkdir -p $(WORKDIR_TEST)/$@/deps/bowerbird-deps/.git
	! $(MAKE) FORCE TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_PATH=true

ifdef TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_PATH
    $(call bowerbird::git-dependency, \
        name=test-bowerbird-deps-bad-path, \
        path=$(WORKDIR_TEST)/test-git-dependency-bowerbird-deps-bad-path/deps/bowerbird-deps, \
        url=https://github.com/ic-designer/make-bowerbird-deps.git, \
        branch=main, \
        entry=bowerbird.mk)
endif


# test-git-dependency-bowerbird-deps-bad-url
#
#	Tests error handling when URL parameter is missing or empty.
#
#	Raises:
#		ERROR: 'url' parameter is required.
#
test-git-dependency-bowerbird-deps-bad-url:
	! $(MAKE) FORCE TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_URL=true
	! test -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps

ifdef TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_URL
    $(call bowerbird::git-dependency, \
        name=test-bowerbird-deps-bad-url, \
        path=$(WORKDIR_TEST)/test-git-dependency-bowerbird-deps-bad-url/deps/bowerbird-deps, \
        url=, \
        branch=main, \
        entry=bowerbird.mk)
endif


# test-git-dependency-bowerbird-deps-bad-version
#
#	Tests error handling when branch/revision parameter is missing or empty.
#
#	Raises:
#		ERROR: Must specify either 'branch' or 'revision'.
#
test-git-dependency-bowerbird-deps-bad-version:
	! $(MAKE) FORCE TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_VERSION=true
	! test -d $(WORKDIR_TEST)/$@/deps/bowerbird-deps

ifdef TEST_GIT_DEPENDENCY_BOWERBIRD_DEPS_BAD_VERSION
    $(call bowerbird::git-dependency, \
        name=test-bowerbird-deps-bad-version, \
        path=$(WORKDIR_TEST)/test-git-dependency-bowerbird-deps-bad-version/deps/bowerbird-deps, \
        url=https://github.com/ic-designer/make-bowerbird-deps.git, \
        branch=, \
        entry=bowerbird.mk)
endif


.PHONY: FORCE
FORCE:
	:
