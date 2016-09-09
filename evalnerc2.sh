#!/bin/bash

# CRFsuite train and evaluate datasets with NER featurizer and
# different c2 parameter values.

# http://stackoverflow.com/a/246128
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

datadir="$basedir/data/ner"
featurizer="$basedir/featurize/ner.py"

for d in "$datadir"/*; do
    "$basedir/eval/evalc2.sh" $@ "$d" "$featurizer"&
done

wait
