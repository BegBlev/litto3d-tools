#!/usr/bin/env bash

ASC_DIR=/var/tmp/litto3d/asc

for (( x=0; x<=1300; x++))
do
    for (( y=6000; y<=7200; y++))
    do
        if [ ! -f "${ASC_DIR}/LITTO3D_FRA_0${x}_${y}_MNT1M_20231011_LAMB93_RGF93_IGN69.asc" ]; then
            continue
        fi

        if [ ! -f "${ASC_DIR}/LITTO3D_FRA_0${x}_$((y+1))_MNT1M_20231011_LAMB93_RGF93_IGN69.asc" ]; then
            continue
        fi

        if [ ! -f "${ASC_DIR}/LITTO3D_FRA_0$((x+1))_$((y+1))_MNT1M_20231011_LAMB93_RGF93_IGN69.asc" ]; then
            continue
        fi

        if [ ! -f "${ASC_DIR}/LITTO3D_FRA_0$((x+1))_${y}_MNT1M_20231011_LAMB93_RGF93_IGN69.asc" ]; then
            continue
        fi

        echo "0${x}_${y}_0$((x+1))_$((y+1)).kap"
    done
done
