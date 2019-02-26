NAME	= my-proposal
BIBTEX	= biber
LATEX	= xelatex
CLEXT   = aux bbl bcf blg fls log out run.xml toc
all:	$(NAME).pdf clean
$(NAME).pdf: $(NAME).tex $(NAME).bib ../mynsfc.cls
	test -L mynsfc.cls || ln -s ../mynsfc.cls .
	$(LATEX) -shell-escape -recorder -interaction=batchmode $(NAME).tex > /dev/null
	$(BIBTEX) $(NAME).bcf >/dev/null
	$(LATEX) -recorder -interaction=nonstopmode $(NAME).tex > /dev/null
	$(LATEX) -recorder -interaction=nonstopmode $(NAME).tex > /dev/null
.PHONY:	clean distclean $(CLEXT)
.SILENT:$(CLEXT)
$(CLEXT):
	$(RM) $(NAME).$@
clean: $(CLEXT)
distclean:	clean
	$(RM) $(NAME).pdf 
	$(RM) mynsfc.cls $(NAME)-contents.tex
