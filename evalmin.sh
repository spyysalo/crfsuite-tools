#!/bin/bash

# CRFsuite train and evaluate all datasets with minimal featurizer

# http://stackoverflow.com/a/246128
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

datadir="$basedir/data/all"
featurizer="$basedir/featurize/minimal.py"

"$basedir/eval/evaldirs.sh" "$@" "$datadir" "$featurizer"
