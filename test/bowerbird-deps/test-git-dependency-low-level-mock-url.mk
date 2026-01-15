# Mock test for git clone with different URL formats (low-level API)
#
# Verifies that bowerbird::deps::git-dependency-low-level handles various URL formats
# like https://gitlab.com/group/subgroup/project.git

include $(dir $(lastword $(MAKEFILE_LIST)))fixture-git-dependency-mock-expected.mk

test-git-dependency-low-level-mock-url:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_LOW_LEVEL_MOCK_URL=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-low-level-mock-url)

ifdef TEST_GIT_DEPENDENCY_LOW_LEVEL_MOCK_URL
$(call bowerbird::deps::git-dependency-low-level,low-level-url,$(WORKDIR_TEST)/test-git-dependency-low-level-mock-url/mock-dep,https://gitlab.com/group/subgroup/project.git,main,,bowerbird.mk)

$(WORKDIR_TEST)/test-git-dependency-low-level-mock-url/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-git-dependency-low-level-mock-url/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

expected-git-dependency-low-level-mock-url := $(call bowerbird::deps::test-fixture::expected-git-dependency,branch,https://gitlab.com/group/subgroup/project.git,$(WORKDIR_TEST)/test-git-dependency-low-level-mock-url/mock-dep,main,bowerbird.mk)
