# Mock tests for command-line override functionality
#
# These tests verify that bowerbird::git-dependency generates correct
# git clone commands with various overrides, using the mock shell.

test-override-mock-branch: $(WORKDIR_TEST)/test-override-mock-branch/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_BRANCH=true \
		test-repo.branch=0.1.0 \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-branch)

ifdef TEST_OVERRIDE_MOCK_BRANCH
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-branch/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-branch/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-override-mock-branch/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-branch
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch 0.1.0 https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-override-mock-branch/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-override-mock-branch/mock-dep"
test -d "$(WORKDIR_TEST)/test-override-mock-branch/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-override-mock-branch/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-override-mock-branch/mock-dep/
touch $(WORKDIR_TEST)/test-override-mock-branch/mock-dep/bowerbird.mk
endef

expected-override-mock-branch := $(__expected-override-mock-branch)


test-override-mock-revision: $(WORKDIR_TEST)/test-override-mock-revision/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_REVISION=true \
		test-repo.revision=8e3c8a1 \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-revision)

ifdef TEST_OVERRIDE_MOCK_REVISION
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-revision/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-revision/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-override-mock-revision/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-revision
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --revision 8e3c8a1 https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-override-mock-revision/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-override-mock-revision/mock-dep"
test -d "$(WORKDIR_TEST)/test-override-mock-revision/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-override-mock-revision/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-override-mock-revision/mock-dep/
touch $(WORKDIR_TEST)/test-override-mock-revision/mock-dep/bowerbird.mk
endef

expected-override-mock-revision := $(__expected-override-mock-revision)


test-override-mock-url: $(WORKDIR_TEST)/test-override-mock-url/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_URL=true \
		test-repo.url=https://github.com/asikros/make-bowerbird-help.git \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-url)

ifdef TEST_OVERRIDE_MOCK_URL
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-url/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-url/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-override-mock-url/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-url
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/asikros/make-bowerbird-help.git $(WORKDIR_TEST)/test-override-mock-url/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-help.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-override-mock-url/mock-dep"
test -d "$(WORKDIR_TEST)/test-override-mock-url/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-override-mock-url/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-override-mock-url/mock-dep/
touch $(WORKDIR_TEST)/test-override-mock-url/mock-dep/bowerbird.mk
endef

expected-override-mock-url := $(__expected-override-mock-url)


test-override-mock-path: $(WORKDIR_TEST)/test-override-mock-path/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/alt-path || rm -rf $(WORKDIR_TEST)/$@/alt-path
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_PATH=true \
		test-repo.path=$(WORKDIR_TEST)/test-override-mock-path/alt-path \
		$(WORKDIR_TEST)/$@/alt-path/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-path)

ifdef TEST_OVERRIDE_MOCK_PATH
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-path/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-path/alt-path/bowerbird.mk: | $(WORKDIR_TEST)/test-override-mock-path/alt-path/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-path
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-override-mock-path/alt-path || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-override-mock-path/alt-path"
test -d "$(WORKDIR_TEST)/test-override-mock-path/alt-path/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-override-mock-path/alt-path/.git"
mkdir -p $(WORKDIR_TEST)/test-override-mock-path/alt-path/
touch $(WORKDIR_TEST)/test-override-mock-path/alt-path/bowerbird.mk
endef

expected-override-mock-path := $(__expected-override-mock-path)


test-override-mock-entry: $(WORKDIR_TEST)/test-override-mock-entry/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_ENTRY=true \
		test-repo.entry=Makefile \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-entry)

ifdef TEST_OVERRIDE_MOCK_ENTRY
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-entry/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-entry/mock-dep/Makefile: | $(WORKDIR_TEST)/test-override-mock-entry/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-entry
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-override-mock-entry/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-override-mock-entry/mock-dep"
test -d "$(WORKDIR_TEST)/test-override-mock-entry/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-override-mock-entry/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-override-mock-entry/mock-dep/
touch $(WORKDIR_TEST)/test-override-mock-entry/mock-dep/Makefile
endef

expected-override-mock-entry := $(__expected-override-mock-entry)


test-override-mock-multiple: $(WORKDIR_TEST)/test-override-mock-multiple/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/alt-path || rm -rf $(WORKDIR_TEST)/$@/alt-path
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_MULTIPLE=true \
		test-repo.path=$(WORKDIR_TEST)/test-override-mock-multiple/alt-path \
		test-repo.branch=0.1.0 \
		test-repo.entry=README.md \
		$(WORKDIR_TEST)/$@/alt-path/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-multiple)

ifdef TEST_OVERRIDE_MOCK_MULTIPLE
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-multiple/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-multiple/alt-path/README.md: | $(WORKDIR_TEST)/test-override-mock-multiple/alt-path/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-multiple
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch 0.1.0 https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-override-mock-multiple/alt-path || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-override-mock-multiple/alt-path"
test -d "$(WORKDIR_TEST)/test-override-mock-multiple/alt-path/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-override-mock-multiple/alt-path/.git"
mkdir -p $(WORKDIR_TEST)/test-override-mock-multiple/alt-path/
touch $(WORKDIR_TEST)/test-override-mock-multiple/alt-path/README.md
endef

expected-override-mock-multiple := $(__expected-override-mock-multiple)


test-override-mock-branch-with-dev-mode: $(WORKDIR_TEST)/test-override-mock-branch-with-dev-mode/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_BRANCH_DEV=true \
		test-repo.branch=0.1.0 \
		$(WORKDIR_TEST)/$@/mock-dep/. \
		-- --bowerbird-dev-mode
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-branch-with-dev-mode)

ifdef TEST_OVERRIDE_MOCK_BRANCH_DEV
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-branch-with-dev-mode/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-branch-with-dev-mode/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-override-mock-branch-with-dev-mode/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-branch-with-dev-mode
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --branch 0.1.0 https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-override-mock-branch-with-dev-mode/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
mkdir -p $(WORKDIR_TEST)/test-override-mock-branch-with-dev-mode/mock-dep/
touch $(WORKDIR_TEST)/test-override-mock-branch-with-dev-mode/mock-dep/bowerbird.mk
endef

expected-override-mock-branch-with-dev-mode := $(__expected-override-mock-branch-with-dev-mode)


test-override-mock-no-override: $(WORKDIR_TEST)/test-override-mock-no-override/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_OVERRIDE_MOCK_NONE=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-override-mock-no-override)

ifdef TEST_OVERRIDE_MOCK_NONE
$(eval $(call bowerbird::git-dependency, \
    name=test-repo, \
    path=$(WORKDIR_TEST)/test-override-mock-no-override/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-override-mock-no-override/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-override-mock-no-override/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-override-mock-no-override
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-override-mock-no-override/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-override-mock-no-override/mock-dep"
test -d "$(WORKDIR_TEST)/test-override-mock-no-override/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-override-mock-no-override/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-override-mock-no-override/mock-dep/
touch $(WORKDIR_TEST)/test-override-mock-no-override/mock-dep/bowerbird.mk
endef

expected-override-mock-no-override := $(__expected-override-mock-no-override)
