NAME	?= mynsfc
EGFN	?= my-proposal
BIB		?= biber
LATEX	?= xelatex
LATEXFLAGS ?= -shell-escape -recorder -interaction=batchmode
CLEXT   ?= aux bbl bcf blg fls log out run.xml toc
LINKS   = $(NAME).cls $(NAME).def

all:	$(EGFN).pdf clean

$(LINKS): %: ../%
	ln -sf $< $@

$(EGFN).pdf: $(EGFN).tex $(EGFN).bib $(LINKS)
	$(LATEX) $(LATEXFLAGS) $(EGFN).tex
	$(BIB) $(EGFN).bcf >/dev/null
	$(LATEX) $(LATEXFLAGS) $(EGFN).tex
	$(LATEX) $(LATEXFLAGS) $(EGFN).tex

.PHONY:	clean distclean $(CLEXT)
.SILENT: $(CLEXT)

$(CLEXT):
	$(RM) $(EGFN).$@

clean: $(CLEXT)

distclean:	clean
	$(RM) $(EGFN).pdf $(EGFN).bib $(EGFN).tex
	$(RM) $(LINKS)