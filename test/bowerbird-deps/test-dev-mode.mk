# Mock tests for --bowerbird-dev-mode flag
#
# These tests verify that bowerbird::git-dependency generates correct
# git clone commands with and without dev mode, using the mock shell.

test-dev-mode-mock-shallow-clone:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_DEV_MODE_MOCK_SHALLOW_CLONE=true \
		$(WORKDIR_TEST)/$@/mock-dep/.
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-dev-mode-mock-shallow-clone)

ifdef TEST_DEV_MODE_MOCK_SHALLOW_CLONE
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-shallow, \
    path=$(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-dev-mode-mock-shallow-clone
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --depth 1 --branch main https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
test -n "$(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep"
test -d "$(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep/.git"
rm -rfv -- "$(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep/.git"
mkdir -p $(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep/
touch $(WORKDIR_TEST)/test-dev-mode-mock-shallow-clone/mock-dep/bowerbird.mk
endef

expected-dev-mode-mock-shallow-clone := $(__expected-dev-mode-mock-shallow-clone)


test-dev-mode-mock-full-clone:
	test ! -d $(WORKDIR_TEST)/$@/mock-dep || rm -rf $(WORKDIR_TEST)/$@/mock-dep
	@mkdir -p $(WORKDIR_TEST)/$@
	@cat /dev/null > $(WORKDIR_TEST)/$@/results
	$(MAKE) -j1 BOWERBIRD_MOCK_RESULTS=$(WORKDIR_TEST)/$@/results \
		TEST_DEV_MODE_MOCK_FULL_CLONE=true \
		$(WORKDIR_TEST)/$@/mock-dep/. \
		-- --bowerbird-dev-mode
	$(call bowerbird::test::compare-file-content-from-var,$(WORKDIR_TEST)/$@/results,expected-dev-mode-mock-full-clone)

ifdef TEST_DEV_MODE_MOCK_FULL_CLONE
$(eval $(call bowerbird::git-dependency, \
    name=mock-dep-full, \
    path=$(WORKDIR_TEST)/test-dev-mode-mock-full-clone/mock-dep, \
    url=https://github.com/asikros/make-bowerbird-deps.git, \
    branch=main, \
    entry=bowerbird.mk))

$(WORKDIR_TEST)/test-dev-mode-mock-full-clone/mock-dep/bowerbird.mk: | $(WORKDIR_TEST)/test-dev-mode-mock-full-clone/mock-dep/.
	@mkdir -p $(dir $@)
	@touch $@
endif

define __expected-dev-mode-mock-full-clone
git clone --config advice.detachedHead=false --config http.lowSpeedLimit=1000 --config http.lowSpeedTime=60 --branch main https://github.com/asikros/make-bowerbird-deps.git $(WORKDIR_TEST)/test-dev-mode-mock-full-clone/mock-dep || (>&2 echo "ERROR: Failed to clone dependency 'https://github.com/asikros/make-bowerbird-deps.git'" && exit 1)
mkdir -p $(WORKDIR_TEST)/test-dev-mode-mock-full-clone/mock-dep/
touch $(WORKDIR_TEST)/test-dev-mode-mock-full-clone/mock-dep/bowerbird.mk
endef

expected-dev-mode-mock-full-clone := $(__expected-dev-mode-mock-full-clone)
