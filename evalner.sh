#!/bin/bash

# CRFsuite train and evaluate datasets with NER featurizer

# http://stackoverflow.com/a/246128
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

datadir="$basedir/data/ner"
featurizer="$basedir/featurize/ner.py"

"$basedir/eval/evaldirs.sh" "$@" "$datadir" "$featurizer"
