# Mock test for git clone with revision (low-level API)
#
# Verifies that bowerbird::deps::git-dependency-low-level generates correct
# git clone commands for revision-based dependencies.

include $(dir $(lastword $(MAKEFILE_LIST)))fixture-git-dependency-mock-expected.mk

test-git-dependency-low-level-revision:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_LOW_LEVEL_REVISION=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-low-level-revision)

ifdef TEST_GIT_DEPENDENCY_LOW_LEVEL_REVISION
$(call bowerbird::deps::git-dependency-low-level,low-level-revision,$(WORKDIR_TEST)/test-git-dependency-low-level-revision/mock-dep,https://github.com/example/test-repo.git,,abc123def456789,lib.mk)

$(WORKDIR_TEST)/test-git-dependency-low-level-revision/mock-dep/lib.mk: | $(WORKDIR_TEST)/test-git-dependency-low-level-revision/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

expected-git-dependency-low-level-revision := $(call bowerbird::deps::test-fixture::expected-git-dependency,revision,https://github.com/example/test-repo.git,$(WORKDIR_TEST)/test-git-dependency-low-level-revision/mock-dep,abc123def456789,lib.mk)
