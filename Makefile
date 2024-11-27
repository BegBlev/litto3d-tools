ZIP_PATH=~/Downloads
ZIP_FILES=$(wildcard ${ZIP_PATH}/*.7z)

AREAS_PATH=/var/tmp/litto3d/areas
AREAS_DIRS := $(patsubst ${ZIP_PATH}/%.7z, ${AREAS_PATH}/%, ${ZIP_FILES})

ASC_DIR := /var/tmp/litto3d/asc

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
