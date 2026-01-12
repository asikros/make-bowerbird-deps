# Error Checking
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Dependencies
#
#	Loads the bowerbird-deps system and declares all project dependencies.
#	Dependencies are cloned into $(WORKDIR_DEPS) and included automatically.
#
include src/bowerbird-deps/bowerbird-deps.mk

$(call bowerbird::git-dependency, \
    name=bowerbird-help, \
    path=$(WORKDIR_DEPS)/bowerbird-help, \
    url=https://github.com/ic-designer/make-bowerbird-help.git, \
    branch=main, \
    entry=bowerbird.mk)

$(call bowerbird::git-dependency, \
    name=bowerbird-githooks, \
    path=$(WORKDIR_DEPS)/bowerbird-githooks, \
    url=https://github.com/ic-designer/make-bowerbird-githooks.git, \
    branch=main, \
    entry=bowerbird.mk)

$(call bowerbird::git-dependency, \
    name=bowerbird-test, \
    path=$(WORKDIR_DEPS)/bowerbird-test, \
    url=https://github.com/ic-designer/make-bowerbird-test.git, \
    branch=main, \
    entry=bowerbird.mk)
