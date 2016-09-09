#!/bin/bash

# Train and evaluate CRFsuite tagger on given dataset and featurizer.

set -e
set -u

if [ "$#" -lt 2 ]; then
    echo "Usage: $0  [-t] [LEARN-OPTIONS] DATADIR FEATURIZER" >&2
    echo "    example: $0 example-data/bionlp-st-2009 featurize/ner.py" >&2
    exit
fi

# separate own options from options to crfsuite learn
evaltest=false
learnargs=""
isvalue=false
for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
	if [ "$arg" = "-t" ]; then
	    evaltest=true
	    isvalue=false
	else
	    learnargs="$learnargs $arg"
	    if [[ "$arg" =~ ^-(a|p|m|g|e|L)$ ]]; then
		isvalue=true    # next is value, include in learnargs
	    else
		isvalue=false
	    fi
	fi
	shift
    elif [ "$isvalue" = true ]; then
	learnargs="$learnargs $arg"
	isvalue=false
	shift
    else
	break
    fi
done

datadir="$1"
featurizer="$2"

# http://stackoverflow.com/a/246128
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

logdir="$scriptdir/../logs"
mkdir -p "$logdir"
logfile="$logdir/"$(date +"%Y-%m-%d--%H-%M-%S")"--"$(basename "$0" ".sh")"--"$(basename "$datadir")"--"$(basename "$featurizer" ".py")".log"

workdir=$(mktemp -d)
function onexit {
    # echo "Removing $workdir ..."
    rm -rf "$workdir"
}
trap onexit EXIT

if [ "$evaltest" = true ]; then
    testdata="$datadir/test.tsv"
else
    testdata="$datadir/devel.tsv"    # devel only
fi

cat "$datadir/train.tsv" | "$featurizer" > "$workdir/train.crfsuite.txt"
cat "$datadir/devel.tsv" | "$featurizer" > "$workdir/devel.crfsuite.txt"
cat "$testdata" | "$featurizer" > "$workdir/test.crfsuite.txt"

modelfile="$workdir"/$(basename "$datadir").model
crfsuite learn -m "$modelfile" -e2 $learnargs \
 	 "$workdir/train.crfsuite.txt" \
	 "$workdir/devel.crfsuite.txt" \
	 > "$logfile"
crfsuite tag -m "$modelfile" "$workdir/test.crfsuite.txt" \
	 > "$workdir/test.tags"

# Colons in labels escaped for CRFsuite, unescape here.
perl -p -i -e 's/__COLON__/:/g' "$workdir/test.tags"

python "$scriptdir/mergetags.py" "$testdata" "$workdir/test.tags" \
       > "$workdir/test.merged"
"$scriptdir/conlleval.pl" < "$workdir/test.merged" \
    | perl -pe 's/^/'$(basename "$datadir")':\t/'
