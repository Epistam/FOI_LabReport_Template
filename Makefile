###################################### Report settings ######################################
SURNAME= # Your own surname
NAME= # Your own name
SUBJECT= # The name of the class / subject related to the lab, e.g. "Computer Networks"
REPORT_INDEX= # Report no. N
SHORT_DATE= # The date in shortened format, e.g. "10.10.10"
DATE= # The full date, e.g. "February 10th 2010"
TEACHER= # The teacher's name, e.g. "Prof. Stallman"
LAB_NAME= # The lab name, e.g. "Network elements and performance" ; use '%' if empty
#############################################################################################

# The bash way
#SHORT_SUBJECT := $(shell echo $(SUBJECT) | sed 's/ //g')
# Literal "space" definition, so we can remove it with subst : doesn't look too elegant, but portable probably worth it if there are multiple of these to do...
space :=
space +=
SHORT_SUBJECT := $(subst $(space),,$(SUBJECT))

# LaTeX Compiler in use
LC=pdflatex

BASENAME=report
# Makefile sometimes evaluates variables with a trailing whitespace... 2 options : use strip for every variable, sed it all away, or use subst again
RELEASE_NAME=$(subst $(space),,$(BASENAME)_$(SHORT_SUBJECT)_$(SURNAME)_$(SHORT_DATE)_Lab$(REPORT_INDEX))
BUILDDIR=build

# Target par défaut : c'est la première rencontrée qui commence pas par '.'
$(BASENAME): $(BASENAME).tex
	# Creating the build dir
	mkdir -p $(BUILDDIR)
	# Make necessary substitutions then redirect to new file in BUILDDIR
	sed -e "s/\/SURNAME\//$(SURNAME)/" \
	-e "s/\/NAME\//$(NAME)/" \
	-e "s/\/SUBJECT\//$(SUBJECT)/" \
	-e "s/\/SHORT_DATE\//$(SHORT_DATE)/" \
	-e "s/\/DATE\//$(DATE)/" \
	-e "s/\/REPORT_INDEX\//$(REPORT_INDEX)/" \
	-e "s/\/TEACHER\//$(TEACHER)/" \
	-e "s/\/LAB_NAME\//$(LAB_NAME)/" \
	$< > $(BUILDDIR)/$(BASENAME).tex
	# Compiling twice for ToC & lastPage
	$(LC) -jobname=$(BASENAME) -output-directory=$(BUILDDIR)/ $<
	$(LC) -jobname=$(BASENAME) -output-directory=$(BUILDDIR)/ $<
	# Moving the PDF back to current directory
	mv build/$(BASENAME).pdf ./$(RELEASE_NAME).pdf

clean: # --force allows the rms to keep going even if one fails
	rm -Rf $(BUILDDIR)
	rm -Rf $(RELEASE_NAME).pdf

# Every rule that doesn't generate a same name file must be mentionned ere
.PHONY: clean commit
