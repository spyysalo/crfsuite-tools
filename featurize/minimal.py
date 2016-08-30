#!/usr/bin/env python

# Minimal CRFsuite feature extractor using only the focus word.

separator = '\t'
fields = 'w y'

templates = (
    (('w',  0), ),
    )

import crfutils

def feature_extractor(X):
    crfutils.apply_templates(X, templates)
    if X:
        X[0]['F'].append('__BOS__')     # BOS feature
        X[-1]['F'].append('__EOS__')    # EOS feature
    # CRFsuite doesn't like colons as labels, so escape
    for m in X:
        m['y'] = m['y'].replace(':', '__COLON__')

if __name__ == '__main__':
    crfutils.main(feature_extractor, fields=fields, sep=separator)
