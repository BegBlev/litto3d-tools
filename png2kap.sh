#!/usr/bin/env bash

LC_NUMERIC="en_US.UTF-8"

TMP_DIR=/var/tmp/
IMAGE_SIZE=2000

png_file=$1
kap_file=$2

# Compute position from file name
sw_x=$(echo $(basename -s ".png" ${png_file})|cut -d "_" -f1|sed -e 's/^0//')
sw_x=$((sw_x*1000))

sw_y=$(echo $(basename -s ".png" ${png_file})|cut -d "_" -f2)
sw_y=$((sw_y*1000))

echo "Input PNG file: ${png_file}"
echo "Output KAP file: ${kap_file}"
echo "SW long: ${sw_x}, lat: ${sw_y}"

se_x=$((sw_x + IMAGE_SIZE))
se_y=$sw_y
ne_x=$se_x
ne_y=$((se_y + IMAGE_SIZE))
nw_x=$sw_x
nw_y=$ne_y

echo "SE long: ${se_x}, lat: ${se_y}"
echo "NE long: ${ne_x}, lat: ${ne_y}"
echo "NW long: ${nw_x}, lat: ${nw_y}"

read sw_long sw_lat < <(echo $sw_x $sw_y|invproj -f "%.6f" EPSG:2154)
read se_long se_lat < <(echo $se_x $se_y|invproj -f "%.6f" EPSG:2154)
read ne_long ne_lat < <(echo $ne_x $ne_y|invproj -f "%.6f" EPSG:2154)
read nw_long nw_lat < <(echo $nw_x $nw_y|invproj -f "%.6f" EPSG:2154)

echo "SW long: ${sw_long}, lat: ${sw_lat}"
echo "SE long: ${se_long}, lat: ${se_lat}"
echo "NE long: ${ne_long}, lat: ${ne_lat}"
echo "NW long: ${nw_long}, lat: ${nw_lat}"

read rotation_angle < <(echo "asin((${sw_lat}-(${se_lat}))*113000/${IMAGE_SIZE})" |bc -l bcrc)

echo "Rotation angle: ${rotation_angle} rad"

read rotation_angle_deg < <(echo "deg(${rotation_angle})" |bc -l bcrc)

echo "Rotation angle: ${rotation_angle_deg} deg"

convert $png_file -rotate $rotation_angle_deg +repage ${TMP_DIR}/rotate.png

# Compute new image size after rotation
read image_size < <(echo "${IMAGE_SIZE}*(abs(s(${rotation_angle}))+abs(c(${rotation_angle})))" |bc -l bcrc)
image_size=$(printf "%.0f\n" $image_size)

echo "Image size after rotation: ${image_size}x${image_size}"

# Compute the number of pixels to crop
read crop_pixels < <(echo "${IMAGE_SIZE}*(abs(s(${rotation_angle})))" |bc -l bcrc)
crop_pixels=$(printf "%.0f\n" $crop_pixels)

echo "Crop ${crop_pixels} pixels"

# Crop upper left
convert  ${TMP_DIR}/rotate.png \
         +repage \
         -crop "+${crop_pixels}+${crop_pixels}" \
         ${TMP_DIR}/crop.png

# Crop bottom right
convert  ${TMP_DIR}/crop.png \
         +repage \
         -crop "-${crop_pixels}-${crop_pixels}" \
         ${TMP_DIR}/crop.png

imgkap ${TMP_DIR}/crop.png "$nw_lat" "$sw_long" "$se_lat" "$ne_long" $kap_file
