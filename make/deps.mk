# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Dependencies
#
#	Loads the bowerbird-deps system and declares all project dependencies.
#	Dependencies are cloned into $(WORKDIR_DEPS) and included automatically.
#
#	Note: We use the low-level positional API (bowerbird::deps::git-dependency-low-level) to bootstrap
#	all dependencies, including bowerbird-libs. This avoids a chicken-and-egg problem
#	where the kwargs-based API requires bowerbird-libs to be loaded first.
#
include src/bowerbird-deps/bowerbird-deps.mk

# Bootstrap all dependencies using low-level positional API
$(call bowerbird::deps::git-dependency-low-level,bowerbird-libs,$(WORKDIR_DEPS)/bowerbird-libs,https://github.com/asikros/make-bowerbird-libs.git,main,,bowerbird.mk)
$(call bowerbird::deps::git-dependency-low-level,bowerbird-help,$(WORKDIR_DEPS)/bowerbird-help,https://github.com/asikros/make-bowerbird-help.git,main,,bowerbird.mk)
$(call bowerbird::deps::git-dependency-low-level,bowerbird-githooks,$(WORKDIR_DEPS)/bowerbird-githooks,https://github.com/asikros/make-bowerbird-githooks.git,main,,bowerbird.mk)
$(call bowerbird::deps::git-dependency-low-level,bowerbird-test,$(WORKDIR_DEPS)/bowerbird-test,https://github.com/asikros/make-bowerbird-test.git,main,,bowerbird.mk)
