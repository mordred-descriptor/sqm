#!/usr/bin/env python3

import re
from io import BytesIO
import subprocess
import shutil
import os
import sys


def get_library_path(gcc):
    proc = subprocess.Popen([gcc, "--print-search-dirs"], stdout=subprocess.PIPE)
    stdout, _ = proc.communicate()
    for line in BytesIO(stdout):
        matched = re.match(rb"^libraries: =(.*)", line)
        if matched is not None:
            return matched.group(1).decode()


def main():
    _, gcc = sys.argv
    print(shutil.which("libquadmath.a", mode=os.F_OK, path=get_library_path(gcc)))


if __name__ == "__main__":
    main()
