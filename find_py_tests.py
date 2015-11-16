#!/usr/bin/env python

import fnmatch, os, sys

def main():
    for f, m in iterModules(*sys.argv[1:]):
        if skip(m): continue
        print f
        continue
    return

def skip(m):
    return getattr(m, 'skip', None) or getattr(m, 'long_test', None)


def iterModules(path, pattern):
    for f in iter_files(path, pattern):
        m = _importModule(f)
        yield f, m
        continue
    return


def _importModule(path):
    dir = os.path.dirname(path)
    filename = os.path.basename(path)
    name = filename[:-3]
    _restore = list(sys.path)
    sys.path = [dir] + sys.path
    try:
        exec 'import %s as m' % name
    except:
        import traceback
        tb = traceback.format_exc()
        raise ImportError, 'failed to import %s. traceback:\n%s' % (name, tb)
    reload(m)
    sys.path = _restore
    return m


def iter_files(path, pattern):
    matches = []
    for root, dirnames, filenames in os.walk(path):
        for filename in fnmatch.filter(filenames, pattern):
            yield os.path.join(root, filename)
            continue
    return


if __name__ == '__main__': main()
