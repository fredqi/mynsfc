PACKAGE = mynsfc
NAME	= my-proposal
BIBTEX	= biber
LATEX	= xelatex
CLEXT   = aux bbl bcf blg fls log out run.xml toc
all:	$(NAME).pdf clean
$(NAME).pdf: $(NAME).tex $(NAME).bib ../$(PACKAGE).cls ../$(PACKAGE).def
	test -L $(PACKAGE).cls || ln -s ../$(PACKAGE).cls .
	test -L $(PACKAGE).def || ln -s ../$(PACKAGE).def .
	$(LATEX) -shell-escape -recorder -interaction=batchmode $(NAME).tex > /dev/null
	$(BIBTEX) $(NAME).bcf >/dev/null
	$(LATEX) -recorder -interaction=nonstopmode $(NAME).tex > /dev/null
	$(LATEX) -recorder -interaction=nonstopmode $(NAME).tex > /dev/null
.PHONY:	clean distclean $(CLEXT)
.SILENT: $(CLEXT)
$(CLEXT):
	$(RM) $(NAME).$@
clean: $(CLEXT)
distclean:	clean
	$(RM) $(NAME).{pdf,bib,tex}
	$(RM) $(PACKAGE).{cls,def}