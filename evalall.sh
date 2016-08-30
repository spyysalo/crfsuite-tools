#!/bin/bash

datadir="data/all"
featurizer="featurize/ner.py"

if [ "$1" == "-p" ]; then
    parallel=true
else
    parallel=false
fi

# http://stackoverflow.com/a/246128
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
runeval="$scriptdir/eval/runeval.sh"

for d in "$datadir"/*; do
    if [ "$parallel" = true ]; then
	"$runeval" "$d" "$featurizer"&
    else
	"$runeval" "$d" "$featurizer"
    fi
done
