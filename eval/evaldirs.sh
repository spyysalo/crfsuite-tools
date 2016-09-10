#!/bin/bash

# Run evaluation on all subdirectories of given directory.

set -e
set -u

USAGE="Usage: $0 [-p] [-t] [-s params] [DATADIR [FEATURIZER]]"

# defaults
datadir="data/all"
featurizer="featurize/ner.py"
parallel=false
evaltest=false
selected=""

while getopts 'pts:' opt; do
    case "$opt" in
	'p') parallel=true ;;
	's') selected="$OPTARG" ;;
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

if [ ! "$selected" ]; then
    datadirs=$(find "$datadir"/* -maxdepth 0 -type d -or -type l)
    if [ ! "$datadirs" ]; then
	echo "No data directories in $datadir" >&2
	exit 1
    fi
else
    datadirs=$(cut -f 1 "$selected")
fi

echo "$0: datadirs: $datadirs" >&2

for d in $datadirs; do
    if [ ! "$selected" ]; then
	p=""
    else
	p="-p "$(egrep '^'"$d"$'\t' "$selected" | cut -f 2 | head -n 1)
	d="$datadir/$d"
    fi
    echo "$0 running $runeval $params $p $d" >&2
    if [ "$parallel" = true ]; then
	"$runeval" $params $p "$d" "$featurizer"&
    else
	"$runeval" $params $p "$d" "$featurizer"
    fi
done

wait
