#!/usr/bin/env python

# Merge CoNLL data and tags output by CRFSuite. Useful for preparing
# CRFsuite output for conlleval.

from __future__ import print_function

import sys

SEPARATOR = ' '

def read_lines(fn):
    return [l.rstrip() for l in open(fn)]

def merge_lines(conll_lines, tag_lines):
    if len(conll_lines) != len(tag_lines):
        raise ValueError('line number mismatch: {} vs {}'.format(
                len(conll_lines), len(tag_lines)))
    merged = []
    for i in range(len(conll_lines)):
        cl, tl = conll_lines[i], tag_lines[i]
        if (cl and not tl) or (tl and not cl):
            raise ValueError('separator mismatch on line {}'.format(i))
        if not cl:
            merged.append(cl)
        else:
            # assure that the correct separator is used
            cl = SEPARATOR.join(cl.split())
            merged.append(cl + SEPARATOR + tl)
    return merged

def main(argv):
    if len(argv) != 3:
        print('Usage: {} CONLLFILE TAGFILE'.format(__file__), file=sys.stderr)
        return 1
    conllfn, tagfn = argv[1:]

    conll_lines = read_lines(conllfn)
    tag_lines = read_lines(tagfn)

    merged_lines = merge_lines(conll_lines, tag_lines)
    for line in merged_lines:
        print(line)
    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
