# Delphi-Bible / Lazarus-Bible
#
#   make            alle Demos bauen (Linux/FPC)
#   make report     nur den letzten Build-Bericht anzeigen
#   make tests      Testsuite (fpcunit/GUI) bauen und starten
#   make index      Projektdateien (.lpr/.lpi/.lpg) neu erzeugen
#   make setup      Lazarus-Pakete im Benutzerprofil registrieren
#   make clean      Build-Artefakte loeschen

SHELL   := /bin/sh
ROOT    := $(CURDIR)
LAZBUILD ?= lazbuild
MODE    ?= Default

.PHONY: all build report tests index setup clean

all: build

build:
	@sh FPC/tools/build_all.sh $(MODE)

report:
	@cat build/build-report.txt 2>/dev/null || echo "noch kein Build gelaufen"

tests:
	@sh FPC/tools/run_tests.sh

index:
	@python3 FPC/tools/gen_projects.py

setup:
	@sh FPC/tools/setup_lazarus.sh

clean:
	@rm -rf bin build
	@find FPC -name '*.lps' -delete
	@echo "aufgeraeumt"
