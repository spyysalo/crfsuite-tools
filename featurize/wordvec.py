#!/usr/bin/env python

from __future__ import print_function

import sys

import wvlib

# Max number of word vectors to load
VOCAB_SIZE = 100000

UNKNOWN_WORD = '</s>'    # TODO

SEPARATOR = '\t'

class FormatError(Exception):
    pass

def load_conll(f, separator=None):
    rows = []
    for ln, line in enumerate(f, start=1):
        line = line.rstrip()
        if not line:
            rows.append([])
        else:
            fields = line.split(separator)
            if len(fields) < 2:
                raise FormatError('line {}: {}'.format(ln, line))
            rows.append(fields)
    return rows

def wordvec_lookup(wordvecs, token):
    if token in wordvecs:
        return wordvecs[token]
    elif token.lower() in wordvecs:
        return wordvecs[token.lower()]
    else:
        return wordvecs[UNKNOWN_WORD]

def featurize_vector(vec, label='wv'):
    return ['{}[{}]:{:.5f}'.format(label, i, v) for i, v in enumerate(vec)]

def featurize_context(conll, wordvecs, size=0):
    """Create features of vectors for word and context words in a window
    of given size."""
    featurized = []
    prev = None
    for i, row in enumerate(conll):
        if not row:
            featurized.append([])
        else:
            tag, feats = row[-1], []
            for j in range(i-size, i+size+1):
                if 0 <= j < len(conll) and conll[j]:
                    token = conll[j][0]
                    vec = wordvec_lookup(wordvecs, token)
                    feats.extend(featurize_vector(vec, 'wv[{}]'.format(j-i)))
            featurized.append([tag] + feats)
    return featurized
    
def main(argv):
    if not 2 <= len(argv) <= 3:
        print('Usage: {} [CONTEXTSIZE] WORDVECS'.format(__file__),
              file=sys.stderr)
        return 1
    if len(argv) > 2:
        context_size = int(argv[1])
        wvfn = argv[2]
    else:
        context_size = 0
        wvfn = argv[1]
        
    wordvecs = wvlib.load(wvfn, max_rank=VOCAB_SIZE)
    conll = load_conll(sys.stdin)

    featurized = featurize_context(conll, wordvecs, context_size)
    for row in featurized:
        print(SEPARATOR.join(row))

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
