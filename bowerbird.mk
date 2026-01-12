# Compute the directory path of this makefile for correct relative includes
# regardless of where this file is included from
_PATH := $(dir $(lastword $(MAKEFILE_LIST)))
include $(_PATH)/src/bowerbird-deps/bowerbird-deps.mk
