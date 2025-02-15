SHELL:=/bin/bash
ZIP=pseries_basis# ZIP name
VERSION=$(shell cat ./VERSION)

# change to your sage command if needed
SAGE=sage

# Package folder
PACKAGE=pseries_basis

all: install lint doc test
	
# Installing commands
install:
	$(SAGE) -pip install --upgrade .

no-deps:
	$(SAGE) -pip install --upgrade --no-deps .

uninstall:
	$(SAGE) -pip uninstall $(PACKAGE)

develop:
	$(SAGE) -pip install --upgrade -e .

test: no-deps
	$(SAGE) -tox -e doctest -- pseries_basis

coverage:
	$(SAGE) -tox -e coverage -- pseries_basis

lint:
	$(SAGE) -tox -e relint,pycodestyle-minimal -- pseries_basis
	
# Documentation commands
doc: no-deps
	cd docsrc && $(SAGE) -sh -c "make html"

doc-github: doc
	@rm -rf ./docs
	@cp -a docsrc/build/html/. ./docs
	@echo "" > ./docs/.nojekyll
		
# Cleaning commands
clean: clean_doc clean_pyc

clean_doc:
	@echo "Cleaning documentation"
	@cd docsrc && $(SAGE) -sh -c "make clean"
	
clean_pyc:
	@echo "Cleaning the Python precompiled files (.pyc)"
	@find . -name "*.pyc" -exec rm {} +
	@find . -name "__pycache__" -exec rm -d {} +
	@rm -rf ./build

.PHONY: all install develop test coverage clean clean_doc doc doc-pdf
	
