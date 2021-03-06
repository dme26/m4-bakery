# causes all .html files to be saved with no extension. For this to work right
# you should configure your webserver's default mime-type to be text/html.
#
# This helps to keep HTML URIs free of filename extensions. (URIs never need
# filename extensions, if your webserver can figure out a resource's file type
# through other means.) Apache "multiviews" or the "paths_are_dirs.mk" plugins
# are other ways to do the same.
targets := $(targets:.html=)
$(DST)/%: $(DST)/%.html
	cp $< $@
