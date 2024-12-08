ZIP_PATH=~/Downloads
ZIP_FILES=$(wildcard ${ZIP_PATH}/*.7z)

AREAS_PATH=/var/tmp/litto3d/areas
AREAS_DIRS := $(patsubst ${ZIP_PATH}/%.7z, ${AREAS_PATH}/%, ${ZIP_FILES})

ASC_DIR := /var/tmp/litto3d/asc

ASC_FILES := $(shell find ${ASC_DIR} -type f -name '*_MNT1M_*.asc')

PNG_DIR := /var/tmp/litto3d/png
PNG_FILES := $(patsubst ${ASC_DIR}/%.asc, ${PNG_DIR}/%.png, ${ASC_FILES})

MIN_ELEVATION=-37
MAX_ELEVATION=43

.PHONY: unzip
unzip: ${AREAS_PATH} ${AREAS_DIRS}

${AREAS_PATH}:
	mkdir -p ${AREAS_PATH}

${AREAS_DIRS}: ${AREAS_PATH}/%: ${ZIP_PATH}/%.7z
	7z x -o$@ $?

.PHONY: move-asc
move-asc: ${ASC_DIR}
	find ${AREAS_PATH} -type f -name '*_MNT1M_*.asc' -exec mv {} ${ASC_DIR} \;

${ASC_DIR}:
	mkdir ${ASC_DIR}

.PHONY: png
png: ${PNG_FILES}

${PNG_FILES}: ${PNG_DIR}/%.png: ${PNG_DIR} ${ASC_DIR}/%.asc
	@echo creating $@
	python3 asc2png.py --emin ${MIN_ELEVATION} --emax ${MAX_ELEVATION} $(word 2, $^) $@

${PNG_DIR}:
	@echo creating ${PNG_DIR}
	mkdir ${PNG_DIR}

include Makefile.kap
