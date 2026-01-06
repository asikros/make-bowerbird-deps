# --bowerbird-dev-mode
#
#   Optional flag for enabling development mode when cloning dependencies.
#   In development mode, git repositories are cloned with full history and
#   .git directories are preserved, allowing for local modifications and commits.
#
#   Include guard to prevent "overriding commands for target" warnings when this file
#   is included multiple times.
#
#   Example:
#       make <target> -- --bowerbird-dev-mode
#
ifndef __BOWERBIRD_DEPS_FLAGS_DEFINED
__BOWERBIRD_DEPS_FLAGS_DEFINED := 1

__BOWERBIRD_DEV_FLAG = --bowerbird-dev-mode
.PHONY: $(__BOWERBIRD_DEV_FLAG)
$(__BOWERBIRD_DEV_FLAG):
	@:

endif

# Set clone depth based on dev mode flag
ifneq ($(filter $(__BOWERBIRD_DEV_FLAG),$(MAKECMDGOALS)),)
    __BOWERBIRD_CLONE_DEPTH :=
    __BOWERBIRD_KEEP_GIT := 1
    export __BOWERBIRD_KEEP_GIT
else
    __BOWERBIRD_CLONE_DEPTH := --depth 1
    __BOWERBIRD_KEEP_GIT :=
endif

# bowerbird::git-dependency,<path>,<url>,<version>,<entry>
#
#   Installs a bowerbird compatible git dependency for immediate use. This command will
#   clone the dependency repo from the designated URL location into the specified path.
#
#   By default, performs a shallow clone and deletes the git history to prevent
#   accidental changes. When --dev flag is used, performs a full clone and keeps
#   the .git directory for development purposes.
#
#   Args:
#       path: Path where the dependency repo is cloned.
#       url: Location of the repo specified as a URL.
#       version: Version of the repo specified as a tag or branch name.
#       entry: Entry point of the repo specified as a relative file path.
#
#   Error:
#       If the specified entry point cannot be created, the command will remove all
#           partially installed files and terminate with exit 1.
#       If the specified path is not empty, the cloning operation will fail and return
#           a non-zero exit code.
#
#   Example:
#       $(call bowerbird::git-dependency,deps/bowerbird-deps,\
#               https://github.com/ic-designer/make-bowerbird-deps.git,\
#               main,bowerbird.mk))
#
define bowerbird::git-dependency
$(eval $(call bowerbird::deps::git-dependency-implementation,$1,$2,$3,$4))
endef

# bowerbird::deps::git-dependency-implementation,<path>,<url>,<version>,<entry>
#
#   Implementation for installing a bowerbird compatible git dependency for immediate
#   use. This command will clone the dependency repo from the designated URL location
#   into the specified path. The commands performs a shallow clone and deletes the git
#   history of the clone to prevent against accidental changes in the cloned repo.
#
#   Args:
#       path: Path where the dependency repo is cloned.
#       url: Location of the repo specified as a URL.
#       version: Version of the repo specified as a tag or branch name.
#       entry: Entry point of the repo specified as a relative file path.
#
#   Error:
#       If the specified entry point cannot be created, the command will remove all
#           partially installed files and terminate with exit 1.
#       If the specified path is not empty, the cloning operation will fail and return
#           a non-zero exit code.
#
#   Example:
#       $(eval $(call bowerbird::git-dependency-implementation,deps/bowerbird-deps,\
#               https://github.com/ic-designer/make-bowerbird-deps.git,\
#               main,bowerbird.mk))
#
define bowerbird::deps::git-dependency-implementation
    $$(eval $$(call bowerbird::deps::define-dependency-constants,BOWERBIRD_DEPENDENCY/$1,$2,$3,$1,$4))
    $$(BOWERBIRD_DEPENDENCY/$1/PATH)/.:
		$$(if $(__BOWERBIRD_KEEP_GIT),@echo "INFO: Cloning dependency in DEV mode: $$(BOWERBIRD_DEPENDENCY/$1/URL)")
		@git clone --config advice.detachedHead=false $$(__BOWERBIRD_CLONE_DEPTH) \
				--branch $$(BOWERBIRD_DEPENDENCY/$1/VERSION) \
				$$(BOWERBIRD_DEPENDENCY/$1/URL) \
				$$(BOWERBIRD_DEPENDENCY/$1/PATH) || \
        (>&2 echo "ERROR: Failed to clone dependency '$$(BOWERBIRD_DEPENDENCY/$1/URL)'" && exit 1)
		@test -n "$$(BOWERBIRD_DEPENDENCY/$1/PATH)"
		@test -d "$$(BOWERBIRD_DEPENDENCY/$1/PATH)/.git"
		$$(if $(__BOWERBIRD_KEEP_GIT),,@\rm -rfv -- "$$(BOWERBIRD_DEPENDENCY/$1/PATH)/.git")


    $$(BOWERBIRD_DEPENDENCY/$1.MK): | $$(BOWERBIRD_DEPENDENCY/$1/PATH)/.
		@test -d $$|
		@test -f $$@ || (\
			\rm -rf $$(BOWERBIRD_DEPENDENCY/$1/PATH) && \
			>&2 echo "ERROR: Expected entry point not found: $$@" && \
			exit 1\
		)

    include $$(BOWERBIRD_DEPENDENCY/$1.MK)
endef


# bowerbird::deps::define-constant,<name>,<value>
#
#   Helper macro for emulating the declaration of a readonly constant. If the variable
#   designated by name does not exit, this command will create it and assign it to the
#   supplied value. If the variable already exists, this command throw an error it the
#   supplied value is different than the current value.
#
#   Args:
#       name: Name of the variable.
#       value: Value for the variable.
#
#   Error:
#       Raises an error if the variable designated by name already exists and the
#           supplied value for the variable is different than the current value of the
#           variable.
#
define bowerbird::deps::define-constant # name, value
    ifndef $1
        $1 := $2
    else
        ifneq ($$($1),$2)
            $$(error ERROR: Identified conflict with $1: '$$($1)' != '$2' )
        endif
    endif
endef

# bowerbird::deps::define-constant,<id>,<url>,<version>,<path>,<entry>
#
#   Helper macro for creating constants used by the git-dependency macros.

#   Args:
#       id: Unique id used as a prefix for the dependency constant names.
#       path: Path where the dependency repo is cloned.
#       url: Location of the repo specified as a URL.
#       version: Version of the repo specified as a tag or branch name.
#       entry: Entry point of the repo specified as a relative file path
#
#   Error:
#       Raises an error if the value for any of the constants is different than
#           previously supplied values.
#
define bowerbird::deps::define-dependency-constants # id, url, version, path, entry
    $$(eval $$(call bowerbird::deps::define-constant,$1/URL,$2))
    $$(eval $$(call bowerbird::deps::define-constant,$1/VERSION,$3))
    $$(eval $$(call bowerbird::deps::define-constant,$1/PATH,$$(abspath $4)))
    $$(eval $$(call bowerbird::deps::define-constant,$1.MK,$$($1/PATH)/$5))
endef
