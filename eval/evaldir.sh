#!/bin/bash

USAGE="Usage: $0 [-p] [DATADIR [FEATURIZER]]"

# defaults
datadir="data/all"
featurizer="featurize/ner.py"
parallel=false

while getopts 'p' opt; do
    case "$opt" in
	p)
	    parallel=true
	    ;;
	\?)
	    echo "$USAGE" >&2
	    exit
	    ;;
    esac
done
shift $((OPTIND - 1));

if [ "$#" -gt 2 ]; then
    echo "$USAGE" >&2
    exit
fi

datadir=${1:-"$datadir"}
featurizer=${2:-"$featurizer"}

# http://stackoverflow.com/a/246128
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
runeval="$scriptdir/runeval.sh"

for d in "$datadir"/*; do
    if [ "$parallel" = true ]; then
	"$runeval" "$d" "$featurizer"&
    else
	"$runeval" "$d" "$featurizer"
    fi
done

wait
