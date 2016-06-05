#
# Filter files with .m4 extensions through the m4 macro processor.
#
M4 	     := m4 -I etc -P -D__BASEURL="$(BASEURL)"
MACROS   := macros.m4
targets := $(targets:.m4=)
# Any files named '*.html.m4' will be interpreted by M4
# with the macros available, wrapped in the HTML template,
# and saved without the '.m4' extension.
$(DST)/%.html: $(DST)/%.html.m4 $(MACROS) $(TEMPLATE)
	$(M4) $(MACROS) $< $(TEMPLATE) > $@
$(DST)/%.htm: $(DST)/%.htm.m4 $(MACROS) $(TEMPLATE)
	$(M4) $(MACROS) $< $(TEMPLATE) > $@
# Any other files named '*.m4' will be interpreted by M4
# with the macros available, saved without the '.m4'
# extension, but will not be wrapped in the HTML template.
# This lets you use M4 within .css, .js, etc. (Just name
# them blah.css.m4, blah.js.m4, etc.)
$(DST)/%: $(DST)/%.m4 $(MACROS)
	$(M4) $(MACROS) $< > $@
