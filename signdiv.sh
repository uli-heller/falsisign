#!/bin/bash
set -Eeuo pipefail

D="$(dirname "$0")"
D="$(cd "${D}" && pwd)"

SIGNATURES=$1
TMPDIR=/tmp/falsisign-${RANDOM}

cleanUp () {
    rm -rf "${TMPDIR}"
}

trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15

mkdir "${TMPDIR}"
SIGNATURES_BN=$(basename "${SIGNATURES}" .pdf)

# Die Maße eines Blattes in DIN A4-Format betragen 21,0 cm x 29,7 cm
A4_WIDTH=$((2100*2))
A4_HEIGHT=$((2970*2))

A4_COLS=4
A4_ROWS=16
A4_LINE_WIDTH=40

(
 set -x
 gs -sDEVICE=png16m -dTextAlphaBits=4 -r600 -o ${TMPDIR}/tmp.png "${SIGNATURES}"
 convert -density 576 -resize ${A4_WIDTH}x${A4_HEIGHT} -fuzz 10% -transparent white "${TMPDIR}/tmp.png" "${TMPDIR}/${SIGNATURES_BN}.png"
)

DIMENSIONS="$(file "${TMPDIR}/${SIGNATURES_BN}.png" | grep -o "[0-9]* x [0-9]*")"
WIDTH="$(echo "${DIMENSIONS}"|cut -d " " -f1)"
HEIGHT="$(echo "${DIMENSIONS}"|cut -d " " -f3)"

FIELD_WIDTH="$((${WIDTH} / ${A4_COLS}))"
FIELD_HEIGHT="$((${HEIGHT} / ${A4_ROWS}))"
SIGNATURE_WIDTH="$((${FIELD_WIDTH} - ${A4_LINE_WIDTH}))"
SIGNATURE_HEIGHT="$((${FIELD_HEIGHT} - ${A4_LINE_WIDTH}))"

X0="$((${A4_LINE_WIDTH} / 2))"
Y0="$((${A4_LINE_WIDTH} / 2))"

mkdir -p signatures
CNT=1
for X in $(seq ${X0} ${FIELD_WIDTH} ${WIDTH})
do
    for Y in $(seq ${Y0} ${FIELD_HEIGHT} ${HEIGHT})
    do
        (
         set -x
         convert "${TMPDIR}/${SIGNATURES_BN}.png" -crop "${SIGNATURE_WIDTH}x${SIGNATURE_HEIGHT}+${X}+${Y}" +repage \
                signatures/"${SIGNATURES_BN}_${CNT}".png
        )
        CNT="$((${CNT}+1))"
    done
done

cleanUp
