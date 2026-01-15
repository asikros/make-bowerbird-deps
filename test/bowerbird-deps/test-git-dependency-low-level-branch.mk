# Mock test for git clone with branch (low-level API)
#
# Verifies that bowerbird::deps::git-dependency-low-level generates correct
# git clone commands for branch-based dependencies.

include $(dir $(lastword $(MAKEFILE_LIST)))fixture-git-dependency-mock-expected.mk

test-git-dependency-low-level-branch:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_LOW_LEVEL_BRANCH=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-low-level-branch)

ifdef TEST_GIT_DEPENDENCY_LOW_LEVEL_BRANCH
$(call bowerbird::deps::git-dependency-low-level,low-level-branch,$(WORKDIR_TEST)/test-git-dependency-low-level-branch/mock-dep,https://github.com/example/test-repo.git,main,,test.mk)

$(WORKDIR_TEST)/test-git-dependency-low-level-branch/mock-dep/test.mk: | $(WORKDIR_TEST)/test-git-dependency-low-level-branch/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

expected-git-dependency-low-level-branch := $(call bowerbird::deps::test-fixture::expected-git-dependency,branch,https://github.com/example/test-repo.git,$(WORKDIR_TEST)/test-git-dependency-low-level-branch/mock-dep,main,test.mk)
