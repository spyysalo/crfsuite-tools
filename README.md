# crfsuite-tools

Tools for working with CRFsuite (http://www.chokkan.org/software/crfsuite/)

(Support stuff for a project, not intended for general consumption.)

## Quickstart

### Install CRFsuite

If CRFsuite is not set up already, libLBFGS (a CRFsuite dependency)
and CRFsuite can be installed locally (in $HOME/local/) by running the
following:

libLBFGS:

    wget https://github.com/downloads/chokkan/liblbfgs/liblbfgs-1.10.tar.gz
    tar xzf liblbfgs-1.10.tar.gz
    cd liblbfgs-1.10/
    ./configure --prefix=$HOME/local
    make install
    cd -

CRFsuite:

    wget https://github.com/downloads/chokkan/crfsuite/crfsuite-0.12.tar.gz
    tar xzf crfsuite-0.12.tar.gz
    cd crfsuite-0.12
    ./autogen.sh
    ./configure --prefix=$HOME/local --with-liblbfgs=$HOME/local
    make install
    cd -

CRFsuite must be found in $PATH:

    export PATH=$PATH:$HOME/local/bin

### Run example evaluation

    ./example.sh

(Progress is logged into a file in logs/)

### Run devel set evaluation on NER datasets

    ./evalner.sh

### Run devel set evaluation on NER datasets in parallel

    ./evalner.sh -p

### Run test set evaluation on NER datasets in parallel

    ./evalner.sh -t -p

### Run NER devel set eval with various c2 values

    ./evalnerc2.sh > nerc2-results.txt

Select best c2 value for each dataset

    ./bestnerc2.sh nerc2-results.txt > ner-parameters.txt

### Run NER test set eval with selected parameters in parallel

    ./evalner.sh -s ner-parameters.txt -t -p

### Run evaluation with word vector features and window 0

    ./evalwv.sh wv.bin 0

Word vectors should be in a wvlib-compatible format. The window
parameter gives the number of additional words on each side of the
context word to include, so that e.g. window 1 includes three words in
total.
