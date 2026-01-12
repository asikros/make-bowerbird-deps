# Tests for --bowerbird-dev-mode flag

# test-dev-mode-shallow-clone
#
#	Tests default shallow clone behavior (without dev mode flag).
#	Verifies dependency is cloned with --depth 1 and .git directory is removed.
#
test-dev-mode-shallow-clone:
	@echo "Running test-dev-mode-shallow-clone (normal mode)"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_DEV_MODE_SHALLOW_CLONE=true
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git

ifdef TEST_DEV_MODE_SHALLOW_CLONE
    $(call bowerbird::git-dependency, \
        name=test-dev-mode-shallow, \
        path=$(WORKDIR_TEST)/test-dev-mode-shallow-clone/deps/test-repo, \
        url=https://github.com/ic-designer/make-bowerbird-deps.git, \
        branch=main, \
        entry=bowerbird.mk)
endif

# test-dev-mode-full-clone
#
#	Tests full clone behavior with --bowerbird-dev-mode flag.
#	Verifies dependency is cloned with full git history, .git directory is preserved,
#	and git config file exists.
#
test-dev-mode-full-clone:
	@echo "Running test-dev-mode-full-clone (dev mode)"
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_DEV_MODE_FULL_CLONE=true -- --bowerbird-dev-mode
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git
	test -f $(WORKDIR_TEST)/$@/deps/test-repo/.git/config

ifdef TEST_DEV_MODE_FULL_CLONE
    $(call bowerbird::git-dependency, \
        name=test-dev-mode-full, \
        path=$(WORKDIR_TEST)/test-dev-mode-full-clone/deps/test-repo, \
        url=https://github.com/ic-designer/make-bowerbird-deps.git, \
        branch=main, \
        entry=bowerbird.mk)
endif

.PHONY: FORCE
FORCE:
	@:
