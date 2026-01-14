# Mock tests for git clone command generation
#
# These tests verify that bowerbird::git-dependency generates correct
# git clone commands without actually executing them, using the mock shell.

test-git-dependency-mock-branch: $(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_BRANCH=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-branch)

ifdef TEST_GIT_DEPENDENCY_MOCK_BRANCH
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-branch, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    branch=main, \
    entry=test.mk))

# Override the directory target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep/test.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-branch
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/example/test-repo.git $(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/example/test-repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep/
touch $(WORKDIR_TEST)/test-git-dependency-mock-branch/mock-dep/test.mk
endef

expected-git-dependency-mock-branch := $(__expected-git-dependency-mock-branch)


test-git-dependency-mock-revision: $(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_REVISION=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-revision)

ifdef TEST_GIT_DEPENDENCY_MOCK_REVISION
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-revision, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    revision=abc123def456789, \
    entry=lib.mk))

# Override the entry point target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep/lib.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-revision
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --revision abc123def456789 https://github.com/example/test-repo.git $(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/example/test-repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep/
touch $(WORKDIR_TEST)/test-git-dependency-mock-revision/mock-dep/lib.mk
endef

expected-git-dependency-mock-revision := $(__expected-git-dependency-mock-revision)


test-git-dependency-mock-dev-mode: $(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_DEV=true \
		$(WORKDIR_TEST)/$@/mock-dep/. -- --bowerbird-dev-mode
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-dev-mode)

ifdef TEST_GIT_DEPENDENCY_MOCK_DEV
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-dev, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    branch=develop, \
    entry=main.mk))

# Override the entry point target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep/main.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-dev-mode
echo "INFO: Cloning dependency in DEV mode: https://github.com/example/test-repo.git"
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --branch develop https://github.com/example/test-repo.git $(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/example/test-repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep/
touch $(WORKDIR_TEST)/test-git-dependency-mock-dev-mode/mock-dep/main.mk
:
endef

expected-git-dependency-mock-dev-mode := $(__expected-git-dependency-mock-dev-mode)


test-git-dependency-mock-override-branch: $(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_BRANCH=true \
		mock-dep-override.branch=feature-xyz \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-override-branch)

ifdef TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_BRANCH
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-override, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    branch=main, \
    entry=entry.mk))

# Override the entry point target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep/entry.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-override-branch
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch feature-xyz https://github.com/example/test-repo.git $(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/example/test-repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep/
touch $(WORKDIR_TEST)/test-git-dependency-mock-override-branch/mock-dep/entry.mk
endef

expected-git-dependency-mock-override-branch := $(__expected-git-dependency-mock-override-branch)


test-git-dependency-mock-override-path: $(WORKDIR_TEST)/test-git-dependency-mock-override-path/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_PATH=true \
		mock-dep-path.path=$(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path \
		$(WORKDIR_TEST)/$@/overridden-path/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-override-path)

ifdef TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_PATH
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-path, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-override-path/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    branch=main, \
    entry=bowerbird.mk))

# Override the entry point target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path/bowerbird.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-override-path
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/example/test-repo.git $(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/example/test-repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path/
touch $(WORKDIR_TEST)/test-git-dependency-mock-override-path/overridden-path/bowerbird.mk
endef

expected-git-dependency-mock-override-path := $(__expected-git-dependency-mock-override-path)


test-git-dependency-mock-override-url: $(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_URL=true \
		mock-dep-url.url=https://github.com/overridden/repo.git \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-override-url)

ifdef TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_URL
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-url, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    branch=develop, \
    entry=lib.mk))

# Override the entry point target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep/lib.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-override-url
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch develop https://github.com/overridden/repo.git $(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/overridden/repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep/
touch $(WORKDIR_TEST)/test-git-dependency-mock-override-url/mock-dep/lib.mk
endef

expected-git-dependency-mock-override-url := $(__expected-git-dependency-mock-override-url)


test-git-dependency-mock-override-revision: $(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_REVISION=true \
		mock-dep-rev.revision=fedcba987654321 \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-override-revision)

ifdef TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_REVISION
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-rev, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    revision=abc123def456789, \
    entry=main.mk))

# Override the entry point target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep/main.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-override-revision
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --revision fedcba987654321 https://github.com/example/test-repo.git $(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/example/test-repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep/
touch $(WORKDIR_TEST)/test-git-dependency-mock-override-revision/mock-dep/main.mk
endef

expected-git-dependency-mock-override-revision := $(__expected-git-dependency-mock-override-revision)


test-git-dependency-mock-override-entry: $(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-shell.bash
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_ENTRY=true \
		mock-dep-entry.entry=overridden-entry.mk \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-git-dependency-mock-override-entry)

ifdef TEST_GIT_DEPENDENCY_MOCK_OVERRIDE_ENTRY
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-entry, \
    path=$(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep, \
    url=https://github.com/example/test-repo.git, \
    branch=main, \
    entry=default.mk))

# Override the entry point target to create mock files after git commands run
$(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep/overridden-entry.mk: | $(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-git-dependency-mock-override-entry
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/example/test-repo.git $(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep || (>&2 echo "ERROR: Failed to clone dependency '\''https://github.com/example/test-repo.git'\''" && exit 1)
test -n "$(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep"
test -d "$(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep/
touch $(WORKDIR_TEST)/test-git-dependency-mock-override-entry/mock-dep/overridden-entry.mk
endef

expected-git-dependency-mock-override-entry := $(__expected-git-dependency-mock-override-entry)
