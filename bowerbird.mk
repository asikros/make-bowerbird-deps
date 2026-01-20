$(error make-bowerbird-deps is DEPRECATED. Use make-bowerbird-core instead: https://github.com/asikros/make-bowerbird-core)

# Compute the directory path of this makefile for correct relative includes
# regardless of where this file is included from
_PATH := $(dir $(lastword $(MAKEFILE_LIST)))
include $(_PATH)/src/bowerbird-deps/bowerbird-deps.mk
