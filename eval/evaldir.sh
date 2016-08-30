#!/bin/bash

USAGE="Usage: $0 [-p] [-t] [DATADIR [FEATURIZER]]"

# defaults
datadir="data/all"
featurizer="featurize/ner.py"
parallel=false
evaltest=false

while getopts 'pt' opt; do
    case "$opt" in
	'p') parallel=true ;;
	't') evaltest=true ;;
	'?') echo "$USAGE" >&2; exit ;;
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

params=""
if [ "$evaltest" = true ]; then
    params="-t"
fi

for d in "$datadir"/*; do
    if [ "$parallel" = true ]; then
	"$runeval" $params "$d" "$featurizer"&
    else
	"$runeval" $params "$d" "$featurizer"
    fi
done

wait
