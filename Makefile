NAME  = mynsfc
EGDIR = examples
EGFN  = my-proposal
SHELL = bash
LATEX = xelatex
LATEXFLAGS = -shell-escape -recorder -interaction=batchmode
BIB   = biber
PWD   = $(shell pwd)
TEMP := $(shell mktemp -u -d -t dtxgen.XXXXXXXXXX)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx)
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)
CLEXT = aux bbl bcf blg fls glo gls hd idx ilg ind ins log out run.xml
export NAME EGFN LATEX LATEXFLAGS BIB CLEXT
GENERATED = $(NAME).cls $(NAME).def $(NAME).ins
EXAMPLES = $(EGDIR)/$(EGFN).tex $(EGDIR)/$(EGFN).bib

all:	$(NAME).pdf
	$(MAKE) -C examples all

$(GENERATED) $(EXAMPLES): $(NAME).dtx
	tex -interaction=batchmode $(NAME).dtx

$(NAME).pdf: $(NAME).dtx $(NAME).cls
	$(LATEX) $(LATEXFLAGS) $(NAME).dtx
	$(BIB) $(NAME).bcf > /dev/null
	if [ -f $(NAME).glo ]; then makeindex -q -s gglo.ist -o $(NAME).gls $(NAME).glo; fi
	$(LATEX) $(LATEXFLAGS) $(NAME).dtx
	$(LATEX) $(LATEXFLAGS) $(NAME).dtx
.PHONY:	$(CLEXT) clean distclean inst install zip
.SILENT:$(CLEXT)
$(CLEXT):
	$(RM) $(NAME).$@
clean:  $(CLEXT)
	$(MAKE) -C examples clean
distclean: clean
	$(MAKE) -C examples distclean
	$(RM) $(GENERATED) $(EXAMPLES) $(NAME).pdf
define install_tree
	$(2) mkdir -p $(1)/tex/latex/$(NAME)
	$(2) cp $(NAME).cls $(NAME).def $(1)/tex/latex/$(NAME)/
	$(2) mkdir -p $(1)/source/latex/$(NAME)
	$(2) cp $(NAME).dtx $(NAME).ins $(1)/source/latex/$(NAME)/
	$(2) mkdir -p $(1)/doc/latex/$(NAME)
	$(2) cp $(NAME).pdf $(addprefix $(EGDIR)/$(EGFN)., tex bib pdf) $(1)/doc/latex/$(NAME)/
endef

inst: all
	$(call install_tree,$(UTREE),)

install: all
	$(call install_tree,$(LOCAL),sudo)

zip: all
	$(RM) $(PWD)/$(NAME)-$(VERS).zip
	mkdir -p $(TDIR)
	cp $(addprefix $(NAME)., dtx ins pdf) README.md $(TDIR)/
	cp $(EGDIR)/$(EGFN).pdf $(TDIR)/
	cd $(TEMP); zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)
	$(RM) -r $(TEMP)
