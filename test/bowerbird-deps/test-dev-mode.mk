# Test development mode flag

test-dev-mode-shallow-clone:
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_DEV_MODE_SHALLOW=true
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	! test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git

ifdef TEST_DEV_MODE_SHALLOW
    $(call bowerbird::git-dependency,$(WORKDIR_TEST)/test-dev-mode-shallow-clone/deps/test-repo,\
		https://github.com/ic-designer/make-bowerbird-deps.git,main,bowerbird.mk)
endif


test-dev-mode-full-clone:
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo || rm -rf $(WORKDIR_TEST)/$@/deps/test-repo
	test ! -d $(WORKDIR_TEST)/$@/deps/test-repo
	$(MAKE) FORCE TEST_DEV_MODE_FULL=true -- --bowerbird-dev-mode
	test -d $(WORKDIR_TEST)/$@/deps/test-repo
	test -d $(WORKDIR_TEST)/$@/deps/test-repo/.git
	test -f $(WORKDIR_TEST)/$@/deps/test-repo/.git/config

ifdef TEST_DEV_MODE_FULL
    $(call bowerbird::git-dependency,$(WORKDIR_TEST)/test-dev-mode-full-clone/deps/test-repo,\
		https://github.com/ic-designer/make-bowerbird-deps.git,main,bowerbird.mk)
endif
