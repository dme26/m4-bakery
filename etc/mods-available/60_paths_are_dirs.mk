# Causes all source .html files to end up as name/(default doc). This
# effectively makes every page into a "directory." Compared to mechanisms like
# apache multiviews or our extensionless_html module, this method makes for a
# messier filesystem layout, but reasoning (in javascript) about page resources
# and parent/child/sibling relationships becomes more elegant:
#
# Without this mod, a page's parent might be "./" or "../" depending on whether
# the page itself has children. With this mod, a page's parent is always "../"
#
# Without this mod, a page's sibling might be "sibling" or "sibling/" or
# "../sibling" or "../sibling/" depending on whether or not the page and its
# sibling have children. With this mode, a page's sibling is always
# "../sibling/"
#
# Without this mod, a page at /path will change to /path/ if a child is added.
# Apache does a redirect automatically, but now its interior relative links to
# other things must be changed. With this mod, pages always live at /path/.
#
targets := $(targets:.html=/$(DEFAULT_DOCUMENT))
targets := $(targets:/$(basename $(DEFAULT_DOCUMENT))/$(DEFAULT_DOCUMENT)=/$(DEFAULT_DOCUMENT))
$(DST)/$(basename $(DEFAULT_DOCUMENT)): $(DST)/$(DEFAULT_DOCUMENT).html
	ginstall -m 644 -D $< $@
$(DST)/%/$(DEFAULT_DOCUMENT): $(DST)/%.html
	ginstall -m 644 -D $< $@
