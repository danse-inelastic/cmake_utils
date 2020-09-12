#!/usr/bin/env python

"""
Create version.py for a package

Example:

 $ create_version_py.py "# mcvine version" ~/dv/mcvine/mcvine ~/dv/mcvine/mcvine/version.py

"""

template = """
%(banner)s

version = %(version)r
git_revision = %(git_revision)r
"""

import subprocess as sp, os, sys

def get_version_from_git():
    if not os.path.isdir(".git"):
        raise IOError("not a git repo")
    args = ["git", "describe", "--tags", "--dirty", "--always"]
    p = sp.Popen(args, stdout=sp.PIPE)
    stdout = p.communicate()[0]
    if p.returncode != 0:
        raise RuntimeError("cmd %r failed" % ' '.join(args))
    # output is like 1.0-31-ge63953d
    if sys.version_info>=(3,0):
        stdout = stdout.decode()
    ver = stdout.strip().split('-')[0]
    return ver


def get_git_revision():
    if not os.path.isdir(".git"):
        raise IOError("not a git repo")
    args = ["git", "rev-parse", "HEAD"]
    p = sp.Popen(args, stdout=sp.PIPE)
    stdout = p.communicate()[0]
    if p.returncode != 0:
        raise RuntimeError("cmd %r failed" % ' '.join(args))
    return stdout.strip()


def main():
    banner, srcdir, outpath = sys.argv[1:]
    os.chdir(srcdir)
    version = get_version_from_git()
    git_revision = get_git_revision()
    content = template % locals()
    open(outpath, 'wt').write(content)
    return

if __name__ == '__main__': main()
