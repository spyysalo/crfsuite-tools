#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 NER-RESULTS" >&2
    exit 1
fi

RESULTS="$1"

egrep 'accuracy:.*FB1:' "$RESULTS" | cut -f 2 | perl -pe 's/:$//' \
    | sort | uniq \
    | while read dataset; do
    egrep '^[^[:space:]]+'$'\t'"$dataset"':.*accuracy:.*FB1' "$RESULTS" \
	| perl -pe 's/accuracy:.*FB1:\s+//' \
	| awk '{ print $3"\t"$2"\t"$1 }' \
	| sort -rn \
	| head -n 1
done \
    | awk '{ print $2"\t"$3"\t"$1 }' \
    | perl -pe 's/://'
