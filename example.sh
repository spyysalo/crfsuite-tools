#!/bin/bash

# CRFsuite training and evaluation example

# http://stackoverflow.com/a/246128
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"$basedir/eval/runeval.sh" "$basedir/example-data/bionlp-st-2009" "$basedir/featurize/ner.py"
