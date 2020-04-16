#!/bin/bash
#
# Example:  ./falsisign.sh Nachweis_FIV_202003_UHe_IPL.pdf 200x100+550+700 Nachweis_FIV_202003_UHe_IPL_signed.pdf
#
set -Eeuo pipefail

DOCUMENT=$1
SIGNATURES=signatures
GEO=$2
OUTPUT=$3
DOCUMENT_BN=$(basename "${DOCUMENT}" .pdf)
TMPDIR=/tmp/falsisign-${RANDOM}

cleanUp () {
    rm -rf "${TMPDIR}"
}

trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15

mkdir ${TMPDIR}

# Aktuell verarbeiten wir nur einseitige Dokumente!
gs -sDEVICE=png16m -dTextAlphaBits=4 -r100 -o ${TMPDIR}/tmp.png "${DOCUMENT}"
SIGNATURE=$(find "${SIGNATURES}" -name '*.png' | shuf -n 1)
convert "${TMPDIR}/tmp.png" "${SIGNATURE}" -geometry "${GEO}" +profile '*' -composite "${TMPDIR}/${DOCUMENT_BN}"-signed.jpeg
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile="${OUTPUT}" viewjpeg.ps -c "(${TMPDIR}/${DOCUMENT_BN}-signed.jpeg) viewJPEG showpage"
cleanUp
