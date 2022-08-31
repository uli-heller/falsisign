#!/bin/bash
#
# Example:  ./falsisign.sh Nachweis_FIV_202003_UHe_IPL.pdf 200x100+550+700 Nachweis_FIV_202003_UHe_IPL_signed.pdf
#
set -Eeuo pipefail

DOCUMENT=$1
SIGNATURES=signatures
GEO=$2
OUTPUT=$3
SIGNPAGE=${4:-1}
DOCUMENT_BN=$(basename "${DOCUMENT}" .pdf)
TMPDIR=/tmp/falsisign-${RANDOM}

cleanUp () {
    rm -rf "${TMPDIR}"
}

trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15

mkdir ${TMPDIR}

# Aktuell verarbeiten wir nur einseitige Dokumente!
gs -sDEVICE=png16m -dTextAlphaBits=4 -r100 -o ${TMPDIR}/tmp-%d.png "${DOCUMENT}"
SIGNATURE=$(find "${SIGNATURES}/" -name '*.png' | shuf -n 1)

convert "${TMPDIR}/tmp-${SIGNPAGE}.png" "${SIGNATURE}" -geometry "${GEO}" +profile '*' -composite "${TMPDIR}/tmp-${SIGNPAGE}"-signed.png
rm "${TMPDIR}/tmp-${SIGNPAGE}.png"
convert -format pdf -density 100 -units PixelsPerInch "${TMPDIR}/tmp-*.png" out.pdf
cleanUp
