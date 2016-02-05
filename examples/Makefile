NAME	= my-nsfc-proposal
BIBTEX	= biber
LATEX	= xelatex
CLEANEXT= aux bbl bcf blg fls log out run.xml
all:	$(NAME).pdf clean
$(NAME).pdf: $(NAME).tex $(NAME).bib
	$(LATEX) -shell-escape -recorder -interaction=batchmode $(NAME).tex >/dev/null
	$(BIBTEX) $(NAME).bcf >/dev/null
	$(LATEX) --recorder --interaction=nonstopmode $(NAME).tex > /dev/null
	$(LATEX) --recorder --interaction=nonstopmode $(NAME).tex > /dev/null
.PHONY:	clean distclean $(CLEANEXT)
.SILENT:	$(CLEANEXT)
$(CLEANEXT):
	$(RM) $(NAME).$@
clean: $(CLEANEXT)
distclean:	clean
	$(RM) $(NAME).pdf
