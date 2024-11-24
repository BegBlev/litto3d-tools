ZIP_PATH=~/Downloads
ZIP_FILES=$(wildcard ${ZIP_PATH}/*.7z)

ASC_PATH=/var/tmp/litto3d/asc
ASC_DIRS := $(patsubst ${ZIP_PATH}/%.7z, ${ASC_PATH}/%, ${ZIP_FILES})

.PHONY: unzip
unzip: ${ASC_PATH} ${ASC_DIRS}

${ASC_PATH}:
	mkdir -p ${ASC_PATH}

${ASC_DIRS}: ${ASC_PATH}/%: ${ZIP_PATH}/%.7z
	7z x -o$@ $?
