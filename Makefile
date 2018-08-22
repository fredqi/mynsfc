NAME  = mynsfc
EGFN  = examples/my-nsfc-proposal
SHELL = bash
LATEX = xelatex
PWD   = $(shell pwd)
TEMP := $(shell mktemp -u -d -t dtxgen.XXXXXXXXXX)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx)
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)
all:	$(NAME).pdf clean
	$(MAKE) -C examples all
$(NAME).pdf: $(NAME).dtx
	$(LATEX) -shell-escape -recorder -interaction=batchmode $(NAME).dtx > /dev/null
	if [ -f $(NAME).glo ]; then makeindex -q -s gglo.ist -o $(NAME).gls $(NAME).glo; fi
	if [ -f $(NAME).idx ]; then makeindex -q -s gind.ist -o $(NAME).ind $(NAME).idx; fi
	$(LATEX) --recorder --interaction=nonstopmode $(NAME).dtx > /dev/null
	$(LATEX) --recorder --interaction=nonstopmode $(NAME).dtx > /dev/null
clean:
	$(RM) $(NAME).{aux,fls,glo,gls,hd,idx,ilg,ind,ins,log,out}
	$(MAKE) -C examples clean
distclean: clean
	$(RM) $(NAME).{pdf,cls}
	$(MAKE) -C examples distclean
inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).dtx $(UTREE)/source/latex/$(NAME)
	cp $(NAME).cls $(UTREE)/tex/latex/$(NAME)
	cp $(NAME).pdf $(UTREE)/doc/latex/$(NAME)
	cp $(EGFN).tex $(UTREE)/doc/latex/$(NAME)
	cp $(EGFN).bib $(UTREE)/doc/latex/$(NAME)
	cp $(EGFN).pdf $(UTREE)/doc/latex/$(NAME)
install: all
	sudo mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(NAME)
	sudo cp $(NAME).dtx $(LOCAL)/source/latex/$(NAME)
	sudo cp $(NAME).cls $(LOCAL)/tex/latex/$(NAME)
	sudo cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)
	sudo cp $(EGFN).bib $(LOCAL)/doc/latex/$(NAME)
	sudo cp $(EGFN).tex $(LOCAL)/doc/latex/$(NAME)
	sudo cp $(EGFN).pdf $(LOCAL)/doc/latex/$(NAME)
zip: all
	mkdir -p $(TEMP)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).dtx $(TEMP)/source/latex/$(NAME)
	cp $(NAME).cls $(TEMP)/tex/latex/$(NAME)
	cp $(NAME).pdf $(TEMP)/doc/latex/$(NAME)
	cp $(EGFN).tex $(TEMP)/doc/latex/$(NAME)
	cp $(EGFN).bib $(TEMP)/doc/latex/$(NAME)
	cp $(EGFN).pdf $(TEMP)/doc/latex/$(NAME)
	cd $(TEMP); zip -Drq $(TEMP)/$(NAME).tds.zip tex source doc
	mkdir -p $(TDIR)
	cp $(NAME).{pdf,dtx} README.md $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME) $(NAME).tds.zip
	$(RM) -r $(TEMP)
