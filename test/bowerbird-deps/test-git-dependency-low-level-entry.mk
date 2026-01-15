# Mock test for git clone with nested entry path (low-level API)
#
# Verifies that bowerbird::deps::git-dependency-low-level handles nested
# entry point paths like src/lib/bowerbird.mk

include $(dir $(lastword $(MAKEFILE_LIST)))fixture-git-dependency-mock-expected.mk

test-git-dependency-low-level-entry:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_LOW_LEVEL_ENTRY=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-low-level-entry)

ifdef TEST_GIT_DEPENDENCY_LOW_LEVEL_ENTRY
$(call bowerbird::deps::git-dependency-low-level,low-level-entry,$(WORKDIR_TEST)/test-git-dependency-low-level-entry/mock-dep,https://github.com/example/test-repo.git,main,,src/lib/bowerbird.mk)

$(WORKDIR_TEST)/test-git-dependency-low-level-entry/mock-dep/src/lib/bowerbird.mk: | $(WORKDIR_TEST)/test-git-dependency-low-level-entry/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

expected-git-dependency-low-level-entry := $(call bowerbird::deps::test-fixture::expected-git-dependency,branch,https://github.com/example/test-repo.git,$(WORKDIR_TEST)/test-git-dependency-low-level-entry/mock-dep,main,src/lib/bowerbird.mk)
