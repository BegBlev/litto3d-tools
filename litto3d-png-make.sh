#!/usr/bin/env bash

PNG_DIR=/var/tmp/litto3d/png/

TARGET_FILE=${1}
TARGET_BASENAME=$(basename --suffix ".png" ${TARGET_FILE})

echo generating ${TRAGET_FILE}
echo basename ${TARGET_BASENAME}

WEST_LONGITUDE=$(echo ${TARGET_BASENAME}| cut -d "_" -f1)
echo "West longitude is: ${WEST_LONGITUDE}"

EAST_LONGITUDE=$(echo ${TARGET_BASENAME}| cut -d "_" -f3)
echo "East longitude is: ${EAST_LONGITUDE}"

SOUTH_LATITUDE=$(echo ${TARGET_BASENAME}| cut -d "_" -f2)
echo "South latitude is: ${SOUTH_LATITUDE}"

NORTH_LATITUDE=$(echo ${TARGET_BASENAME}| cut -d "_" -f4)
echo "North latitude is: ${NORTH_LATITUDE}"

# Find south west png file
SW_FILE=$(find ${PNG_DIR} -type f -name "*_${WEST_LONGITUDE}_${SOUTH_LATITUDE}_*.png")
echo south west file ${SW_FILE}

# Find north west png file
NW_FILE=$(find ${PNG_DIR} -type f -name "*_${WEST_LONGITUDE}_${NORTH_LATITUDE}_*.png")
echo north west file ${NW_FILE}

# Find south east png file
SE_FILE=$(find ${PNG_DIR} -type f -name "*_${EAST_LONGITUDE}_${SOUTH_LATITUDE}_*.png")
echo south east file ${SE_FILE}

# Find north east png file
NE_FILE=$(find ${PNG_DIR} -type f -name "*_${EAST_LONGITUDE}_${NORTH_LATITUDE}_*.png")
echo north east file ${NE_FILE}

# Merging east files
convert ${NE_FILE} ${SE_FILE} -append ${PNG_DIR}/east.png

# Merging west files
convert ${NW_FILE} ${SW_FILE} -append ${PNG_DIR}/west.png

# Merging east and west files
convert ${PNG_DIR}/west.png ${PNG_DIR}/east.png +append ${TARGET_FILE}
