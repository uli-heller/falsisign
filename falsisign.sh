#!/bin/bash
set -Eeuxo pipefail

DOCUMENT=$1
X=$3
Y=$4
DOCUMENT_BN=$(basename "${DOCUMENT}" .pdf)
TMPDIR=/tmp/falsisign-${RANDOM}

cleanUp () {
    rm -rf "${TMPDIR}"
}

trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15

mkdir ${TMPDIR}

# Aktuell verarbeiten wir nur einseitige Dokumente!
gs -sDEVICE=png16m -dTextAlphaBits=4 -r600 -o ${TMPDIR}/tmp.png "${DOCUMENT}"
SIGNATURE=$(find "$2" -name '*.png' | shuf -n 1)
convert "${TMPDIR}/tmp.png" "${SIGNATURE}" -geometry "+${X}+${Y}" +profile '*' -composite "${TMPDIR}/${DOCUMENT_BN}"-signed.jpeg
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile="$5" viewjpeg.ps -c "(${TMPDIR}/${DOCUMENT_BN}-signed.jpeg) viewJPEG showpage"
cleanUp
exit 0

# Extract each page of the PDF
convert +profile '*' "${DOCUMENT}" "${TMPDIR}/${DOCUMENT_BN}.pdf"  # Some PDF trigger errors with their shitty profiles
convert "${TMPDIR}/${DOCUMENT_BN}.pdf" -density 576 -resize 3560x4752 "${TMPDIR}/${DOCUMENT_BN}-%04d.png"
for page in "${TMPDIR}/${DOCUMENT_BN}"-*.png
do
    PAGE_BN=$(basename "${page}" .png)
    # "Sign each page"
    

    # "Scan" each page
    # https://tex.stackexchange.com/a/94541
    ROTATION=$(shuf -n 1 -e '-' '')$(shuf -n 1 -e $(seq 0 .1 2))
    convert -density 150 "${TMPDIR}/${PAGE_BN}"-signed.png -linear-stretch 3.5%x10% -blur 0x0.5 -attenuate 0.25 -rotate "${ROTATION}" +noise Gaussian "${TMPDIR}/${PAGE_BN}-scanned.pdf"
done
cleanUp
