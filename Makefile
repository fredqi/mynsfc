NAME  = mynsfc
EGDIR = examples
EGFN  = my-proposal
SHELL = bash
LATEX = xelatex
BIB   = biber
PWD   = $(shell pwd)
TEMP := $(shell mktemp -u -d -t dtxgen.XXXXXXXXXX)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx)
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)
CLEXT = aux bbl bcf blg fls glo gls hd idx ilg ind ins log out run.xml
all:	$(NAME).pdf clean
	$(MAKE) -C examples all
$(NAME).pdf: $(NAME).dtx
	$(LATEX) -shell-escape -recorder -interaction=batchmode $(NAME).dtx > /dev/null
	$(BIB) $(NAME).bcf > /dev/null
	if [ -f $(NAME).glo ]; then makeindex -q -s gglo.ist -o $(NAME).gls $(NAME).glo; fi
	if [ -f $(NAME).idx ]; then makeindex -q -s gind.ist -o $(NAME).ind $(NAME).idx; fi
	$(LATEX) --recorder --interaction=nonstopmode $(NAME).dtx > /dev/null
	$(LATEX) --recorder --interaction=nonstopmode $(NAME).dtx > /dev/null
.PHONY:	$(CLEXT) clean distclean inst install zip
.SILENT:$(CLEXT)
$(CLEXT):
	$(RM) $(NAME).$@
clean:  $(CLEXT)
	$(MAKE) -C examples clean
distclean: clean
	$(RM) $(NAME).{pdf,cls}
	$(MAKE) -C examples distclean
inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).{dtx,cls,pdf} $(UTREE)/source/latex/$(NAME)
	cp $(EGDIR)/$(EGFN).{tex,bib,pdf} $(LOCAL)/doc/latex/
install: all
	sudo mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(NAME)
	sudo cp $(NAME).{dtx,cls,pdf} $(LOCAL)/source/latex/$(NAME)
	sudo cp $(EGDIR)/$(EGFN).{tex,bib,pdf} $(LOCAL)/doc/latex/$(EGFN).tex
zip: all
	mkdir -p $(TEMP)/{tex,source,doc}/xelatex/$(NAME)
	cp $(NAME).cls $(TEMP)/tex/xelatex/$(NAME)/
	cp $(NAME).dtx $(TEMP)/source/xelatex/$(NAME)/
	cp $(NAME).pdf $(TEMP)/doc/xelatex/$(NAME)/
	cp $(EGDIR)/$(EGFN).{tex,bib,pdf} $(TEMP)/doc/xelatex/$(NAME)/
	cd $(TEMP); zip -Drq $(TEMP)/$(NAME).tds.zip tex source doc
	mkdir -p $(TDIR)
	cp $(NAME).{pdf,dtx} README.md $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME) $(NAME).tds.zip
	$(RM) -r $(TEMP)
