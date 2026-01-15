# Mock test for git clone in dev mode (low-level API)
#
# Verifies that bowerbird::deps::git-dependency-low-level generates correct
# git clone commands when --bowerbird-dev-mode is enabled.

include $(dir $(lastword $(MAKEFILE_LIST)))fixture-git-dependency-mock-expected.mk

test-git-dependency-low-level-dev-mode:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_LOW_LEVEL_DEV=true \
		$(WORKDIR_TEST)/$@/mock-dep/. -- --bowerbird-dev-mode
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-low-level-dev-mode)

ifdef TEST_GIT_DEPENDENCY_LOW_LEVEL_DEV
$(call bowerbird::deps::git-dependency-low-level,low-level-dev,$(WORKDIR_TEST)/test-git-dependency-low-level-dev-mode/mock-dep,https://github.com/example/test-repo.git,develop,,main.mk)

$(WORKDIR_TEST)/test-git-dependency-low-level-dev-mode/mock-dep/main.mk: | $(WORKDIR_TEST)/test-git-dependency-low-level-dev-mode/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

expected-git-dependency-low-level-dev-mode := $(call bowerbird::deps::test-fixture::expected-git-dependency,dev-mode,https://github.com/example/test-repo.git,$(WORKDIR_TEST)/test-git-dependency-low-level-dev-mode/mock-dep,develop,main.mk)
