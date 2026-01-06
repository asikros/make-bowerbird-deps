# Error Checking
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Load Dependencies
include src/bowerbird-deps/bowerbird-deps.mk
$(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-help,\
		https://github.com/ic-designer/make-bowerbird-help.git,main,bowerbird.mk)
$(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-githooks,\
		https://github.com/ic-designer/make-bowerbird-githooks.git,main,bowerbird.mk)
$(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-test,\
		https://github.com/ic-designer/make-bowerbird-test.git,main,bowerbird.mk)
