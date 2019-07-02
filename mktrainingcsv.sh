#!/bin/bash

SCRIPT=$(readlink -m $(type -p "$0"))
SCRIPTDIR=${SCRIPT%/*}      

usage() {
    echo -e "Makes 'trainingDataT1AHCC.csv'
Usage: 
    ${0##*/} [<dir>]

    <dir>   output directory for csv files
    "
}

[ $# -gt 0 ] || { usage; exit 0; }

if [ $# -gt 0 ]; then 
    [[ "${1-}" != "-h" ]] || { usage; exit 0; }
    dir=$1
fi

dirTmp=$(mktemp -d)
datadir="$SCRIPTDIR/"
ls -1 $datadir/*cingl.nrrd | sed "s|.*\/|$datadir|" > $dirTmp/cingl.txt
ls -1 $datadir/*cingr.nrrd | sed "s|.*\/|$datadir|" > $dirTmp/cingr.txt
ls -1 $datadir/*amyhipl.nrrd | sed "s|.*\/|$datadir|" > $dirTmp/amyhipl.txt
ls -1 $datadir/*amyhipr.nrrd | sed "s|.*\/|$datadir|" > $dirTmp/amyhipr.txt
ls -1 $datadir/*realign.cent.nrrd | sed "s|.*\/|$datadir|" > $dirTmp/t1s.txt
ls -1 $datadir/*realign-mask.nrrd | sed "s|.*\/|$datadir|" > $dirTmp/masks.txt
# no header
paste -d, $dirTmp/t1s.txt $dirTmp/masks.txt $dirTmp/cingl.txt $dirTmp/cingr.txt $dirTmp/amyhipl.txt $dirTmp/amyhipr.txt > $dir/trainingDataT1AHCC.csv
# header
echo "image,mask,cingl,cingr,amyhipl,amyhipr" > $dir/trainingDataT1AHCC-hdr.csv
paste -d, $dirTmp/t1s.txt $dirTmp/masks.txt $dirTmp/cingl.txt $dirTmp/cingr.txt $dirTmp/amyhipl.txt $dirTmp/amyhipr.txt >> $dir/trainingDataT1AHCC-hdr.csv

# mask only, no header
paste -d, $dirTmp/t1s.txt $dirTmp/masks.txt > $dir/trainingDataT1Masks.csv
# mask only, header
echo "image,mask" > $dir/trainingDataT1Masks-hdr.csv
paste -d, $dirTmp/t1s.txt $dirTmp/masks.txt >> $dir/trainingDataT1Masks-hdr.csv

rm -r "$dirTmp"
