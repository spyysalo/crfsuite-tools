#!/bin/bash

# Train and evaluate CRFsuite with different c2 parameter values.

set -e
set -u

# c2 values to evaluate
c2values=$(python -c 'print " ".join(str(2.**i) for i in range(-10, 5))')

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 DATADIR FEATURIZER" >&2
    exit
fi

# http://stackoverflow.com/a/246128
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for c2 in $c2values; do
    "$scriptdir/runeval.sh" -p c2=$c2 $@ \
	| perl -pe 's/^/c2='"$c2"'\t/'
done
