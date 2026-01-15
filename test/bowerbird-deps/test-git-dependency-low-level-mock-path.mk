# Mock test for git clone with nested installation path (low-level API)
#
# Verifies that bowerbird::deps::git-dependency-low-level handles deeply nested
# installation paths like deps/vendor/mock-dep

include $(dir $(lastword $(MAKEFILE_LIST)))fixture-git-dependency-mock-expected.mk

test-git-dependency-low-level-mock-path:
	test ! -d $(WORKDIR_TEST)/$@/deps/vendor/mock-dep || rm -rf $(WORKDIR_TEST)/$@/deps/vendor/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_LOW_LEVEL_MOCK_PATH=true \
		$(WORKDIR_TEST)/$@/deps/vendor/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-low-level-mock-path)

ifdef TEST_GIT_DEPENDENCY_LOW_LEVEL_MOCK_PATH
$(call bowerbird::deps::git-dependency-low-level,low-level-path,$(WORKDIR_TEST)/test-git-dependency-low-level-mock-path/deps/vendor/mock-dep,https://github.com/example/test-repo.git,main,,bowerbird.mk)

$(WORKDIR_TEST)/test-git-dependency-low-level-mock-path/deps/vendor/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-git-dependency-low-level-mock-path/deps/vendor/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

expected-git-dependency-low-level-mock-path := $(call bowerbird::deps::test-fixture::expected-git-dependency,branch,https://github.com/example/test-repo.git,$(WORKDIR_TEST)/test-git-dependency-low-level-mock-path/deps/vendor/mock-dep,main,bowerbird.mk)
