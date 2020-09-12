#!/usr/bin/env python

from __future__ import print_function
import fnmatch, os, sys

def main():
    if not os.path.exists(sys.argv[1]):
        return
    for f in iter_files(*sys.argv[1:]):
        if skip(f): continue
        print(f)
        continue
    return

def skip(f):
    if "obsolete" in f: return True
    lines = open(f).readlines()
    for line in lines:
        if line.startswith("skip"):
            if get_value(line, 'skip'): return True
        elif line.startswith("long_test"):
            if get_value(line, 'long_test'): return True
        elif line.startswith("interactive"):
            return True
        continue
    return


def get_value(line, key):
    d = {}
    exec(line, d)
    return d.get(key)

    
def iter_files(path, pattern):
    matches = []
    for root, dirnames, filenames in os.walk(path):
        for filename in fnmatch.filter(filenames, pattern):
            yield os.path.join(root, filename)
            continue
    return


if __name__ == '__main__': main()
