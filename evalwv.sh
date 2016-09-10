#!/bin/bash

# CRFsuite train and evaluate datasets with word vector featurizer

set -e
set -u

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 WORDVECS WINDOW [EVAL-ARGS]"
    exit
fi

wordvecs=$1
window=$2
shift 2

# http://stackoverflow.com/a/246128
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

datadir="$basedir/data/ner"
featurizer="$basedir/featurize/wordvec.py $window $wordvecs"

"$basedir/eval/evaldirs.sh" "$@" "$datadir" "$featurizer"
