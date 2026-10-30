.PHONY: all build report tests index setup clean

SHELL   := /bin/sh
ROOT    := $(CURDIR)
MODE    ?= Default

# Vollstaendiger Durchlauf: Endungen normalisieren, Projekte erzeugen,
# alles bauen.  make build baut nur die Projekte.
all:
	@sh tools/fix_line_endings.py
	@python3 tools/normalize_extensions.py
	@python3 tools/fix_unit_refs.py
	@python3 tools/gen_projects.py
	@sh tools/build_all.sh $(MODE)

build:
	@sh tools/build_all.sh $(MODE)

report:
	@cat build/build-report.txt 2>/dev/null || echo "noch kein Build gelaufen"

tests:
	@sh tools/run_tests.sh

index:
	@python3 tools/gen_projects.py

setup:
	@sh tools/setup_lazarus.sh

clean:
	@rm -rf bin build
	@find FPC -name '*.lps' -delete
	@echo "aufgeraeumt"
