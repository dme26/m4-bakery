# Copies files from source tree to build location. Any .html
# files are interpreted by GNU m4 and wrapped in a the GNU
# m4 template. Common m4 macros may be stored in a macros
# file.
# Perennial hurdles:
# - Who should wrap the template around content?
# 	- pandoc     => easy to get vars in; pandoc becomes common target language
# 	- m4 / jinja => harder to get vars in; html becomes common target

SRC      := ../src-2017
DST      := ../build-2017
TEMPLATE    := $(SRC)/.site/template.htm.m4

DEFAULT_DOCUMENT := index.htm

# BASEPATH is the absolute path to the root on the
# filesystem of the site build-out
BASEPATH    := $(shell readlink $(DST) || echo $(DST))
# BASEURL is the URL path from the root of the domain to
# the root of the site. If defined, should start with / and
# never end with /
# BASEURL	    := /m4-bakery

PLATFORM := $(shell uname -s)

export DST
export SRC
export BASEURL
export DEFAULT_DOCUMENT

default: all
# Build a list of all the files that should exist when the
# baking is done. We do this by getting a list of all the
# source files and rewriting pathnames and file suffixes as
# necessary.
#
#	Implementation note: an alternative to the complex
#	process implemented here in GNU Make might be to have a
#	helper script that could process the list of files into
#	the list of destinations:
#
#		targets := $(shell find $(SRC) -type f -print0 | xargs -0 python list_targets.py
#
#	Another approach might be to have an includable
#	makefile snippet generated by some script:
#
#		include targets_and_indices.mk
#		targets_and_indices.mk: create_targets.py
#		python create_targets.py > $@
#
#	But I avoid these approaches here because I want this
#	project to have few dependencies.

# We want a second class of ".index" files to be processed
# after all the other files have been processed, but we
# want to process them with the same pipeline as all
# the other files. So: 
#
# 1. Temporarily renames whatevs.index to I/whatevs
# 2. Separates the indices into another vairable so we can
# have the indices depend on the completed processing of
# the non-indices.
#
# In words, we're doing this. "To obtain the list of all
# the files we want to generate,
# - collect the filenames of all files in the source
#   directory
# - remove temporary files like .inc and .swp
# - change the path so that they live in the same subpath
#   of the destination directory
# - mark those that have a .index suffix as indices
# - remove all .index suffixes
# - remove all .m4 suffixes
# - transform all .md suffixes into .html
# - split all the makred indices into their own variable
sources := $(shell find -L $(SRC)/ \( -name '.site' -o -name '.git' -o -name '.gitignore' -o -name '.dir-locals.el' \) -prune -o -type f -print)
targets := $(sources:$(SRC)/%=$(DST)/%)
targets := $(filter-out %.inc %.swp,$(targets))

include etc/mods-enabled/*.mk

all: $(targets)

# First, all source files will be copied verbatim to the
# destination. When Make is done compiling it will delete
# those copies.
$(DST)/%: $(SRC)/%
	test -d "$(dir $@)" || mkdir -p "$(dir $@)"
	cp $< $@

# By default, GNU Make will skip any source files that have
# not been modified since the last time they were rendered.
# Run 'make clean' to erase the destination directory for a
# complete rebuild. I do a 'mv' then 'rm' to reduce the
# chances of running an 'rm -rf /'.
clean:
	mv $(BASEPATH) $(BASEPATH).old
	mkdir $(BASEPATH)
	if [ -d "$(BASEPATH).old/.git" ]; then mv $(BASEPATH).old/.git $(BASEPATH); fi
	rm -rf $(BASEPATH).old

serve:
	python bin/serve.py

# vim: tw=59 :
