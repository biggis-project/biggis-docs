# Minimal makefile for Sphinx documentation
# (inspired by geotrellis docs)

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = BigGIS
SOURCEDIR     = .
BUILDDIR      = _build

OUT_PDF_DOC  = $(BUILDDIR)/latex/BigGIS-docs.pdf
OUT_HTML_DOC = $(BUILDDIR)/html/index.html

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@echo
	@echo Additional targets:
	@/bin/echo -e "\e[36m  img       \e[0m: converts all images to PDF using figconv tool"
	@/bin/echo -e "\e[36m  open-html \e[0m: Opens HTML document in browser"
	@/bin/echo -e "\e[36m  open-pdf  \e[0m: Opens PDF document in browser"
	@/bin/echo -e "\e[36m  watch     \e[0m: Opens HTML in browser and recompile on change"

.PHONY: help

img:
	cd images; figconv

# how to compile HTML documents
%.html:
	make html

# how to compile PDF documents
%.pdf: latexpdf
	@echo "PDF ready"

# open documents in the browser
open-html: $(OUT_HTML_DOC)
	@echo -n Opening browser at $^
	@browse $^ >/dev/null
	@echo ... done.

open-pdf: $(OUT_PDF_DOC)
	@echo -n Opening browser at $^
	@browse $^ >/dev/null
	@echo ... done.

# open in browser and recompile in background when sources have changed
watch: open-html
	watchmedo shell-command -p '*.rst;*.md' -c 'make html' -R -D

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%:
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
