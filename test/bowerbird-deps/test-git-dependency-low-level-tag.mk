# Mock test for git clone with tag as branch (low-level API)
#
# Verifies that bowerbird::deps::git-dependency-low-level handles git tags
# specified via the branch parameter like v1.2.3

include $(dir $(lastword $(MAKEFILE_LIST)))fixture-git-dependency-mock-expected.mk

test-git-dependency-low-level-tag:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_LOW_LEVEL_TAG=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-low-level-tag)

ifdef TEST_GIT_DEPENDENCY_LOW_LEVEL_TAG
$(call bowerbird::deps::git-dependency-low-level,low-level-tag,$(WORKDIR_TEST)/test-git-dependency-low-level-tag/mock-dep,https://github.com/example/test-repo.git,v1.2.3,,bowerbird.mk)

$(WORKDIR_TEST)/test-git-dependency-low-level-tag/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-git-dependency-low-level-tag/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

expected-git-dependency-low-level-tag := $(call bowerbird::deps::test-fixture::expected-git-dependency,branch,https://github.com/example/test-repo.git,$(WORKDIR_TEST)/test-git-dependency-low-level-tag/mock-dep,v1.2.3,bowerbird.mk)
