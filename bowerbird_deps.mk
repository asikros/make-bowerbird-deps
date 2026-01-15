# --bowerbird-dev-mode
#
#	Optional flag for enabling development mode when cloning dependencies.
#
#	In development mode, git repositories are cloned with full history and
#	.git directories are preserved, allowing for local modifications and commits.
#
#	Include guard prevents "overriding commands for target" warnings when this
#	file is included multiple times.
#
#	Example:
#		make <target> -- --bowerbird-dev-mode
#		make check -- --bowerbird-dev-mode
#
ifndef __BOWERBIRD_DEPS_FLAGS_DEFINED
__BOWERBIRD_DEPS_FLAGS_DEFINED := 1

__BOWERBIRD_DEV_FLAG = --bowerbird-dev-mode
.PHONY: $(__BOWERBIRD_DEV_FLAG)
$(__BOWERBIRD_DEV_FLAG): ## Enables development mode (keeps .git history for dependencies)
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

# Define comma and space variables (needed for substitution)
, := ,
empty :=
space := $(empty) $(empty)

# Keyword arguments limit (we support one less than this value)
KEYWORD_ARGS_LIMIT := 11

# bowerbird::deps::parse-keyword-args
#
#	Parses keyword arguments with flexible spacing.
#
#	Args:
#		$(...): Keyword arguments in format key=value (flexible spacing supported).
#
#	Returns:
#		Sets __ARG_<key> variables for each parsed key=value pair.
#		Errors if KEYWORD_ARGS_LIMIT arguments are reached.
#
#	Example:
#		$(call bowerbird::deps::parse-keyword-args,name=foo,path=bar,url=baz)
#		$(call bowerbird::deps::parse-keyword-args, name=foo, path=bar, url=baz)
#
__ARG_NUMS := $(filter-out $(KEYWORD_ARGS_LIMIT),$(shell seq 1 $(KEYWORD_ARGS_LIMIT)))
define bowerbird::deps::parse-keyword-args
# Dynamically build the argument list
$(eval __ALL_ARGS := $(foreach n,$(__ARG_NUMS),$(if $($n),$(if $(filter 1,$n),$($n),$(,)$($n)))))
# Replace commas with spaces
$(eval __SPLIT_ARGS := $(subst $(,),$(space),$(__ALL_ARGS)))
# Error if word at KEYWORD_ARGS_LIMIT position exists (too many args)
$(if $(word $(KEYWORD_ARGS_LIMIT),$(__SPLIT_ARGS)),\
    $(error ERROR: Keyword argument limit reached (KEYWORD_ARGS_LIMIT=$(KEYWORD_ARGS_LIMIT))))
# Parse each key=value pair
$(foreach arg,$(__SPLIT_ARGS),\
    $(if $(findstring =,$(arg)),\
        $(eval __CLEAN := $(strip $(arg)))\
        $(eval __KV := $(subst =, ,$(__CLEAN)))\
        $(eval __ARG_$(word 1,$(__KV)) := $(word 2,$(__KV)))\
    )\
)
endef

# bowerbird::git-dependency
#
#	Installs a git dependency using keyword arguments.
#
#	By default, performs a shallow clone and deletes the git history to prevent
#	accidental changes. When --bowerbird-dev-mode flag is used, performs a full
#	clone and keeps the .git directory for development purposes.
#
# 	Args:
#       name: Dependency name (for override variables).
#       path: Installation path.
#       url: Git repository URL.
#       branch: Branch or tag name (uses git clone --branch).
#       revision: Specific commit SHA (uses git clone --revision).
#       entry: Entry point file (relative path).
#
#	Note:
#		Specify either 'branch' OR 'revision', not both (mutually exclusive).
#
#	Command-Line Overrides:
#		<name>.branch=<value>     Override branch/tag.
#		<name>.revision=<value>   Override to specific SHA.
#		<name>.url=<value>        Override repository URL.
#		<name>.path=<value>       Override installation path.
#		<name>.entry=<value>      Override entry point.
#
#	Returns:
#		Creates a target for the dependency path and includes the entry point.
#		Errors if required parameters are missing or validation fails.
#
#	Example:
#		$(call bowerbird::git-dependency, \
#		    name=bowerbird-help, \
#		    path=$(WORKDIR_DEPS)/bowerbird-help, \
#		    url=https://github.com/ic-designer/make-bowerbird-help.git, \
#		    branch=main, \
#		    entry=bowerbird.mk)
#
#		$(call bowerbird::git-dependency,name=test,path=/tmp/test,\
#		    url=https://github.com/example/repo.git,revision=abc123,entry=test.mk)
#
#		make check bowerbird-help.branch=feature-xyz
#
define bowerbird::git-dependency
$(eval $(call bowerbird::deps::parse-keyword-args,$1,$2,$3,$4,$5,$6,$7,$8,$9,$(10)) \
    $(if $(__ARG_name),,$(error ERROR: 'name' parameter is required)) \
    $(if $(__ARG_path),,$(error ERROR: 'path' parameter is required)) \
    $(if $(__ARG_url),,$(error ERROR: 'url' parameter is required)) \
    $(if $(__ARG_entry),,$(error ERROR: 'entry' parameter is required)) \
    $(if $(and $(__ARG_branch),$(__ARG_revision)),$(error ERROR: Cannot specify both 'branch' and 'revision')) \
    $(if $(or $(__ARG_branch),$(__ARG_revision)),,$(error ERROR: Must specify either 'branch' or 'revision')) \
    $(call bowerbird::deps::git-dependency-implementation,$(or $($(__ARG_name).path),$(__ARG_path)),$(or $($(__ARG_name).url),$(__ARG_url)),$(or $($(__ARG_name).branch),$(__ARG_branch)),$(or $($(__ARG_name).revision),$(__ARG_revision)),$(or $($(__ARG_name).entry),$(__ARG_entry))))
endef

# bowerbird::deps::git-dependency-implementation
#
#	Implementation that clones a git dependency.
#
#	Uses --branch flag if branch is specified, --revision flag if revision is specified.
#	Parameters are already resolved with command-line overrides applied.
#
#	Args:
#		$1: Installation path for the dependency.
#		$2: Git repository URL.
#		$3: Branch or tag name (empty if revision is used).
#		$4: Specific commit SHA (empty if branch is used).
#		$5: Entry point file (relative path).
#
#	Returns:
#		Creates target for dependency path and entry point.
#		Performs shallow or full clone based on --bowerbird-dev-mode flag.
#		Removes .git directory unless in dev mode.
#		Includes the entry point makefile.
#
#	Raises:
#		Errors if git clone fails or entry point is not found.
#		Cleans up partially installed files on failure.
#
define bowerbird::deps::git-dependency-implementation
    $1/.:
		$$(if $(__BOWERBIRD_KEEP_GIT),@echo "INFO: Cloning dependency in DEV mode: $2")
		@git clone --config advice.detachedHead=false \
				--config http.lowSpeedLimit=1000 \
				--config http.lowSpeedTime=60 \
				$$(__BOWERBIRD_CLONE_DEPTH) \
				$$(if $3,--branch $3,--revision $4) \
				$2 \
				$1 || \
				(>&2 echo "ERROR: Failed to clone dependency '$2'" && exit 1)
		@test -n "$1"
		@test -d "$1/.git"
		$$(if $(__BOWERBIRD_KEEP_GIT),,@\rm -rfv -- "$1/.git")

    $1/$5: | $1/.
		@test -d $$|
		@test -f $$@ || (\
			\rm -rf $1 && \
			>&2 echo "ERROR: Expected entry point not found: $$@" && \
			exit 1\
		)

    include $1/$5
endef
