#!/bin/bash

# Summarize evaluation results from output.

echo $'dataset\taccuracy\tf-score'
egrep 'accuracy:' "$@" | perl -pe 's/^(.*?):\s.*?\baccuracy:\s+(\S+)\%.*FB1:\s+(\S+)/$1\t$2\t$3/'
